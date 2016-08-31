//
//  MoneyPack.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
class Wallect: UIViewController {
    private let statuFrame = UIApplication.sharedApplication().statusBarFrame
    private let TopView = UIView()
    private let SecondView = UIView()
    private let thirdView = UIView()
    private let leftMoney = UILabel()
    let mainHelper = TCVMLogModel()
    var info = walletInfo()
    var dataSource = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        
        self.getData()
    }
    
    func getData(){
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as!String
        print(uid)
        mainHelper.getQianBaoData(uid) { (success, response) in
            let myinfo1:walletInfo = response as! walletInfo
            self.info = response as! walletInfo
            print(myinfo1)
            self.dataSource.addObject(myinfo1)
            print(self.info.allincome)
            print(self.info.alltasks)
            self.setTopView()
            self.setSecondView()
            self.setThirdView()
        }
    
    }
    
    
    func setTopView()
    {
        TopView.frame = CGRectMake(0, 0, WIDTH, 180)
        TopView.backgroundColor = COLOR
        self.view.addSubview(TopView)
        let TitileLabel = UILabel()
        
        
        let BackButton = UIButton.init(frame: CGRectMake(5, statuFrame.height + 10, 50,50 ))
        BackButton.setImage(UIImage.init(named: "ic_fanhui-left"), forState: UIControlState.Normal)
        BackButton.setImage(UIImage.init(named: "ic_fanhui-left"), forState: UIControlState.Selected)
        BackButton.addTarget(self, action: #selector(self.backAction), forControlEvents: UIControlEvents.TouchUpInside)
        TopView.addSubview(BackButton)
        
        TitileLabel.text = "钱包"
        TitileLabel.frame = CGRectMake(WIDTH / 2 - 50, statuFrame.height + 10 , 100, 30)
        TitileLabel.textColor = UIColor.whiteColor()
        TitileLabel.adjustsFontSizeToFitWidth = true
        TitileLabel.textAlignment = NSTextAlignment.Center
        TopView.addSubview(TitileLabel)
        
        let dayTip = UILabel()
        dayTip.frame = CGRectMake(5, statuFrame.height + 40 + 70 + 10, 100, 30)
        dayTip.text = "账户余额"
        dayTip.textColor = UIColor.whiteColor()
        dayTip.adjustsFontSizeToFitWidth  = true
        dayTip.font = UIFont.systemFontOfSize(15)
        TopView.addSubview(dayTip)
        
        leftMoney.frame = CGRectMake(5, statuFrame.height + 40 + 10, WIDTH - 5, 60)
        if info.availablemoney == nil {
            leftMoney.text = "0.00"
        }else{
            leftMoney.text = info.availablemoney
        }
//        leftMoney.text = "0.00"
        leftMoney.textColor = UIColor.whiteColor()
        leftMoney.textAlignment = NSTextAlignment.Left
        leftMoney.font = UIFont.systemFontOfSize(35)
        
        
        TopView.addSubview(leftMoney)
    }
    
    func setSecondView(){
    
        SecondView.frame = CGRectMake(0, 180, WIDTH, 110)
        SecondView.backgroundColor = UIColor.whiteColor()
        let label1 = UILabel.init(frame: CGRectMake(10, 10, 100, 20))
        label1.text = "本月接单数"
        let label2 = UILabel.init(frame: CGRectMake(10, 30, 100,30))
        print(info.monthtasks)
        label2.text = info.monthtasks
        let label3 = UILabel.init(frame: CGRectMake(200, 10, 100, 20))
        label3.text = "本月收入"
        let label4 = UILabel.init(frame: CGRectMake(200,30, 100, 30))
        print(info.monthincome)
        label4.text = info.monthincome
        let line = UIView.init(frame: CGRectMake(0, 60, WIDTH, 1))
        line.backgroundColor = RGREY
        let label5 = UILabel.init(frame: CGRectMake(10, 61, 100, 20))
        label5.text = "总单数"
        let label6 = UILabel.init(frame: CGRectMake(10, 81, 100,30))
        label6.text = info.alltasks
        let label7 = UILabel.init(frame: CGRectMake(200, 61, 100, 20))
        label7.text = "总收入"
        let label8 = UILabel.init(frame: CGRectMake(200,81, 100, 30))
        label8.text = info.allincome
        SecondView.addSubview(label1)
        SecondView.addSubview(label2)
        SecondView.addSubview(label3)
        SecondView.addSubview(label4)
        SecondView.addSubview(line)
        SecondView.addSubview(label5)
        SecondView.addSubview(label6)
        SecondView.addSubview(label7)
        SecondView.addSubview(label8)
        self.view.addSubview(SecondView)
    }
    
    func backAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func setThirdView(){
    
        thirdView.frame = CGRectMake(0, 300, WIDTH, 120)
        thirdView.backgroundColor = UIColor.whiteColor()
        let headerImageView1  = UIImageView()
        headerImageView1.frame = CGRectMake(5, (50-17)/2, 18, 17)
        headerImageView1.image = UIImage(named: "ic_wodefadan")
//        headerImageView1.backgroundColor = UIColor.redColor()
        
        let headerImageView2  = UIImageView()
        headerImageView2.frame = CGRectMake(5, (50-17)/2+70, 18, 17)
        headerImageView2.image = UIImage(named: "ic_wodejiedan")
        
        let label1 = UILabel.init(frame: CGRectMake(30, 0, 100, 50))
        label1.text = "收支记录"
        let button1 = UIButton.init(frame: CGRectMake(WIDTH-50, 10, 20, 40))
        button1.setImage(UIImage(named: "ic_arrow_right"), forState: UIControlState.Normal)
        
        let button1Back = UIButton.init(frame: CGRectMake(0, 0, WIDTH, 50))
        button1Back.backgroundColor = UIColor.clearColor()
        button1Back.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        let line = UIView.init(frame: CGRectMake(0, 50, WIDTH, 1))
        line.backgroundColor = RGREY
        let label2 = UILabel.init(frame: CGRectMake(30, 70, 100,50))
        label2.text = "提现记录"
        let button2 = UIButton.init(frame: CGRectMake(WIDTH-50, 70, 20, 40))
        button2.setImage(UIImage(named: "ic_arrow_right"), forState: UIControlState.Normal)
        let button2Back = UIButton.init(frame: CGRectMake(0, 70, WIDTH, 50))
        button2Back.backgroundColor = UIColor.clearColor()
        button2Back.addTarget(self, action: #selector(self.nextView2), forControlEvents: UIControlEvents.TouchUpInside)
//        button2.addTarget(self, action: #selector(self.nextView2), forControlEvents: UIControlEvents.TouchUpInside)
        self.thirdView.addSubview(headerImageView1)
        self.thirdView.addSubview(headerImageView2)
        thirdView.addSubview(label1)
        thirdView.addSubview(button1)
        thirdView.addSubview(line)
        thirdView.addSubview(label2)
        thirdView.addSubview(button2)
        thirdView.addSubview(button1Back)
        thirdView.addSubview(button2Back)
        self.view.addSubview(thirdView)
        
    }
    func nextView(){
        
        let vc = WallectDetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func nextView2(){
    
        let vc = WalletDetail2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}