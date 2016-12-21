//
//  MineViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
protocol ViewControllerDelegate:NSObjectProtocol {
    func viewcontrollerDesmiss()
}

var loginSign = 0
class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,MineDelegate{
    var login = UIButton()//登陆按钮
    let badgeView1 = UIView()//小红点
    let badgeView2 = UIView()//小红点
    let badgeView3 = UIView()//小红点
    let badgeView4 = UIView()//小红点
    let badgeView5 = UIView()//小红点
    let badgeView6 = UIView()//小红点
    var dataSource2 : Array<chatInfo>?
    
    let phone:String = "400608856"
    let mainhelper = MainHelper()
    
    let headerView = NSBundle.mainBundle().loadNibNamed("MineHeaderCell", owner: nil, options: nil).first as! MineHeaderCell
    var isShow = Bool()
    var image = UIImage.init(named: "ic_moren-1")!
    let LOGINFO_KEY = "logInfo"
    let USER_NAME = "username"
    let USER_PWD = "password"
    let SHOW_GUIDE = "showguide"
    var LOGIN_STATE = false
    weak var delegate:ViewControllerDelegate?
    var phoneNum:String?
    var pwd:String?
    var backView = UIView()//登陆页面
    var logVM:TCVMLogModel?
    let top = UIView()
    let myTableView = UITableView()
    let foot:[String] = ["我是买家","我是卖家","",""]
    let team:[String] = ["我的发单","我的订单","我的发布","我的收藏","卷码验证","分享二维码","商户订单"]
    let teamImg:[String] = ["ic_wodefadan","ic_youhuiquan","ic_wodefabu","ic_wodedingdan","wodeshoucang","ic_weizhi拷贝2","ic_fenxiang","ic_youhuiquan"]
    
    let busness:[String] = ["我的接单","我的投保","我的地址"]
    let busnissImg:[String] = ["ic_wodejiedan","ic_woyaotoubao","ic_weizhi拷贝2"]
    
    let benApp:[String] = ["客服咨询","更多服务"]
    let benImg:[String] = ["ic_kefuzixun","ic_gengduofuwu"]
    
