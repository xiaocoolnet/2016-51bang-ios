//
//  RushViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class RushViewController: UIViewController,myDelegate ,UITableViewDelegate,UITableViewDataSource{

    var dataSource1 = SkillModel()
    let skillHelper = RushHelper()
    var backView = UIView()
    var ddddd = UIDynamicAnimator()
    var distance = NSString()
    var cityName = String()
    var longitude = String()
    var latitude = String()
    let mainHelper = MainHelper()
    var dataSource : Array<TaskInfo>?
    let myTableView = UITableView()
    let certifyImage = UIImageView()
    let certiBtn = UIButton()
    let jiahaoView = UIView()
    var isShowJiaHao = Bool()
    let backClearButton = UIButton()
    
    
    var kai = false
    var sign = Int()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.isShowJiaHao = false
        self.navigationController?.navigationBar.hidden = false
        let function = BankUpLoad()
        function.CheckRenzheng()
        let ud = NSUserDefaults.standardUserDefaults()
        print(ud.objectForKey("ss"))
        if (ud.objectForKey("quName") != nil) {
            self.cityName = ud.objectForKey("quName") as! String
        }
//        if(ud.objectForKey("ss") != nil){
        
            
//        if(ud.objectForKey("ss") as! String == "yes")
//            
//        {
            certiBtn.userInteractionEnabled = false
            certiBtn.hidden = true
            certifyImage.hidden = true
            self.myTableView.hidden = false
            self.title = "抢单"
            self.backView.hidden = true
            
//            }
//        else{
//            certiBtn.userInteractionEnabled = true
//            certiBtn.hidden = false
//            certifyImage.hidden = false
//            self.myTableView.hidden = true
//            self.backView.hidden = true
//            self.title = "认证"
//            }
//        }
        
//        let mybackView = UIView.init(frame: CGRectMake(0, -HEIGHT+100, WIDTH, HEIGHT*2+100))
//        self.view.addSubview(mybackView)
        
        
        
        self.GetData1()
