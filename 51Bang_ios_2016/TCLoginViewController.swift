//
//  TCLoginViewController.swift
//  Parking
//  Created by xiaocool on 16/5/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD

class TCLoginViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var areaCode: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPwdBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var cancelPwdBtn: UIButton!
//    @IBOutlet weak var keyboardScrollView: TPKeyboardAvoidingScrollView!
    var logVM:TCVMLogModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        logVM = TCVMLogModel()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //autoLogin()
    }
    
//    func autoLogin(){
//        let logInfo = NSUserDefaults.standardUserDefaults().objectForKey(LOGINFO_KEY) as? Dictionary<String,String>
//        if logInfo != nil {
//            let usernameStr = logInfo![USER_NAME]!
//            let passwordStr = logInfo![USER_PWD]!
//            phoneNumber.text = usernameStr
//            password.text = passwordStr
//            loginWithNum(usernameStr , pwd: passwordStr)
//        }
//    }
    
    func configureUI(){
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        password.layer.borderColor = UIColor.whiteColor().CGColor
        password.layer.borderWidth = 2
//        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        phoneNumber.layer.borderWidth = 2
        loginBtn.layer.cornerRadius = 8
        
    }
    //区号
    @IBAction func areaCodeAction(sender: AnyObject) {
        print("area Code")
    }
    @IBAction func loginAction(sender: AnyObject) {
        print("login")
        if (phoneNumber.text!.isEmpty) {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        if (password.text!.isEmpty) {
            SVProgressHUD.showErrorWithStatus("请输入密码！")
            return
        }
        loginWithNum(phoneNumber.text!, pwd: password.text!)
    }
    
    func loginWithNum(num:String,pwd:String){
        SVProgressHUD.show()
        logVM?.login(num, password: pwd, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success == false {
                    if response != nil {
                        SVProgressHUD.showErrorWithStatus(response as! String)
                    }else{
                        SVProgressHUD.showErrorWithStatus("登录失败")
                    }
                    return
                }else{
                    SVProgressHUD.showSuccessWithStatus("登录成功")
                    let ud = NSUserDefaults.standardUserDefaults()
                    ud .setObject(self.phoneNumber.text, forKey: "phone")
                    ud.setObject(self.password.text, forKey: "pwd")
//                    ud.setObject([USER_NAME:self.phoneNumber.text!,USER_PWD:self.password.text!], forKey: LOGINFO_KEY)
                    self.loginSuccess()
                }
            })
            })

    }
    
    @IBAction func forgetPwdAction(sender: AnyObject) {
        print("forget")
       // let VC = TCForgetPasswordController(nibName: "TCForgetPasswordController",bundle: nil)
       // self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func registerAction(sender: AnyObject) {
        print("register")
        let registerVC = TCRegisterViewController(nibName: "TCRegisterViewController",bundle:nil)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func cancelPwdAction(sender: AnyObject) {
        password.text = ""
        print("cancelPassword")
    }
    func tapBackView(){
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        view.endEditing(true)
    }
    
    func loginSuccess(){
        print("登陆成功")
//        //controller
//        let appGuideController = UITabBarController()
//        
//        let homePage:UIViewController = TCHomePageController(nibName: "TCHomePageController", bundle:nil)
//        homePage.title = "首页"
//        setTabbarItemAttribute(homePage, normalImageName: "ic_home", selectedImageName: "ic_home-0")
//        let carInfo:UIViewController = TCCarInfoController(nibName: "TCCarInfoController", bundle:nil)
//        carInfo.title = "车辆信息"
//        setTabbarItemAttribute(carInfo, normalImageName: "ic_qiche-0", selectedImageName: "ic_qiche")
//        let payment:UIViewController = TCPaymentViewController(nibName: "TCPaymentViewController", bundle:nil)
//        payment.title = "缴费信息"
//        setTabbarItemAttribute(payment, normalImageName: "ic_jiaofei", selectedImageName: "ic_jiaofei-0")
//        let more:UIViewController = TCMoreFunctionController(nibName: "TCMoreFunctionController", bundle:nil)
//        more.title = "更多"
//        setTabbarItemAttribute(more, normalImageName: "ic_gengduo", selectedImageName: "ic_gengduo-0")
//        //nav
//        let homePageNav = UINavigationController(rootViewController: homePage)
//        homePageNav.navigationBar.barTintColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1) //backgroundColor
//        homePageNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()] //titleColor
//        let carInfoNav = UINavigationController(rootViewController: carInfo)
//        carInfoNav.navigationBar.barTintColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1) //backgroundColor
//        carInfoNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//        let paymentNav = UINavigationController(rootViewController: payment)
//        paymentNav.navigationBar.barTintColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1) //backgroundColor
//        paymentNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//        let moreNav = UINavigationController(rootViewController: more)
//        moreNav.navigationBar.barTintColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1) //backgroundColor
//        moreNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//        appGuideController.setViewControllers([homePageNav,carInfoNav,paymentNav,moreNav], animated: true)
//        appGuideController.tabBar.barTintColor = .whiteColor()
//        let window  = UIApplication.sharedApplication().keyWindow;
//        window?.rootViewController = appGuideController;
    }
    func setTabbarItemAttribute(controller:UIViewController,normalImageName:String,selectedImageName:String){
        controller.tabBarItem.image = UIImage(named: normalImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1)], forState: .Selected)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()],forState: .Normal)
    }
}