    let labArr:[String] = ["钱包","签到","消息"]
    let labImg:[String] = ["ic_qianbao","ic_qiandao","ic_xiaoxi"]
    var pwdTextfield = UITextField()
    var phoneTextfield = UITextField()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
        self.login.userInteractionEnabled = true
        self.login.backgroundColor = COLOR
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if registrationID != nil{
                self.login.userInteractionEnabled = true
            }
        }
        self.login.userInteractionEnabled = true
        isShow = false
        
        if self.badgeView1.hidden && self.badgeView2.hidden && self.badgeView3.hidden && self.badgeView4.hidden && self.badgeView5.hidden{
            let view = self.tabBarController?.tabBar.viewWithTag(888)
            view?.removeFromSuperview()
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
        
        
        
        //        backView.frame = CGRectMake(0, 64, WIDTH, HEIGHT)
        //        backView.backgroundColor = RGREY
       
        let ud = NSUserDefaults.standardUserDefaults()
        
        if(loginSign == 0)
        {
//            self.createLoginUI()
            self.backView.hidden = false
            
        }else
            
        {
            
            getuserData()
            
            
        }
        
        
        
        
        
        pwdTextfield.secureTextEntry = true
//        pwdTextfield.keyboardType = 
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
//        let ud = NSUserDefaults.standardUserDefaults()
        self.Checktoubao()
        if(ud.objectForKey("userid")==nil)
        {
            backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        }
        if ud.objectForKey("ss") != nil{
            if ud.objectForKey("ss") as! String == "no"{
                self.headerView.renzheng.setTitle("未实名认证", forState: UIControlState.Normal)
                self.headerView.renzheng.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            }else{
                self.headerView.renzheng.setTitle("实名认证", forState: UIControlState.Normal)
                self.headerView.renzheng.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
        }else{
            self.headerView.renzheng.setTitle("未实名认证", forState: UIControlState.Normal)
            self.headerView.renzheng.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }
        
//        self.headerView.renzheng.hidden = false
        Checktoubao()
        
        
//        getuserData()
        print(loginSign)
        
    }
    
    //    override func viewDidDisappear(animated: Bool) {
    //        self.tabBarController?.tabBar.hidden = true
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //检查是否登录过
        resignTongZhi()
        logVM = TCVMLogModel()
        top.frame = CGRectMake(0, -50, WIDTH, 100)
        //        top.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(top)
        
        myTableView.backgroundColor = RGREY
        myTableView.tag = 1
        myTableView.frame = CGRectMake( 0, 0, WIDTH, HEIGHT-49)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.registerNib(UINib(nibName: "MineTableViewCell",bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(myTableView)
        //        self.navigationController?.title = "51帮"
        
        headerView.backgroundColor = COLOR
        headerView.iconBtn.addTarget(self, action: #selector(self.edit), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.backgroundColor = COLOR
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*150/375)
        //        headerView.backgroundColor = UIColor.blueColor()
        self.myTableView.tableHeaderView = headerView
        badgeView1.hidden = true
        badgeView2.hidden = true
        badgeView3.hidden = true
        badgeView4.hidden = true
        badgeView5.hidden = true
        badgeView6.hidden = true
        self.createLoginUI()
        self.backView.hidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func resignTongZhi(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.newMessage(_:)), name:"newMessage", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sendTaskType(_:)), name:"sendTaskType", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.acceptTaskType(_:)), name:"acceptTaskType", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.buyOrderType(_:)), name:"buyOrderType", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.businessOrderType(_:)), name:"businessOrderType", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loginFromOther), name:"loginFromOther", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.certificationType(_:)), name:"certificationType", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.CustomPushType(_:)), name:"CustomPushType", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.prohibitVisit(_:)), name:"prohibitVisit", object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeButton), name:"getRegistrationID", object: nil)
        
        
    }
    
    
    func changeButton(){
        login.userInteractionEnabled = true
        if loginSign == 0{
            self.tabBarController?.selectedIndex = 3
            if self.tabBarController?.selectedIndex == 3{
                self.tabBarController?.selectedIndex = 0
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        pwdTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        
    }
    
    func edit(){
        
        let controller = EditInfoViewController()
        controller.myDelegate = self
        self.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(controller, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    func createLoginUI(){
        
        let headerView = NSBundle.mainBundle().loadNibNamed("LoginHeaderCell", owner: nil, options: nil).first as! LoginHeaderCell
        headerView.frame.size.height = 80
        headerView.view1.backgroundColor = COLOR
        headerView.view2.backgroundColor = RGREY
        headerView.frame = CGRectMake(0, 0,WIDTH, 80)
        
        self.headerView.iconBtn.layer.cornerRadius = 60 / 2
        self.headerView.iconBtn.layer.masksToBounds = true
        
        //        backView =  NSBundle.mainBundle().loadNibNamed("LoginView", owner: nil, options: nil).first as! UIView
        backView.backgroundColor = RGREY
        backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        
        self.view.addSubview(backView)
//        self.view.bringSubviewToFront(backView)
        let firstTableView = UITableView.init(frame: CGRectMake(0, 80, WIDTH, WIDTH*100/375))
        //        firstTableView.tableHeaderView =  headerView
        firstTableView.tag = 0
        firstTableView.delegate = self
        firstTableView.dataSource = self
        firstTableView.registerNib(UINib(nibName: "LoginPhoneTableViewCell",bundle: nil), forCellReuseIdentifier: "phone")
        firstTableView.registerNib(UINib(nibName: "LoginPwdTableViewCell",bundle: nil), forCellReuseIdentifier: "pwd")
        login = UIButton.init(frame: CGRectMake(10,firstTableView.frame.origin.y+firstTableView.frame.size.height+30 , WIDTH-20, WIDTH*50/375))
        login.setTitle("登陆", forState: UIControlState.Normal)
        login.backgroundColor = COLOR
        login.layer.cornerRadius = 10
        //        btn.backgroundColor = COLOR
//        login.userInteractionEnabled = false
        login.addTarget(self, action: #selector(self.loginAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let button1 = UIButton.init(frame: CGRectMake(130, login.frame.origin.y+login.frame.size.height+30, WIDTH*100/375, WIDTH*30/375))
        button1.setTitle("忘记密码?", forState: UIControlState.Normal)
        button1.setTitleColor(COLOR, forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.forgot), forControlEvents: UIControlEvents.TouchUpInside)
        let label = UILabel.init(frame: CGRectMake(50, button1.frame.origin.y+button1.frame.size.height+30, WIDTH*200/375, WIDTH*30/375))
        label.text = "您还没有51帮的账号?"
        label.textColor = UIColor.blackColor()
        let register = UIButton.init(frame: CGRectMake(label.frame.origin.x+label.frame.size.width+0, label.frame.origin.y, WIDTH*100/375, WIDTH*30/375))
        register.setTitle("立即注册", forState: UIControlState.Normal)
        register.setTitleColor(COLOR, forState: UIControlState.Normal)
        register.addTarget(self, action: #selector(self.register), forControlEvents: UIControlEvents.TouchUpInside)
        
        backView.addSubview(headerView)
        backView.addSubview(firstTableView)
        backView.addSubview(login)
        backView.addSubview(button1)
        backView.addSubview(label)
        backView.addSubview(register)
        //        self.backView.addSubview(login)
        
        
    }
    
    
    
    //MARK: -- 通知方法
    func newMessage(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        
        let vc = ChetViewController()
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您有新的留言，是否查看？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Default,  handler: { action in
                let badgeView = UIView()
                badgeView.layer.masksToBounds = true
                badgeView.layer.cornerRadius = 5
                badgeView.tag = 888
                badgeView.backgroundColor = UIColor.redColor()
                let tarFrame = self.tabBarController?.tabBar.frame
                
                //        let percentX  = 4.6/4
                let x = ceilf(0.92 * Float(tarFrame!.size.width))
                let y = ceilf(0.2*Float(tarFrame!.size.height))
                badgeView.frame = CGRectMake(CGFloat(x), CGFloat(y), 10, 10)
                print(x)
                print(y)
                self.tabBarController?.tabBar.addSubview(badgeView)
                
                
                
                self.badgeView1.layer.masksToBounds = true
                self.badgeView1.layer.cornerRadius = 7
                self.badgeView1.backgroundColor = UIColor.redColor()
                self.badgeView1.frame = CGRectMake(WIDTH/3-45, 10, 14, 14)
                
                
                let myindexPaths = NSIndexPath.init(forRow: 0, inSection: 0)
                let cell = self.myTableView.cellForRowAtIndexPath(myindexPaths) as!MineTableViewCell
                self.badgeView1.hidden = false
                
                
//                dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: myindexPaths)as!MineTableViewCell
                let btn = cell.viewWithTag(2) as! UIButton
//                btn.setTitle("12121", forState: .Normal)
//                btn.backgroundColor = UIColor.redColor()
                btn.addSubview(self.badgeView1)
                
            })
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            let ud = NSUserDefaults.standardUserDefaults()
                                            let userid = ud.objectForKey("userid")as! String
                                            
                                            self.mainhelper.getChatMessage(userid, receive_uid: ids!) { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    
                                                if !success {
                                                    alert("加载错误", delegate: self)
                                                    return
                                                }
                                                let dat = NSMutableArray()
                                                self.dataSource2 = response as? Array<chatInfo> ?? []
                                                print(self.dataSource2)
                                                
                                                for num in 0...self.dataSource2!.count-1{
                                                    let dic = NSMutableDictionary()
                                                    dic.setObject(self.dataSource2![num].id!, forKey: "id")
                                                    dic.setObject(self.dataSource2![num].send_uid!, forKey: "send_uid")
                                                    dic.setObject(self.dataSource2![num].receive_uid!, forKey: "receive_uid")
                                                    dic.setObject(self.dataSource2![num].content!, forKey: "content")
                                                    dic.setObject(self.dataSource2![num].status!, forKey: "status")
                                                    dic.setObject(self.dataSource2![num].create_time!, forKey: "create_time")
                                                    if self.dataSource2![num].send_face != nil{
                                                        dic.setObject(self.dataSource2![num].send_face!, forKey: "send_face")
                                                    }
                                                    
                                                    if self.dataSource2![num].send_nickname != nil{
                                                        dic.setObject(self.dataSource2![num].send_nickname!, forKey: "send_nickname")
                                                    }
                                                    
                                                    if self.dataSource2![num].receive_face != nil{
                                                        dic.setObject(self.dataSource2![num].receive_face!, forKey: "receive_face")
                                                    }
                                                    
                                                    if self.dataSource2![num].receive_nickname != nil{
                                                        dic.setObject(self.dataSource2![num].receive_nickname!, forKey: "receive_nickname")
                                                    }
                                                    
                                                    
                                                    dat.addObject(dic)
                                                    
                                                    //                vc.datasource2.addObject(dic)
                                                    
                                                }
                                                
                                                print(dat)
                                                vc.datasource2 = NSArray.init(array: dat) as Array
                                                vc.titleTop = self.dataSource2![0].receive_nickname!
                                                vc.receive_uid = ids
                                                self.tabBarController?.selectedIndex = 3
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                                           })
                                    }
                                            
                                            
                                            
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
                                            
        }else{
            
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            
            mainhelper.getChatMessage(userid, receive_uid: ids!) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    
                if !success {
                    alert("加载错误", delegate: self)
                    return
                }
                let dat = NSMutableArray()
                self.dataSource2 = response as? Array<chatInfo> ?? []
                print(self.dataSource2)
                
                for num in 0...self.dataSource2!.count-1{
                    let dic = NSMutableDictionary()
                    dic.setObject(self.dataSource2![num].id!, forKey: "id")
                    dic.setObject(self.dataSource2![num].send_uid!, forKey: "send_uid")
                    dic.setObject(self.dataSource2![num].receive_uid!, forKey: "receive_uid")
                    dic.setObject(self.dataSource2![num].content!, forKey: "content")
                    dic.setObject(self.dataSource2![num].status!, forKey: "status")
                    dic.setObject(self.dataSource2![num].create_time!, forKey: "create_time")
                    if self.dataSource2![num].send_face != nil{
                        dic.setObject(self.dataSource2![num].send_face!, forKey: "send_face")
                    }
                    
                    if self.dataSource2![num].send_nickname != nil{
                        dic.setObject(self.dataSource2![num].send_nickname!, forKey: "send_nickname")
                    }
                    
                    if self.dataSource2![num].receive_face != nil{
                        dic.setObject(self.dataSource2![num].receive_face!, forKey: "receive_face")
                    }
                    
                    if self.dataSource2![num].receive_nickname != nil{
                        dic.setObject(self.dataSource2![num].receive_nickname!, forKey: "receive_nickname")
                    }
                    
                    
                    dat.addObject(dic)
                    
                    //                vc.datasource2.addObject(dic)
                    
                }
                
                print(dat)
                vc.datasource2 = NSArray.init(array: dat) as Array
                vc.titleTop = self.dataSource2![0].receive_nickname!
                vc.receive_uid = ids
                //            if self.dataSource[indexPath.row].other_face! != ""{
                //            let photoUrl:String = Bang_Open_Header+"uploads/images/"+self.dataSource[indexPath.row].my_face!
                ////                let url = NSURL(string: photoUrl)
                //                vc.urlphoto = NSString.init(string: photoUrl) as String
                //                print(vc.urlphoto)
                //            }
                self.tabBarController?.selectedIndex = 3
                self.navigationController?.pushViewController(vc, animated: true)
               })
            }
            
            
        }
            
        
    }
    
    
    func sendTaskType(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        let vc = MyFaDan()
        var warningStr = String()
        
        if ids == "1" {
            warningStr = "您的订单已被抢，是否查看？"
            vc.sign = 2
            
        }else if ids == "2"{
            warningStr = "服务者已上门，是否查看？"
            vc.sign = 3
        }else if ids == "3"{
            warningStr = "服务者完成工作申请付款，是否查看？"
            vc.sign = 3
        }else if ids == "4"{
            warningStr = "服务者评价您的发单，是否查看？"
            vc.sign = 4
        }else{
            warningStr = "您的发单状态发生变化，是否查看？"
        }
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: warningStr, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Default,  handler: { action in
                let badgeView = UIView()
                badgeView.layer.masksToBounds = true
                badgeView.layer.cornerRadius = 5
                badgeView.tag = 888
                badgeView.backgroundColor = UIColor.redColor()
                let tarFrame = self.tabBarController?.tabBar.frame
                
                //        let percentX  = 4.6/4
                let x = ceilf(0.92 * Float(tarFrame!.size.width))
                let y = ceilf(0.2*Float(tarFrame!.size.height))
                badgeView.frame = CGRectMake(CGFloat(x), CGFloat(y), 10, 10)
                print(x)
                print(y)
                self.tabBarController?.tabBar.addSubview(badgeView)
                
                self.badgeView2.layer.masksToBounds = true
                self.badgeView2.layer.cornerRadius = 5
                self.badgeView2.backgroundColor = UIColor.redColor()
                self.badgeView2.frame = CGRectMake(0, 0, 10, 10)
                
                self.badgeView2.hidden = false
                let myindexPaths = NSIndexPath.init(forRow: 0, inSection: 1)
                let cell = self.myTableView.cellForRowAtIndexPath(myindexPaths) as!MineTableViewCell
                cell.mineFunction.addSubview(self.badgeView2)
                
                
            })
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            self.tabBarController?.selectedIndex = 3
                                            self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            //            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.tabBarController?.selectedIndex = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func acceptTaskType(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        let vc = MyReceiveDan()
        var warningStr = String()
        
        if ids == "1" {
            warningStr = "您的抢单已被接受，是否查看？"
            //            vc.sign = 2
            
        }else if ids == "2"{
            warningStr = "您的接单对方已付款，是否查看？"
            //            vc.sign = 3
        }else if ids == "3"{
            warningStr = "您的接单对方已评价，是否查看？"
            //       vc.sign = 3
        }else if ids == "-1"{
            warningStr = "您的接单对方已取消，是否查看？"
            
        }else{
            warningStr = "您的接单状态发生变化，是否查看？"
        }
        
        //        else if ids == "4"{
        //            warningStr = "服务者评价您的发单，是否查看？"
        ////            vc.sign = 4
        //        }
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: warningStr, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Default,  handler: { action in
                let badgeView = UIView()
                badgeView.layer.masksToBounds = true
                badgeView.layer.cornerRadius = 5
                badgeView.tag = 888
                badgeView.backgroundColor = UIColor.redColor()
                let tarFrame = self.tabBarController?.tabBar.frame
                
                //        let percentX  = 4.6/4
                let x = ceilf(0.92 * Float(tarFrame!.size.width))
                let y = ceilf(0.2*Float(tarFrame!.size.height))
                badgeView.frame = CGRectMake(CGFloat(x), CGFloat(y), 10, 10)
                print(x)
                print(y)
                self.tabBarController?.tabBar.addSubview(badgeView)
                
                self.badgeView3.layer.masksToBounds = true
                self.badgeView3.layer.cornerRadius = 5
                self.badgeView3.backgroundColor = UIColor.redColor()
                self.badgeView3.frame = CGRectMake(0, 0, 10, 10)
                
                self.badgeView3.hidden = false
                let myindexPaths = NSIndexPath.init(forRow: 0, inSection: 2)
                let cell = self.myTableView.cellForRowAtIndexPath(myindexPaths) as!MineTableViewCell
                cell.mineFunction.addSubview(self.badgeView3)
                
                
            })
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            self.tabBarController?.selectedIndex = 3
                                            self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.tabBarController?.selectedIndex = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func buyOrderType(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        let vc = MyBookDan()
        var warningStr = String()
        
        if ids == "1" {
            warningStr = "您的订单已被接单，是否查看？"
            //            vc.sign = 2
            
        }else if ids == "2"{
            warningStr = "您的订单已发货，是否查看？"
            //            vc.sign = 3
        }else if ids == "3"{
            warningStr = "您的订单已消费，是否查看？"
            //       vc.sign = 3
        }else if ids == "4"{
            warningStr = "您的订单商家回复你的评论，是否查看？"
            //       vc.sign = 3
        }
        //        else if ids == "4"{
        //            warningStr = "服务者评价您的发单，是否查看？"
        ////            vc.sign = 4
        //        }
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: warningStr, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Default,  handler: { action in
                let badgeView = UIView()
                badgeView.layer.masksToBounds = true
                badgeView.layer.cornerRadius = 5
                badgeView.tag = 888
                badgeView.backgroundColor = UIColor.redColor()
                let tarFrame = self.tabBarController?.tabBar.frame
                
                //        let percentX  = 4.6/4
                let x = ceilf(0.92 * Float(tarFrame!.size.width))
                let y = ceilf(0.2*Float(tarFrame!.size.height))
                badgeView.frame = CGRectMake(CGFloat(x), CGFloat(y), 10, 10)
                print(x)
                print(y)
                self.tabBarController?.tabBar.addSubview(badgeView)
                
                self.badgeView4.layer.masksToBounds = true
                self.badgeView4.layer.cornerRadius = 5
                self.badgeView4.backgroundColor = UIColor.redColor()
                self.badgeView4.frame = CGRectMake(0, 0, 10, 10)
                
                self.badgeView4.hidden = false
                let myindexPaths = NSIndexPath.init(forRow: 1, inSection: 1)
                let cell = self.myTableView.cellForRowAtIndexPath(myindexPaths) as!MineTableViewCell
                cell.mineFunction.addSubview(self.badgeView4)
                
                
            })
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            self.tabBarController?.selectedIndex = 3
                                            self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.tabBarController?.selectedIndex = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func businessOrderType(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        let vc = MyBookDan()
        vc.isNotSigle = true
        var warningStr = String()
        
        if ids == "1" {
            warningStr = "您有新订单，是否查看？"
            //            vc.sign = 2
            
        }else if ids == "2"{
            warningStr = "顾客取消了订单，是否查看？"
            //            vc.sign = 3
        }else if ids == "3"{
            warningStr = "顾客已付款，是否查看？"
            //       vc.sign = 3
        }else if ids == "4"{
            warningStr = "顾客已经确认消费/收货，是否查看？"
            //       vc.sign = 3
        }else if ids == "5"{
            warningStr = "顾客已经对您进行了评价，是否查看？"
            //       vc.sign = 3
        }
        //        else if ids == "4"{
        //            warningStr = "服务者评价您的发单，是否查看？"
        ////            vc.sign = 4
        //        }
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: warningStr, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Default,  handler: { action in
                let badgeView = UIView()
                badgeView.layer.masksToBounds = true
                badgeView.layer.cornerRadius = 5
                badgeView.tag = 888
                badgeView.backgroundColor = UIColor.redColor()
                let tarFrame = self.tabBarController?.tabBar.frame
                
                //        let percentX  = 4.6/4
                let x = ceilf(0.92 * Float(tarFrame!.size.width))
                let y = ceilf(0.2*Float(tarFrame!.size.height))
                badgeView.frame = CGRectMake(CGFloat(x), CGFloat(y), 10, 10)
                print(x)
                print(y)
                self.tabBarController?.tabBar.addSubview(badgeView)
                self.badgeView5.layer.masksToBounds = true
                self.badgeView5.layer.cornerRadius = 5
                self.badgeView5.backgroundColor = UIColor.redColor()
                self.badgeView5.frame = CGRectMake(0, 0, 10, 10)
                
                self.badgeView5.hidden = false
                let myindexPaths = NSIndexPath.init(forRow: 6, inSection: 1)
                let cell = self.myTableView.cellForRowAtIndexPath(myindexPaths) as!MineTableViewCell
                cell.mineFunction.addSubview(self.badgeView5)
                
                
            })
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            self.tabBarController?.selectedIndex = 3
                                            self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.tabBarController?.selectedIndex = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func prohibitVisit(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        alert(ids!, delegate: self)
        let userDatas = NSUserDefaults.standardUserDefaults()
        print(userDatas.objectForKey("userid"))
        userDatas.removeObjectForKey("userid")
        if userDatas.objectForKey("name") != nil {
            userDatas.removeObjectForKey("name")
        }
        
        if userDatas.objectForKey("photo") != nil {
            userDatas.removeObjectForKey("photo")
        }
        if userDatas.objectForKey("sex") != nil {
            userDatas.removeObjectForKey("sex")
        }
        
        if userDatas.objectForKey("pwd") != nil {
            userDatas.removeObjectForKey("pwd")
        }
        if userDatas.objectForKey("userphoto") != nil {
            userDatas.removeObjectForKey("userphoto")
        }
        
        if userDatas.objectForKey("ss") != nil {
            userDatas.removeObjectForKey("ss")
        }
        JPUSHService.setTags(nil, aliasInbackground: "99999999")
        loginSign = 0
        self.tabBarController?.selectedIndex = 3
        if self.tabBarController?.selectedIndex == 3 {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    
    func loginFromOther(){
        alert("您的账号在其他地方登陆", delegate: self)
        let userDatas = NSUserDefaults.standardUserDefaults()
        print(userDatas.objectForKey("userid"))
        userDatas.removeObjectForKey("userid")
        if userDatas.objectForKey("name") != nil {
            userDatas.removeObjectForKey("name")
        }
        
        if userDatas.objectForKey("photo") != nil {
            userDatas.removeObjectForKey("photo")
        }
        if userDatas.objectForKey("sex") != nil {
            userDatas.removeObjectForKey("sex")
        }
        
        if userDatas.objectForKey("pwd") != nil {
            userDatas.removeObjectForKey("pwd")
        }
        if userDatas.objectForKey("userphoto") != nil {
            userDatas.removeObjectForKey("userphoto")
        }
        
        if userDatas.objectForKey("ss") != nil {
            userDatas.removeObjectForKey("ss")
        }
        JPUSHService.setTags(nil, aliasInbackground: "99999999")
        loginSign = 0
        NSNotificationCenter.defaultCenter().postNotificationName("getRegistrationID", object: nil)
        self.tabBarController?.selectedIndex = 3
        if self.tabBarController?.selectedIndex == 3 {
            self.tabBarController?.selectedIndex = 1
        }
        
        
        //        let a = MineViewController()
        //        self.navigationController?.pushViewController(a, animated: true)
    }
    
    func certificationType(notification:NSNotification){
        let ids = notification.object?.valueForKey("name") as? String
        if ids == "1" {
            let function = BankUpLoad()
            function.CheckRenzheng()
            alert("亲，您已经通过51帮身份认证，祝您使用愉快", delegate: self)
        }else if ids == "2"{
            alert("亲，您的资料未通过审核，请重新上传认证，谢谢！", delegate: self)
        }else if ids == "3"{
            let vc = MineViewController()
            vc.Checktoubao()
            alert("亲，您已经通过51帮保险认证，祝您使用愉快", delegate: self)
        }else if ids == "4"{
            alert("亲，您的保险资料未通过审核，请重新上传认证，谢谢！", delegate: self)
        }
    }
    
    func CustomPushType(notification:NSNotification){
        let keyStr = notification.object?.valueForKey("name") as? String
        
        alert(keyStr!, delegate: self)
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.tag == 1 {
            return 4
        }else{
            
            return 1
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            if section == 0 {
                return 1
            }else if section == 1 {
                return team.count
            }else if section == 2 {
                return busness.count
            }else{
                return benApp.count
            }
        }else{
            
            return 2
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 1 {
            if indexPath.section == 0 {
                return WIDTH*50/375
            }else{
                return WIDTH*44/375
            }
        }else{
            
            return WIDTH*50/375
        }
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.tag == 1 {
            if section == 0 {
                return 10
            }else if section == 1 {
                return 10
            }else{
                return 10
            }
        }else{
            
            
            return 0
        }
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.tag == 1 {
            let view = UIView()
            view.frame = CGRectMake(0, 0, 0, 0)
            //            view.backgroundColor = UIColor.clearColor()
            //            let footTit = UILabel(frame: CGRectMake(10, 5, 80, 20))
            //            footTit.text = foot[section]
            //            footTit.font = UIFont.systemFontOfSize(12)
            //            footTit.textColor = UIColor.grayColor()
            //            view.addSubview(footTit)
            
            return view
        }else{
            //此处
            let view = UIView()
            view.frame = CGRectMake(0, 0, 0, 0)
            return view
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            let cell = (NSBundle.mainBundle().loadNibNamed("MineTableViewCell", owner: nil, options: nil).first as? MineTableViewCell)!
            
//            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)as!MineTableViewCell
            cell.selectionStyle = .None
//            for view in cell.subviews {
//                view.removeFromSuperview()
//            }
            
            if indexPath.section == 0 {
                //                let top = UIView(frame: CGRectMake(0, 0, WIDTH, WIDTH*126/375))
                //                top.backgroundColor = COLOR
                //                cell.addSubview(top)
                for i in 0...2 {
                    let lab = UILabel(frame: CGRectMake(WIDTH*20/375+CGFloat(i)*(WIDTH/3), 0, WIDTH/3-WIDTH*20/375, WIDTH*46/375))
                    lab.text = labArr[i]
                    lab.textAlignment = .Center
                    lab.font = UIFont.systemFontOfSize(14)
                    cell.addSubview(lab)
                    let line = UILabel(frame: CGRectMake(CGFloat(i)*WIDTH/3+WIDTH/3, 0, 1, WIDTH*30/375))
                    line.backgroundColor = RGREY
                    cell.addSubview(line)
                    let img = UIImageView(frame: CGRectMake(WIDTH*33/375+CGFloat(i)*(WIDTH/3), 10+5, WIDTH*18/375, WIDTH*17/375))
                    img.image = UIImage(named: labImg[i])
                    cell.addSubview(img)
                    let btn = UIButton(frame: CGRectMake(CGFloat(i)*WIDTH/3, 0, WIDTH/3, WIDTH*46/375))
                    btn.addTarget(self, action: #selector(self.labTheButton(_:)), forControlEvents: .TouchUpInside)
                    btn.tag = i
                    cell.addSubview(btn)
                    
                }
                
                
            }else if indexPath.section == 1{
                cell.mineFunction.text = team[indexPath.row]
                cell.mineImg.image = UIImage(named: teamImg[indexPath.row])
            }else if indexPath.section == 2{
                cell.mineFunction.text = busness[indexPath.row]
                cell.mineImg.image = UIImage(named: busnissImg[indexPath.row])
            }else{
                
                if indexPath.row == 0 {
                    let label = UILabel.init(frame: CGRectMake(WIDTH-100, 5, 90, 30))
                    label.text = "4000608856"
                    label.textColor = COLOR
                    label.font = UIFont.systemFontOfSize(13)
                    cell.addSubview(label)
                }else{
                    let label = UILabel.init(frame: CGRectMake(WIDTH-100, 5, 90, 30))
                    cell.addSubview(label)
                }
                
                cell.mineFunction.text = benApp[indexPath.row]
                
                cell.mineImg.image = UIImage(named: benImg[indexPath.row])
            }
            
            return cell
            
        }else{
            
            if indexPath.row == 0 {
                tableView.separatorStyle = .None
                let cell = tableView.dequeueReusableCellWithIdentifier("phone")as! LoginPhoneTableViewCell
                cell.phone.tag = 100
                cell.selectionStyle = .None
                cell.phone.borderStyle = .None
                phoneTextfield = cell.phone
                cell.phone.keyboardType = UIKeyboardType.NamePhonePad
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("pwd")as! LoginPwdTableViewCell
                cell.pwd.tag = 101
                cell.selectionStyle = .None
                cell.pwd.borderStyle = .None
                pwdTextfield = cell.pwd
                cell.pwd.secureTextEntry = true
                
                return cell
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.badgeView2.hidden = true
                let faDan = MyFaDan()
                faDan.sign = 1
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(faDan, animated: true)
                self.hidesBottomBarWhenPushed = false
                //            case 1:
                //
                //                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                //                let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("2View")
                //                vc.title = "我的优惠券"
                //                self.hidesBottomBarWhenPushed = true
                //                self.navigationController?.pushViewController(vc, animated: true)
            //                self.hidesBottomBarWhenPushed = false
            case 1:
                let bookDanVc = MyBookDan()
                self.badgeView4.hidden = true
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bookDanVc, animated: true)
                self.hidesBottomBarWhenPushed = false
            case 2:
                self.hidesBottomBarWhenPushed = true
                let vc = MenuViewController()
                let userid = NSUserDefaults.standardUserDefaults()
                let id = userid.objectForKey("userid")
                vc.userid = id as! String
                let isShow = true
                vc.isShow = isShow
                vc.title = "我的发布"
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                self.hidesBottomBarWhenPushed = true
                let collection = CollectionViewController()
                self.navigationController?.pushViewController(collection, animated: true)
                self.hidesBottomBarWhenPushed = false
            case 4:
                self.hidesBottomBarWhenPushed = true
                let collection = CodeViewController()
                self.navigationController?.pushViewController(collection, animated: true)
                self.hidesBottomBarWhenPushed = false
            case 5:
                self.hidesBottomBarWhenPushed = true
                let bao = Hongbao()
                self.navigationController?.pushViewController(bao, animated: true)
                self.hidesBottomBarWhenPushed = false
            case 6:
                
                
                let bookDanVc = MyBookDan()
                self.badgeView5.hidden = true
                bookDanVc.isNotSigle = true
                bookDanVc.sign = 0
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bookDanVc, animated: true)
                self.hidesBottomBarWhenPushed = false

                
//                self.hidesBottomBarWhenPushed = true
////                let bao = Hongbao()
////                self.navigationController?.pushViewController(bao, animated: true)
//                alert("程序员正在玩命开发中", delegate: self)
//                self.hidesBottomBarWhenPushed = false
            default:
                print("不合法")
            }
            
            
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                self.hidesBottomBarWhenPushed = true
                let ReceiveVc = MyReceiveDan()
                self.badgeView3.hidden = true
                self.navigationController?.pushViewController(ReceiveVc, animated: true)
                self.hidesBottomBarWhenPushed = false
            case 1:
                self.hidesBottomBarWhenPushed = true
                let Insure = MyInsure()
                self.navigationController?.pushViewController(Insure, animated: true)
                self.hidesBottomBarWhenPushed = false
            case 2:
                self.hidesBottomBarWhenPushed = true
                let Insure = myAddressViewController()
                self.navigationController?.pushViewController(Insure, animated: true)
                self.hidesBottomBarWhenPushed = false
                
            default:
                    print("section2的不合法点击")
            }
            
            
            
            
        }else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "是否要拨打电话4000608856？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                
                                                let url1 = NSURL(string: "tel://4000608856")
                                                UIApplication.sharedApplication().openURL(url1!)
                                                
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)

                
            }else{
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Ben\(indexPath.row+1)View")
                self.navigationController?.pushViewController(vc, animated: true)
                vc.title = benApp[indexPath.row]
            }
            
        }
        
        
    }
    
    //MARK:钱包 签到  消息
    func labTheButton(btn:UIButton) {
        if(btn.tag == 1)
        {
            let vc = QianDao()
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }else if btn.tag == 0{
            
            let vc = Wallect()
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
            
        }else{
            
            let vc = MessageViewController()
            self.badgeView1.hidden = true
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
            
        }
        
        
    }
    
    func loginAction(sender:UIButton){
        sender.backgroundColor = UIColor.grayColor()
        
            SVProgressHUD.show()
            var registrationIDs = JPUSHService.registrationID()
            if registrationIDs == nil{
                registrationIDs = ""
            }
            self.pwdTextfield.resignFirstResponder()
            self.phoneTextfield.resignFirstResponder()
            let phoneNumber = self.view.viewWithTag(100)as! UITextField
            let password = self.view.viewWithTag(101)as! UITextField
            self.phoneNum = phoneNumber.text
            self.pwd = password.text
            if self.phoneNum!.isEmpty {
                self.phoneNum =  self.phoneTextfield.text
            }
            if self.pwd!.isEmpty {
                self.pwd = self.pwdTextfield.text
            }
            
//            print(self.phoneNum!)
//            print(self.pwd!)
            if (self.phoneNum!.isEmpty) {
                SVProgressHUD.showErrorWithStatus("请输入手机号！")
                self.login.backgroundColor = COLOR
                return
            }
            if (self.pwd!.isEmpty) {
                SVProgressHUD.showErrorWithStatus("请输入密码！")
                self.login.backgroundColor = COLOR
                return
            }
            
            self.loginWithNum(self.phoneNum! as String, pwd: self.pwd! as String,registrationID:registrationIDs)
        
        
        
        
    }
    
    func loginWithNum(num:String,pwd:String,registrationID:String){
        
        let password = self.view.viewWithTag(101)as! UITextField
        logVM!.login(num, password: pwd,registrationID:registrationID, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success == false {
                    if response != nil {
                        alert(response as! String, delegate: self)
                        SVProgressHUD.dismiss()
                    }else{
//                        SVProgressHUD.showErrorWithStatus("账号或密码错误！")
                        alert("账号或密码错误！", delegate: self)
                        SVProgressHUD.dismiss()
                    }
                    self.login.backgroundColor = COLOR
                    return
                }else{
                    print(response)
                    let userInfo = response as! UserInfo
                    print(TCUserInfo.currentInfo.userid)
                    print(userInfo.id)
                    print(userInfo.xgtoken)
                    //                    print()
                    loginSign = 1
                    
                    SVProgressHUD.showSuccessWithStatus("登录成功")
                    self.navigationController?.navigationBar.hidden = true
                    let ud = NSUserDefaults.standardUserDefaults()
                    //                    ud.setObject(userInfo.id, forKey: "uid")
                    ud.setObject(userInfo.id, forKey: "userid")
//                    let defalutid = NSUserDefaults.standardUserDefaults()
//                    let studentid = defalutid.stringForKey("userid")
//                    let udid = String( UIDevice.currentDevice().identifierForVendor!)
//                    print(udid)
//                    let settt = NSSet.init(array: [udid])
                    if userInfo.id != nil && userInfo.id! != ""{
                        JPUSHService.setTags(nil, aliasInbackground: userInfo.id!)

                    }
                    if userInfo.myreferral != nil{
                        ud.setObject(userInfo.myreferral, forKey: "myreferral")
                    }else{
                        ud.setObject("暂无", forKey: "myreferral")
                    }
                    
                    ud.setObject(userInfo.xgtoken, forKey: "token")
                    ud.setObject(userInfo.name, forKey: "name")
                    ud.setObject(self.phoneNum, forKey: "phone")
                    ud.setObject(self.pwd, forKey: "pwd")
//                    print(userInfo.photo)
//                    print(userInfo.sex)
                    if userInfo.photo != "" && userInfo.photo != nil{
                        ud.setObject(userInfo.photo, forKey: "photo")
                    }
                    if userInfo.sex != "" && userInfo.sex != nil{
                        ud.setObject(userInfo.sex, forKey: "sex")
                    }
                    
                    //实名认证反馈
                    
                    let checkUrl = Bang_URL_Header + "CheckHadAuthentication"
                    if( NSUserDefaults.standardUserDefaults().objectForKey("userid") == nil)
                    {
                        return
                    }
                    let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
                    let param = ["userid":id]
                    Alamofire.request(.GET, checkUrl, parameters: param ).response{
                        
                        request, response , json , error in
                        dispatch_async(dispatch_get_main_queue(), {
                        let ud = NSUserDefaults.standardUserDefaults()
                        
                        
                        let result = Http(JSONDecoder(json!))
                        if result.status == "success"{
                            print("已经认证")
                            ud .setObject("yes", forKey: "ss")
                            self.headerView.renzheng.setTitle("实名认证", forState: UIControlState.Normal)
                            self.headerView.renzheng.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            MainViewController.renZhengStatue = 1
                            
                            
                        }else{
                            ud .setObject("no", forKey: "ss")
                            self.headerView.renzheng.setTitle("未实名认证", forState: UIControlState.Normal)
                            self.headerView.renzheng.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
                            MainViewController.renZhengStatue = 0
                        }
                        
                        })
                        
                    }
//                    if(ud.objectForKey("userid")==nil)
//                    {
//                        self.backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
//                    }
//                    if ud.objectForKey("ss") != nil{
//                        if ud.objectForKey("ss") as! String == "no"{
//                            
//                        }else{
//                           
//                        }
//                    }else{
//                        self.headerView.renzheng.setTitle("未实名认证", forState: UIControlState.Normal)
//                        self.headerView.renzheng.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
//                    }

                    
                    //强制写入
                    ud.synchronize()
                    password.resignFirstResponder()
                    //登录成功
                    self.LOGIN_STATE = true
                    self.headerView.phone.text = self.phoneNum
                    self.loginSuccess()
                    self.getuserData()
                    self.Checktoubao()
                    let udid = UIDevice.currentDevice().systemVersion
                    var ns2 = String()
                    print(udid)
                    print(udid.characters.count)
                    if udid.characters.count > 3 {
                        ns2=(udid as NSString).substringToIndex(3)
                    }else{
                        ns2 = udid
                    }
                    
                    print(ns2)
                    if Double(ns2) < 9 {
                        let alertController = UIAlertController(title: "系统提示",
                            message: "建议使用iOS9.0以上版本体检更顺畅,是否去更新？（点击界面中的软件更新）", preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                        let okAction = UIAlertAction(title: "确定", style: .Default,
                            handler: { action in
                                
                                let url = NSURL.init(string: "prefs:root=General")
                                if UIApplication.sharedApplication().canOpenURL(url!){
                                    UIApplication.sharedApplication().openURL(url!)
                                }
                                
                                
                                
                                
                        })
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                    
                }
            })
            })
        
        
        
    }
    
    
    func Checktoubao()
    {
        
        let checkUrl = Bang_URL_Header + "CheckInsurance"
        if( NSUserDefaults.standardUserDefaults().objectForKey("userid") == nil)
        {
            return
        }
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        let param = ["userid":id]
        
        Alamofire.request(.GET, checkUrl, parameters: param ).response{
            request, response , json , error in
            
            let result = Http(JSONDecoder(json!))
            let ud = NSUserDefaults.standardUserDefaults()
            
            if result.status == "success"{
                if result.data == "1"{
                    ud .setObject("yes", forKey: "baoxiangrenzheng")
                    print("已经认证")
                    self.headerView.baoxianRenZheng.setTitle("保险认证", forState: UIControlState.Normal)
                    self.headerView.baoxianRenZheng.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }else{
                    ud .setObject("no", forKey: "baoxiangrenzheng")
                    self.headerView.baoxianRenZheng.setTitle("未保险认证", forState: UIControlState.Normal)
                    self.headerView.baoxianRenZheng.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                    print("未进行认证")
                    
                }
                
            }else{
                ud .setObject("no", forKey: "baoxiangrenzheng")
                self.headerView.baoxianRenZheng.setTitle("未保险认证", forState: UIControlState.Normal)
                self.headerView.baoxianRenZheng.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
                print("未进行认证")
                
            }
            
        }
        
    }
    
    func getuserData()
    {
        let urlHeader = Bang_URL_Header+"getuserinfo&"
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        let param = ["userid":id]
        Alamofire.request(.GET, urlHeader, parameters: param).response
            {
                request, response, json, error in
                
                dispatch_async(dispatch_get_main_queue(), {
                    let userData = NSUserDefaults.standardUserDefaults()
                    let result = MineGetModel(JSONDecoder(json!))
                    print("状态")
                    print(result.status)
                    print(request)
                    if(result.status == "success")
                    {
                        let name = result.data?.name
                        
                        
                        if(name==nil)
                        {
                            userData.setObject(" ", forKey: "name")
                        }else{
                            
                            userData.setObject(name, forKey: "name")
                        }
                        
                        let photo = result.data?.photo
                        
                        if(photo == nil)
                        {
                            userData.setObject("", forKey: "photo")
                        }else{
                            
                            userData.setObject(photo, forKey: "photo")
                        }
                        var sex = result.data?.sex
                        if(sex == nil)
                        {
                            sex = "1"
                            userData.setObject(sex, forKey: "sex")
                        }else{
                            
                            userData.setObject(sex, forKey: "sex")
                        }
                        
                        userData.synchronize()
                        //回调函数
                        self.downloadPic()
                        
                        let ud = NSUserDefaults.standardUserDefaults()
                        
                        self.image = UIImage()
                        
                        loginSign = 1
                        if(NSUserDefaults.standardUserDefaults().objectForKey("userphoto") == nil)
                        {
                            self.image = UIImage.init(named: "ic_moren-da")!
                        }else
                        {
                            self.image = UIImage.init(data: NSUserDefaults.standardUserDefaults().objectForKey("userphoto") as! NSData)!
                            
                        }
                        self.headerView.name.text = ud.objectForKey("name")as? String
                        //NSUserDefaults.standardUserDefaults().objectForKey("userphoto")
                        self.headerView.iconBtn.setImage(self.image, forState: UIControlState.Normal)
                        self.headerView.iconBtn.setImage(self.image, forState: UIControlState.Selected)
                        self.headerView.iconBtn.layer.cornerRadius = 55 / 2
                        self.headerView.iconBtn.layer.masksToBounds = true
                        
                        
                        //                        if NSUserDefaults.standardUserDefaults().objectForKey("photo") != nil{
                        //                            let a = MainHelper()
                        //                            a.downloadImage(NSUserDefaults.standardUserDefaults().objectForKey("photo") as! String)
                        //                        }
                        
                    }
                })
                
        }
    }
    
    
    func downloadPic()
    {
        
        let userData = NSUserDefaults.standardUserDefaults()
        //        print(NSUserDefaults.standardUserDefaults().objectForKey("photo") as! String)
        if NSUserDefaults.standardUserDefaults().objectForKey("photo") as! String == "" || NSUserDefaults.standardUserDefaults().objectForKey("photo") == nil{
            print("下载失败")
            image = UIImage.init(named: "ic_moren-da")!
            let photodata = NSData.init(data: UIImageJPEGRepresentation(image, 1)!)
            userData.setObject(photodata, forKey: "userphoto")
            
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/" + (NSUserDefaults.standardUserDefaults().objectForKey("photo") as! String)
            print(photoUrl)
            //http://bang.xiaocool.net./data/product_img/4.JPG
            let imview = UIImageView()
            
            //imview.sd_setImageWithURL(NSURL(string:"http://bang.xiaocool.net./data/product_img/4.JPG"), placeholderImage: nil)
            
            imview.sd_setImageWithURL(NSURL(string: photoUrl), completed: {
                
                void in
                
                if(imview.image != nil)
                {
                    let imageData = UIImageJPEGRepresentation(imview.image!, 1)
//                    print(imageData)
                    userData.setObject(imageData, forKey: "userphoto")
//                    print(imageData)
                    userData.synchronize()
                    print("图片下载成功")
                    print(self.image)
                    self.image = imview.image!
                    self.headerView.iconBtn.setImage(self.image, forState: UIControlState.Normal)
                    self.headerView.iconBtn.setImage(self.image, forState: UIControlState.Selected)
                    self.headerView.iconBtn.layer.cornerRadius = 55 / 2
                    self.headerView.iconBtn.layer.masksToBounds = true
                }else{
                    
                    let imageData = UIImageJPEGRepresentation(UIImage.init(named: "ic_moren-da")!, 1)
                    userData.setObject(imageData, forKey: "userphoto")
                    userData.synchronize()
                    self.image = UIImage.init(named: "ic_moren-da")!
                    self.headerView.iconBtn.setImage(self.image, forState: UIControlState.Normal)
                    self.headerView.iconBtn.setImage(self.image, forState: UIControlState.Selected)
                    self.headerView.iconBtn.layer.cornerRadius = 55 / 2
                    self.headerView.iconBtn.layer.masksToBounds = true
                }
            })
            
            
        }
        
        
        
        
    }
    
    func loginSuccess(){
        
        print("登陆成功")
        self.tabBarController?.tabBar.hidden = false
        self.backView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT)
        pwdTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
        
    }
    
    
    func register(){
        let vc  = TCRegisterViewController(nibName:"TCRegisterViewController",bundle: nil)
        
        
//        let vc = TCRegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //忘记密码
    func forgot(){
        
        let vc = ChangePwdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - MainDelegte
    func editePictureInMain() {
        if NSUserDefaults.standardUserDefaults().objectForKey("userphoto") != nil {
            let UsrImageData = NSUserDefaults.standardUserDefaults().objectForKey("userphoto")
            let userImage = UIImage.init(data: UsrImageData as! NSData)
            headerView.iconBtn.setImage(userImage, forState: UIControlState.Normal)
            headerView.iconBtn.setImage(userImage, forState: UIControlState.Selected)
        }
        
    }
    
    func updateName(name:String) {
        
    }
    
    func updateSex(flag: Int) {
        
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
