//
//  CodeViewController.swift
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/9/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SVProgressHUD

class CodeViewController: UIViewController,UITextFieldDelegate {
    
    let textfile = UITextField()
    var userid = NSString()
    var button = UIButton()
    let mainhelper = MainHelper()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "卷码验证"
        self.view.backgroundColor = RGREY
        let ud = NSUserDefaults.standardUserDefaults()
        self.userid = ud.objectForKey("userid")as!String
        
        let backview = UIView()
        backview.frame = CGRectMake(0, 50, WIDTH, 50)
        backview.backgroundColor = UIColor.whiteColor()
        backview.layer.masksToBounds = true
        backview.layer.cornerRadius = 10
        backview.layer.borderColor = COLOR.CGColor
        backview.layer.borderWidth = 1
        
        self.textfile.frame = CGRectMake(20, 0, WIDTH-20, 50)
        self.textfile.delegate = self
        backview.addSubview(self.textfile)
        
        self.view.addSubview(backview)
        
        button = UIButton.init(frame: CGRectMake(0, HEIGHT-118, WIDTH, 50))
        button.backgroundColor = COLOR
        button.setTitle("开始验证", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.yanZheng), forControlEvents: UIControlEvents.TouchUpInside)
//        let view = UIView()
//        self.myTableView.tableFooterView = view
//        self.view.addSubview(myTableView)
        self.view.addSubview(button)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        
        // Do any additional setup after loading the view.
    }
    
    func yanZheng(){
        
        button.userInteractionEnabled = false
        
        let user = NSUserDefaults.standardUserDefaults()
        let userid1 = user.objectForKey("userid") as! String
        mainhelper.getVerifyShoppingCode(userid1, code: textfile.text!) { (success, response) in
            if !success{
                alert("卷码错误！", delegate: self)
                self.button.userInteractionEnabled = true
                return
            }
            alert("卷码验证成功", delegate: self)
            self.button.userInteractionEnabled = true
//            SVProgressHUD.showSuccessWithStatus("卷码验证成功")
            let vc = MyBookDan()
            vc.isNotSigle = true
            vc.sign = 3
            self.tabBarController?.selectedIndex = 3
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func textFieldDidEndEditing(textField: UITextField){
        if (self.textfile.text == nil) {
            alert("请输入正确格式的卷码", delegate: self)
        }
        UIView.animateWithDuration(0.25) {
            self.button.frame = CGRectMake(0, HEIGHT-118, WIDTH, 50)
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            print("收回键盘")
            self.textfile.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
        UIView.animateWithDuration(0.25) {
            self.button.frame = CGRectMake(0, HEIGHT-118, WIDTH, 50)
        }
    }
    func textFieldDidBeginEditing(textField: UITextField){
        UIView.animateWithDuration(0.25) {
            self.button.frame = CGRectMake(0, 150, WIDTH, 50)
        }
    }
}
