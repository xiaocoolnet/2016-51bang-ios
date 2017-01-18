//
//  MyFaDan.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class DanModel {
    var taskid:String = ""
    var taskName:String = ""
    var taskMan:String = ""
    var receive:String = ""
    var statuMoney:String = ""
    
}
class MyFaDan: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    //此处有bug
    var finshTable = UITableView()
    let weiBtn = UIButton()
    let finshBtn = UIButton()
    let rushedBtn = UIButton()
    let visitedBtn = UIButton()
    var cellData = TaskInfo()
    var Data = []
    var mTable = UITableView()
    let decorView = UIView()
    let rect  = UIApplication.sharedApplication().statusBarFrame
    
    let mainHelper = MainHelper()
    var dataSource : Array<TaskInfo>?
    var dataSource1 : Array<TaskInfo>?
    var info = TaskInfo()
    var xiaofeiview = XiaoFeiTableViewCell()
//    var dataSource2 : Array<TaskInfo>?
    var sign = Int()
    
    override func  viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let view = self.view.viewWithTag(48)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        view?.removeFromSuperview()
//        xiaofeiview = self.view.viewWithTag(23)
//        xiaofeiview.removeFromSuperview()
//        sign = 1
        headerRefresh()
    }
    
    
    override func viewDidLoad() {
        
//        GetWWCData("1")
        
        self.title = "我的发单"
        self.navigationController?.navigationBar.hidden = false
        decorView.frame = CGRectMake(0, 35, WIDTH / 4, 5)
        decorView.backgroundColor = COLOR
        self.view.addSubview(decorView)
//        cellData.taskName="充公交卡"
//        cellData.receive = "15589542081"
//        cellData.statuMoney = "10元"
//        cellData.taskid = "wyb123456"
//        cellData.taskMan = "15589542081"
        Data = [cellData,cellData,cellData,cellData,cellData]
//        mTable = UITableView.init(frame: CGRectMake(0, 40, WIDTH, self.view.frame.size.height - 45 - rect.height ), style: UITableViewStyle.Grouped)
       
//        self.view.addSubview(mTable)
//        mTable.delegate = self
//        mTable.dataSource = self
//        mTable.tag = 0
        
        setButton()
        self.view.backgroundColor = RGREY
        
    }
    
    
    func GetYWCData(state:NSString){
    
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
         var userid = String()
        if ud.objectForKey("userid") != nil{
            userid = ud.objectForKey("userid")as! String
        }
        
        mainHelper.GetTaskList (userid,state: state,handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
//                     self.mTable.mj_header.endRefreshing()
                    return
                }
                print(response)
                    hud.hidden = true
//                self.dataSource?.removeAll()
//                self.dataSource = response as? Array<TaskInfo> ?? []
//                self.Data = self.dataSource!
//                if state == "0"{
                    self.dataSource1?.removeAll()
                    self.dataSource1 = response as? Array<TaskInfo> ?? []
//                    self.mTable.mj_header.endRefreshing()
                if self.dataSource1?.count == 0{
                
//                    alert("还没有已完成的任务", delegate: self)
                }
//                    self.Data = self.dataSource1!
                
                    self.createTableView()
                    print(self.dataSource1?.count)
              
//                }
            })
           })

    }
    
    func GetWWCData(state:NSString){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil{
            userid = ud.objectForKey("userid")as! String
        }
//        let userid = ud.objectForKey("userid")as! String
        mainHelper.GetTaskList (userid,state: state,handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
//                     self.mTable.mj_header.endRefreshing()
                    return
                }
                hud.hidden = true
                print(response)
//                self.dataSource?.removeAll()
//                 self.mTable.mj_header.endRefreshing()
                if ((response?.isKindOfClass(NSArray)) != nil){
                    self.dataSource = response as? Array<TaskInfo> ?? []
                }
                
                self.Data = self.dataSource!
//                self.GetYWCData("4")
                self.createTableView()
                print(self.dataSource?.count)
                
            })
            
            })
    }

    func createTableView(){
        
        mTable = UITableView.init(frame: CGRectMake(0, 40, WIDTH, self.view.frame.size.height  - rect.height ), style: UITableViewStyle.Grouped)
        self.view.addSubview(mTable)
        mTable.delegate = self
        mTable.dataSource = self
//        mTable.backgroundColor = UIColor.whiteColor()
        mTable.tag = 0
        mTable.registerNib(UINib(nibName: "YwcTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        finshTable =  UITableView.init(frame: CGRectMake(0,35, WIDTH, self.view.frame.size.height - 45 - rect.height), style: UITableViewStyle.Grouped)
        finshTable.hidden = true
        finshTable.delegate = self
        finshTable.dataSource = self
        finshTable.tag = 1
//        self.view.addSubview(finshTable)
        
        let HeaderView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 0.01))
        mTable.tableHeaderView = HeaderView
        mTable.sectionHeaderHeight = 1
        mTable.sectionFooterHeight = 5
    
        mTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            self.mTable.mj_header.endRefreshing()
        })
        
        //划动手势
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleRight))
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
    }
    func handleRight(){
        
        if sign == 0 {
            visitedBtnAction()
        }else if sign == 3{
            rushedBtnAction()
        }else if sign == 2{
             weiBtnAction()
        }else{
//            finshBtnAction()
        }
    
    }
    
    func handleLeft(){
        
        if sign == 2 {
            visitedBtnAction()
        }else if sign == 1{
            rushedBtnAction()
        }else if sign == 3{
            finshBtnAction()
        }else{
//            weiBtnAction()
        }
        
    }
    
    func headerRefresh(){
        
        if sign == 3 {
            visitedBtnAction()
        }else if sign == 2{
            rushedBtnAction()
        }else if sign == 1{
            weiBtnAction()
        }else{
            finshBtnAction()
        }
        
        
//        if(sign == 1){
//            weiBtnAction()
////            GetWWCData("0,1,2,3,4")
//        }else{
//            finshBtnAction()
////            GetYWCData("5")
//        }
    }
        
    
    func setButton()
    {
        weiBtn.frame = CGRectMake(0, 0, WIDTH / 4, 35)
        finshBtn.frame  = CGRectMake(WIDTH / 4*3, 0, WIDTH / 4, 35)
        weiBtn.setTitle("未抢单", forState: UIControlState.Normal)
        weiBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        finshBtn.setTitle("已完成", forState: UIControlState.Normal)
        
        finshBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        finshBtn.addTarget(self, action: #selector(self.finshBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        weiBtn.addTarget(self, action: #selector(self.weiBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        weiBtn.backgroundColor = UIColor.whiteColor()
        finshBtn.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(weiBtn)
        self.view.addSubview(finshBtn)
        
        
        rushedBtn.frame = CGRectMake(WIDTH / 4, 0, WIDTH / 4, 35)
        rushedBtn.setTitle("已被抢", forState: UIControlState.Normal)
        rushedBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        rushedBtn.addTarget(self, action: #selector(self.rushedBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        rushedBtn.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(rushedBtn)
        
        
        visitedBtn.frame = CGRectMake(WIDTH / 4*2, 0, WIDTH / 4, 35)
        visitedBtn.setTitle("已上门", forState: UIControlState.Normal)
        visitedBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        visitedBtn.addTarget(self, action: #selector(self.visitedBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        visitedBtn.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(visitedBtn)
        
    }
    
    
    
    func finshBtnAction()
    {
        sign = 0
        GetYWCData("5,6,7,10")
        self.dataSource?.removeAll()
        
//        self.GetYWCData("4")
//        self.GetWWCData("0,1,2,3")
        weiBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        rushedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        visitedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        finshBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        decorView.frame = CGRectMake( WIDTH / 4*3, 35, WIDTH / 4, 5)
        mTable.reloadData()
//        mTable.hidden = true
//        finshTable.hidden = false
        
        
    }
    
    func weiBtnAction()
    {
        sign = 1
        self.dataSource1?.removeAll()
        self.GetWWCData("1")
        weiBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        finshBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        rushedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        visitedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        decorView.frame = CGRectMake( 0, 35, WIDTH / 4, 5)
        mTable.reloadData()
        
        
    }
    
    func rushedBtnAction(){
        sign = 2
        self.dataSource1?.removeAll()
        self.GetWWCData("2")
        rushedBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        finshBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        weiBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        visitedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        decorView.frame = CGRectMake( WIDTH / 4, 35, WIDTH / 4, 5)
        mTable.reloadData()
    }
    func visitedBtnAction(){
        sign = 3
        self.dataSource1?.removeAll()
        self.GetWWCData("3,4")
        visitedBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        finshBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        weiBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        rushedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        decorView.frame = CGRectMake( WIDTH / 4*2, 35, WIDTH / 4, 5)
        mTable.reloadData()

    }
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(sign == 1 || sign == 2 || sign == 3)
        {
            print(self.dataSource?.count)
            if self.dataSource == nil {
                return 0
            }else{
                return (self.dataSource?.count)!
            }
            
            
        }else{
            if self.dataSource1 == nil {
                return 0
            }else{
                return (self.dataSource1?.count)!
            }
            
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(sign == 1 || sign == 2 || sign == 3 )
        {
           
            if dataSource?.count != 0{
                print(self.dataSource!)
                print(indexPath.section)
                print(self.dataSource![indexPath.section])
                let cell = MyFaDanCell.init(model: self.dataSource![indexPath.section])
                cell.payBtn.tag = indexPath.section
                cell.myButton.tag = 1000+indexPath.section
                cell.myButton.addTarget(self, action: #selector(self.goMyZhuye(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                //            let payBtn = cell.viewWithTag(10)as! UIButton
                if (self.dataSource![indexPath.section].paystatus == "0") {
                    cell.payBtn.addTarget(self, action: #selector(self.nextView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }else{
                    cell.payBtn.addTarget(self, action: #selector(self.pay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
                 return cell
            }else{
                let cell = UITableViewCell()
                 return cell
            }
           
        }else{
            if dataSource1?.count != 0 {
                print(self.dataSource1)
                print(indexPath.section)
                print(self.dataSource1![indexPath.section])
                
                let cell = tableView.dequeueReusableCellWithIdentifier("cell")as! YwcTableViewCell
                cell.goZhuye.addTarget(self, action: #selector(self.GoZhuyeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.goZhuye.tag = indexPath.section+500
                cell.setValueWithInfo(self.dataSource1![indexPath.section])
                cell.selectionStyle = .None
                
                if self.dataSource1![indexPath.section].commentlist.count>0 {
                    cell.pingjia.setTitle("已评价", forState:UIControlState.Normal)
                    cell.pingjia.tag = indexPath.section+200
                    cell.pingjia.setTitleColor(UIColor.orangeColor(), forState: .Normal)
                    cell.pingjia.userInteractionEnabled = false
                }else{
                    cell.pingjia.setTitle("评价", forState:UIControlState.Normal)
                    cell.pingjia.userInteractionEnabled = true
                    cell.pingjia.setTitleColor(COLOR, forState: .Normal)
                    cell.pingjia.tag = indexPath.section+200
                    cell.pingjia.addTarget(self, action: #selector(self.goPingJia(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
//                cell.pingjia.hidden = true
                
                return cell
            }else{
                let cell = UITableViewCell()
                return cell
            }
            
            
        }
        
        
    }
    
    func goMyZhuye(sender:UIButton){
        let vc = FuWuHomePageViewController()
        vc.isUserid = true
        print(self.dataSource![sender.tag-1000].apply!.userid)
//        print(self.dataSource![sender.tag-1000].apply!.userid)
        if self.dataSource![sender.tag-1000].apply!.userid != nil {
            vc.userid = self.dataSource![sender.tag-1000].apply!.userid!
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func GoZhuyeAction(sender:UIButton){
        let vc = FuWuHomePageViewController()
        vc.isUserid = true
        print(sender.tag-500)
        print(self.dataSource1![sender.tag-500].apply!.userid)
        if self.dataSource1![sender.tag-500].apply!.userid != nil {
            vc.userid = self.dataSource1![sender.tag-500].apply!.userid!
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func pay(btn:UIButton){
        
        
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定要付款吗？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        let ud = NSUserDefaults.standardUserDefaults()
                                        var userid = String()
                                        if ud.objectForKey("userid") != nil{
                                            userid = ud.objectForKey("userid")as! String
                                        }
//                                        let userid = ud.objectForKey("userid")as! String
            self.mainHelper.gaiBianRenWu(userid,ordernum: self.dataSource![btn.tag].order_num!, state: "5", handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    alert("付款失败请重试", delegate: self)
                    return
                }
                self.finshBtnAction()
                })
            })
                                        
                                        
                                        
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    
//        self.info = self.dataSource![btn.tag]
//        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
//        view.backgroundColor = UIColor.grayColor()
//        view.alpha = 0.6
//        view.tag = 48
//        self.view.addSubview(view)
//         xiaofeiview = NSBundle.mainBundle().loadNibNamed("XiaoFeiTableViewCell", owner: nil, options: nil).first as! XiaoFeiTableViewCell
//        xiaofeiview.tag = 23
//        xiaofeiview.frame = CGRectMake(WIDTH/2-125, HEIGHT/2-50, 250, 110)
//        xiaofeiview.yes.tag = 45
//        xiaofeiview.no.tag = 46
//        xiaofeiview.textField.tag = 47
//        xiaofeiview.textField.delegate = self
//        xiaofeiview.yes.layer.cornerRadius = 5
//        xiaofeiview.no.layer.cornerRadius = 5
//        xiaofeiview.yes.addTarget(self, action: #selector(self.nextView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        xiaofeiview.no.addTarget(self, action: #selector(self.nextView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(xiaofeiview)
////        let view = NSBundle.mainBundle().loadNibNamed("XiaoFeiTableViewCell", owner: nil, options: nil).first as! XiaoFeiTableViewCell
    
    }
    
    // MARK: -UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 47 {
            UIView.animateWithDuration(0.4, animations: {
                self.xiaofeiview.frame = CGRectMake(WIDTH/2-125, HEIGHT/2-50-150, 250, 110)
            })
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 47 {
            UIView.animateWithDuration(0.4, animations: {
                self.xiaofeiview.frame = CGRectMake(WIDTH/2-125, HEIGHT/2-50, 250, 110)
            })
            
        }
        
    }
    
    func nextView(btn:UIButton){
        
        let vc = PayViewController()
        vc.price =  Double(self.dataSource![btn.tag].price! as String)!
        vc.body = self.dataSource![btn.tag].title! as String
        vc.numForGoodS = self.dataSource![btn.tag].order_num! as String
        vc.isRenwu = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        let view = self.view.viewWithTag(48)
//        view?.removeFromSuperview()
////        let xiaofeiview = self.view.viewWithTag(23)
//        self.xiaofeiview.textField.resignFirstResponder()
//        self.xiaofeiview.removeFromSuperview()
//        self.xiaofeiview.hidden = true
//    }
    
    
    func viewTap(sender: UITapGestureRecognizer) {
        
        let vc = PingJiaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goPingJia(sender:UIButton){
    
        let orderCommentViewController = OrderCommentViewController()
        orderCommentViewController.idStr = self.dataSource1![sender.tag-200].id!
        orderCommentViewController.order_num = self.dataSource1![sender.tag-200].order_num!
        orderCommentViewController.usertype = "2"
        orderCommentViewController.types = "1"
        self.navigationController?.pushViewController(orderCommentViewController, animated: true)
    
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 1
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 204
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = FaDanDetailViewController()
        if sign == 0 {
           
            vc.info = self.dataSource1![indexPath.section]
            
        }else{
        
            vc.info = self.dataSource![indexPath.section]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