//        ddddd = UIDynamicAnimator.init(referenceView: mybackView)
//        self.backView.transform=CGAffineTransformMakeRotation(90)
//        let gravity = UIGravityBehavior.init()
//        gravity.magnitude = 5
////        gravity.gravityDirection=CGVectorMake(1, 1)
//        gravity.addItem(backView)
//        
//        let collision = UICollisionBehavior.init()
//        collision.addItem(backView)
//        
//        collision.translatesReferenceBoundsIntoBoundary = true
//        ddddd.addBehavior(gravity)
//        ddddd.addBehavior(collision)
        
        
        self.tabBarController?.selectedIndex = 1
        if(ud.objectForKey("userid")==nil)
        {
            
            self.tabBarController?.selectedIndex = 3
            
            
        }
       
     
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.view = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = MineViewController()
        vc.Checktoubao()
        
        let ud = NSUserDefaults.standardUserDefaults()
        if (ud.objectForKey("quName") != nil) {
            self.cityName = ud.objectForKey("quName") as! String
        }
        
        sign = 0
        self.createRightItemWithTitle("我的任务")
        self.createLeftItem()
        self.createTableView()
        setBtnAndImage()
        
        self.GetData()
        
        backView = UIView.init(frame: CGRectMake(0, -HEIGHT, WIDTH, HEIGHT))
        backView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backView)
        
        let jinengButton = UIButton.init(frame: CGRectMake(0, 150, WIDTH, 50))
        jinengButton.backgroundColor = COLOR
        jinengButton.addTarget(self, action: #selector(self.goJineng), forControlEvents: UIControlEvents.TouchUpInside)
        jinengButton.setTitle("您还没有注册技能，点击我去修改技能", forState: UIControlState.Normal)
        self.backView.addSubview(jinengButton)
        
        
        self.jiahaoView.frame = CGRectMake(WIDTH-110, -110, 100, 101)
        self.jiahaoView.backgroundColor = COLOR
        let button1 = UIButton.init(frame: CGRectMake(0, 0, 100, 50))
        button1.setTitle("我的任务", forState: UIControlState.Normal)
        button1.backgroundColor = UIColor.whiteColor()
        button1.setTitleColor(COLOR, forState: .Normal)
        button1.addTarget(self, action: #selector(self.goRenwu), forControlEvents: .TouchUpInside)
        self.jiahaoView.addSubview(button1)
        let button2 = UIButton.init(frame: CGRectMake(0, 51, 100, 50))
        button2.setTitle("修改技能", forState: UIControlState.Normal)
        button2.backgroundColor = UIColor.whiteColor()
        button2.setTitleColor(COLOR, forState: .Normal)
        button2.addTarget(self, action: #selector(self.goJineng), forControlEvents: .TouchUpInside)
        self.jiahaoView.addSubview(button2)
        backClearButton.frame = self.view.frame
        backClearButton.backgroundColor = UIColor.clearColor()
        backClearButton.addTarget(self, action: #selector(self.hidenJiahao), forControlEvents: .TouchUpInside)
        self.view.addSubview(backClearButton)
        self.backClearButton.hidden = true
        self.view.addSubview(jiahaoView)
        self.jiahaoView.layer.masksToBounds = true
        self.jiahaoView.layer.borderColor = COLOR.CGColor
        self.jiahaoView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
  
    
    func setBtnAndImage()
    {
        certifyImage.frame = CGRectMake(WIDTH / 2 - 100, HEIGHT / 2 - 150, 200,100)
        certifyImage.image =  UIImage.init(named: "未认证")
        self.view.addSubview(certifyImage)
        certiBtn.frame = CGRectMake(15, certifyImage.frame.origin.y + 150, WIDTH - 30, 50)
        certiBtn.layer.cornerRadius = 10
        certiBtn.layer.masksToBounds = true
        certiBtn.backgroundColor = COLOR
        certiBtn.addTarget(self, action: #selector(self.nowToCertification(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(certiBtn)
        certiBtn.setTitle("立即认证", forState: UIControlState.Normal)
        
    }
    func createLeftItem(){
        let ud = NSUserDefaults.standardUserDefaults()
        
        if ud.objectForKey("userid") != nil {
            mainHelper.GetWorkingState(ud.objectForKey("userid") as! String) { (success, response) in
                if !success{
                    alert("数据加载出错", delegate: self)
                    return
                }
                print(response! as! String)
                
                let button = UIButton.init(frame: CGRectMake(0, 10, 50, 92 * 50 / 174))
                if response as! String == "1"{
                    button.setImage(UIImage(named: "ic_kai-3"), forState: UIControlState.Normal)
                    self.sign = 1
                }else{
                    button.setImage(UIImage(named: "ic_guan-2"), forState: UIControlState.Normal)
                    self.sign = 0
                }
                
                button.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                //        button.selected = true
                //        let mySwitch = UISwitch.init(frame: CGRectMake(0, 0, 30, 30))
                
                //        mySwitch.onImage = UIImage(named: "ic_kai-1")
                //        mySwitch.offImage = UIImage(named: "ic_guan-0")
                let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
                self.navigationItem.leftBarButtonItem = item
            }

        }
        
        
    }
    //174/92
    func click(btn:UIButton){
        
        let vc = MineViewController()
        vc.Checktoubao()
        let type = CLLocationManager.authorizationStatus()
        
        if !CLLocationManager.locationServicesEnabled() || type == CLAuthorizationStatus.Denied{
            alert("请打开定位", delegate: self)
            return
        }
        let ud = NSUserDefaults.standardUserDefaults()
        var subLocality = String()
        var longitude = String()
        var latitude = String()
        var isworking = String()
        var cutyName = String()
        var strrr = String()
        if ud.objectForKey("subLocality") != nil {
            strrr = String( ud.objectForKey("subLocality")! as! String)
        }
        
        if ud.objectForKey("subLocality") != nil && strrr != "0" && ud.objectForKey("streetName") != nil && ud.objectForKey("streetName") as! String != ""{
            subLocality = ud.objectForKey("subLocality") as! String
            cutyName = subLocality + (ud.objectForKey("streetName") as! String)
            
//            cutyName = ud.objectForKey("subLocality") as! String
        }
        if ud.objectForKey("longitude") != nil {
            longitude = ud.objectForKey("longitude") as! String
        }else{
            alert("请打开定位", delegate: self)
            return
        }
        if ud.objectForKey("latitude") != nil {
            latitude = ud.objectForKey("latitude") as! String
        }else{
            alert("请打开定位", delegate: self)
            return
        }
        
        
        if self.sign == 0 {
            if(ud.objectForKey("ss") != nil){
                if(ud.objectForKey("ss") as! String == "no"){
                    let alertController = UIAlertController(title: "系统提示",
                                                            message: "是否去实名认证？", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                    let okAction = UIAlertAction(title: "确定", style: .Default,
                                                 handler: { action in
                                                    let vc = CertificationViewController()
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                    
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)

                    return
                    
                }else{
                    if (ud.objectForKey("baoxiangrenzheng") as! String == "no") {
                         alert("请先进行投保认证", delegate: self)
                        self.hidesBottomBarWhenPushed = true
                        let Insure = MyInsure()
                        self.navigationController?.pushViewController(Insure, animated: true)
                        self.hidesBottomBarWhenPushed = false
                        return
                    }else{
                        if self.sign == 0 {
                            isworking = "1"
                        }else{
                            isworking = "0"
                        }
                    }
                }
            }
            
        }else{
           
        }
        
        
        print(longitude)
        print(latitude)
        
        
        if ud.objectForKey("userid") != nil {
            mainHelper.BeginWorking(ud.objectForKey("userid") as! String, address: cutyName, longitude: longitude, latitude: latitude, isworking: isworking) { (success, response) in
                if !success {
                    alert("数据加载出错", delegate: self)
                    return
                }
                if self.sign == 0 {
                    btn.setImage(UIImage(named: "ic_kai-3"), forState: UIControlState.Normal)
                    self.sign = 1
                }else{
                    btn.setImage(UIImage(named: "ic_guan-2"), forState: UIControlState.Normal)
                    self.sign = 0
                }
                
            }
        }
       
        
        print(self.sign)
        
//        print(btn.selected)
//        if btn.selected == true {
//            btn.setImage(UIImage(named: "ic_guan-0"), forState: UIControlState.Selected)
//               btn.selected = false
//        }else{
//            btn.setImage(UIImage(named: "ic_kai-1"), forState: UIControlState.Normal)
//            btn.selected = true
//        }
        

    }
    
    
    func GetData1(){//获取当前用户的技能
        
        let ud = NSUserDefaults.standardUserDefaults()
        
        let userid =  ud.objectForKey("userid") as! String
        
        let hud = MBProgressHUD.init()
        hud.animationType = .Zoom
        
        hud.labelText = "正在努力加载"
        
        skillHelper.getSkillListByUserId(userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    hud.hide(true)
                    alert("数据加载出错", delegate: self)
                    return
                }
                hud.hide(true)
                print(response)
                self.dataSource1 = response as! SkillModel
                if self.dataSource1.skilllist.count<1{
                    UIView.animateWithDuration(0.4, animations: {
                        self.backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
                    })
                }else{
                    UIView.animateWithDuration(0.4, animations: {
                        self.backView.frame = CGRectMake(0, -HEIGHT, WIDTH, HEIGHT)
                    })
                }
                //                print(self.dataSource)
                //                print(self.dataSource.count)
                //                print(self.dataSource1.skilllist[0].type)
//                for skillSelect in self.dataSource1.skilllist {
//                    if !self.jiNengID.containsObject(skillSelect.type!){
//                        self.jiNengID.addObject(skillSelect.type!)
//                    }
//                    
//                    
//                }
//                self.createTableViewHeaderView()
                
            })
        }
    }
    
    
    func createRightItemWithTitle(title:String){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 21 , 21);
        button.setImage(UIImage(named: "ic_jia-1"), forState: .Normal)
//        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.myTask), forControlEvents:UIControlEvents.TouchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = item
    }

    func myTask(){
        if self.isShowJiaHao {
            self.jiahaoView.layer.position.y = -110
            self.isShowJiaHao = false
        }else{
            self.isShowJiaHao = true
            self.backClearButton.hidden = false
            
            UIView.animateWithDuration(0.2,
                                       animations:
                { self.jiahaoView.layer.position.y = 20 },
                                       completion: {(finished) in UIView.animateWithDuration(0.5, delay: 0,
                                        usingSpringWithDamping: 0.2,
                                        initialSpringVelocity: 5.0,
                                        options: UIViewAnimationOptions.CurveEaseOut,
                                        animations: {//弹性参数的调教，可以参见本文的“参考”部分
                                            self.jiahaoView.layer.position.y += 30
                                        },
                                        completion: nil)})
        }
        
        
       
        
        
        
    
    }
    
    func goRenwu(){
        let vc = MyTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func goJineng(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("ss") != nil{
            if(ud.objectForKey("ss") as! String == "no")
            {
                //                    let vc  = WobangRenZhengController()
                //                    self.hidesBottomBarWhenPushed = true
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //                    self.hidesBottomBarWhenPushed = false
                //                    return
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "是否去实名认证？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                let vc = CertificationViewController()
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return

                
            }
        }
        
        
        let vc = SkillselectViewController()
        vc.ischangged = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.title = "技能选择"
        
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setObject("yes", forKey: "isxiugai")
//        vc.title = "技能选择"
    }
    
    func hidenJiahao(){
        self.jiahaoView.layer.position.y = -110
        self.backClearButton.hidden = true
        self.isShowJiaHao = false
    }

    
    

        func nowToCertification(sender: AnyObject) {
        
        if loginSign == 0 {//未登陆
            
            self.tabBarController?.selectedIndex = 3
            
        }else{//已登陆
            print("立即认证")
            let vc = CertificationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "身份认证"
        
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createView() {

//        myTableView.hidden = false
        
//        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)
//        myTableView.reloadData()
//        self.view.addSubview(myTableView)
//        self.createTableView()
//        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)
//        myTableView.backgroundColor = UIColor.redColor()

    }
    
    func createTableView(){
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height-64)

        myTableView.backgroundColor = RGREY
//        self.myTableView = UITableView.init(frame: CGRectMake(0, -38, WIDTH, self.view.frame.size.height), style: .Grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerNib(UINib(nibName: "OrderTableViewCell",bundle: nil), forCellReuseIdentifier: "order")
        myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            print("MJ:(上拉加载)")
            self.footerRefresh()
            
        })


        //        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH/2, 120))
        let btn = UIButton(frame: CGRectMake(0, HEIGHT-110, WIDTH/2,50))
        btn.alpha = 0.7
        btn.setTitle("我的任务", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.grayColor()
        let label = UILabel()
        label.frame = CGRectMake(WIDTH/2, HEIGHT-109, 1, btn.frame.size.height-2)
        label.backgroundColor = UIColor.whiteColor()
        let btn2 = UIButton(frame: CGRectMake(WIDTH/2, HEIGHT-110, WIDTH/2,50))
        btn2.alpha = 0.7
        btn2.setTitle("刷新列表", forState: .Normal)
        btn2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn2.backgroundColor = UIColor.grayColor()
//        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
//        myTableView.hidden = false
        self.view.addSubview(myTableView)
        //        self.view.addSubview(btn)
        //        self.view.addSubview(btn2)
        //        self.view.addSubview(label)
        
    }
    

    
    func GetData(){
        
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.labelText = "正在努力加载"
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            print(self.latitude)
            print(self.latitude)
            mainHelper.getTaskList (userid,beginid:"0",cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        print(success)
                        return
                        //                        alert("暂无数据", delegate: self)
                    }
                    hud.hide(true)
                    print(response)
                    self.dataSource?.removeAll()
                    
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    print(self.dataSource)
                    print(self.dataSource?.count)
                    if self.dataSource?.count == 0{
                        alert("暂无数据", delegate: self)
                    }
                    print(self.dataSource?.count)
                    
                    //                self.ClistdataSource = response as? ClistList ?? []
                    self.myTableView.reloadData()
                    //self.configureUI()
                })
                
                })
        }
        
    }
    func headerRefresh(){
        if loginSign == 0 {
            self.tabBarController?.selectedIndex = 3
        }else{
            
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            
            mainHelper.getTaskList (userid,beginid:"0",cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        print(success)
                        self.myTableView.mj_header.endRefreshing()
                        return
                    }
                    print(response)
                    self.dataSource?.removeAll()
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    self.myTableView.mj_header.endRefreshing()
                    print(self.dataSource)
                    print(self.dataSource?.count)
                    if self.dataSource?.count == 0{
                        alert("暂无数据", delegate: self)
                    }
                    print(self.dataSource?.count)
//                    self.createTableView()
                    
                    self.myTableView.reloadData()
                    
                })
                
                })
        }
        
        
    }
    func footerRefresh(){
        if loginSign == 0 {
            self.tabBarController?.selectedIndex = 3
        }else{
            
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            let  beginId = (self.dataSource![(self.dataSource?.count)!-1] as TaskInfo).id! as String
            mainHelper.getTaskList (userid,beginid:beginId,cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        print(success)
                        self.myTableView.mj_footer.endRefreshing()
                        return
                    }
                    print(response)
                    
                    let datass = response as? Array<TaskInfo> ?? []
                    if datass.count < 1 {
                        self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                        return
                    }
                    for datas in datass{
                        self.dataSource?.append(datas)
                    }
                    self.myTableView.mj_footer.endRefreshing()
                    print(self.dataSource)
                    print(self.dataSource?.count)
                    if self.dataSource?.count == 0{
                        alert("暂无数据", delegate: self)
                    }
                    print(self.dataSource?.count)
                    //                    self.createTableView()
                    
                    self.myTableView.reloadData()
                    
                })
                
                })
        }
        
        
    }
    
    func nextToView(){
        let vc = MyTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(self.dataSource?.count)
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource?.count)!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order") as! OrderTableViewCell
       
        
        cell.setValueWithInfo(self.dataSource![indexPath.row])
        //        cell.location.text
        cell.selectionStyle = .None
        cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
        cell.icon.clipsToBounds = true
        let now = NSDate()
        let nowDateStr:NSTimeInterval = now.timeIntervalSince1970
        let timeStampNow = Int(nowDateStr)
        var timeStampOrder = Int()
        if self.dataSource![indexPath.row].state == "1" {
            
            if self.dataSource![indexPath.row].expirydate != nil{
                timeStampOrder = Int(self.dataSource![indexPath.row].expirydate!)!
                if timeStampOrder < timeStampNow {
                    cell.snatchButton.setTitle("已过期", forState: UIControlState.Normal)
                    cell.snatchButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                    cell.snatchButton.enabled = false
                }else{
                    cell.snatchButton.setTitle("立即抢单", forState: UIControlState.Normal)
                    cell.snatchButton.addTarget(self, action: #selector(self.qiangdan(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    cell.snatchButton.enabled = true
                }

            }else{
                cell.snatchButton.setTitle("无效", forState: UIControlState.Normal)
                cell.snatchButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                cell.snatchButton.enabled = false
            }
            
            
            
            
        }else{
            cell.snatchButton.setTitle("已被抢", forState: UIControlState.Normal)
            cell.snatchButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            cell.snatchButton.enabled = false
        }
        
        
        
        
        
        cell.snatchButton.tag = indexPath.row+10000
//        print(cell.location.text!)
        //        pushMapButton.removeFromSuperview()
        
        cell.pushMapButton.tag = indexPath.row
        cell.pushFuwuButton.tag = 1000+indexPath.row
        if  self.dataSource![indexPath.row].saddress == nil{
            cell.pushFuwuButton.userInteractionEnabled = false
        }
        if  self.dataSource![indexPath.row].address == nil{
            cell.pushMapButton.userInteractionEnabled = false
        }
        cell.pushMapButton.addTarget(self, action: #selector(self.pushMapButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.pushFuwuButton.addTarget(self, action: #selector(self.pushFuwuButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if cell.location.text != ""{
            self.getAddressWithString(indexPath.row)
            
            let distance = self.distance.componentsSeparatedByString(".")
            cell.distnce.text = distance[0]
        }
        
        return cell
        
    }
    
    func pushMapButton(sender:UIButton){
        
        
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        print(dataSource![sender.tag].latitude!)
        print(dataSource![sender.tag].longitude!)
        print(dataSource![sender.tag].slatitude!)
        print(dataSource![sender.tag].slongitude!)
        
        print(self.dataSource![sender.tag].address!)
        print(self.dataSource![sender.tag].saddress!)
        if dataSource![sender.tag].latitude != nil && dataSource![sender.tag].longitude != nil && dataSource![sender.tag].latitude! as String != "" && dataSource![sender.tag].longitude! as String != ""{
            print(dataSource![sender.tag].latitude!)
            coor1.latitude = CLLocationDegrees(dataSource![sender.tag].latitude! as String)!
            coor1.longitude = CLLocationDegrees(dataSource![sender.tag].longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if self.dataSource![sender.tag].address != nil && self.dataSource![sender.tag].address! as String != ""{
            start.name = self.dataSource![sender.tag].address!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if dataSource![sender.tag].slatitude != nil && dataSource![sender.tag].slongitude != nil && dataSource![sender.tag].slatitude! as String != "" && dataSource![sender.tag].slongitude! as String != ""{
            print(dataSource![sender.tag].slatitude)
            coor2.latitude = CLLocationDegrees(dataSource![sender.tag].slatitude! as String)!
            coor2.longitude = CLLocationDegrees(dataSource![sender.tag].slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.dataSource![sender.tag].saddress != nil && self.dataSource![sender.tag].saddress != "" {
            end.name = self.dataSource![sender.tag].saddress!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
     
    }
    
    
    func pushFuwuButton(sender:UIButton){
        
        
        
        
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        if dataSource![sender.tag-1000].latitude != nil && dataSource![sender.tag-1000].longitude != nil && dataSource![sender.tag-1000].latitude! as String != "" && dataSource![sender.tag-1000].longitude! as String != ""{
//            print(dataSource![sender.tag].latitude)
            coor1.latitude = CLLocationDegrees(dataSource![sender.tag-1000].latitude! as String)!
            coor1.longitude = CLLocationDegrees(dataSource![sender.tag-1000].longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if self.dataSource![sender.tag-1000].address != nil && self.dataSource![sender.tag-1000].address! as String != ""{
            start.name = self.dataSource![sender.tag-1000].address!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if dataSource![sender.tag-1000].slatitude != nil && dataSource![sender.tag-1000].slongitude != nil && dataSource![sender.tag-1000].slatitude! as String != "" && dataSource![sender.tag-1000].slongitude! as String != ""{
//            print(dataSource![sender.tag].slatitude)
            coor2.latitude = CLLocationDegrees(dataSource![sender.tag-1000].slatitude! as String)!
            coor2.longitude = CLLocationDegrees(dataSource![sender.tag-1000].slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.dataSource![sender.tag-1000].saddress != nil && self.dataSource![sender.tag-1000].saddress != "" {
            end.name = self.dataSource![sender.tag-1000].saddress!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
        
        
        
    }
    
    func qiangdan(sender:UIButton){
        
        var userid = String()
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
//         = ud.objectForKey("userid")as! String
        if userid == dataSource![sender.tag-10000].userid {
            alert("不能抢自己的单", delegate: self)
            return
        }
        
        
        
        
        if(ud.objectForKey("ss") != nil){
            if(ud.objectForKey("ss") as! String == "no"){
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "是否去实名认证？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                let vc = CertificationViewController()
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
                
            }else{
                if (ud.objectForKey("baoxiangrenzheng") != nil && ud.objectForKey("baoxiangrenzheng") as! String == "no") {
                    
                    let alertController = UIAlertController(title: "系统提示",
                                                            message: "请先投保在抢单，是否去投保？", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                    let okAction = UIAlertAction(title: "确定", style: .Default,
                                                 handler: { action in
                                                    
                                                    print(ud.objectForKey("baoxiangrenzheng") as! String)
                                                    let vc2 = MyInsure()
                                                    self.navigationController?.pushViewController(vc2, animated: true)
                                                    
                                                    
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
            }
        }
        
        
        
        (self.myTableView.viewWithTag(sender.tag)as! UIButton).enabled = false
        
        print("抢单")
        var longitude = String()
        var latitude = String()
//        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("longitude") != nil && ud.objectForKey("latitude") != nil {
            longitude = ud.objectForKey("longitude")as! String
            latitude = ud.objectForKey("latitude")as! String
        }
        
        
        print(longitude)
        
        print(latitude)
        
        let str = String(longitude)
        let array:NSArray = str.componentsSeparatedByString("(")
        let str2 = array[0]as! String
        let array2 = str2.componentsSeparatedByString(")")
        let str3 = array2[0]
        print(str3)
        
        let str4 = String(latitude)
        let array3:NSArray = str4.componentsSeparatedByString("(")
        let str5 = array3[0]as! String
        let array4 = str5.componentsSeparatedByString(")")
        let str6 = array4[0]
        print(str6)
        
        
        mainHelper.qiangDan(userid, taskid: dataSource![sender.tag-10000].id!, longitude: str3, latitude: str6) { (success, response) in
            print(response)
            if !success {
                alert("抢单失败！", delegate: self)
                return
            }
            
            let vc = MyTaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    func getAddressWithString(row:Int){
        print("检测数据*********")
       
        if self.dataSource![row].latitude == "" || self.dataSource![row].longitude == ""  ||  self.dataSource![row].slatitude == "" || self.dataSource![row].slongitude  ==  "" || self.dataSource![row].latitude == nil || self.dataSource![row].longitude == nil  ||  self.dataSource![row].slatitude == nil || self.dataSource![row].slongitude  ==  nil {
            self.distance = "0"
            return
        }
        
        let current = CLLocation.init(latitude: CLLocationDegrees(self.dataSource![row].latitude!)!, longitude: CLLocationDegrees(self.dataSource![row].longitude!)!)
        let before = CLLocation.init(latitude: CLLocationDegrees(self.dataSource![row].slatitude!)!, longitude: CLLocationDegrees(self.dataSource![row].slongitude!)!)
        let meters = current.distanceFromLocation(before)
        print("-----")
        self.distance = String(meters)
        print(meters)
        print(self.distance)
        print("-----")
        //self.createAnnotation(self.latitude, longitude: self.longitude)
        //        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = TaskDetailViewController()
        let taskInfo = dataSource![indexPath.row]
        vc.taskInfo = taskInfo
        vc.qiangdanBut = false
        vc.title = "任务详情"
        self.navigationController?.pushViewController(vc, animated: true)
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
