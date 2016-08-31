//
//  MyBookDanCell.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class MyBookDanCell: UITableViewCell {
    let  showImage = UIImageView()
    let  titleLabel = UILabel()
    let  tipLabel = UILabel()
    let  Price = UILabel()
    let  Statue = UILabel()
    let  Btn = UIButton()
    var idStr = String()
    var sign = Int()
    var targets:UIViewController!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(Data:MyOrderInfo,sign:Int)
    {
        super.init(style: UITableViewCellStyle.Default
            , reuseIdentifier: "MyBookDanCell")
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.sign = sign
        setLayout(Data)
        self.idStr = Data.id!
        
        
    }
    
    func setLayout(Data:MyOrderInfo)
    {
        
        showImage.frame = CGRectMake(5, 5, 100, 90)
        showImage.sd_setImageWithURL(NSURL(string: Data.picture!),placeholderImage: UIImage(named: "01"))
//        showImage.image = Data.DshowImage
        self.addSubview(showImage)
        
        Statue.frame = CGRectMake(WIDTH - 50, 5, 45, 30)
        self.addSubview(Statue)
        Statue.adjustsFontSizeToFitWidth = true
        
//        if(Data.Dflag == 5)
//        {
//            Statue.textColor = UIColor.grayColor()
//            Statue.text = Data.DDistance + "Km"//重用此Cell让状态改为距离用于我收藏界面
//        
//        }else{
        Statue.textColor = COLOR
        if self.sign == 0 {
            Statue.text = "待评价"
            Btn.setTitle("评价", forState: UIControlState.Normal)
            Btn.addTarget(self, action: #selector(MyBookDanCell.Comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }else if self.sign == 1{
            Statue.text = "待付款"
            Btn.setTitle("付款", forState: UIControlState.Normal)
        }else if self.sign == 2{
//            Btn.frame = CGRectMake(WIDTH - 50, tipLabel.frame.origin.y + 30, 55, 30)
            Statue.text = "待消费"
            Btn.setTitle("取消订单", forState: UIControlState.Normal)
            
        }else{
            Statue.text = "待评价"
            Btn.setTitle("评价", forState: UIControlState.Normal)
            Btn.addTarget(self, action: #selector(MyBookDanCell.Comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
//        }
        
        
        
        titleLabel.frame = CGRectMake(showImage.frame.origin.x + 105, 5, WIDTH - (showImage.frame.origin.x + 105) - Statue.frame.width - 10, 30)
        self.addSubview(titleLabel)
        titleLabel.text = Data.goodsname
        
        tipLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + 30, WIDTH - titleLabel.frame.origin.x , 30)
        
//        tipLabel.text = Data.
//        self.addSubview(tipLabel)
        
        
        Btn.frame = CGRectMake(WIDTH - 50, tipLabel.frame.origin.y + 30, 45, 30)
        self.addSubview(Btn)
        Btn.layer.cornerRadius = 10
        Btn.layer.masksToBounds = true
        Btn.layer.borderWidth = 1
        Btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        Btn.layer.borderColor = UIColor.orangeColor().CGColor
        Btn.titleLabel?.font = UIFont.systemFontOfSize(15)
//        Btn.adjustsFontSizeToFitWidth = true
        
        Price.frame = CGRectMake(titleLabel.frame.origin.x,  tipLabel.frame.origin.y + 30, 100, 30)
        Price.text = "￥" + Data.price!
        Price.textColor = UIColor.redColor()
        self.addSubview(Price)
        
        
        
//        switch Data.Dflag {
//        case 1:
//            Btn.setTitle("评价", forState: UIControlState.Normal)
//
//            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
//        case 2:
//            Btn.setTitle("付款", forState: UIControlState.Normal)
//            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
//        case 3:
//            Btn.hidden = true
//        case 4:
//            Btn.setTitle("取消订单", forState: UIControlState.Normal)
//            
//            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
//            let btnFrame = Btn.frame
//            Btn.frame = CGRectMake(btnFrame.origin.x - 20,btnFrame.origin.y, 70, 30)
//        case 5:
//            Btn.setTitle("立即购买", forState: UIControlState.Normal)
//            
//            Btn.addTarget(self, action: #selector(self.imdiaBuy), forControlEvents: UIControlEvents.TouchUpInside)
//            let btnFrame = Btn.frame
//            Btn.frame = CGRectMake(btnFrame.origin.x - 20,btnFrame.origin.y, 70, 30)
//            
//        default:
//            print("没有此button")
//            
//            
//            
//        }
        
        
        
    }
    
    func Comment(button: UIButton)
    {
        print("评价")
        let orderCommentViewController = OrderCommentViewController()
        orderCommentViewController.idStr = self.idStr
        targets.navigationController?.pushViewController(orderCommentViewController, animated: true)
    }
    
    func pay()
    {
        print("付款")
    }
    
    func Cancel()
    {
        print("取消订单")
    }
    
    
    func imdiaBuy()
    {
        print("立即购买")
    }
    
}
