//
//  AddAddressViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController,UITextFieldDelegate {

    var userid = String()
    var cityController:CityViewController!
    let mainHelper = TCVMLogModel()
    let ud = NSUserDefaults.standardUserDefaults()
    var isdefault = String()
    var sign = Int(0)
    let addressLabe = UILabel()
    let textView = UITextField()
    
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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeCity(_:)), name:"changeCityStr", object: nil)
        
        self.addressLabe.frame = CGRectMake(0, 0, WIDTH, 50)
        
        self.addressLabe.backgroundColor = UIColor.whiteColor()
        self.addressLabe.text = "请选择省市区👉"
        self.addressLabe.textAlignment = NSTextAlignment.Center
        let goImageView = UIImageView.init(image: UIImage(named: "ic_arrow_right"))
        goImageView.frame = CGRectMake(WIDTH-30, 18, 10, 20)
        goImageView.backgroundColor = UIColor.whiteColor()
        self.addressLabe.addSubview(goImageView)
        self.view.addSubview(self.addressLabe)
        let backButton = UIButton.init(frame: self.addressLabe.frame)
        backButton.backgroundColor = UIColor.clearColor()
        backButton.addTarget(self, action: #selector(self.goCitySelect), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        textView.frame = CGRectMake(0, 60, WIDTH, 50)
        textView.placeholder = "请填写详细地址"
        textView.delegate = self
        textView.backgroundColor = UIColor.whiteColor()
//        textView.text = "请填写详细地址"
        textView.tag = 10
        textView.delegate = self
        let button = UIButton.init(frame: CGRectMake(0, HEIGHT-118, WIDTH, 50))
        button.setTitle("确定", forState: UIControlState.Normal)
        button.backgroundColor = COLOR
        button.addTarget(self, action: #selector(self.addAddress), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(textView)
        self.view.addSubview(button)
        let button1 = UIButton.init(frame: CGRectMake(WIDTH-125, textView.frame.size.height+textView.frame.origin.y+10, 20, 20))
        button1.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(button1)
        let button2 = UIButton.init(frame: CGRectMake(WIDTH-100, textView.frame.size.height+textView.frame.origin.y+10, 80, 30))
        button2.addTarget(self, action: #selector(self.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button2.setTitle("默认地址", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        self.view.addSubview(button2)
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        self.textView.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    
    func changeCity(notification:NSNotification){
        print(notification)
//        print(notification.object?.valueForKey("cityName"))
        
        let name = notification.object?.valueForKey("cityName") as? String
        self.addressLabe.text = name
//        dataHistoryCitys.addObject(name!);
    }
    
    func goCitySelect(){
        cityController = CityViewController(nibName: "CityViewController", bundle: nil)
//        cityController.delegate = self
        cityController.isNotDingwei = true
        self.navigationController?.pushViewController(cityController, animated: true)
        
        cityController.title = "省份选择"
    }

    func addAddress(){
        if addressLabe.text == "请选择省市区👉" || self.textView.text == nil {
            alert("请正确选择填写地址", delegate: self)
            return
        }
        self.textView.resignFirstResponder()
//        let longtitude = ud.objectForKey("longitude")as!String
//        let latitude = ud.objectForKey("latitude")as!String
//        print(longtitude)
//        print(latitude)
//        let mylongtitude = removeOptionWithString(longtitude)
//        let mylatitude = removeOptionWithString(latitude)
//        print(mylongtitude)
//        print(mylatitude)
        var userid = String()
        if ud.objectForKey("userid") != nil {
             userid = ud.objectForKey("userid")as! String
        }
        
//        let textView = self.view.viewWithTag(10)as!UITextView
        print(textView.text)
//        if textView.text == "添加新地址" {
//            textView.text = ""
//        }
        mainHelper.addAddress(userid, address: addressLabe.text! + self.textView.text!, longitude: "", latitude: "", isdefault: self.isdefault) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            alert("添加成功", delegate: self)
//            let vc = myAddressViewController()
            self.navigationController?.popViewControllerAnimated(true)
//            self.navigationController?.popToViewController(vc, animated: true)
            })
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
