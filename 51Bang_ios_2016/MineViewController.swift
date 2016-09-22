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
    
    let phone:String = "400608856"
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
    let teamImg:[String] = ["ic_wodefadan","ic_youhuiquan","ic_wodedingdan","ic_wodedingdan","wodeshoucang","ic_weizhi拷贝2","ic_fenxiang","ic_youhuiquan"]
    
    let busness:[String] = ["我的接单","我的投保","我的地址"]
    let busnissImg:[String] = ["ic_wodejiedan","ic_woyaotoubao","ic_weizhi拷贝2"]
    
    let benApp:[String] = ["客服咨询","更多服务"]
    let benImg:[String] = ["ic_kefuzixun","ic_gengduofuwu"]
    
    let labArr:[String] = ["钱包","签到","消息"]
    let labImg:[String] = ["ic_qianbao","ic_qiandao","ic_xiaoxi"]
    var pwdTextfield = UITextField()
    var phoneTextfield = UITextField()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        isShow = false
        //        backView.frame = CGRectMake(0, 64, WIDTH, HEIGHT)
        //        backView.backgroundColor = RGREY
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
        self.view.addSubview(myTableView)
        //        self.navigationController?.title = "51帮"
        
        headerView.backgroundColor = COLOR
        headerView.iconBtn.addTarget(self, action: #selector(self.edit), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.backgroundColor = COLOR
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*150/375)
        //        headerView.backgroundColor = UIColor.blueColor()
        self.myTableView.tableHeaderView = headerView
        let ud = NSUserDefaults.standardUserDefaults()
        
        if(ud.objectForKey("userid")==nil)
        {
            self.createLoginUI()
            
        }else
            
        {
            
            getuserData()
            
            
        }
        
        
        
        
        
        pwdTextfield.secureTextEntry = true
//        pwdTextfield.keyboardType = 
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
//        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("userid")==nil)
        {
            backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        }
        if ud.objectForKey("ss") != nil{
            if ud.objectForKey("ss") as! String == "no"{
                self.headerView.renzheng.setTitle("未实名认证", forState: UIControlState.Normal)
                self.headerView.renzheng.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            }else{
                self.headerView.renzheng.setTitle("实名认证", forState: UIControlState.Normal)
                self.headerView.renzheng.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
        }else{
            self.headerView.renzheng.setTitle("未实名认证", forState: UIControlState.Normal)
            self.headerView.renzheng.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
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
        
        
        // Do any additional setup after loading the view.
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
        let firstTableView = UITableView.init(frame: CGRectMake(0, 80, WIDTH, WIDTH*100/375))
        //        firstTableView.tableHeaderView =  headerView
        firstTableView.tag = 0
        firstTableView.delegate = self
        firstTableView.dataSource = self
        firstTableView.registerNib(UINib(nibName: "LoginPhoneTableViewCell",bundle: nil), forCellReuseIdentifier: "phone")
        firstTableView.registerNib(UINib(nibName: "LoginPwdTableViewCell",bundle: nil), forCellReuseIdentifier: "pwd")
        let login = UIButton.init(frame: CGRectMake(10,firstTableView.frame.origin.y+firstTableView.frame.size.height+30 , WIDTH-20, WIDTH*50/375))
        login.setTitle("登陆", forState: UIControlState.Normal)
        login.backgroundColor = COLOR
        login.layer.cornerRadius = 10
        //        btn.backgroundColor = COLOR
        login.addTarget(self, action: #selector(self.login), forControlEvents: UIControlEvents.TouchUpInside)
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
            let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)as!MineTableViewCell
            cell.selectionStyle = .None
            
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
                    let img = UIImageView(frame: CGRectMake(WIDTH*33/375+CGFloat(i)*(WIDTH/3), 10, WIDTH*18/375, WIDTH*17/375))
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
                bookDanVc.isNotSigle = true
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
                let url1 = NSURL(string: "tel://4000608856")
                UIApplication.sharedApplication().openURL(url1!)
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
            
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
            
        }
        
        
    }
    
    func login(){
        
        print("login")
        pwdTextfield.resignFirstResponder()
        phoneTextfield.resignFirstResponder()
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
        
        print(self.phoneNum!)
        print(self.pwd!)
        if (self.phoneNum!.isEmpty) {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        if (self.pwd!.isEmpty) {
            SVProgressHUD.showErrorWithStatus("请输入密码！")
            return
        }
        
        loginWithNum(self.phoneNum! as String, pwd: self.pwd! as String)
        
    }
    
    func loginWithNum(num:String,pwd:String){
        SVProgressHUD.show()
        let password = self.view.viewWithTag(101)as! UITextField
        logVM!.login(num, password: pwd, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success == false {
                    if response != nil {
                        SVProgressHUD.showErrorWithStatus(response as! String)
                    }else{
                        SVProgressHUD.showErrorWithStatus("登录失败")
                    }
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
                    if userInfo.id != nil && userInfo.id! != ""{
                        JPUSHService.setTags(nil, aliasInbackground: userInfo.id!)

                    }
                    ud.setObject(userInfo.xgtoken, forKey: "token")
                    ud.setObject(userInfo.name, forKey: "name")
                    ud.setObject(self.phoneNum, forKey: "phone")
                    ud.setObject(self.pwd, forKey: "pwd")
                    print(userInfo.photo)
                    print(userInfo.sex)
                    if userInfo.photo != "" && userInfo.photo != nil{
                        ud.setObject(userInfo.photo, forKey: "photo")
                    }
                    if userInfo.sex != "" && userInfo.sex != nil{
                        ud.setObject(userInfo.sex, forKey: "sex")
                    }
                    
                    let function = BankUpLoad()
                    function.CheckRenzheng()
                    
                    //强制写入
                    ud.synchronize()
                    password.resignFirstResponder()
                    //登录成功
                    self.LOGIN_STATE = true
                    self.headerView.phone.text = self.phoneNum
                    self.loginSuccess()
                    self.getuserData()
                    self.Checktoubao()
                    
                    
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
        
        let vc = TCRegisterViewController()
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
