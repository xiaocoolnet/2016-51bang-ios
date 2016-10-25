//
//  GetCashViewController.swift
//  51Bang_ios_2016
//
//  Created by Pencil on 16/9/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class GetCashViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var myTableView = UITableView()
    var buttonSelect1 = UIButton()
    var buttonSelect2 = UIButton()
    var buttonSelect3 = UIButton()
    let mainHelper = MainHelper()
    var dataSource = GetUserBankInfo()
    var tagButton = Int()
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
       
        getData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择提现账户"
        
        self.view.backgroundColor = RGREY
        createView()
        
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
    
    func createView(){
        myTableView = UITableView.init(frame: CGRectMake(0, 15, WIDTH, 120))
//            myTableView = UITableView.init(frame: CGRectMake(0, 15, WIDTH, 180))
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.scrollEnabled = false
        self.view.addSubview(myTableView)
        
        let buttonQueren = UIButton.init(frame: CGRectMake(30, 220, WIDTH-60, 50))
        buttonQueren.setTitle("确认", forState: UIControlState.Normal)
        buttonQueren.backgroundColor = COLOR
        buttonQueren.cornerRadius = 10
        buttonQueren.clipsToBounds = true
        buttonQueren.addTarget(self, action: #selector(getCashGo), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonQueren)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
//            return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.row == 0{
            let imageView = UIImageView.init(frame: CGRectMake(15, 10, 60-20, 60-20))
            imageView.image = UIImage.init(named: "ic_zhifubao")
            
            let label = UILabel.init(frame: CGRectMake(75, 8, 80, 30))
            label.text = "支付宝"
            
            let button = UIButton.init(frame: CGRectMake(65+10, 35, 100, 20))
            button.titleLabel?.textAlignment = NSTextAlignment.Left
            if dataSource.alipay != nil {
                if dataSource.alipay == "" {
                    button.setTitle("[未绑定]", forState: UIControlState.Normal)
                }else{
                    button.setTitle(dataSource.alipay, forState: UIControlState.Normal)
                }
            }else{
                button.setTitle("[未绑定]", forState: UIControlState.Normal)
            }
            
            button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.titleLabel?.textAlignment = NSTextAlignment.Left
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.addTarget(self, action: #selector(zhifubaoGo), forControlEvents: UIControlEvents.TouchUpInside)
            
            buttonSelect1 = UIButton.init(frame: CGRectMake(WIDTH-50, 15, 30, 30))
            buttonSelect1.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
            buttonSelect1.addTarget(self, action: #selector(selectGo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            buttonSelect1.tag = tagButton
            cell.addSubview(imageView)
            cell.addSubview(label)
            cell.addSubview(button)
            cell.addSubview(buttonSelect1)
            
        }else if indexPath.row == 1{
            
                let imageView = UIImageView.init(frame: CGRectMake(15, 10, 60-20, 60-20))
                imageView.image = UIImage.init(named: "yinhangka")
                
                let label = UILabel.init(frame: CGRectMake(75, 8, 80, 30))
                label.text = "银行卡"
                
                let button = UIButton.init(frame: CGRectMake(65+10, 35, 100, 20))
                button.titleLabel?.textAlignment = NSTextAlignment.Left  
                if dataSource.bank != nil {
                   if dataSource.bank == "" {
                    button.setTitle("[未绑定]", forState: UIControlState.Normal)
                    }else{
                       button.setTitle(dataSource.bank, forState: UIControlState.Normal)
                    }
                }else{
                    button.setTitle("[未绑定]", forState: UIControlState.Normal)
            }
            
                button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                button.titleLabel?.font = UIFont.systemFontOfSize(12)
                button.titleLabel?.textAlignment = NSTextAlignment.Left
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
                button.addTarget(self, action: #selector(bank), forControlEvents: UIControlEvents.TouchUpInside)

            
                buttonSelect2 = UIButton.init(frame: CGRectMake(WIDTH-50, 15, 30, 30))
                buttonSelect2.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
                buttonSelect2.addTarget(self, action: #selector(selectGo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                tagButton = 101
                buttonSelect2.tag = tagButton
                cell.addSubview(imageView)
                cell.addSubview(label)
                cell.addSubview(button)
                cell.addSubview(buttonSelect2)
        }else {
            
            let imageView = UIImageView.init(frame: CGRectMake(15, 10, 60-20, 60-20))
            imageView.image = UIImage.init(named: "ic_weixin-1")
            
            let label = UILabel.init(frame: CGRectMake(75, 8, 80, 30))
            label.text = "微信"
            
            let button = UIButton.init(frame: CGRectMake(65+10, 35, 100, 20))
            if dataSource.bank != nil {
                if dataSource.bank == "" {
                    button.setTitle("[未绑定]", forState: UIControlState.Normal)
                }else{
                    button.setTitle(dataSource.bank, forState: UIControlState.Normal)
                }
            }else{
                button.setTitle("[未绑定]", forState: UIControlState.Normal)
            }
            
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.titleLabel?.textAlignment = NSTextAlignment.Left
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            
            buttonSelect3 = UIButton.init(frame: CGRectMake(WIDTH-50, 15, 30, 30))
            buttonSelect3.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect3.addTarget(self, action: #selector(selectGo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            tagButton = 102
            buttonSelect3.tag = tagButton
            cell.addSubview(imageView)
            cell.addSubview(label)
            cell.addSubview(button)
            cell.addSubview(buttonSelect3)
        }
        tagButton = 100
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            tagButton = 100
            buttonSelect1.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
            buttonSelect2.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect3.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
        case 1:
            tagButton = 101
            buttonSelect1.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect2.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
            buttonSelect3.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
        case 2:
            tagButton = 102
            buttonSelect1.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect2.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect3.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
        default:
            break
        }

    }
    
    //按钮点击事件
    func zhifubaoGo(){
        if dataSource.alipay != nil{
            if dataSource.alipay == "" {
                let vc = zhifubaoBandViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
               alert("已绑定支付宝", delegate: self)
            }
        }else{
            alert("网络环境差，请稍等", delegate: self)
        }

        
    }
    
    func bank(){
        if dataSource.bank != nil{
            if dataSource.bank == "" {
                let vc = BankBandViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                alert("已绑定支付宝", delegate: self)
            }
        }else{
            alert("网络环境差，请稍等", delegate: self)
        }
        
    }
    
    func selectGo(sendtag:UIButton){
        switch sendtag.tag {
        case 100:
            buttonSelect1.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
            buttonSelect2.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect3.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            tagButton = 100
        case 101:
            buttonSelect1.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect2.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
            buttonSelect3.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            tagButton = 101
        case 102:
            buttonSelect1.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect2.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
            buttonSelect3.setImage(UIImage.init(named: "ic_xuanze"), forState: UIControlState.Normal)
            tagButton = 102
        default: break
            
        }
        
    }

    func getCashGo(sendtag:UIButton){
        sendtag.tag = tagButton
        print(sendtag.tag)
        if sendtag.tag == 100  {
            if dataSource.alipay != nil{
                 if dataSource.alipay == "" {
                 alert("未绑定支付宝", delegate: self)
                 }else{
                 let vc = CashGetViewController()
                    vc.tagButton = self.tagButton
                 self.navigationController?.pushViewController(vc, animated: true)
                 
                 }
            }else{
                alert("网络环境差，请稍等", delegate: self)
            }
        }else  if sendtag.tag == 101{
            if dataSource.bank != nil{
                if dataSource.bank == "" {
                    alert("未绑定银行卡", delegate: self)
                }else{
                    let vc = CashGetViewController()
                    vc.tagButton = self.tagButton
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }else{
                alert("网络环境差，请稍等", delegate: self)
            }
            
        }
       
        
    }
}
