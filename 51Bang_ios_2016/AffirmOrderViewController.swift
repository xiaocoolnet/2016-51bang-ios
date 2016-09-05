//
//  AffirmOrderViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class AffirmOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let myTableView = TPKeyboardAvoidingTableView()
    let textField = UITextField()
    let addButton = UIButton()
    let deleteButton = UIButton()
    var num = 1
    var info = GoodsInfo2()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        self.title = "确认订单"
        self.createTableView()
        // Do any additional setup after loading the view.
    }
    
    func createTableView(){
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
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
        
        let view = UIView.init(frame: CGRectMake(0,myTableView.height-50-49-20+5, WIDTH, 50))
        view.backgroundColor = UIColor.whiteColor()
        let submit = UIButton.init(frame: CGRectMake(WIDTH-100, 0, 100, 50))
        submit.setTitle("提交订单", forState:UIControlState.Normal)
        submit.addTarget(self, action: #selector(self.goToBuy), forControlEvents: UIControlEvents.TouchUpInside)
        submit.backgroundColor = UIColor.orangeColor()
        view.addSubview(submit)
        self.view.addSubview(view)
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        }else if section == 0{
            return 2
        }else{
            
            return 3
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return nil
        }else{
            let view2 = UIView.init(frame: CGRectMake(0, 0, WIDTH, 10))
            view2.backgroundColor = RGREY
            return view2
        }
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                cell.selectionStyle = .None
                let ud = NSUserDefaults.standardUserDefaults()
                let name = ud.objectForKey("name")as!String
                cell.name.text = name
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("CNEE")as! CNEETableViewCell
                let ud = NSUserDefaults.standardUserDefaults()
                let phone = ud.objectForKey("phone")as!String
                cell.CNEE.text = "联系电话"
                cell.selectionStyle = .None
                cell.name.text = phone
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
                cell.CNEE.text = "自助烤肉"
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
                
                textField.text = "1"
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
                cell.name.removeFromSuperview()
                cell.addSubview(textField)
                cell.addSubview(deleteButton)
                cell.addSubview(addButton)
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
                }
                //                cell.title.frame.origin.y = 20
                //                cell.mode.frame.origin.y = 20
                //                cell.selectionStyle = .None
                //                cell.bottomLabel.removeFromSuperview()
                return cell
                
            }else{
                let cell = myTableView.dequeueReusableCellWithIdentifier("LiuYan")as! LiuYanTableViewCell
                cell.liuyan.tag = 10
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
            }
            
        }
        //        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    func goToBuy(){
        
        let vc = PayViewController()
        let xiaoji = self.view.viewWithTag(99)as! UILabel
        print(xiaoji)
        print(xiaoji.text!)
        vc.price = ((xiaoji.text)! as NSString).doubleValue
        vc.subject = self.info.goodsname!
        vc.body = self.info.description!
        self.navigationController?.pushViewController(vc, animated: true)
        print(myTableView.height)
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
