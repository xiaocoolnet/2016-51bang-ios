//
//  SkillselectViewController.swift
//  51Bang_ios_2016
//
//  Created by Pencil on 16/9/26.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class SkillselectViewController: UIViewController,skillProrocol {

    let array = ["跑腿","维修","家政","车辆","兼职","代办","宠物","丽人","婚恋","其他"]
    let headerView = UIView()
    
    var dataSource = Array<SkillModel>()
    var dataSource1 = SkillModel()
    let skillHelper = RushHelper()
    let totalloc:Int = 4
    let textView = PlaceholderTextView()
     var infosss = Array<ClistInfo>()
    let jiNengID = NSMutableArray()
    var skillNum = Int()
    var selectedIndex = Int()
    var taskDescription = String()
    var selectIDArr = NSMutableArray()
    var ischangged = Bool()
    var btn = UIButton()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        let vc = MineViewController()
        vc.Checktoubao()
        GetData()
        self.view.backgroundColor = RGREY
        // Do any additional setup after loading the view.
    }

    func GetData(){
        
        let hud = MBProgressHUD.init()
        hud.animationType = .Zoom
        
        hud.labelText = "正在努力加载"
        
        skillHelper.getSkillList({[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
               
                hud.hide(true)
//                print(response)
                if response != nil{
                    if (response?.isKindOfClass(NSArray)) == true{
                        if (response as! NSArray).count>0{
                            if ((response as! NSArray)[0]).isKindOfClass(SkillModel){
                                self.dataSource = response as? Array<SkillModel> ?? []
                            }else{
                               alert("加载错误", delegate: self)
                            }
                            
                        }else{
                           alert("加载错误", delegate: self)
                        }
                        
                    }else{
                        alert("加载错误", delegate: self)
                    }
                }else{
                    alert("加载错误", delegate: self)
                }
                
                
                
//                print(self.dataSource)
//                print(self.dataSource.count)
                
                if self.ischangged{
                     self.GetData1()
                }else{
                    self.createTableViewHeaderView()
                }
//
                
            })
            })
    }
    
    func GetData1(){
        
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
//                print(self.dataSource)
//                print(self.dataSource.count)
//                print(self.dataSource1.skilllist[0].type)
                for skillSelect in self.dataSource1.skilllist {
                    if !self.jiNengID.containsObject(skillSelect.type!){
                        self.jiNengID.addObject(skillSelect.type!)
                    }
                    
                    
                }
                self.createTableViewHeaderView()
                
            })
        }
    }
    
        
   

    func createTableViewHeaderView(){
//        print(self.dataSource.count)
        let startMargin = (WIDTH - 4 * (WIDTH*80/375) ) / 5
        
        headerView.frame = CGRectMake(0, 0, WIDTH, 250)
        //        view.backgroundColor = UIColor.grayColor()
        let myTableViwWidth = WIDTH
        let margin:CGFloat = (myTableViwWidth-CGFloat(self.totalloc) * WIDTH*95/375)/(CGFloat(self.totalloc)+1);
//        print(margin)
        for i in 0..<self.dataSource.count{
            let row:Int = i / totalloc;//行号
            //1/3=0,2/3=0,3/3=1;
            let loc:Int = i % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+myTableViwWidth/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+WIDTH*40/375) * CGFloat(row)
            let btn = UIButton()
            btn.tag = i+500
            btn.addTarget(self, action: #selector(self.onCLick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //            btn.backgroundColor = UIColor.redColor()
            
            btn.frame = CGRectMake(appviewx + startMargin, appviewy+10, WIDTH*80/375, WIDTH*30/375)
            btn.layer.cornerRadius = WIDTH*10/375
            btn.layer.borderWidth = 1
            btn.layer.borderColor = COLOR.CGColor
            btn.setTitleColor(COLOR, forState: UIControlState.Normal)
            
            let label = UILabel.init(frame: CGRectMake(0, 0, btn.frame.width, btn.frame.height))
            let model = self.dataSource[i]
            
            label.text = model.name
            //            label.text = array[i]
            label.textColor = COLOR
            label.textAlignment = .Center
            btn.addSubview(label)
            headerView.addSubview(btn)
//            for skillAry in self.dataSource {
            if self.dataSource1.skilllist.count != 0 {
                for skill in model.clist {
                    for skillSelect in self.dataSource1.skilllist {
                        if skill.id == skillSelect.type {
                            btn.backgroundColor = COLOR
                            label.textColor = UIColor.whiteColor()
                        }
                    }
                }
            }
            
//            }
            
        }
       
        btn = UIButton(frame: CGRectMake(15, 300, WIDTH-30, 50))
        btn.layer.cornerRadius = 8
        if  self.ischangged {
            btn.setTitle("确认提交", forState: .Normal)
        }else{
            btn.setTitle("下一步", forState: .Normal)
        }
//        btn.setTitle("确认提交", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
//        headerView.frame.size.height = WIDTH*180/375+WIDTH*180/375+10
        self.view.addSubview(headerView)
        
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onCLick(btn:UIButton){
        
        let vc = SkillSubitemViewController()
        let model = self.dataSource[btn.tag-500]
        infosss = model.clist
        vc.jinengID = self.jiNengID
        print(model.name)
        vc.mytitle = model.name
        vc.info = infosss
        vc.index = btn.tag-500
        vc.delegate = self
        self.selectedIndex = btn.tag
        self.presentViewController(vc, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func sendMessage(arr:NSArray){
        
        
        let button = self.view.viewWithTag(self.selectedIndex)as! UIButton
        
        if arr.count == 0  {
            button.backgroundColor = RGREY
            let label =  button.subviews[0]as! UILabel
            label.textColor = COLOR
        }
        
        for ids in self.infosss {
            if  self.jiNengID.containsObject(ids.id!) {
                self.jiNengID.removeObject(ids.id!)
            }
        }
        
        if arr.count != 0 {
            print(self.selectedIndex)
            
            //             let strrr = NSMutableString()
            
            
            for i in 0..<arr.count{
                if !self.jiNengID.containsObject(self.infosss[(arr[i]as! UIButton).tag].id!) {
                    self.jiNengID.addObject(self.infosss[(arr[i]as! UIButton).tag].id!)
                }
                
                
                
            }
            
            print(self.jiNengID)
            //            for str in arr {
            //
            //                strrr = strrr + self.infosss[(str  as! UIButton).tag].name!
            //
            //            }
            self.taskDescription = self.dataSource[self.selectedIndex-500].name!
            //            print(strrr)
            
            //            print(self.type )
            //            self.type = (button.titleLabel?.text)!
            button.backgroundColor = COLOR
            let label =  button.subviews[0]as! UILabel
            label.textColor = UIColor.whiteColor()
        }
        
    }

    func nextToView() {
        let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud1.animationType = .Zoom
        hud1.labelText = "正在努力加载"
        btn.userInteractionEnabled = false
        let types = NSMutableString()
        let ud = NSUserDefaults.standardUserDefaults()
        
        let userid =  ud.objectForKey("userid") as! String
        if loginSign == 0 {//未登陆
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            
//            let userdefault = NSUserDefaults.standardUserDefaults()
            
            
            if  self.ischangged {
                
                for i in 0..<self.jiNengID.count{
                    if i == jiNengID.count-1{
                        types.appendString(jiNengID[i]as! String)
                    }else{
                        types.appendString(jiNengID[i]as! String)
                        types.appendString(",")
                    }
                }
                
                skillHelper.UpdataUserSkill(userid, type: types as String, handle: { (success, response) in
                    if !success{
                        hud1.hide(true)
                        alert("上传失败", delegate: self)
                        self.btn.userInteractionEnabled = true
                        return
                    }
                    hud1.hide(true)
                    self.btn.userInteractionEnabled = true
                    alert("修改成功", delegate: self)
                    self.navigationController?.popViewControllerAnimated(true)
                    return
                })
                
//                alert("正在开发", delegate: self)
                return
            }
            print("立即提交")
            let info = NSUserDefaults.standardUserDefaults()
            let array = info.objectForKey("infomation")as! NSDictionary
            //            print(array)
            //            print(array.count)
            
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            //测试方便，以后打开
            print(array)
            var positive_pic = String()
            var opposite_pic = String()
            var driver_pic = String()
            var city = String()
            var name = String()
            var idcard = String()
            var contactperson = String()
            var contactphone = String()
            if array["positive_pic"] == nil {
                positive_pic = ""
            }else{
                positive_pic = array["positive_pic"] as! String
            }
            if array["opposite_pic"] == nil {
                opposite_pic = ""
            }else{
                opposite_pic = array["opposite_pic"] as! String
            }
            if array["driver_pic"] == nil {
                driver_pic = ""
            }else{
                driver_pic = array["driver_pic"] as! String
            }
            if array["city"] == nil {
                city = ""
            }else{
                city = array["city"] as! String
            }
            if array["name"] == nil {
                name = ""
            }else{
                name = array["name"] as! String
            }
            if array["idcard"] == nil {
                idcard = ""
            }else{
                idcard = array["idcard"] as! String
            }
            if array["contactperson"] == nil {
                contactperson = ""
            }else{
                contactperson = array["contactperson"] as! String
            }
            if array["contactphone"] == nil {
                contactphone = ""
            }else{
                contactphone = array["contactphone"] as! String
            }
            
            
            //            let strrr = NSMutableString()
            for i in 0..<self.jiNengID.count{
                if i == jiNengID.count-1{
                    types.appendString(jiNengID[i]as! String)
                }else{
                    types.appendString(jiNengID[i]as! String)
                    types.appendString(",")
                }
            }
            
            print(types)
            if array.count<6 {
                self.btn.userInteractionEnabled = true
                let alert = UIAlertView.init(title: "温馨提示", message: "请完善信息", delegate: self, cancelButtonTitle: "确定")
                hud1.hide(true)
                alert.show()
            }else{
                print(array)
                
                skillHelper.identityAffirm(userid, city: city, realname:name, idcard: idcard, contactperson: contactperson, contactphone: contactphone, positive_pic:positive_pic, opposite_pic:opposite_pic, driver_pic: driver_pic,types:types as String) { (success, response) in
                    if success{
                        hud1.hide(true)
                        self.btn.userInteractionEnabled = true
                        
                        print(response)
                        //let homepage = RushHomePageViewController()
                        //self.presentViewController(homepage, animated: true, completion: nil)
                        let ud = NSUserDefaults.standardUserDefaults()
                        //                        ud.setObject("no", forKey: "ss")
                        ud.synchronize()
                        
                        if ud.objectForKey("baoxiangrenzheng") != nil{
                            if ud.objectForKey("baoxiangrenzheng") as! String == "yes" {
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }else{
                                let vc = MyInsure()
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }else{
                        hud1.hide(true)
                        self.btn.userInteractionEnabled = true
                        let alert = UIAlertView.init(title: "温馨提示", message: response as? String, delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                    }
                }
                
            }
            
        }
        
    }


}
