//
//  MyMessageChildViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/2/28.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

import MBProgressHUD
import MJRefresh
import AVFoundation

class MyMessageChildViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,pushDelegate {

    var convenienceTable = UITableView()
    var beginmid = "0"
    var status = String()
    var dataSource2 = NSMutableArray()
    var dataSource : Array<TCHDInfo>?
    let mainHelper = MainHelper()
    
    
    var player = AVPlayer.init()
    var imageView = UIImageView()
    
    var timer1 = NSTimer()
    
    var timesCount = Int()
    
    var audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setConvenienceTable()
        self.convenienceTable.mj_header.beginRefreshing()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }
    
    
    func setConvenienceTable()
    {
        
        
        convenienceTable.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-43)
        convenienceTable.delegate = self
        convenienceTable.dataSource = self
        convenienceTable.separatorStyle = .None
        //--------------------
        
        convenienceTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
        convenienceTable.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            print("MJ:(上拉加载)")
            self.footerRefresh()
            
        })
        //---------------------
        self.view.addSubview(convenienceTable)
    }
    
    
    func headerRefresh(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        
        mainHelper.getbbspostlist(self.status, beginid: "0",userid: userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.convenienceTable.mj_header.endRefreshing()
                    return
                }
                
                self.dataSource2.removeAllObjects()
                self.dataSource = response as? Array<TCHDInfo> ?? []
                self.convenienceTable.mj_header.endRefreshing()
                for data in self.dataSource!{
                    data.isOpen = false
                    self.dataSource2.addObject(data)
                }
                self.convenienceTable.reloadData()
            })
        }
        
    }
    
    func footerRefresh(){
        print(self.beginmid)
        if dataSource2.count > 0  {
            if dataSource2.lastObject?.isKindOfClass(TCHDInfo) == true {
                beginmid = (dataSource2.lastObject as! TCHDInfo).mid!
            }
            
        }
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        var myID:Int = Int(beginmid)!
        myID = myID - 5
        self.beginmid = String(myID)
        print(beginmid)
        mainHelper.getbbspostlist(self.status, beginid: beginmid,userid:userid ) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.convenienceTable.mj_footer.endRefreshing()
                    return
                }
                self.dataSource = response as? Array<TCHDInfo> ?? []
                self.convenienceTable.mj_footer.endRefreshing()
                if self.dataSource?.count == 0{
                    self.convenienceTable.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
                for data in self.dataSource!{
                    data.isOpen = false
                    self.dataSource2.addObject(data)
                }
                
                self.convenienceTable.reloadData()
            })
        }
    }

    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.dataSource2.count > 0){
            return ((self.dataSource2.count))
        }else{
            return 0
            
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ConveniceCell.init(info: self.dataSource2[indexPath.row] as! TCHDInfo )
        cell.targets = self
//        cell.deletebutton.hidden = false
        cell.messageButton.hidden = true
        cell.phone.hidden = true
        cell.accountnumberButton.hidden = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.boFangButton.addTarget(self, action: #selector(self.boFangButtonActions(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.boFangButton.tag = indexPath.row
        cell.myDelegate = self
        if status == "-2"{
            let payButton = UIButton.init(frame: CGRectMake(WIDTH-70, 15, 60, 25))
            payButton.setTitle("去支付", forState: .Normal)
            payButton.setTitleColor( UIColor.orangeColor(), forState: .Normal)
            payButton.layer.masksToBounds = true
            payButton.layer.cornerRadius = 5
            payButton.layer.borderColor = UIColor.orangeColor().CGColor
            payButton.layer.borderWidth = 1
            payButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            payButton.tag = indexPath.row + 1000
            payButton.addTarget(self, action: #selector(self.payButton(_:)), forControlEvents: .TouchUpInside)
            cell.addSubview(payButton)
        }
        
        cell.deletebutton.hidden = false
        cell.deletebutton.addTarget(self, action: #selector(self.deletemyfabu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.deletebutton.tag = indexPath.row+1000
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var str = (dataSource2[indexPath.row] as! TCHDInfo).content
        if (dataSource2[indexPath.row] as! TCHDInfo).content != nil{
            str = (dataSource2[indexPath.row] as! TCHDInfo).content
        }else{
            str = ""
        }
        
        
        
        let piccount = (dataSource2[indexPath.row] as! TCHDInfo).pic.count
        
        var height = calculateHeight( str!, size: 15, width: WIDTH - 20 )
        
        if height>95{
            if (dataSource2[indexPath.row] as! TCHDInfo).isOpen == false{
                height = 120
            }else{
                height = height+30
            }
        }
        var picHeight:CGFloat = 0
        if piccount == 1{
            picHeight = WIDTH-120
        }else{
            switch (piccount-1) / 3 {
            case 0:
                picHeight = (WIDTH-60) / 3
            case 1:
                picHeight = (WIDTH-60) / 3 * 2
            case 2:
                picHeight = (WIDTH-60) / 3 * 3
            default:
                picHeight = WIDTH-60
            }
            
        }
        
        if( piccount == 0 )
        {
            picHeight = 0
        }
        if (dataSource2[indexPath.row] as! TCHDInfo).record != nil && (dataSource2[indexPath.row] as! TCHDInfo).record != "" {
            return 75 + picHeight + height + 20+80
        }else{
            return 75 + picHeight + height + 20
        }
    }
    
    
    func pushVC(myVC:UIViewController){
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    func deletemyfabu(sender:UIButton){
        //                print(sender.tag-1000)
        if loginSign == 0 {
            
            alert("请先登录", delegate: self)
            
        }else{
            
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "确定要删除发布信息？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            let user = NSUserDefaults.standardUserDefaults()
                                            let userid = user.objectForKey("userid") as! String
                                            let mainhelper = MainHelper()
                                            mainhelper.Deletebbspost(userid, id: (self.dataSource2[sender.tag-1000] as! TCHDInfo).mid!, handle: { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    if !success{
                                                        return
                                                    }
                                                    self.dataSource2.removeObject(self.dataSource2[sender.tag-1000] as! TCHDInfo)
                                                    
                                                    if sender.tag-1000<7{
                                                        
                                                        self.convenienceTable.reloadData()
                                                        alert("内容已删除", delegate: self)
                                                    }else{
                                                        
                                                        
                                                        let myindexPaths = NSIndexPath.init(forRow:
                                                            sender.tag-1000, inSection: 0)
                                                        self.convenienceTable.deleteRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Right)
                                                        self.convenienceTable.reloadData()
                                                        alert("内容已删除", delegate: self)
                                                    }
                                                    
                                                    
                                                })
                                            })
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    
    func boFangButtonActions(sender:UIButton){
        player.pause()
        timer1.invalidate()
        if (self.dataSource2[sender.tag] as! TCHDInfo).soundtime != ""&&(self.dataSource2[sender.tag] as! TCHDInfo).soundtime != nil
        {
            timesCount =  Int((self.dataSource2[sender.tag] as! TCHDInfo).soundtime!)! + 1
        }else{
            timesCount = 1
        }
        
        
        print(timesCount)
        
        imageView.removeFromSuperview()
        //        player.
        
        imageView = UIImageView.init(frame: CGRectMake(0, 0, sender.width, sender.height))
        imageView.animationImages =  [UIImage(named:"ic_yuyino1")!,UIImage(named:"ic_yuyino2")!,UIImage(named:"ic_yuyino3")!]
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.userInteractionEnabled = false
        imageView.backgroundColor = UIColor.clearColor()
        sender.addSubview(imageView)
        imageView.startAnimating()
        
        let item = AVPlayerItem.init(URL:NSURL.init(string: Bang_Image_Header + (self.dataSource2[sender.tag] as! TCHDInfo).record!)!)
        player = AVPlayer.init(playerItem: item)
        player.volume = 1
        print()
        player.play()
        
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1,
                                                        target:self,selector:#selector(self.recordTimeTick),
                                                        userInfo:nil,repeats:true)
    }
    
    
    func recordTimeTick(){
        timesCount = timesCount - 1
        if timesCount < 0{
            imageView.removeFromSuperview()
            timer1.invalidate()
        }
    }
    func payButton(sender:UIButton){
        let vc = PayViewController()
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let numForGoodS =  dateStr + userid + String(arc4random()) + "_M" + (self.dataSource2[sender.tag-1000] as! TCHDInfo).mid!
        userid = ud.objectForKey("userid")as! String
        
        
        vc.numForGoodS = numForGoodS
        vc.isMessage = true
        
        self.mainHelper.GetMessagePrice("0",userid:userid, handle: { (success, response) in
            if success{
                
                let price1 = Double(response as! String)
                if price1 != nil{
                    vc.price = Double(response as! String)!
                }
                vc.subject = "同城发布购买"
                
                vc.body = "同城发布购买"
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
