//
//  MyAdvertisementPublishListViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class MyAdvertisementPublishListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {

    var status = String()
    let mytableView = UITableView()
    var beginmid = "0"
    let mainHelper = MainHelper()
    var dataSource2 = NSMutableArray()
    var dataSource : Array<AdVlistInfo> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-43)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
//        self.mytableView.registerClass(MyAdvertisementPublishListTableViewCell.self, forCellReuseIdentifier: "MyAdvertisementPublishListTableViewCell")
        mytableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.beginmid = "0"
            self.headerRefresh()
            
        })
        mytableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            print("MJ:(上拉加载)")
            self.footerRefresh()
            
        })
        
        self.view.addSubview(self.mytableView)

//        self.mytableView.mj_header.beginRefreshing()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mytableView.mj_header.beginRefreshing()
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    func headerRefresh(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        mainHelper.getMyAdlist(self.status, beginid: "0",userid: userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                
                hud.hide(true)
                if !success {
                    self.mytableView.mj_header.endRefreshing()
                    return
                }
                if self.beginmid=="0"{
                    self.dataSource = response as? Array<AdVlistInfo> ?? []
                    self.mytableView.mj_header.endRefreshing()
                    self.mytableView.mj_footer.endRefreshing()
                    self.mytableView.reloadData()
                }
                
                
            })
        }
        
    }
    
    func footerRefresh(){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        self.beginmid = (self.dataSource.last?.slide_id)!
        print(beginmid)
        mainHelper.getbbspostlist(self.status, beginid: beginmid,userid:userid ) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                hud.hide(true)
                if !success {
                    self.mytableView.mj_footer.endRefreshing()
                    return
                }
                if (response as? Array<AdVlistInfo> ?? []).count == 0{
                    self.mytableView.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
                self.dataSource = self.dataSource + (response as? Array<AdVlistInfo> ?? [])
                self.mytableView.mj_footer.endRefreshing()
                
                
                self.mytableView.reloadData()
            })
        }
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 350+WIDTH/2
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataSource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = MyAdvertisementPublishListTableViewCell.init(myinfo: self.dataSource[indexPath.row])
        cell.selectionStyle = .None
        
        cell.urlLabel.addTarget(self, action: #selector(self.goUrlAction(_:)), forControlEvents: .TouchUpInside)
        cell.urlLabel.tag = indexPath.row+100
        
        
        if stringIsNotNil(self.dataSource[indexPath.row].slide_status!) as! String=="1"{
            cell.payButton.hidden = true
            cell.deletebutton.hidden = true
        }else if stringIsNotNil(self.dataSource[indexPath.row].slide_status!) as! String=="-2"{
            cell.deletebutton.hidden = false
            cell.deletebutton.tag = indexPath.row
            cell.deletebutton.addTarget(self, action: #selector(self.deletebuttonAction(_:)), forControlEvents: .TouchUpInside)
            cell.payButton.hidden = false
            cell.payButton.tag = indexPath.row
            cell.payButton.addTarget(self, action: #selector(self.payButtonAction(_:)), forControlEvents: .TouchUpInside)
        }else if stringIsNotNil(self.dataSource[indexPath.row].slide_status!) as! String=="-3"{
            cell.payButton.hidden = false
            cell.deletebutton.hidden = false
            cell.payButton.setTitle("编辑", forState: .Normal)
        }
        return cell
    }
    
    func payButtonAction(sender:UIButton){
        
        if stringIsNotNil(self.dataSource[sender.tag].slide_status!) as! String == "-3"{
            let vc = GoAdvertisementPublishViewController()
            vc.info = self.dataSource[sender.tag]
            vc.isEdit = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc = PayViewController()
        vc.isGuanggao = true
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        if self.dataSource[sender.tag].order_num != nil{
            let numForGoodS =  dateStr + userid  + "_"+self.dataSource[sender.tag].order_num!
            vc.numForGoodS = numForGoodS
        }
        if self.dataSource[sender.tag].price != nil{
            let price1 = Double(self.dataSource[sender.tag].price!)
            if price1 != nil{
                vc.price = 0.01
//                vc.price = Double(self.dataSource[sender.tag].price!)
            }
        }
        
        
        vc.subject = "广告发布购买"
        
        vc.body = "广告发布购买"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deletebuttonAction(sender:UIButton){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        
        let alertController = UIAlertController(title: "系统提示",
                                                message: "确定要删除广告？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        self.mainHelper.DeleteMyAD(userid, id: self.dataSource[sender.tag].slide_id!) { (success, response) in
                                            if success{
                                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                                hud.mode = MBProgressHUDMode.Text;
                                                hud.labelText = "删除成功"
                                                hud.margin = 10.0
                                                hud.yOffset = Float(HEIGHT/2-80)
                                                hud.labelFont = UIFont.systemFontOfSize(14)
                                                hud.hide(true, afterDelay: 1.5)
                                                self.mytableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: sender.tag, inSection: 0)], withRowAnimation: .Left)
                                                self.mytableView.reloadData()
                                            }
                                        }
                          
                                        
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func goUrlAction(sender:UIButton){
        let vc = PublicWebViewVC()
        vc.view.backgroundColor = UIColor.brownColor()
        if self.dataSource[sender.tag-100].slide_name != nil{
            vc.title = self.dataSource[sender.tag-100].slide_name
        }
        
        
        if self.dataSource[sender.tag-100].slide_url != nil{
            let url = NSURL(string:"http://"+(self.dataSource[sender.tag-100].slide_url)!)
            if url != nil{
                vc.url = url!
            }else{
                return
            }
        }
        
        
       
        
        self.navigationController?.pushViewController(vc, animated: true)
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
