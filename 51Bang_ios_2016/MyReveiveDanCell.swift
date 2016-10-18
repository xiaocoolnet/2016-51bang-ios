//
//  ReveiveCell.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyReceiveDanCell: UITableViewCell{
    let topView = UIView()
    let middleView = UIView()
    let bottomView = UIView()
    
   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    init(Data:TaskInfo)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "MyReceiveDanCell")
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        topView.frame = CGRectMake(0, 0, WIDTH, 40)
        middleView.frame = CGRectMake(0, 40, WIDTH, 90)
        bottomView.frame = CGRectMake(0, 120, WIDTH, 50)
        self.addSubview(topView)
        self.addSubview(middleView)
        self.addSubview(bottomView)
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, 2))
        view.backgroundColor = COLOR
        self.addSubview(view)
        
        let timLabel = UILabel.init(frame: CGRectMake(WIDTH - 100, 0, 95, 40))
        timLabel.textColor = UIColor.grayColor()
        timLabel.adjustsFontSizeToFitWidth = true
        timLabel.text = Data.time
        if Data.time != "" || Data.time != nil{
            let str = timeStampToString(Data.time!)
            timLabel.text = str
            //            self.desc.text = str+"前有效"
        }
        topView.addSubview(timLabel)
        let taNum = UILabel.init(frame: CGRectMake(10, 0, WIDTH - 100 , 40))
        taNum.text = " 订单号" + Data.order_num!
        topView.addSubview(taNum)
        
        let taName = UILabel.init(frame: CGRectMake(10, 0, WIDTH, 30))
        if Data.title! == "" {
            taName.text = ""
        }else{
            taName.text = " " + Data.description!
        }
        
        taName.textColor = UIColor.grayColor()
        middleView.addSubview(taName)
        
        let addImage = UIImageView()
        addImage.image = UIImage.init(named: "ic_fuwudidian")
        addImage.frame = CGRectMake(10, 35, 15,15)
        middleView.addSubview(addImage)
        
        let addressLabel = UILabel()
        addressLabel.text = Data.address!
        addressLabel.textColor = UIColor.grayColor()
        addressLabel.frame = CGRectMake(35, 30, WIDTH - 35, 30)
        middleView.addSubview(addressLabel)
        
        let fuwuPay = UILabel.init(frame: CGRectMake(10, 0, 100, 20))
        fuwuPay.text = " 服务费"
        fuwuPay.textColor = UIColor.grayColor()
        fuwuPay.textAlignment = NSTextAlignment.Left
        bottomView.addSubview(fuwuPay)
        
        
        let Price = UILabel.init(frame: CGRectMake(10, 20, 100, 30))
        Price.text = " ￥" + Data.price!
        Price.textColor = UIColor.redColor()
        Price.textAlignment = NSTextAlignment.Left
        Price.adjustsFontSizeToFitWidth = true
        bottomView.addSubview(Price)
        
        let tipStatue = UILabel.init(frame: CGRectMake(130, 0, 100, 20))
        tipStatue.text = "支付类型"
        tipStatue.textColor  = UIColor.grayColor()
        bottomView.addSubview(tipStatue)
        
        let KindPay = UILabel.init(frame: CGRectMake(130, 20, 100, 30))
        KindPay.text = "线下支付"
        KindPay.textColor = UIColor.orangeColor()
        KindPay.adjustsFontSizeToFitWidth = true
        bottomView.addSubview(KindPay)
        
    
        let stat = UILabel.init(frame: CGRectMake(WIDTH - 55, 0, 45, 20))
        stat.text = "订单状态"
        stat.textColor = UIColor.grayColor()
        stat.textAlignment  = NSTextAlignment.Left
        stat.adjustsFontSizeToFitWidth = true
        bottomView.addSubview(stat)
        let ST = UILabel.init(frame: CGRectMake(WIDTH - 55, 20,45, 30))
        ST.textColor = COLOR
//        ST.text = "已抢单"
        if Data.state! == "2" {
           ST.text = "已抢单"
        }else if Data.state! == "3"{
            ST.text = "已上门"
        }else if Data.state! == "4"{
            ST.text = "请求付款"
        }else if Data.state! == "5"{
            ST.text = "已付款"
        }else if Data.state! == "-1"{
            ST.text = "已取消"
        }
        ST.adjustsFontSizeToFitWidth = true
        bottomView.addSubview(ST)
        
    }
    
}
