//
//  BankBandViewController.swift
//  51Bang_ios_2016
//
//  Created by Pencil on 16/9/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class BankBandViewController: UIViewController {
    
   
    let nameTextField = UITextField()
    let certifyField = UITextField()
    let baoNumber = UITextField()
    let phoneVerify = UITextField()
    let bankSelect = UIButton()
    var haomalabel = UILabel()
    var textShow = UIView()
    var cityName = ""
    var longitude = ""
    var latitude = ""
    var address = ""
    var ViewTag = 1
    var timer = NSTimer.init()
    var getPhoneVerityBtn = UIButton()
    var timeCount = 30
    var Finish = UIButton()
    let scrollView = TPKeyboardAvoidingScrollView()
    
    
    override func viewWillAppear(animated: Bool) {
        
        if( BankSelectVc.banName != "")
        {
            bankSelect.setTitle( BankSelectVc.banName , forState: UIControlState.Normal )
        }
        getPhoneVerityBtn.userInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        BankSelectVc.banName = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "银行卡绑定"
        setScrolView()
        setTextField()
        setlabel()
        setButton()
        setFooter()
        bankChange()
        
    }
    
    
    func setScrolView()
    {
        scrollView.frame = CGRectMake(0, -50, WIDTH, self.view.frame.size.height )
        scrollView.backgroundColor = RGREY
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.directionalLockEnabled = false
        scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT + 150)
        scrollView.scrollsToTop = true
        scrollView.backgroundColor = UIColor(red: 247 / 255.0, green: 247 / 255.0, blue: 249 / 255.0, alpha: 1.0)
        
        self.view.addSubview(scrollView)
        
    }
    
    
    func setTextField()
    {
        nameTextField.frame = CGRectMake(15, 80, WIDTH - 30, 35)
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        nameTextField.layer.borderWidth = 1
        sethoder(nameTextField, size: 13, str: "   请输入您的姓名")
        scrollView.addSubview(nameTextField)
        
        
        
        certifyField.frame = CGRectMake(15, nameTextField.frame.origin.y + 35 + 15, WIDTH - 30, 35)
        certifyField.layer.masksToBounds = true
        certifyField.layer.cornerRadius = 10
        certifyField.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        certifyField.layer.borderWidth = 1
        sethoder(certifyField, size: 13, str: "   请输入身份证号码")
        scrollView.addSubview(certifyField)
        
        baoNumber.frame = CGRectMake(15, certifyField.frame.origin.y + 35 + 15, WIDTH - 30, 35)
        baoNumber.layer.masksToBounds = true
        baoNumber.layer.cornerRadius = 10
        baoNumber.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        baoNumber.layer.borderWidth = 1
        sethoder(baoNumber, size: 13, str: "   请输入支付宝账号")
        scrollView.addSubview(baoNumber)
        
        phoneVerify.frame = CGRectMake(15, baoNumber.frame.origin.y + 35 + 20 + 35 + 10 , WIDTH - 30, 35)
        phoneVerify.layer.masksToBounds = true
        phoneVerify.layer.cornerRadius = 10
        phoneVerify.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        phoneVerify.layer.borderWidth = 1
        sethoder(phoneVerify, size: 13, str: "   请输入短信验证码")
        scrollView.addSubview(phoneVerify)
        
        getPhoneVerityBtn.userInteractionEnabled = true
        getPhoneVerityBtn = UIButton.init(frame: CGRectMake(phoneVerify.frame.size.width - 100, 0,100, 35))
        getPhoneVerityBtn.setTitle("获取短信验证码", forState: UIControlState.Normal)
        getPhoneVerityBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        getPhoneVerityBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        getPhoneVerityBtn.addTarget(self, action: #selector(self.getPhoneVerifyAction), forControlEvents: UIControlEvents.TouchUpInside)
        getPhoneVerityBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        let decorlabel = UILabel.init(frame: CGRectMake(getPhoneVerityBtn.frame.origin.x - 1, 0, 1, 35))
        decorlabel.backgroundColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0)
        phoneVerify.addSubview(decorlabel)
        phoneVerify.addSubview(getPhoneVerityBtn)
        
    }
    
    func timego(){
        
        if(timeCount != -1)
        {
            getPhoneVerityBtn.userInteractionEnabled = false
            getPhoneVerityBtn.setTitle("\(timeCount)后重新获取", forState: UIControlState.Normal)
            getPhoneVerityBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            timeCount -= 1
            
        }else
            
        {
            getPhoneVerityBtn.userInteractionEnabled = true
            timer.invalidate()
            timeCount = 30
            getPhoneVerityBtn.userInteractionEnabled = true
            getPhoneVerityBtn.setTitle("获取短信验证码", forState: UIControlState.Normal)
            getPhoneVerityBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            
        }
        
    }
    
    func setlabel()
    {
        haomalabel = UILabel.init(frame: CGRectMake(0, baoNumber.frame.origin.y + 35 + 20, WIDTH, 35))
        haomalabel.font = UIFont.systemFontOfSize(13)
        haomalabel.text = phoneNumberCal()
        haomalabel.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(haomalabel)
        
        
    }
    
    
    func phoneNumberCal() ->String
    {
        
        let userData = NSUserDefaults.standardUserDefaults()
        if userData.objectForKey("phone") != nil {
            let phoneNum = userData.objectForKey("phone") as! String
            let temp1 = (phoneNum as NSString).substringWithRange(NSMakeRange(0, 4))
            let temp2 = (phoneNum as NSString).substringWithRange(NSMakeRange(7, 4))
            return "您当前绑定的手机号码：" + temp1 + "****" + temp2
        }
        
        return "未绑定手机号"
    }
    
    
    func sethoder(field:UITextField,size:CGFloat,str:String)
    {
        var attributes:[String:AnyObject] = [:]
        attributes[NSFontAttributeName] = UIFont.systemFontOfSize(size)
        let atrholder = NSMutableAttributedString.init(string: str, attributes: attributes)
        field.attributedPlaceholder = atrholder
    }
    
    func setButton()
    {
        Finish = UIButton.init(frame: CGRectMake(15, phoneVerify.frame.origin.y + 100, WIDTH - 30, 35))
        Finish.backgroundColor = COLOR
        Finish.setTitle("完成认证并绑定", forState: UIControlState.Normal)
        Finish.layer.masksToBounds = true
        Finish.layer.cornerRadius  = 10
        Finish.addTarget(self, action: #selector(self.action), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(Finish)
        
    }
    
    
    func setFooter()
    {
        textShow = UIView.init(frame: CGRectMake(0,Finish.frame.origin.y + 35 + 10 , WIDTH, 100))
        
        let lin1 = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 25))
        setText(lin1, size: 12)
        lin1.text = "*此次认证与提现认证一致，且只认证一次，"
        
        let lin2 = UILabel.init(frame: CGRectMake(0, 30, WIDTH, 25))
        setText(lin2, size: 12)
        lin2.text = "请输入正确的身份证号码和姓名且收款账户必须与姓"
        
        let lin3 = UILabel.init(frame: CGRectMake(0, 60, WIDTH, 25))
        setText(lin3, size: 12)
        lin3.text = "名一致，否则无法认证与提现"
        
        scrollView.addSubview(textShow)
        textShow.addSubview(lin1)
        textShow.addSubview(lin2)
        textShow.addSubview(lin3)
        
    }
    
    func setText(label:UILabel,size:CGFloat)
    {
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(size)
        
    }
    
    func action()
    {
        let userData = NSUserDefaults.standardUserDefaults()
        var phoneNum = String()
        if userData.objectForKey("phone") != nil{
            phoneNum = userData.objectForKey("phone") as! String
        }
//        let phoneNum = userData.objectForKey("phone") as! String
        let vc = CommitOrderViewController()
        vc.cityName = self.cityName
        vc.longitude =   self.longitude
        vc.latitude =   self.latitude
        vc.address = address
        
        let uploadFunction = BankUpLoad()
        if( ViewTag == 1)
        {
//            var userid = String()
//            if userData.objectForKey("userid") != nil {
//                userid = userData.objectForKey("userid")as! String
//            }
           uploadFunction.bankMessageUpload( nameTextField.text! , idCard: certifyField.text! , bankName: BankSelectVc.banName , bankNum: baoNumber.text!, Phone: phoneNum, Code: phoneVerify.text! , Target: self,pushVc: vc )
            
        }else{
            uploadFunction.bankMessageUpload( nameTextField.text! , idCard: certifyField.text! , bankName: BankSelectVc.banName , bankNum: baoNumber.text!, Phone: phoneNum, Code: phoneVerify.text! , Target: self,pushVc: vc )
            
            
            
        }
        
    }
    
    func getPhoneVerifyAction()
    {
        getPhoneVerityBtn.userInteractionEnabled = false
        print("开始发送")
        let userData = NSUserDefaults.standardUserDefaults()
        if userData.objectForKey("phone") != nil {
            let phoneNum = userData.objectForKey("phone") as! String
            let getphoneMessage = BankUpLoad()
            getphoneMessage.requestMessage(phoneNum)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.timego), userInfo: nil, repeats: true)
        }else{
            alert("获取手机号失败", delegate: self)
            getPhoneVerityBtn.userInteractionEnabled = true
        }
        
    }
    
    
    
    func bankChange()
    {
        self.title = "银行卡认证"
        sethoder(baoNumber, size: 13, str: "   请输入银行卡号")
        
        bankSelect.frame = CGRectMake(15, baoNumber.frame.origin.y + 35 + 15, WIDTH - 30, 35)
        bankSelect.layer.masksToBounds = true
        bankSelect.layer.cornerRadius = 10
        bankSelect.hidden = false
        bankSelect.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        bankSelect.layer.borderWidth = 1
        bankSelect.setTitleColor(UIColor.blackColor(), forState:  UIControlState.Normal )
        bankSelect.setTitle("请选择开户行", forState: UIControlState.Normal)
        bankSelect.addTarget(self, action: #selector(self.banselectAction), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(bankSelect)
        haomalabel.frame = CGRectMake(15, bankSelect.frame.origin.y + 35 + 20 , WIDTH - 30, 35)
        phoneVerify.frame = CGRectMake(15, bankSelect.frame.origin.y + 35 + 20 + 35 + 10 , WIDTH - 30, 35)
        Finish.frame = CGRectMake(15, phoneVerify.frame.origin.y + 100, WIDTH - 30, 35)
        textShow.frame = CGRectMake(0,Finish.frame.origin.y + 35 + 10 , WIDTH, 100)
    }
    
    func banselectAction()
    {
        let vc = BankSelectVc()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //self.hidesBottomBarWhenPushed = false
    }
    
    func baoChange()
    {
        self.title = "支付宝认证"
        sethoder(baoNumber, size: 13, str: "   请输入支付宝账号")
        bankSelect.hidden = true
        haomalabel.frame = CGRectMake(0, baoNumber.frame.origin.y + 35 + 20, WIDTH, 35)
        phoneVerify.frame = CGRectMake(15, baoNumber.frame.origin.y + 35 + 20 + 35 + 10 , WIDTH - 30, 35)
        Finish.frame =  CGRectMake(15, phoneVerify.frame.origin.y + 100, WIDTH - 30, 35)
        textShow.frame = CGRectMake(0,Finish.frame.origin.y + 35 + 10 , WIDTH, 100)
    }
}


