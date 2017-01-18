//
//  MyDingDanXiangQingViewController.swift
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/9/7.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyDingDanXiangQingViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ChangeWordDelegate{
    
    var sign = Int()
    var isDingdan = Bool()
    var citynameStr = String()
    let myTableView = TPKeyboardAvoidingTableView()
    let textField = UITextField()
    var remark = String()
    let addButton = UIButton()
    let deleteButton = UIButton()
    let mainHelper = MainHelper()
    var num = 1
    var info = MyOrderInfo()
    var isSigle = Bool()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        self.title = "订单详情"
        if info.address == nil {
            citynameStr = "请选择地址👉"
        }else{
            citynameStr = info.address!
        }
        
        self.createTableView()
        print(self.info.state)
        print(self.info.delivery)
        if self.info.state! == "3" && !isSigle && self.info.tracking != nil {
            let juanma = UILabel()
            juanma.frame = CGRectMake(0, 10, WIDTH-20, 50)
            
            juanma.text = "您的卷码为"+self.info.tracking!
            juanma.textAlignment = NSTextAlignment.Center
            juanma.textColor = COLOR
            juanma.layer.masksToBounds = true
            juanma.layer.cornerRadius = 10
            juanma.layer.borderColor = COLOR.CGColor
            juanma.layer.borderWidth = 1
            
            self.myTableView.tableFooterView = juanma
            
        }
        
        if self.info.state! == "2" && !isSigle && self.info.tracking != nil {
            let juanma = UILabel()
            juanma.frame = CGRectMake(0, 10, WIDTH-20, 50)
            
            juanma.text = "您的卷码为"+self.info.tracking!
            juanma.textAlignment = NSTextAlignment.Center
            juanma.textColor = COLOR
            juanma.layer.masksToBounds = true
            juanma.layer.cornerRadius = 10
            juanma.layer.borderColor = COLOR.CGColor
            juanma.layer.borderWidth = 1
            
            self.myTableView.tableFooterView = juanma
            
        }
        
//        if self.info.state! == "2" && isSigle {
//            
//        }
        
        
        if "0" == "2"{
            let juanma = UIButton()
            print(WIDTH)
            print(self.myTableView.frame.width)
            juanma.frame = CGRectMake(10, 10, WIDTH-80, 50)
            juanma.layer.masksToBounds = true
//            juanma.layer.cornerRadius = 10
//            juanma.layer.borderColor = COLOR.CGColor
//            juanma.layer.borderWidth = 1
            juanma.backgroundColor = COLOR
            juanma.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            juanma.setTitle("已消费", forState: UIControlState.Normal)
            juanma.addTarget(self, action: #selector(self.yiXiaofei), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.myTableView.tableFooterView = juanma
            self.myTableView.tableFooterView?.frame = CGRectMake(0, 0, WIDTH, 50)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func yiXiaofei(){
        mainHelper.gaiBianDingdan(self.info.order_num!, state: "4") { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success{
                alert("数据请求失败请重试", delegate: self)
                return
            }
            self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
    
    func createTableView(){
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
//        myTableView.sectionFooterHeight = 10
        myTableView.backgroundColor = RGREY
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.registerNib(UINib(nibName: "FabuTableViewCell3",bundle: nil), forCellReuseIdentifier: "peisong")
        myTableView.registerNib(UINib(nibName: "FabuTableViewCell1",bundle: nil), forCellReuseIdentifier: "address")
        myTableView.registerNib(UINib(nibName: "CNEETableViewCell",bundle: nil), forCellReuseIdentifier: "CNEE")
        myTableView.registerNib(UINib(nibName: "LiuYanTableViewCell",bundle: nil), forCellReuseIdentifier: "LiuYan")
        myTableView.registerNib(UINib(nibName: "MothedTableViewCell",bundle: nil), forCellReuseIdentifier: "Mothed")
        //        myTableView.registerNib(UINib(nibName: "FabuTableViewCell1",bundle: nil), forCellReuseIdentifier: "address")
        self.view.addSubview(myTableView)
        
        let view = UIView.init(frame: CGRectMake(0,myTableView.height-50, WIDTH, 50))
        view.backgroundColor = UIColor.whiteColor()
        
        let delete = UIButton.init(frame: CGRectMake(0, 0, 100, 50))
        delete.setTitle("取消订单", forState:UIControlState.Normal)
        delete.addTarget(self, action: #selector(self.Cancel), forControlEvents: UIControlEvents.TouchUpInside)
        delete.backgroundColor = UIColor.orangeColor()
        if !isSigle {
            view.addSubview(delete)
        }
        
        
        
        let submit = UIButton.init(frame: CGRectMake(WIDTH-100, 0, 100, 50))
        submit.setTitle("提交订单", forState:UIControlState.Normal)
        submit.addTarget(self, action: #selector(self.goToBuy), forControlEvents: UIControlEvents.TouchUpInside)
        submit.backgroundColor = UIColor.orangeColor()
        view.addSubview(submit)
        if self.info.state == "1" && !isSigle{
            self.view.addSubview(view)
        }
        if self.info.state == "2" && isSigle && self.info.delivery == "送货上门"{
            submit.setTitle("已发货", forState:UIControlState.Normal)
            self.view.addSubview(view)
        }
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if info.time != nil{
                return 4
            }else{
                return 3
            }
            
        }else if section == 0{
            return 2
        }else{
            
            return 3
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return nil
        }else{
            let view2 = UIView.init(frame: CGRectMake(0, 0, WIDTH-20, 10))
            view2.backgroundColor = RGREY
            return view2
        }
        
    }
    
    
    func changeWord(string:String){
        citynameStr = "地址：" + string
        self.myTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                cell.selectionStyle = .None
                let ud = NSUserDefaults.standardUserDefaults()
                var name = String()
                if ud.objectForKey("name") != nil {
                    name = ud.objectForKey("name")as!String
                }
//                let name = ud.objectForKey("name")as!String
                if isDingdan {
                    if info.username != nil {
                        cell.name.text = info.username! as String
                    }else{
                        cell.name.text = info.mobile! as String
                    }
                    
                }else{
                    cell.name.text = name
                }
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                let ud = NSUserDefaults.standardUserDefaults()
                let phone = ud.objectForKey("phone")as!String
                cell.CNEE.text = "联系电话"
                cell.selectionStyle = .None
                if isDingdan {
                    if info.mobile != nil {
                        cell.name.text = info.mobile! as String
                    }else{
                        cell.name.text = ""
                    }
                    
                }else{
                    cell.name.text = phone
                }
//                cell.name.text = phone
                return cell
            }
            //            else{
            //                let cell = tableView.dequeueReusableCellWithIdentifier("address")as! FabuTableViewCell1
            //                cell.selectionStyle = .None
            //                cell.title.text = "收获地址"
            //                let textField = UITextField.init(frame: CGRectMake(80, cell.title.frame.origin.y, 200, cell.title.frame.size.height))
            //                textField.center = cell.title.center
            //                textField.placeholder = "请选择收获地址"
            ////                cell.addSubview(textField)
            //
            //                return cell
            //            }
        }else if indexPath.section == 1{
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                cell.CNEE.text = self.info.goodsname
                cell.name.text = "¥"+self.info.price!
                //                cell.name.textColor = UIColor.orangeColor()
                cell.selectionStyle = .None
                return cell
            }else if indexPath.row == 1{
                
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                cell.CNEE.text = "数量"
                cell.selectionStyle = .None
                //                cell.name.text = "103.3元"
                textField.frame = CGRectMake(WIDTH-50, 10, 30, cell.CNEE.frame.size.height)
                textField.borderStyle = .Line
                
                textField.text = self.info.number!
                addButton.frame = CGRectMake(textField.frame.origin.x+32, 10, 20, cell.CNEE.frame.size.height)
                //                addButton.backgroundColor = UIColor.redColor()
                addButton.setTitle("加", forState: UIControlState.Normal)
                addButton.setImage(UIImage(named: "ic_jia-lv"), forState: UIControlState.Normal)
                addButton.addTarget(self, action: #selector(self.add), forControlEvents: UIControlEvents.TouchUpInside)
                deleteButton.frame = CGRectMake(textField.frame.origin.x-20, 10, 20, cell.CNEE.frame.size.height)
                deleteButton.addTarget(self, action:#selector(self.deleteNum), forControlEvents: UIControlEvents.TouchUpInside)
                //                deleteButton.backgroundColor = UIColor.redColor()
                deleteButton.setTitle("减", forState: UIControlState.Normal)
                deleteButton.setImage(UIImage(named: "ic_jian-lv"), forState: UIControlState.Normal)
                //                textField.leftView = deleteButton
                //                textField.rightView = addButton
                cell.name.hidden = true
                cell.addSubview(textField)
                textField.userInteractionEnabled = false
                if self.info.state == "100" {//暂时不考虑对订单进行修改
                    cell.addSubview(deleteButton)
                    cell.addSubview(addButton)
                    textField.userInteractionEnabled = true
                }
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                cell.CNEE.text = "小计"
                cell.selectionStyle = .None
                let num = Int(self.textField.text!)
                let price = Float(num!)*Float(self.info.price!)!
                cell.name.text = String(price)
                cell.name.tag = 99
                cell.name.textColor = UIColor.orangeColor()
                return cell
            }
            
        }else{
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Mothed")as! MothedTableViewCell
                if self.info.delivery != nil && self.info.delivery != ""{
                    cell.typeLabel.text = self.info.delivery
                }else{
                    cell.typeLabel.text = ""
                }
                //                cell.title.frame.origin.y = 20
                //                cell.mode.frame.origin.y = 20
                //                cell.selectionStyle = .None
                //                cell.bottomLabel.removeFromSuperview()
                return cell
                
            }else if indexPath.row == 1{
                let cell = myTableView.dequeueReusableCellWithIdentifier("LiuYan")as! LiuYanTableViewCell
                cell.liuyan.tag = 10
                cell.liuyan.text = self.info.remarks!
                cell.liuyan.delegate = self
                cell.selectionStyle = .None
                tableView.separatorStyle = .None
                //                cell.title.text = "买家留言"
                //                cell.mode.removeFromSuperview()
                //                cell.title.frame.origin.y = 20
                //                cell.mode.frame.origin.y = 20
                //                cell.selectionStyle = .None
                //                cell.bottomLabel.removeFromSuperview()
                return cell
            }else if indexPath.row == 2{
                let cell  = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell4")
                cell.selectionStyle = .None
//                if self.info.state == "1"{
//                    cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator;
//                }
                
                cell.textLabel?.text = citynameStr
                return cell
                
            }else {
                let cell  = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell4")
                cell.selectionStyle = .None
                cell.textLabel?.text = "下单时间："+timeStampToString(info.time!)
                return cell
            }
            
        }
        //        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            if indexPath.row == 0{
                let next = BusnissViewController()
                if self.info.gid != nil {
                    next.id = self.info.gid! as String
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
            }
        }
//        if self.info.state == "1"{
//            if indexPath.section == 2 && indexPath.row == 2 {
//                let vc = myAddressViewController()
//                vc.isDingdan = true
//                vc.delegate = self
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
//        }
                if indexPath.section == 3{
            if indexPath.row == 1{
                (self.view.viewWithTag(10)as! UITextField).resignFirstResponder()
                
            }
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
        let offset:CGFloat = 100
        UIView.animateWithDuration(0.4, animations: {
            if offset > 0{
                self.myTableView.frame.origin.y = -offset
            }
            
        })
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.myTableView.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let offset:CGFloat = 100
        UIView.animateWithDuration(0.4, animations: {
            if offset > 0{
                self.myTableView.frame.origin.y = -offset
            }
            
        })
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.remark = textField.text!
        self.myTableView.frame.origin.y = 0
        
    }
    
    func add(){
        
        num = Int(self.textField.text!)!
        //        if num > 0 || num<100 {
        //            print(num)
        self.textField.text = String(num+1)
        let xiaoji = self.view.viewWithTag(99)as! UILabel
        let price = Float(self.textField.text!)! * Float(self.info.price!)!
        xiaoji.text = String(price)
        //            if num > 0 {
        //                self.addButton.enabled = true
        //            }
        //            if num > 100 {
        //                self.addButton.enabled = false
        //            }
        //
        //        }
        
    }
    
    func deleteNum(){
        
        //        addButton.setImage(UIImage(named: "ic_jia-hui"), forState: UIControlState.Normal)
        //        deleteButton.setImage(UIImage(named: "ic_jian-lv"), forState: UIControlState.Normal)
        num = Int(self.textField.text!)!
        self.deleteButton.enabled = true
        print(num)
        if num > 1 {
            //            self.deleteButton.enabled = true
            print(num)
            self.textField.text = String(num-1)
            let xiaoji = self.view.viewWithTag(99)as! UILabel
            let price = Float(self.textField.text!)! * Float(self.info.price!)!
            xiaoji.text = String(price)
            
            //            if num < 100 {
            //                self.deleteButton.enabled = true
            //            }
            
            
        }else{
            self.textField.text = String(num)
            let alert = UIAlertView(title: "提示", message: "数量不能少于1", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    
    func Cancel()
    {
                
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "您确定要取消订单吗？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                
                                                
                                                //                let ud = NSUserDefaults.standardUserDefaults()
                                                //                let userid = ud.objectForKey("userid")as! String
                                                self.mainHelper.gaiBianDingdan(self.info.order_num!, state: "-1") { (success, response) in
                                                    dispatch_async(dispatch_get_main_queue(), {
                                                    if !success {
                                     alert("订单取消失败请重试", delegate: self)
                                                        return
                                                        
                                                        
                                                       
                                                        
                                                    }
                                      self.navigationController?.popViewControllerAnimated(true)
                                                    })
                                                }
                                                
                                                
                                                
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
}
            
    
        
        


    
    
    func goToBuy(){
        
        if self.info.state == "2" && isSigle  {
            mainHelper.gaiBianDingdan(self.info.order_num!, state: "3", handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    alert("提交失败请重试！", delegate: self)
                    return
                }
                alert("已通知买家！", delegate: self)
                self.navigationController?.popViewControllerAnimated(true)
                })
            })
        }else{
            let textview  = self.myTableView.viewWithTag(10) as!UITextField
            textview.resignFirstResponder()
            
            let vc = PayViewController()
            
            vc.numForGoodS = self.info.order_num!
            let xiaoji = self.view.viewWithTag(99)as! UILabel
            print(xiaoji)
            print(xiaoji.text!)
            vc.price = ((xiaoji.text)! as NSString).doubleValue
            vc.subject = self.info.goodsname!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
