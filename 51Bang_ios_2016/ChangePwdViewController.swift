//
//  ChangePwdViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePwdViewController: UIViewController {
    
    var phoneLabel:UILabel!
    var checkLabel:UILabel!
    var passWordLabel:UILabel!
    var passCheckLabel:UILabel!
    
    var phoneNumFiled:UITextField!
    var checkNumFiled:UITextField!
    var passWordFiled:UITextField!
    var passNumCheckFiled:UITextField!
    
    var checkNumBtn:UIButton!
    var showPassWordBtn:UIButton!
    var showPassCheckBtn:UIButton!
    var successBtn:UIButton!
    
    var backView:UIView!
    
    var numView:UIView!
    var phoneNumView:UIView!
    var checkView:UIView!
    var passWordView:UIView!
    var checkPassView:UIView!
    
    
    //  注册功能
    var changeVM:TCVMLogModel?
    //  倒计时功能
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
//        self.view.backgroundColor = UIColor.lightGrayColor()
        //  显示导航控制器
        self.navigationController?.navigationBar.hidden = false
        self.title = "修改密码"
        
        
        changeVM = TCVMLogModel()
        
        //  1.验证码倒计时
        time()
        //  2.创建视图
        createView()
        //  3.搭建UI
        createUI()
        
        
    }
    func time(){
        
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.checkNumBtn.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                self.checkNumBtn.setTitleColor(COLOR, forState: .Normal)
                
                self.checkNumBtn.setTitle(btnTitle, forState: .Normal)
                
                
                
            })
        }
        
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.checkNumBtn.userInteractionEnabled = true
                self.checkNumBtn.setTitleColor(COLOR, forState: .Normal)
                self.checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                self.checkNumBtn.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic["forget"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["forget"]?.PHandle = processHandle
    }
    
    // MARK: - createView(创建视图)
    func createView(){
        //  创建五个视图
        numView = UIView()
        numView.frame = CGRectMake(0, 40, 80, 60)
        numView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(numView)
        
        phoneNumView = UIView()
        phoneNumView.frame = CGRectMake(81, 40, WIDTH - 81, 60)
        phoneNumView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(phoneNumView)
        
        checkView = UIView()
        checkView.frame = CGRectMake(0, 101, WIDTH, 60)
        checkView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(checkView)
        
        passWordView = UIView()
        passWordView.frame = CGRectMake(0, 162, WIDTH, 60)
        passWordView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(passWordView)
        
        checkPassView = UIView()
        checkPassView.frame = CGRectMake(0, 223 , WIDTH, 60)
        checkPassView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(checkPassView)
    }
    // MARK: - createUI(创建界面控件)
    func createUI(){
        
        //  四个label
        phoneLabel = UILabel()
        phoneLabel.frame = CGRectMake(20, 15, 60, 30)
        phoneLabel.text = "+86"
        phoneLabel.font = UIFont.systemFontOfSize(16)
        numView.addSubview(phoneLabel)
        
        checkLabel = UILabel()
        checkLabel.frame = CGRectMake(20, 15, 70, 30)
        checkLabel.text = "验证码"
        checkLabel.font = UIFont.systemFontOfSize(16)
        checkView.addSubview(checkLabel)
        
        passWordLabel = UILabel()
        passWordLabel.frame = CGRectMake(20, 15, 70, 30)
        passWordLabel.text = "输入密码"
        passWordLabel.font = UIFont.systemFontOfSize(16)
        passWordView.addSubview(passWordLabel)
        
        passCheckLabel = UILabel()
        passCheckLabel.frame = CGRectMake(20, 15, 70, 30)
        passCheckLabel.text = "确认密码"
        passCheckLabel.font = UIFont.systemFontOfSize(16)
        checkPassView.addSubview(passCheckLabel)
        
        //  四个textFiled
        phoneNumFiled = UITextField()
        phoneNumFiled.frame = CGRectMake(19, 15, WIDTH * 0.4, 30)
        phoneNumFiled.font = UIFont.systemFontOfSize(14)
        phoneNumFiled.placeholder = "请输入手机号"
        phoneNumView.addSubview(phoneNumFiled)
        
        checkNumFiled = UITextField()
        checkNumFiled.frame = CGRectMake(100, 15, WIDTH * 0.4, 30)
        checkNumFiled.font = UIFont.systemFontOfSize(14)
        checkNumFiled.placeholder = "请输入验证码"
        checkView.addSubview(checkNumFiled)
        
        passWordFiled = UITextField()
        passWordFiled.frame = CGRectMake(100, 15, WIDTH * 0.4, 30)
        passWordFiled.font = UIFont.systemFontOfSize(14)
        
        passWordFiled.placeholder = "请输入密码"
        //  密文输入
        passWordFiled.secureTextEntry = true
        passWordView.addSubview(passWordFiled)
        
        passNumCheckFiled = UITextField()
        passNumCheckFiled.frame = CGRectMake(100, 15, WIDTH * 0.4, 30)
        passNumCheckFiled.font = UIFont.systemFontOfSize(14)
        passNumCheckFiled.placeholder = "请确认密码"
        passNumCheckFiled.secureTextEntry = true
        checkPassView.addSubview(passNumCheckFiled)
        
        //  四个button
        
        checkNumBtn = UIButton()
        checkNumBtn.frame = CGRectMake(WIDTH - 191, 15, 100, 30)
        checkNumBtn.layer.cornerRadius = 13
        checkNumBtn.layer.borderColor = COLOR.CGColor
        checkNumBtn.layer.borderWidth = 1.5
        checkNumBtn.setTitle("获取验证码", forState: .Normal)
        checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        checkNumBtn.setTitleColor(COLOR, forState: .Normal)
        checkNumBtn.addTarget(self, action: #selector(self.getCheckNum), forControlEvents: .TouchUpInside)
        phoneNumView.addSubview(checkNumBtn)
        
        showPassWordBtn = UIButton()
        showPassWordBtn.frame = CGRectMake(WIDTH - 40, 15, 30, 30)
        showPassWordBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
        showPassWordBtn.setTitleColor(COLOR, forState: .Normal)
        showPassWordBtn.addTarget(self, action: #selector(self.showPassWord(_:)), forControlEvents: .TouchUpInside)
        passWordView.addSubview(showPassWordBtn)
        
        showPassCheckBtn = UIButton()
        showPassCheckBtn.frame = CGRectMake(WIDTH - 40, 15, 30, 30)
        showPassCheckBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
        showPassCheckBtn.setTitleColor(COLOR, forState: .Normal)
        showPassCheckBtn.addTarget(self, action: #selector(self.showCheckPassWord(_:)), forControlEvents: .TouchUpInside)
        checkPassView.addSubview(showPassCheckBtn)
        
        
        
        
        successBtn = UIButton()
        successBtn.frame = CGRectMake(20, 320 , WIDTH - 40, 40)
        successBtn.setTitle("完成", forState: .Normal)
        successBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        successBtn.backgroundColor = COLOR
//        successBtn.backgroundColor = UIColor.whiteColor()
        successBtn.addTarget(self, action: #selector(self.changeSuccsee), forControlEvents: .TouchUpInside)
        self.view.addSubview(successBtn)
        
        
        
    }
    
   
    // MARK: - 点击事件
    
    func getCheckNum() {
        checkNumBtn.userInteractionEnabled = false
        //  获取验证码
        //  1.判断手机号是否为空
        if phoneNumFiled.text!.isEmpty {
            alert("请输入手机号", delegate: self)
            checkNumBtn.userInteractionEnabled = true
            return
        }
        //  2.通过上传url获取验证码（检测手机是否已经注册）
        print(phoneNumFiled.text!)
        
        //  [unowned self]什么意思   dispatch_async(dispatch_get_main_queue() 这里为什么需要加一个主线程
        changeVM?.comfirmPhoneHasRegister(phoneNumFiled.text!, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    //  2.1成功,验证码传到手机,执行倒计时操作
                    self.checkNumBtn.userInteractionEnabled = false
                    TimeManager.shareManager.begainTimerWithKey("forget", timeInterval: 30, process: self.processHandle!, finish: self.finishHandle!)
                    self.changeVM?.sendMobileCodeWithPhoneNumber(self.phoneNumFiled.text!)
                }else{
                    //  2.2失败,手机号没有注册
                    self.checkNumBtn.userInteractionEnabled = true
                    alert("手机没有注册", delegate: self)
                }
            })
            })
    }
    func showPassWord(btn:UIButton) {
        //  显示输入密码
        if passWordFiled.secureTextEntry == true {
            passWordFiled.secureTextEntry = false
            btn.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
        }else{
            passWordFiled.secureTextEntry = true
            btn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
        }
    }
    func showCheckPassWord(btn:UIButton) {
        //  显示确认密码
        if passNumCheckFiled.secureTextEntry == true {
            passNumCheckFiled.secureTextEntry = false
            btn.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
        }else{
            passNumCheckFiled.secureTextEntry = true
            btn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
        }
    }
    func changeSuccsee() {
        if phoneNumFiled.text!.isEmpty {
//            alert("请输入手机号", delegate: self)
            SVProgressHUD.showErrorWithStatus("请输入手机号")
            return
        }
        if checkNumFiled.text!.isEmpty {
//            alert("请输入验证码", delegate: self)
            SVProgressHUD.showErrorWithStatus("请输入验证码")
            return
        }
        if passWordFiled.text!.isEmpty {
//            alert("请输入密码", delegate: self)
            SVProgressHUD.showErrorWithStatus("请输入密码")
            return
        }
        if passNumCheckFiled.text!.isEmpty {
//            alert("请确认密码", delegate: self)
            SVProgressHUD.showErrorWithStatus("请确认密码")
            return
        }
        if passWordFiled.text != passNumCheckFiled.text {
//            alert("两次输入密码不一致", delegate: self)
            SVProgressHUD.showErrorWithStatus("两次输入密码不一致")
            return
        }
        
        var regex:String?
        regex = "^[A-Za-z0-9]{6,20}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        let flags = predicate.evaluateWithObject(passWordFiled.text! as NSString)
        if !flags{
            SVProgressHUD.showErrorWithStatus("请输入6-20位密码!")
            return
        }
        
        let flags1 = predicate.evaluateWithObject(passNumCheckFiled.text! as NSString)
        if !flags1{
            SVProgressHUD.showErrorWithStatus("请输入6-20位密码!")
            return
        }
        changeVM?.forgetPassword(phoneNumFiled.text!, code: checkNumFiled.text!, password: passWordFiled.text!, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                
                if success {
                    alert("修改成功", delegate: self)
                    print("修改成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    let string = response as! String
                    print(string)
                    alert(string, delegate: self)
                }
            })
            })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        phoneNumFiled.resignFirstResponder()
        checkNumFiled.resignFirstResponder()
        passWordFiled.resignFirstResponder()
        passNumCheckFiled.resignFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["forget"]?.FHandle = nil
        TimeManager.shareManager.taskDic["forget"]?.PHandle = nil
    }

}
