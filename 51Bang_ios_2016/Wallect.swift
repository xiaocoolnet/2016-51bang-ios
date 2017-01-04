//
//  MoneyPack.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
import MBProgressHUD
class Wallect: UIViewController {
    private let statuFrame = UIApplication.sharedApplication().statusBarFrame
    private let TopView = UIView()
    private let SecondView = UIView()
    private let thirdView = UIView()
    private let leftMoney = UILabel()
    let label2 = UILabel()
    let label4 = UILabel()
    let label6 = UILabel()
    let label8 = UILabel()
    let mainHelper = TCVMLogModel()
    var info = walletInfo()
    var dataSource = NSMutableArray()
    var TixianButton = UIButton()
    var scrollerAll = UIScrollView()
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        self.getData()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
//        self.title = "钱包"
        
        
        scrollerAll = UIScrollView.init(frame: CGRectMake(0, -20, WIDTH, HEIGHT+20))
        scrollerAll.contentSize = CGSize(width: WIDTH, height: scrollerAll.height+100)
        self.view.addSubview(scrollerAll)
        self.setTopView()
        self.setSecondView()
        self.setThirdView()
    }
    
    func getData(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.mode = .Text
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as!String
        print(uid)
        mainHelper.getQianBaoData(uid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            hud.hide(true)
            let myinfo1:walletInfo = response as! walletInfo
                if !success{
                    alert("请求失败", delegate: self)
                    return
                }
            self.info = response as! walletInfo
//            print(myinfo1)
            self.dataSource.addObject(myinfo1)
            if self.info.availablemoney == nil {
                self.leftMoney.text = "0.00"
            }else{
                self.leftMoney.text = self.info.availablemoney
            }
                if self.info.monthtasks != nil{
                    self.label2.text = self.info.monthtasks
                }else{
                    self.label2.text = "0"
                }
                if self.info.alltasks != nil{
                    self.label6.text = self.info.alltasks
                }else{
                    self.label6.text = "0"
                }
            
            
            if self.info.monthincome != nil{
                self.label4.text = self.info.monthincome
            }else{
                self.label4.text = "0.00"
            }
            if self.info.allincome != nil {
                self.label8.text = self.info.allincome
            }else{
                self.label8.text = "0.00"
            }
            
           
            })
        }
    
    }
    
    
    func setTopView()
    {
        TopView.frame = CGRectMake(0, 0, WIDTH, 180 )
        TopView.backgroundColor = COLOR
        self.scrollerAll.addSubview(TopView)
        
        let BackButton = UIButton.init(frame: CGRectMake(5, statuFrame.height, 50,50 ))
        BackButton.setImage(UIImage.init(named: "ic_fanhui-left"), forState: UIControlState.Normal)
        BackButton.setImage(UIImage.init(named: "ic_fanhui-left"), forState: UIControlState.Selected)
        BackButton.addTarget(self, action: #selector(self.backAction), forControlEvents: UIControlEvents.TouchUpInside)
        TopView.addSubview(BackButton)

        let wallect = UILabel()
        wallect.frame = CGRectMake(WIDTH/2 - 40 , statuFrame.height, 80,50 )
        wallect.text = "我的钱包"
        wallect.textColor = UIColor.whiteColor()
        wallect.adjustsFontSizeToFitWidth  = true
        wallect.font = UIFont.systemFontOfSize(25)
        TopView.addSubview(wallect)

        
        let dayTip = UILabel()
        dayTip.frame = CGRectMake(WIDTH/2-50, statuFrame.height + 40 + 70 + 10 , 100, 30)
        dayTip.text = "账户余额"
        dayTip.textColor = UIColor.whiteColor()
        dayTip.adjustsFontSizeToFitWidth  = true
        dayTip.font = UIFont.systemFontOfSize(15)
        dayTip.textAlignment = NSTextAlignment.Center
        TopView.addSubview(dayTip)
        
        leftMoney.frame = CGRectMake(5, statuFrame.height + 40 + 10 , WIDTH - 5, 60)
        if info.availablemoney == nil {
            leftMoney.text = "0.00"
        }else{
            leftMoney.text = info.availablemoney
        }
//        leftMoney.text = "0.00"
        leftMoney.textColor = UIColor.whiteColor()
        leftMoney.textAlignment = NSTextAlignment.Center
        leftMoney.font = UIFont.systemFontOfSize(35)
        
        
        TopView.addSubview(leftMoney)
    }
    
    func setSecondView(){
    
        SecondView.frame = CGRectMake(0, 180 , WIDTH, 110)
        SecondView.backgroundColor = UIColor.whiteColor()
        let label1 = UILabel.init(frame: CGRectMake(10+20, 10, 100, 20))
        label1.text = "本月接单数"
        label2.frame = CGRectMake(10+20, 30, 100,30)
        print(info.monthtasks)
        label2.text = info.monthtasks
        let label3 = UILabel.init(frame: CGRectMake(200, 10, 100, 20))
        label3.text = "本月收入"
        label4.frame = CGRectMake(200,30, 100, 30)
        print(info.monthincome)
        if info.monthincome != nil{
            label4.text = info.monthincome
        }else{
            label4.text = "0.00"
        }
        let line = UIView.init(frame: CGRectMake(0, 60, WIDTH, 1))
        line.backgroundColor = RGREY
        let label5 = UILabel.init(frame: CGRectMake(10+20, 61, 100, 20))
        label5.text = "总单数"
        label6.frame =  CGRectMake(10+20, 81, 100,30)
        label6.text = info.alltasks
        let label7 = UILabel.init(frame: CGRectMake(200, 61, 100, 20))
        label7.text = "总收入"
        label8.frame = CGRectMake(200,81, 100, 30)
        if info.allincome != nil {
            label8.text = info.allincome
        }else{
            label8.text = "0.00"
        }
        
        SecondView.addSubview(label1)
        SecondView.addSubview(label2)
        SecondView.addSubview(label3)
        SecondView.addSubview(label4)
        SecondView.addSubview(line)
        SecondView.addSubview(label5)
        SecondView.addSubview(label6)
        SecondView.addSubview(label7)
        SecondView.addSubview(label8)
        self.scrollerAll.addSubview(SecondView)
    }
    
//    func backAction()
//    {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    
    func setThirdView(){
    
        thirdView.frame = CGRectMake(0, 300, WIDTH, 120+120)
        thirdView.backgroundColor = UIColor.whiteColor()
        let headerImageView1  = UIImageView()
        headerImageView1.frame = CGRectMake(30, (50-17)/2+5, 18, 17)
        headerImageView1.image = UIImage(named: "ic_wodefadan")
        
//        headerImageView1.backgroundColor = UIColor.redColor()
        let label1 = UILabel.init(frame: CGRectMake(30+25, 0+5, 100, 50))
        label1.text = "收支记录"
        let button1 = UIButton.init(frame: CGRectMake(WIDTH-40, 10, 20, 40))
        button1.setImage(UIImage(named: "ic_arrow_right"), forState: UIControlState.Normal)
        
        let button1Back = UIButton.init(frame: CGRectMake(0, 0, WIDTH, 60))
        button1Back.backgroundColor = UIColor.clearColor()
        button1Back.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        let line = UIView.init(frame: CGRectMake(0, 60, WIDTH, 1))
        line.backgroundColor = RGREY
        
        
        let headerImageView2  = UIImageView()
        headerImageView2.frame = CGRectMake(30, (50-17)/2+70-5, 18, 17)
        headerImageView2.image = UIImage(named: "ic_wodejiedan")
        let label2 = UILabel.init(frame: CGRectMake(30+25, 70-5, 100,50))
        label2.text = "提现记录"
        let button2 = UIButton.init(frame: CGRectMake(WIDTH-40, 70, 20, 40))
        button2.setImage(UIImage(named: "ic_arrow_right"), forState: UIControlState.Normal)
        let button2Back = UIButton.init(frame: CGRectMake(0, 60, WIDTH, 60))
        button2Back.backgroundColor = UIColor.clearColor()
        button2Back.addTarget(self, action: #selector(self.nextView2), forControlEvents: UIControlEvents.TouchUpInside)
        
        let line1 = UIView.init(frame: CGRectMake(0, 120, WIDTH, 1))
        line1.backgroundColor = RGREY
        let headerImageView3  = UIImageView()
        headerImageView3.frame = CGRectMake(30, (50-17)/2+70-5+60, 18, 17)
        headerImageView3.image = UIImage(named: "ic_bangdingyinhangka")
        let label3 = UILabel.init(frame: CGRectMake(30+25, 70-5+60, 120,50))
        label3.text = "绑定提现账户"
        let button3 = UIButton.init(frame: CGRectMake(WIDTH-40, 70+60, 20, 40))
        button3.setImage(UIImage(named: "ic_arrow_right"), forState: UIControlState.Normal)
        let button3Back = UIButton.init(frame: CGRectMake(0, 60+60, WIDTH, 60))
        button3Back.backgroundColor = UIColor.clearColor()
        button3Back.addTarget(self, action: #selector(self.nextView3), forControlEvents: UIControlEvents.TouchUpInside)
        
        let line2 = UIView.init(frame: CGRectMake(0, 120+60, WIDTH, 1))
        line2.backgroundColor = RGREY
        let headerImageView5  = UIImageView()
        headerImageView5.frame = CGRectMake(30, (50-17)/2+70-5+120, 18, 17)
        headerImageView5.image = UIImage(named: "nextuser")
        
        let label5 = UILabel.init(frame: CGRectMake(30+25, 70-5+60+60, 120,50))
        label5.text = "我的业务"
        let button5 = UIButton.init(frame: CGRectMake(WIDTH-40, 70+60+60, 20, 40))
        button5.setImage(UIImage(named: "ic_arrow_right"), forState: UIControlState.Normal)
        let button5Back = UIButton.init(frame: CGRectMake(0, 60+60+60, WIDTH, 60))
        button5Back.backgroundColor = UIColor.clearColor()
        button5Back.addTarget(self, action: #selector(self.nextView4), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        TixianButton = UIButton.init(frame: CGRectMake(WIDTH/2 - 50, 470+60+60, 100, 40))
        TixianButton.backgroundColor = COLOR
        TixianButton.setTitle("提现", forState: UIControlState.Normal)
        TixianButton.clipsToBounds = true
        TixianButton.layer.cornerRadius = 8
        TixianButton.layer.masksToBounds = true
        TixianButton.addTarget(self, action: #selector(self.Tixian), forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollerAll.addSubview(TixianButton)
        let TixianXiangJieButton = UIButton.init(frame: CGRectMake(WIDTH/2 - 100, 520+60+60 , 200, 40))
        TixianXiangJieButton.backgroundColor = RGREY
        TixianXiangJieButton.setTitle("欲了解提现详解请点击此处", forState: UIControlState.Normal)
        TixianXiangJieButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        TixianXiangJieButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        TixianXiangJieButton.addTarget(self, action: #selector(self.TixianXiangJie), forControlEvents: UIControlEvents.TouchUpInside)
        self.scrollerAll.addSubview(TixianXiangJieButton)
        
//        button2.addTarget(self, action: #selector(self.nextView2), forControlEvents: UIControlEvents.TouchUpInside)
        self.thirdView.addSubview(headerImageView1)
        self.thirdView.addSubview(headerImageView2)
        thirdView.addSubview(headerImageView3)
        thirdView.addSubview(headerImageView5)
        
        thirdView.addSubview(line)
        thirdView.addSubview(line1)
        thirdView.addSubview(line2)
        thirdView.addSubview(label1)
        thirdView.addSubview(label2)
        thirdView.addSubview(label3)
        thirdView.addSubview(label5)
        thirdView.addSubview(button1)
        thirdView.addSubview(button2)
        thirdView.addSubview(button3)
        thirdView.addSubview(button5)
        thirdView.addSubview(button1Back)
        thirdView.addSubview(button2Back)
        thirdView.addSubview(button3Back)
        thirdView.addSubview(button5Back)
        self.scrollerAll.addSubview(thirdView)
        
    }
    
    func TixianXiangJie(){
        let vc = JiaoChengViewController()
        vc.sign = 4
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func Tixian(){
        let vc = GetCashViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func nextView(){
        
        let vc = WallectDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func nextView2(){
    
        let vc = WalletDetail2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func nextView3(){
        
        let vc = WalletDetail3ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func nextView4(){
        
        let vc = FriendListViewController()
        vc.isNextGrade = true
        vc.title = "我的业务"
        self.navigationController?.pushViewController(vc, animated: true)
//        alert("程序员在玩命建设ing...", delegate: self)
    }
    
    
    
    
    func backAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}