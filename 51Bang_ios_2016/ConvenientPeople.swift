//
//  ConvenientPeople.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class ConvenientPeople: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,pushDelegate {
    //----------
    var idleImages:NSMutableArray = []
    var refreshingImages:NSMutableArray = []
    //---------
    var convenienceTable = UITableView.init()
    var myindexRow = NSInteger()
    var boFangButton = UIButton()
    var dataSource : Array<TCHDInfo>?
    var dataSource2 = NSMutableArray()
    var dataSource3 : Array<chatInfo>?
    let mainHelper = MainHelper()
    var isShow = Bool()
    let coverView = UIView()
    let leftTableView = UITableView()
    var headerView = ConvenienceHeaderViewCell()
    var beginmid = "0"
    let FMArr = ["百世汇通","韵达快递","中通快递","申通快递","天天快递","圆通快递","顺丰速运","全峰快递","宅急送","EMS"]
    let FMArr1 = ["baishihuitong","yundakuaidi","zhongtongkuaidi","shentongkuaidi","tiantiankuaidi","yuantongkuaidi","shunfengkuaidi","quanfengkuaidi","zhaijisong","ems"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getData()
//        headerRefresh()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        convenienceTable.userInteractionEnabled = true
        
    }
    override func viewDidAppear(animated: Bool) {
//        self.tabBarController?.tabBar.hidden = false
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setConvenienceTable()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title="便民圈"
        self.convenienceTable.mj_header.beginRefreshing()
        //        let headerView = NSBundle.mainBundle().loadNibNamed("ConvenienceHeaderViewCell", owner: nil, options: nil).first as? ConvenienceHeaderViewCell
        //        //       headerView!.choose.addTarger()
        //        headerView!.choose.addTarget(self, action: #selector(self.choseFM), forControlEvents:UIControlEvents.TouchUpInside)
        //        headerView!.jiantou.addTarget(self, action: #selector(self.choseFM), forControlEvents: UIControlEvents.TouchUpInside)
        //        headerView!.query.backgroundColor = COLOR
        //        headerView?.query.addTarget(self, action: #selector(query(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //        headerView?.tag = 5
        //        convenienceTable.tableHeaderView = headerView
        createRightNavi()
        
        
    }
    
    func pushVC(myVC:UIViewController) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    
    
    func createRightNavi(){
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 40, 20)
        //        button.backgroundColor = UIColor.redColor()
        button.setTitle("发布", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView:button)
        self.navigationItem.rightBarButtonItem = item
        
    }
    
    //MARK:跳转发布页
    func nextView(){
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            
            let ud = NSUserDefaults.standardUserDefaults()
            
            if(ud.objectForKey("ss") as! String == "no")
            {
                let vc  = WobangRenZhengController()
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
                return
                
            }
            //            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            //            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AddView")
            //            self.navigationController?.pushViewController(vc, animated: true)
            let vc = FaBuBianMinViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            //            vc.title = "发布便民信息"
        }
        
    }
    
    
    func query(btn:UIButton){
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
        
        let LogisticsVC = UIViewController()
        LogisticsVC.view.backgroundColor = GREY
        
        
        let myWebView = UIWebView()
        myWebView.backgroundColor = GREY
        myWebView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string:"http://m.kuaidi100.com/index_all.html?type="+FMArr1[myindexRow]+"&postid="+"")!))
        myWebView.delegate = self
        LogisticsVC.view.addSubview(myWebView)
        
        
        //        let vc = LogisticsViewController()
        self.navigationController?.pushViewController(LogisticsVC, animated: true)
        }
    }
    
    
    
    func choseFM(){
        
        if isShow == false {
            coverView.frame = CGRectMake(0, 60, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            leftTableView.frame = CGRectMake(0, 60, WIDTH/3, HEIGHT/2)
            leftTableView.tag = 1
            leftTableView.delegate = self
            leftTableView.dataSource = self
            leftTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "leftTableView")
            convenienceTable.addSubview(leftTableView)
            convenienceTable.addSubview(coverView)
            convenienceTable.bringSubviewToFront(leftTableView)
            isShow = true
        }else{
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow = false
        }
        
    }
    
    
    
    
    
    func getData(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        mainHelper.GetTchdList("1", beginid: beginmid) { (success, response) in
            if !success {
                hud.hide(true)
                alert("数据加载出错", delegate: self)
                return
            }
            hud.hide(true)
            print(response)
            self.dataSource = response as? Array<TCHDInfo> ?? []
            print("---------------------------")
//            print(self.dataSource![0].mid)
//            print(self.dataSource![1].mid)
//            print(self.dataSource![2].mid)
//            print(self.dataSource![3].mid)
//            print(self.dataSource![4].mid)
            print("---------------------------")
//            print(self.dataSource?.count)
//            print(self.dataSource)
//            print(self.dataSource![0].pic)
//            print(self.dataSource![0].record)
            
            self.convenienceTable.reloadData()
            
        }
        
    }
    
    
    func setConvenienceTable()
    {
        //        convenienceTable.frame = CGRectMake(0, 0, WIDTH, self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height)! - (self.navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.height )
        
        convenienceTable.frame = CGRectMake(0, 0, WIDTH, HEIGHT - (self.navigationController?.navigationBar.frame.size.height)!)
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
        mainHelper.GetTchdList("1", beginid: "0") { (success, response) in
            if !success {
                self.convenienceTable.mj_header.endRefreshing()
                return
            }
            
            self.dataSource2.removeAllObjects()
            self.dataSource = response as? Array<TCHDInfo> ?? []
            self.convenienceTable.mj_header.endRefreshing()
            for data in self.dataSource!{
                self.dataSource2.addObject(data)
            }
            self.convenienceTable.reloadData()
            
        }
        
    }
    
    func footerRefresh(){
        print(self.beginmid)
        
        beginmid = (dataSource2.lastObject as! TCHDInfo).mid!
        var myID:Int = Int(beginmid)!
        myID = myID - 5
        self.beginmid = String(myID)
        print(beginmid)
        mainHelper.GetTchdList("1", beginid: beginmid) { (success, response) in
            if !success {
                self.convenienceTable.mj_footer.endRefreshing()
                return
            }
            self.dataSource = response as? Array<TCHDInfo> ?? []
            self.convenienceTable.mj_footer.endRefreshing()
//            if self.dataSource?.count == 0{
//                self.convenienceTable.mj_footer.endRefreshingWithNoMoreData()
//            }
            for data in self.dataSource!{
                
                self.dataSource2.addObject(data)
            }
            
            self.convenienceTable.reloadData()
            
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if (tableView == leftTableView){
        //            return FMArr.count
        //        }
        
        if(self.dataSource2.count > 0){
            return ((self.dataSource2.count)+1)
        }else{
            return 0
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            //            headerView = (NSBundle.mainBundle().loadNibNamed("ConvenienceHeaderViewCell", owner: nil, options: nil).first as? ConvenienceHeaderViewCell)!
            //            //       headerView!.choose.addTarger()
            //            headerView.choose.addTarget(self, action: #selector(self.choseFM), forControlEvents:UIControlEvents.TouchUpInside)
            //            headerView.jiantou.addTarget(self, action: #selector(self.choseFM), forControlEvents: UIControlEvents.TouchUpInside)
            //            headerView.query.backgroundColor = COLOR
            //            headerView.query.addTarget(self, action: #selector(query(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //            headerView.tag = 5
            //            return headerView
            let cell = UITableViewCell()
            let queryButton = UIButton.init(frame: CGRectMake(5, 5, WIDTH - 10,34))
            queryButton.backgroundColor = COLOR
            queryButton.addTarget(self, action: #selector(query(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            queryButton.setTitle("点击此处可进行快递查询", forState: UIControlState.Normal)
            queryButton.layer.borderColor = COLOR.CGColor
            queryButton.layer.borderWidth = 1.0
            queryButton.layer.cornerRadius = 5
            queryButton.layer.masksToBounds = true
            cell.addSubview(queryButton)
            return cell
            
        }else{
            if tableView.tag == 1 {
                tableView.separatorStyle = .None
                let cell = tableView.dequeueReusableCellWithIdentifier("leftTableView")
                
                cell?.textLabel?.text = FMArr[indexPath.row]
                cell?.selectionStyle = .None
                return cell!
            }else{
                
                
                print( self.dataSource2 )
                if(self.dataSource2.count > 0 )
                {
                    print((dataSource2[indexPath.row-1] as! TCHDInfo).record)
                    self.boFangButton.removeFromSuperview()
                    let cell = ConveniceCell.init(info: self.dataSource2[indexPath.row-1] as! TCHDInfo )
                    //                    if self.dataSource![indexPath.row-1].record != nil || self.dataSource![indexPath.row-1].record != "" {
                    //
                    //
                    //                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.boFangButton.addTarget(self, action: #selector(self.boFangButtonActions(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    cell.boFangButton.tag = indexPath.row-1
                    cell.myDelegate = self
                    cell.messageButton.addTarget(self, action: #selector(self.messageButtonAction(_:)), forControlEvents:
                    UIControlEvents.TouchUpInside)
                    cell.phone.tag = indexPath.row-1+100
                    cell.phone.addTarget(self, action: #selector(self.callPhone(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    cell.messageButton.tag = indexPath.row-1
                    return cell
                }else{
                    let cell = UITableViewCell()
                    return cell
                }
                
                
                
            }
        }
        
        
    }
    
    
    
    func callPhone(sender:UIButton){
//        print(self.info?.phone)
        if loginSign == 0 {
            
            alert("请先登录", delegate: self)
            
        }else{
            
            if (self.dataSource2[sender.tag-100] as! TCHDInfo).phone == nil || (self.dataSource2[sender.tag-100] as! TCHDInfo).phone!.characters.count<0 {
                alert("未发布电话", delegate: self)
                return
            }else{
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "是否要拨打电话？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                
                                                UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://"+(self.dataSource2[sender.tag-100] as! TCHDInfo).phone!)!)
                                                
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
            }
        }
    }
    func messageButtonAction(sender:UIButton) {
        convenienceTable.userInteractionEnabled = false
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
        
        let vc = ChetViewController()
        vc.receive_uid = (dataSource2[sender.tag] as! TCHDInfo).userid
        //        vc.datasource2 = NSMutableArray()
            vc.titleTop = (dataSource2[sender.tag] as! TCHDInfo).name
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        if userid == (dataSource2[sender.tag] as! TCHDInfo).userid{
            convenienceTable.userInteractionEnabled = true
            alert("请不要和自己说话", delegate: self)
        }else{
        mainHelper.getChatMessage(userid, receive_uid: (dataSource2[sender.tag] as! TCHDInfo).userid!) { (success, response) in
            
            if !success {
                alert("加载错误", delegate: self)
                return
            }
            let dat = NSMutableArray()
            self.dataSource3 = response as? Array<chatInfo> ?? []
            print(self.dataSource3)
            if self.dataSource3?.count != 0{
            for num in 0...self.dataSource3!.count-1{
                let dic = NSMutableDictionary()
                dic.setObject(self.dataSource3![num].id!, forKey: "id")
                dic.setObject(self.dataSource3![num].send_uid!, forKey: "send_uid")
                dic.setObject(self.dataSource3![num].receive_uid!, forKey: "receive_uid")
                dic.setObject(self.dataSource3![num].content!, forKey: "content")
                dic.setObject(self.dataSource3![num].status!, forKey: "status")
                dic.setObject(self.dataSource3![num].create_time!, forKey: "create_time")
                if self.dataSource3![num].send_face != nil{
                    dic.setObject(self.dataSource3![num].send_face!, forKey: "send_face")
                }
                
                if self.dataSource3![num].send_nickname != nil{
                    dic.setObject(self.dataSource3![num].send_nickname!, forKey: "send_nickname")
                }
                
                if self.dataSource3![num].receive_face != nil{
                    dic.setObject(self.dataSource3![num].receive_face!, forKey: "receive_face")
                }
                
                if self.dataSource3![num].receive_nickname != nil{
                    dic.setObject(self.dataSource3![num].receive_nickname!, forKey: "receive_nickname")
                }
                
                
                dat.addObject(dic)
                
                //                vc.datasource2.addObject(dic)
                
            }
            
            print(dat)
            vc.datasource2 = NSArray.init(array: dat) as Array
            self.navigationController?.pushViewController(vc, animated: true)
           
            }else{
                self.navigationController?.pushViewController(vc, animated: true)
            }
           

          }
            
       }
        }
    }
    
    func boFangButtonActions(sender:UIButton){
        
        mainHelper.downloadRecond((self.dataSource2[sender.tag] as! TCHDInfo).record!)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0&&tableView == convenienceTable {
            return
        }
        if tableView.tag == 1{
            headerView.choose.setTitle(FMArr[indexPath.row], forState: UIControlState.Normal)
            myindexRow = indexPath.row
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow = false
        }
        return
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0&&tableView == convenienceTable {
            return 44
        }else{
            if tableView.tag == 1 {
                return CGFloat(tableView.frame.height/CGFloat(FMArr.count))
            }else{
                
                let str = (dataSource2[indexPath.row-1] as! TCHDInfo).content
                let piccount = (dataSource2[indexPath.row-1] as! TCHDInfo).pic.count
                
                let height = calculateHeight( str!, size: 15, width: WIDTH - 10 )
                
                var picHeight:CGFloat = 0
                
                switch (piccount-1) / 3 {
                case 0:
                    picHeight = (WIDTH-15) / 3
                case 1:
                    picHeight = (WIDTH-15) / 3 * 2
                case 2:
                    picHeight = (WIDTH-15) / 3 * 3
                default:
                    picHeight = WIDTH
                }
                
                if( piccount == 0 )
                {
                    picHeight = 0
                }
                if (dataSource2[indexPath.row-1] as! TCHDInfo).record != nil && (dataSource2[indexPath.row-1] as! TCHDInfo).record != "" {
                    return 75 + picHeight + height + 20+80 + 20
                }else{
                    return 75 + picHeight + height + 20 + 20
                }
                
                
                
            }
        }
        
        
        
        
    }
    
    
}
