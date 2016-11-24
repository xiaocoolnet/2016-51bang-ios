//
//  TCRegisterViewController.swift
//  Parking
//
//  Created by xiaocool on 16/5/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBProgressHUD


class TCRegisterViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private let GET_ID_KEY = "register"

    @IBOutlet weak var areaCodeBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var getIDButton: UIButton!
    @IBOutlet weak var identifyNumber: UITextField!
    @IBOutlet weak var passwordNumber: UITextField!
    @IBOutlet weak var secretBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var baomiButton: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
//    @IBOutlet weak var realName: UITextField!
//    @IBOutlet weak var personCardID: UITextField!
//    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var InvitationNum: UITextField!
    
    @IBOutlet weak var xieyiButton: UIButton!
    @IBOutlet weak var agreeBut: UIButton!
    var myActionSheet:UIAlertController?
    var logVM:TCVMLogModel?
    var sex:Int = 1
    var avatarImageName:String = "avatar_man.png"
    var hasAvatar = false
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    var showMM = false
    var isAgree = Bool()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.title = "注册账号"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAgree = true
        configureUI()
        logVM = TCVMLogModel()
        backViewHeight.constant = HEIGHT - 64
        backViewHeight.constant = HEIGHT>568 ?HEIGHT:568
        self.view.backgroundColor = RGREY
        
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
               
                self.getIDButton.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.getIDButton.setTitle(btnTitle, forState: .Normal)
            })
        }
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.getIDButton.userInteractionEnabled = true
                self.getIDButton.backgroundColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1)
                self.getIDButton.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic[GET_ID_KEY]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic[GET_ID_KEY]?.PHandle = processHandle
        
        myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        myActionSheet?.addAction(UIAlertAction(title: "拍照", style: .Default, handler: {[unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.takePhoto()
            })
            }))

        myActionSheet?.addAction(UIAlertAction(title: "从相册获取", style: .Default, handler: { [unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.LocalPhoto()
            })
            }))
        
        myActionSheet?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
        
        

        xieyiButton.addTarget(self, action: #selector(self.xieyi(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        agreeBut.addTarget(self, action: #selector(self.agreePro), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic[GET_ID_KEY]?.FHandle = nil
        TimeManager.shareManager.taskDic[GET_ID_KEY]?.PHandle = nil
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        //裁剪后图片
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        //        hud.mode = .Text
        hud.labelText = "正在努力加载"
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        avatarBtn.setImage(image, forState: .Normal)
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr + TCUserInfo.currentInfo.userid
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                let result = Http(JSONDecoder(data))
                hud.hide(true)
                if result.status != nil {
                    if result.status! == "success"{
                        let imageName = result.data!
                        self.avatarImageName = imageName
                        self.hasAvatar = true
                        print(imageName)
                    }else{
                        SVProgressHUD.showErrorWithStatus("图片上传失败")
                    }
                }
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func configureUI(){
        //gestureRecognizer
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        print(avatarBtn)
        avatarBtn!.layer.masksToBounds = true
        avatarBtn!.layer.cornerRadius = 40
        avatarBtn!.clipsToBounds = true
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        getIDButton.layer.cornerRadius = 2
        completeBtn.layer.cornerRadius = 8
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        phoneNumber.keyboardType = UIKeyboardType.PhonePad
        identifyNumber.layer.borderWidth = 2
        identifyNumber.layer.borderColor = UIColor.whiteColor().CGColor
        identifyNumber.keyboardType = UIKeyboardType.PhonePad
        InvitationNum.layer.borderWidth = 2
        InvitationNum.layer.borderColor = UIColor.whiteColor().CGColor
        InvitationNum.keyboardType = UIKeyboardType.Default
        
        passwordNumber.layer.borderWidth = 2
        passwordNumber.layer.borderColor = UIColor.whiteColor().CGColor
//        realName.layer.borderWidth = 2
//        realName.layer.borderColor = UIColor.whiteColor().CGColor
//        personCardID.layer.borderWidth = 2
//        personCardID.layer.borderColor = UIColor.whiteColor().CGColor
//        address.layer.borderWidth = 2
//        address.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.title = "注册账号"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
    }
    
    func tapBackView(){
        self.view.endEditing(true)
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //获取验证码
    @IBAction func getIdentifyingAction(sender: AnyObject) {
        self.getIDButton.userInteractionEnabled = false
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            self.getIDButton.userInteractionEnabled = true
            return
        }
        logVM?.comfirmPhoneHasRegister(phoneNumber.text!, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if success {
                    SVProgressHUD.showErrorWithStatus("手机已注册")
                self.getIDButton.userInteractionEnabled = true
            }else{
                 self.getIDButton.backgroundColor = UIColor.lightGrayColor()
                TimeManager.shareManager.begainTimerWithKey(self.GET_ID_KEY, timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                self.logVM?.sendMobileCodeWithPhoneNumber(self.phoneNumber.text!)
            }
            })
            
        })
        print("get identify")
    }
    
    @IBAction func completeButtonAction(sender: AnyObject) {
        
        print(InvitationNum.text)
        
        if avatarImageName.isEmpty {
            SVProgressHUD.showErrorWithStatus("请选择头像！")
            return
        }
        
//        if phoneNumber.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入姓名")
//            return
//        }
        
//        if personCardID.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入身份证")
//            return
//        }
        
//        let flag = RegularExpression.validateIdentityCard(personCardID.text!)
//        if !flag {
//            SVProgressHUD.showErrorWithStatus("请输入有效身份证号码")
//            return
//        }
        
//        if phoneNumber.text!.isEmpty {
//            SVProgressHUD.showErrorWithStatus("请输入地址")
//            return
//        }
        
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        
        if identifyNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入验证码!")
            return
        }
        
        if passwordNumber.text!.isEmpty {
            
            
            SVProgressHUD.showErrorWithStatus("请输入密码!")
            return
        }
        
        var regex:String?
        regex = "^[A-Za-z0-9]{6,20}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        let flags = predicate.evaluateWithObject(passwordNumber.text! as NSString)
        if !flags{
            SVProgressHUD.showErrorWithStatus("请输入6-20位密码!")
            return
        }
        
        if isAgree != true {
            SVProgressHUD.showErrorWithStatus("同意协议才可以完成注册!")
            return
        }
        var referral = String()
        
        if InvitationNum.text == nil {
            referral = ""
        }else{
            referral = InvitationNum.text! as String
        }
        
        logVM?.register(phoneNumber.text!, password: passwordNumber.text!, code: identifyNumber.text!, avatar: avatarImageName, name: "",sex: String(sex), cardid: "", addr:"",referral:referral, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    alert("注册成功！", delegate: self)
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }else{
                    if response?.isKindOfClass(NSString) == true {
                         alert(response as! String, delegate: self)
                    }
                    
                   
                }
            })
        })
    }
    //男是1，女是0
    @IBAction func manBtnClicked(sender: AnyObject) {
        manBtn.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        baomiButton.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        sex = 1
//        if !hasAvatar {
//            avatarBtn.setImage(UIImage(named:"avatar_nan"), forState: .Normal)
////            avatarImageName = "avatar_man.png"
//        }
    }
    
    @IBAction func womenBtnClicked(sender: AnyObject) {
        manBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
        baomiButton.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        sex = 0
//        if  !hasAvatar {
//            avatarBtn.setImage(UIImage(named:"avatar_nv"), forState: .Normal)
//            avatarImageName = "avatar_woman.png"
//        }
    }
    
    @IBAction func baoMiButtonAction(sender: AnyObject) {
        
        manBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        baomiButton.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
    }
    @IBAction func avatarBtnClicked(sender: AnyObject) {
        
        presentViewController(myActionSheet!, animated: true, completion:nil)
    }
    
    @IBAction func passwordSecretBtnAction(sender: AnyObject) {
        if showMM == false {
            showMM = true
            secretBtn.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
            passwordNumber.secureTextEntry = false
        }else{
            showMM = false
            secretBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
            passwordNumber.secureTextEntry = true
        }
    }
    
    //MARK: - 协议事件
    
    func xieyi(btn:UIButton){
        
        let vc = JiaoChengViewController()
        vc.sign = 2
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func agreePro(){
        
        if isAgree == false {
            
            agreeBut.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            isAgree = true
        }else{
            agreeBut.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
            isAgree = false
        }
        
    }


}
