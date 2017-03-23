//
//  MyAdvertisementPublishListTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyAdvertisementPublishListTableViewCell: UITableViewCell {
    
    var userImage = UIImageView()
    var userName = UILabel()
    var timeLabel = UILabel()
    var lineView = UIView()
    var imageContentView = UIImageView()
    var moneyLabel = UILabel()
    var urlLabel = UIButton()
    var timeContent = UILabel()
    var payButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    init(myinfo:AdVlistInfo){
         super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "myAdList")
         self.sd_addSubviews([userImage,userName,timeLabel,lineView,imageContentView,moneyLabel,urlLabel,timeContent,payButton])
        
        lineView.backgroundColor = LGBackColor
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        
        userImage.frame = CGRectMake(10, 10, 50, 50)
        userImage.layer.masksToBounds = true
        userImage.cornerRadius = 25
        userImage.backgroundColor = UIColor.redColor()
        if myinfo.photo==nil {
            userImage.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+myinfo.photo!
            print(photoUrl)
            userImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }
        
        userName.sd_layout()
            .widthIs(100)
            .heightIs(25)
            .topEqualToView(userImage)
            .leftSpaceToView(userImage,5)
        if myinfo.name == nil || myinfo.name == "" {
            userName.text = myinfo.realname
        }else{
            userName.text = myinfo.name
        }
        
        userName.textColor = COLOR
        
        timeLabel.sd_layout()
            .widthIs(120)
            .heightIs(35)
            .topSpaceToView(userName,-8)
            .leftSpaceToView(userImage,5)
        timeLabel.text = myinfo.create_time
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.grayColor()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Double(myinfo.create_time!)!)
        timeLabel.text = dateFormatter.stringFromDate(date)
        
        
        payButton.sd_layout()
            .rightSpaceToView(self,10)
            .topEqualToView(userImage)
            .widthIs(60)
            .heightIs(25)
        payButton.setTitle("去支付", forState: .Normal)
        payButton.layer.masksToBounds = true
        payButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        payButton.layer.cornerRadius = 5
        payButton.layer.borderColor = UIColor.orangeColor().CGColor
        payButton.layer.borderWidth = 1
        payButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        
        imageContentView.sd_layout()
        .widthIs(WIDTH-60)
        .heightIs(WIDTH/2-30)
        .leftSpaceToView(self,30)
        .topSpaceToView(userImage,10)
        if myinfo.slide_pic != nil{
            imageContentView.sd_setImageWithURL(NSURL.init(string: Bang_Open_Header+myinfo.slide_pic!), placeholderImage: UIImage(named: ""))
        }
        
        
        urlLabel.sd_layout()
        .heightIs(30)
        .widthIs(width-60)
        .leftEqualToView(imageContentView)
        .topSpaceToView(imageContentView,10)
        if myinfo.slide_url != nil{
            urlLabel.setTitle("跳转网址："+myinfo.slide_url!, forState: .Normal)
            urlLabel.contentHorizontalAlignment = .Left

        }
        urlLabel.setTitleColor(COLOR, forState: .Normal)
        
        moneyLabel.sd_layout()
        .heightIs(30)
        .widthIs(100)
        .topSpaceToView(urlLabel,10)
        .rightSpaceToView(self,30)
        
        if myinfo.price != nil{
            moneyLabel.text = "总价：" + myinfo.price!+"元"
        }
        moneyLabel.textColor = UIColor.blackColor()
        
        
        timeContent.sd_layout()
        .heightIs(30)
        .widthIs(WIDTH-60)
        .topSpaceToView(moneyLabel,10)
        .leftSpaceToView(self,30)
        if myinfo.begintime != nil&&myinfo.endtime != nil{
            let dateFormatter1 = NSDateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let date1 = NSDate(timeIntervalSince1970: Double(myinfo.begintime!)!)
            let date2 = NSDate(timeIntervalSince1970: Double(myinfo.endtime!)!)
            timeContent.text = "广告播放时间:"+dateFormatter1.stringFromDate(date1)+"--"+dateFormatter1.stringFromDate(date2)
        }
        timeContent.textColor = UIColor.blackColor()
        timeContent.font = UIFont.systemFontOfSize(12)
        timeContent.textAlignment = .Right
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
