//
//  CashGetViewController.swift
//  51Bang_ios_2016
//
//  Created by Pencil on 16/9/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
class CashGetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

        var myTableView = UITableView()
        var buttonSelect1 = UIButton()
        var buttonSelect2 = UIButton()
        let mainHelper = MainHelper()
        var dataSource = GetUserBankInfo()
        var textField = UITextField()
        var tagButton = Int()
        var banktype = String()
        let mainHelper2 = TCVMLogModel()
        var info = walletInfo()
        override func viewWillAppear(animated: Bool) {
            self.navigationController?.navigationBar.hidden = false
            self.tabBarController?.tabBar.hidden = true
            
            getData()
            getData2()
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.backgroundColor = RGREY
            createView()
            self.navigationController?.navigationBar.topItem?.title = ""
            UIBarButtonItem.appearance() .setTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: UIBarMetrics.Default)
            self.title = "选择提现金额"
        }
        
        func getData(){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.labelText = "正在努力加载"
            let user = NSUserDefaults.standardUserDefaults()
            let userid = user.objectForKey("userid") as! String
            mainHelper.getUserBank(userid) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    hud.hidden = true
                    return
                }
                hud.hidden = true
                self.dataSource = response as! GetUserBankInfo
                self.myTableView.reloadData()
            })
            }
        }
        func getData2(){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.mode = .Text
            hud.labelText = "正在努力加载"
          let ud = NSUserDefaults.standardUserDefaults()
            let uid = ud.objectForKey("userid")as!String
            mainHelper2.getQianBaoData(uid) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
             self.info = response as! walletInfo
             hud.hidden = true
             self.myTableView.reloadData()
                })
         }
        
           }
        
        func createView(){
            myTableView = UITableView.init(frame: CGRectMake(0, 15, WIDTH, 120))
            myTableView.delegate = self
            myTableView.dataSource = self
            myTableView.scrollEnabled = false
            self.view.addSubview(myTableView)
            
            let buttonQueren = UIButton.init(frame: CGRectMake(30, 180, WIDTH-60, 50))
            buttonQueren.setTitle("确认转出", forState: UIControlState.Normal)
            buttonQueren.backgroundColor = COLOR
            buttonQueren.cornerRadius = 10
            buttonQueren.clipsToBounds = true
            buttonQueren.addTarget(self, action: #selector(getCashGo), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(buttonQueren)
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 60
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            if indexPath.row == 0{
                let label = UILabel.init(frame: CGRectMake(15, 5, 80, 60-10))
                label.text = "转出金额"
                
                textField = UITextField.init(frame: CGRectMake(110, 15, 180, 30))
                textField.placeholder = "请输入金额"
                
                let label1 = UILabel.init(frame: CGRectMake(WIDTH-180, 15, 180, 30))
                label1.textAlignment = NSTextAlignment.Right
                if info.availablemoney == nil {
                    label1.text = "余额0.00元"
                }else{
                    label1.text = "余额"+info.availablemoney!+"元"
                }
                label1.textColor = COLOR
                cell.addSubview(label1)
                cell.addSubview(label)
                cell.addSubview(textField)
                
            }else {
                
                let label = UILabel.init(frame: CGRectMake(15, 5, 80, 60-10))
                label.text = "转出帐号"
                
                let label1 = UILabel.init(frame: CGRectMake(110, 15, 180, 30))
                if tagButton == 100{
                    label1.text = dataSource.alipay
                }else if tagButton == 101{
                    label1.text = dataSource.bankno
                }else{
                    
                }
                
                
                cell.addSubview(label1)
                cell.addSubview(label)

            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        
    
        //按钮点击事件
        func getCashGo(){
            
            let user = NSUserDefaults.standardUserDefaults()
            let userid = user.objectForKey("userid") as! String
//            if isbao{
//                banktype = "1"
//            }else{
//                banktype = "2"
//            }
            if tagButton == 100{
                banktype = "1"
            }else{
                banktype = "2"
                 }
            if textField.text != nil {
                if Int(textField.text!) < 100 {
                    alert("提现金额未满100元", delegate: self)
                    return
                }
                if info.availablemoney != nil {
                    if Double(textField.text!) > Double(info.availablemoney!){
                        alert("余额不足", delegate: self)
                        return
                    }
                }else{
                    alert("余额不足", delegate: self)
                    return
                }
                
            }else{
                alert("请输入提现金额", delegate: self)
                return
            }
            
            mainHelper.ApplyWithdraw(userid, money: textField.text!, banktype: banktype) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    alert("提现请求失败", delegate: self)
                    return
                }
                    alert("提现已请求,最迟次日到账", delegate: self)
                self.navigationController?.popViewControllerAnimated(true)
                })
            }
           
        }
}
