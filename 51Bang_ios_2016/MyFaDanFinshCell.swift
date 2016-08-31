//
//  MyFaDanCell.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyFaDanFinshCell: UITableViewCell {
    
    
    private let taskStatu = UILabel()
    private let Middle = UIView()
    private let Bottom = UIView()
    let pingjia = UIButton()
    var vc = UINavigationController()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(model:TaskInfo){
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "MyFaDanCell")
        self.userInteractionEnabled = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        taskStatu.frame = CGRectMake(0, 0, WIDTH,40 )
        Middle.frame = CGRectMake(0, 45, WIDTH, 120)
        Bottom.frame = CGRectMake(0, 170, WIDTH, 40)
        taskStatu.backgroundColor = UIColor.whiteColor()
        Middle.backgroundColor = UIColor.whiteColor()
        Bottom.backgroundColor = UIColor.whiteColor()
        self.addSubview(taskStatu)
        self.addSubview(Middle)
        self.addSubview(Bottom)
        setTop()
        setMiddle(model.order_num!, Name: model.title! ,sMen: "12345678", reMen: "12345678")
        setBottomDan(model.price!)
//        if  model.apply?.phone == nil || model.title == "" {
//            print(model.price!)
//             setMiddle(model.order_num!, Name: "qewr", sMen: "12345678", reMen: "12345678")
////            setBottom("0")
//        }else{
//            
////            print(model.apply?.phone!)
//            
//            
//            setMiddle(model.order_num!, Name: model.title!, sMen: "12345", reMen: "21345")
////            setBottom(model.price!)
//        }
        
    }
    func getna(na:UINavigationController){
    
        self.vc = na
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let vc = PingJiaViewController()
        self.vc.pushViewController(vc, animated: true)
    }
    
    func setTop()
    {
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, 40))
        view.userInteractionEnabled = true
        view.backgroundColor = UIColor.whiteColor()
        
        taskStatu.text = " 已完成"
        taskStatu.textColor = COLOR
        taskStatu.frame = CGRectMake(0, 0,80, 40)
        pingjia.frame = CGRectMake(WIDTH-60, 0, 50, 40)
        pingjia.setTitle("评价", forState: UIControlState.Normal)
        pingjia.backgroundColor = UIColor.whiteColor()
        pingjia.setTitleColor(COLOR, forState: UIControlState.Normal)
        pingjia.addTarget(self, action: #selector(self.goPingJia), forControlEvents: UIControlEvents.TouchUpInside)
//        pingjia.backgroundColor = UIColor.redColor()
        view.addSubview(taskStatu)
//        self.addSubview(taskStatu)
        view.addSubview(pingjia)
//        view.bringSubviewToFront(pingjia)
        self.userInteractionEnabled = true
        self.addSubview(view)
//        self.addSubview(pingjia)
        
    }
    
    func goPingJia(){
        
        let vc = PingJiaViewController()
        self.vc.pushViewController(vc, animated: true)
        
    }
    
    
    func setMiddle(Num:String,Name:String,sMen:String,reMen:String)
    {
        let taskNum = UILabel()
        taskNum.text = " 任务号："+Num
        taskNum.frame = CGRectMake(0, 0, WIDTH, 40)
        Middle.addSubview(taskNum)
        let taskName = UILabel()
        taskName.text = " " + Name
        taskName.frame = CGRectMake(0, 40, WIDTH, 40)
        Middle.addSubview(taskName)
        let startMen = UILabel()
        startMen.text = " 发起人:"
        startMen.frame = CGRectMake(0, 80, WIDTH / 4 - 30, 40)
        startMen.adjustsFontSizeToFitWidth = true
        Middle.addSubview(startMen)
        let smenNum = UILabel()
        smenNum.text = sMen
        smenNum.frame = CGRectMake(WIDTH / 4 - 30, 80, WIDTH / 4 + 30, 40)
        smenNum.textColor = UIColor.blueColor()
        smenNum.adjustsFontSizeToFitWidth = true
        Middle.addSubview(smenNum)
        let receiveMen = UILabel()
        receiveMen.text = "接单人:"
        receiveMen.adjustsFontSizeToFitWidth = true
        receiveMen.frame = CGRectMake(WIDTH * 2 / 4, 80, WIDTH / 4 - 30, 40)
        Middle.addSubview(receiveMen)
        let rmenNum = UILabel()
        rmenNum.text = reMen
        rmenNum.frame = CGRectMake(WIDTH * 3  / 4 - 30, 80, WIDTH / 4 + 30, 40)
        rmenNum.textColor = UIColor.blueColor()
        rmenNum.adjustsFontSizeToFitWidth = true
        Middle.addSubview(rmenNum)
        
    }
    
    func setBottomDan(Money:String)
    {
       
        let payMoney = UILabel()
        payMoney.text = " 支付状态："+Money
        payMoney.frame = CGRectMake(0, 0, 130, 40)
        let Tip = UILabel()
        Tip.text = "已完成支付"
        Tip.textColor = UIColor.orangeColor()
        Tip.adjustsFontSizeToFitWidth = true
        Tip.frame = CGRectMake(130, 0, 130, 40)
        Bottom.addSubview(Tip)
        let payBtn = UIButton()
        payBtn.frame = CGRectMake(WIDTH - 60, 5,50 , 30)
        payBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        payBtn.setTitle("确认付款", forState: UIControlState.Normal)
        payBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        payBtn.layer.cornerRadius = 10
        payBtn.layer.borderWidth = 1
        payBtn.layer.masksToBounds = true
        payBtn.layer.borderColor = UIColor.orangeColor().CGColor
//        Bottom.addSubview(payBtn)
        Bottom.addSubview(payMoney)
//        Bottom.addSubview(Tip)
        
    }
}

