//
//  MyFaDanCell.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyFaDanCell: UITableViewCell {
    
    
    private let taskStatu = UILabel()
    private let Middle = UIView()
    private let Bottom = UIView()
    let payBtn = UIButton()
    let timeLabel  = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(model:TaskInfo){
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "MyFaDanCell")
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        Middle.frame = CGRectMake(0, 45, WIDTH, 120)
        Bottom.frame = CGRectMake(0, 170, WIDTH, 40)
        taskStatu.backgroundColor = UIColor.whiteColor()
        Middle.backgroundColor = UIColor.whiteColor()
        Bottom.backgroundColor = UIColor.whiteColor()
        self.addSubview(taskStatu)
        self.addSubview(Middle)
        self.addSubview(Bottom)
        setTop()
        print(model.phone!)
        setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: "无人接单")
        if model.state! == "0" {
            setBottomDan("未付款")
            payBtn.hidden = true
        }else if model.state! == "1"{
            setBottomDan("未抢单")
            payBtn.hidden = true
        }else if model.state! == "2"{
            setBottomDan("已被抢")
        }else if model.state! == "3"{
            setBottomDan("已上门")
        }
        print(model.time)
        if model.time != nil {
            let string = NSString(string:model.time!)
            let dateFormatter = NSDateFormatter()
            let timeSta:NSTimeInterval = string.doubleValue
            dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
//            dateFormatter.timeStyle = .ShortStyle
//            dateFormatter.dateStyle = .ShortStyle
//            let data = dateFormatter.dateFromString(model.time!)
//            print(data)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dateStr = dateFormatter.stringFromDate(date)
            self.timeLabel.text = "发布时间:" + dateStr

        }
        
        
        
////        print(model.apply!.phone)
//        if  model.apply!.phone != nil || model.title == "" {
//            print(model.price!)
//            print(model.apply!.phone!)
//            setMiddle(model.order_num!, Name: "qewr", sMen: model.apply!.phone!, reMen: "12345678")
//            //            setBottom("0")
//        }else{
//            setMiddle(model.order_num!, Name: model.title!, sMen: model.apply!.phone!, reMen: model.apply!.phone!)
        
//        }

        
    }
    
    
    func setTop()
    {
        self.timeLabel.frame = CGRectMake(width/3, 0, width, 40)
        self.timeLabel.textAlignment = NSTextAlignment.Left
        self.timeLabel.textColor = COLOR
        self.timeLabel.backgroundColor = UIColor.whiteColor()
        self.timeLabel.font = UIFont.systemFontOfSize(13)
        taskStatu.text = " "+"未完成"
        taskStatu.textColor = UIColor.orangeColor()
        taskStatu.frame = CGRectMake(0, 0,WIDTH/3, 40)
        self.addSubview(taskStatu)
        self.addSubview(self.timeLabel)
        
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
        startMen.adjustsFontSizeToFitWidth = true
        startMen.frame = CGRectMake(0, 80, WIDTH / 4 - 30, 40)
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
        payMoney.font = UIFont.systemFontOfSize(12)
        payMoney.frame = CGRectMake(0, 0, 130, 40)
        let Tip = UILabel()
        Tip.text = "未完成（请确认付款）"
        Tip.textColor = UIColor.orangeColor()
        Tip.adjustsFontSizeToFitWidth = true
        Tip.frame = CGRectMake(payMoney.width + 10, 0, 130, 40)
        Bottom.addSubview(Tip)
       
        payBtn.frame = CGRectMake(WIDTH - 60, 5,50 , 30)
        payBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        payBtn.setTitle("确认付款", forState: UIControlState.Normal)
        payBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        payBtn.layer.cornerRadius = 10
        payBtn.layer.borderWidth = 1
        payBtn.layer.masksToBounds = true
        payBtn.layer.borderColor = UIColor.orangeColor().CGColor
        Bottom.addSubview(payBtn)
        Bottom.addSubview(payMoney)
    
    }
}
