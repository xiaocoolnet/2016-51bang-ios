//
//  AddAddressViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController {

    var userid = String()
    let mainHelper = TCVMLogModel()
    let ud = NSUserDefaults.standardUserDefaults()
    var isdefault = String()
    var sign = Int(0)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sign = 0
        self.view.backgroundColor = RGREY
        self.title = "添加新地址"
        let textView = UITextView.init(frame: CGRectMake(0, 0, WIDTH, 150))
        textView.text = "请填写详细地址"
        textView.tag = 10
//        textView.delegate = self
        let button = UIButton.init(frame: CGRectMake(0, HEIGHT-118, WIDTH, 50))
        button.setTitle("确定", forState: UIControlState.Normal)
        button.backgroundColor = COLOR
        button.addTarget(self, action: #selector(self.addAddress), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(textView)
        self.view.addSubview(button)
        let button1 = UIButton.init(frame: CGRectMake(WIDTH-125, textView.frame.size.height+textView.frame.origin.y+10, 20, 20))
        button1.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button1)
        let button2 = UIButton.init(frame: CGRectMake(WIDTH-100, textView.frame.size.height+textView.frame.origin.y+10, 80, 30))
        button2.addTarget(self, action: #selector(self.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button2.setTitle("默认地址", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(button2)
        // Do any additional setup after loading the view.
    }

    func addAddress(){
    
        let longtitude = ud.objectForKey("longitude")as!String
        let latitude = ud.objectForKey("latitude")as!String
//        print(longtitude)
//        print(latitude)
        let mylongtitude = removeOptionWithString(longtitude)
        let mylatitude = removeOptionWithString(latitude)
        print(mylongtitude)
        print(mylatitude)
        let userid = ud.objectForKey("userid")as! String
        let textView = self.view.viewWithTag(10)as!UITextView
        print(textView.text)
        if textView.text == "添加新地址" {
            textView.text = ""
        }
        mainHelper.addAddress(userid, address: textView.text, longitude: mylongtitude, latitude: mylatitude, isdefault: self.isdefault) { (success, response) in
            alert("添加成功", delegate: self)
//            let vc = myAddressViewController()
            self.navigationController?.popViewControllerAnimated(true)
//            self.navigationController?.popToViewController(vc, animated: true)
        }
    
    }
    
    func onClick(btn:UIButton){
    
        if sign == 0{
        
            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            self.isdefault = "1"
            sign = 1
        }else{
        
            btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
            self.isdefault = "0"
            sign = 0

        }
    
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
