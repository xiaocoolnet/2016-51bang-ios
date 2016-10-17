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
    var myButton = UIButton()
    var modell = TaskInfo()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(model:TaskInfo){
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "MyFaDanCell")
        self.modell = model
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        Middle.frame = CGRectMake(0, 42, WIDTH, 120)
        Bottom.frame = CGRectMake(0, 164, WIDTH, 40)
        taskStatu.backgroundColor = UIColor.whiteColor()
        Middle.backgroundColor = UIColor.whiteColor()
        Bottom.backgroundColor = UIColor.whiteColor()
        self.addSubview(taskStatu)
        self.addSubview(Middle)
        self.addSubview(Bottom)
        setTop()
        print(model.phone!)
        
        print(model.apply?.phone)
        
        if model.apply != nil && model.apply != "" && model.phone != nil {
            
            if model.apply?.name != nil && model.apply?.name != ""{
                
                setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: (model.apply?.name)!)
            }else if model.phone != nil && model.apply?.phone != nil && model.apply?.name == nil  {
                setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: (model.apply?.phone!)!)
                
            }else{
                setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: "无人接单")
            }
        }else if model.phone != nil && model.apply?.phone != nil {
            setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: (model.apply?.phone!)!)
        }else if model.phone != nil && model.apply?.name == nil && model.apply?.phone == nil{
            setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: "无人接单")
        }
        else{
           setMiddle(model.order_num!, Name: model.title!, sMen: model.phone!, reMen: "无人接单")
        }
        
        if model.state! == "0" {
            setBottomDan("未开始")
            payBtn.hidden = true
        }else if model.state! == "1"{
            if self.modell.paystatus != nil {
                if self.modell.paystatus! == "0"{
                    setBottomDan("未抢单")
                    payBtn.hidden = false
                }else{
                    setBottomDan("未抢单")
                    payBtn.hidden = true
                }
            }else{
                setBottomDan("未抢单")
                payBtn.hidden = true
            }
            
        }else if model.state! == "2"{
            setBottomDan("已被抢")
        }else if model.state! == "3"{
            setBottomDan("已上门")
        }else if model.state! == "4"{
            setBottomDan("等待付款")
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
        
        let taskName = AutoScrollLabel()
        
        taskName.labelSpacing = 30 // distance between start and end labels
//        taskName.font = UIFont.systemFontOfSize(15)
        taskName.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        taskName.scrollSpeed = 30 // pixels per second
        taskName.fadeLength = 12
        taskName.scrollDirection = AutoScrollDirection.Left
        
        
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
        rmenNum.frame = CGRectMake(WIDTH * 3  / 4 - 30, 80, WIDTH / 4 + 30, 40)
        rmenNum.textColor = UIColor.blueColor()
        if reMen == "无人接单" {
            rmenNum.text = reMen
        }else{
           
            let str1 = NSMutableAttributedString(string: reMen)
            let range1 = NSRange(location: 0, length: str1.length)
            let number = NSNumber(integer:NSUnderlineStyle.StyleSingle.rawValue)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
            str1.addAttribute(NSUnderlineStyleAttributeName, value: number, range: range1)
            str1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range1)
            rmenNum.attributedText = str1
        }
//        rmenNum.text = reMen
        

        rmenNum.adjustsFontSizeToFitWidth = true
        myButton = UIButton.init(frame: rmenNum.frame)
        myButton.backgroundColor = UIColor.clearColor()
//        myButton.addTarget(self, action: #selector(self.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
        Middle.addSubview(rmenNum)
        Middle.addSubview(myButton)
        
    }
    
//    func callPhone(){
//        if modell.apply != nil && modell.apply != "" {
//            if modell.apply?.phone != nil && modell.apply?.phone != ""{
//                let  aaaa = modell.apply?.phone!
//                UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://" + aaaa! )!)
//                
//            }
//        }
    
        
//    }
    
    
    func setBottomDan(Money:String)
    {
        
        let payMoney = UILabel()
        payMoney.text = " 订单状态："+Money
        payMoney.font = UIFont.systemFontOfSize(12)
        payMoney.frame = CGRectMake(0, 0, 130, 40)
        let Tip = UILabel()
        if self.modell.paystatus != nil {
            if self.modell.paystatus! == "0"{
                Tip.text = "支付未托管"
                payBtn.hidden = false
            }else{
                Tip.text = "支付已托管"
            }
        }else{
            Tip.text = "支付已托管"
        }
        
        
        Tip.textColor = UIColor.orangeColor()
        Tip.font = UIFont.systemFontOfSize(13)
        Tip.adjustsFontSizeToFitWidth = true
        Tip.frame = CGRectMake(payMoney.width + 10, 0, 130, 40)
        Bottom.addSubview(Tip)
       
        payBtn.frame = CGRectMake(WIDTH - 80, 5,70 , 30)
        payBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        
        if self.modell.paystatus != nil {
            if self.modell.paystatus! == "0"{
                payBtn.setTitle("支付托管", forState: UIControlState.Normal)
            }else{
                payBtn.setTitle("确认付款", forState: UIControlState.Normal)
            }
        }else{
            payBtn.setTitle("确认付款", forState: UIControlState.Normal)
        }
        
        
        payBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        payBtn.layer.cornerRadius = 10
        payBtn.layer.borderWidth = 1
        payBtn.layer.masksToBounds = true
        payBtn.layer.borderColor = UIColor.orangeColor().CGColor
        Bottom.addSubview(payBtn)
        Bottom.addSubview(payMoney)
    
    }
}
