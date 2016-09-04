//
//  ConveniceCell.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol pushDelegate{
    func pushVC(myVC:UIViewController)
}
class ConveniceCell: UITableViewCell{
    static var heighArray = []
    var myPhotoArray = NSMutableArray()
    var myDelegate:pushDelegate?
    
    var boFangButton = UIButton()
    var userImage = UIImageView()
    var userName = UILabel()
    var timeLabel = UILabel()
    var messageButton = UIButton()
    var phone = UIButton()
    //    var phoneStr = String()
    
    var contenLabel = UILabel()
    var picHeight:CGFloat = 0
    var image1 : UIImageView?
    var image2 : UIImageView?
    var image3 : UIImageView?
    var image4 : UIImageView?
    var image5 : UIImageView?
    var image6 : UIImageView?
    var image7 : UIImageView?
    var image8: UIImageView?
    var image9 : UIImageView?
    var info:TCHDInfo?
    let imshow = UIView()
    init (myinfo:commentlistInfo){
         super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "resucell")
        self.sd_addSubviews([userImage,userName,timeLabel,contenLabel])
        userImage.frame = CGRectMake(10, 10, 50, 50)
        userImage.layer.masksToBounds = true
        userImage.cornerRadius = 25
        userImage.backgroundColor = UIColor.redColor()
        if myinfo.photo==nil {
            userImage.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = "http://bang.xiaocool.net/uploads/images/"+myinfo.photo!
            print(photoUrl)
            userImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }
        userName.sd_layout()
            .widthIs(100)
            .heightIs(25)
            .topEqualToView(userImage)
            .leftSpaceToView(userImage,5)
        userName.text = myinfo.name
        userName.textColor = COLOR
        
        timeLabel.sd_layout()
            .widthIs(120)
            .heightIs(35)
            .topSpaceToView(userName,-8)
            .leftSpaceToView(userImage,5)
        timeLabel.text = myinfo.add_time
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.grayColor()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Double(myinfo.add_time!)!)
        timeLabel.text = dateFormatter.stringFromDate(date)
        
        contenLabel.sd_layout()
            .leftSpaceToView(self,10)
            .rightSpaceToView(self,10)
            .topSpaceToView(userImage,10)
            .autoHeightRatio(0)
        contenLabel.text = myinfo.content
        
        
    }
    init(info:TCHDInfo) {
        
        super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "resucell")
        
        self.sd_addSubviews([userImage,userName,timeLabel,messageButton,phone,contenLabel,imshow])
        
        userImage.frame = CGRectMake(10, 10, 50, 50)
        userImage.layer.masksToBounds = true
        userImage.cornerRadius = 25
        userImage.backgroundColor = UIColor.redColor()
        
        if info.photo==nil {
            userImage.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = "http://bang.xiaocool.net/uploads/images/"+info.photo!
            print(photoUrl)
            userImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }
        self.phone.addTarget(self, action: #selector(self.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.info = info
        userName.sd_layout()
            .widthIs(100)
            .heightIs(25)
            .topEqualToView(userImage)
            .leftSpaceToView(userImage,5)
        userName.text = info.name
        userName.textColor = COLOR
        
        timeLabel.sd_layout()
            .widthIs(120)
            .heightIs(35)
            .topSpaceToView(userName,-8)
            .leftSpaceToView(userImage,5)
        timeLabel.text = info.create_time
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.grayColor()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Double(info.create_time!)!)
        timeLabel.text = dateFormatter.stringFromDate(date)
        
        
        phone.sd_layout()
            .rightSpaceToView(self,10)
            .topEqualToView(userImage)
            .widthIs(35)
            .heightIs(35)
        phone.setImage(UIImage.init(named: "ic_dianhua"), forState: UIControlState.Normal)
        
        messageButton.sd_layout()
            .widthIs(35)
            .heightIs(35)
            .rightSpaceToView(phone,0)
            .topEqualToView(phone)
        messageButton.setImage(UIImage.init(named: "ic_xiaoxi-xiao"), forState: UIControlState.Normal)
        
        
        contenLabel.sd_layout()
            .leftSpaceToView(self,10)
            .rightSpaceToView(self,10)
            .topSpaceToView(userImage,10)
            .autoHeightRatio(0)
        contenLabel.text = info.content
        
        var imcount = 0
        for ima in info.pic
        {
            let imview = UIImageView()
            
            imview.tag = imcount+100
            
            let url = Bang_Image_Header+info.pic[imcount].pictureurl!
            
            print(url)
            
            
            imview.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "1.png"))
            
            switch imcount / 3 {
            case 0:
                imview.frame = CGRectMake( CGFloat( imcount ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3, (WIDTH) / 3 - 5 , WIDTH / 3 )
            case 1:
                imview.frame = CGRectMake( CGFloat( imcount-3) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 5, (WIDTH) / 3 - 5 , WIDTH / 3 )
            case 2:
                imview.frame = CGRectMake( CGFloat( imcount-6 ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 10, (WIDTH) / 3 - 5 , WIDTH / 3 )
            default:
                return
            }
            let backButton = UIButton()
            backButton.frame = imview.frame
            backButton.frame.origin.y = imview.frame.origin.y + 98
            backButton.backgroundColor = UIColor.clearColor()
            backButton.tag = imcount
            self.addSubview(backButton)
            backButton .addTarget(self, action:#selector(self.lookImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            
            imshow.addSubview(imview)
            imcount += 1
            myPhotoArray.addObject(imview)
        }
        
        print(info.pic.count)
        
        switch (info.pic.count+2) / 3 {
            
        case 0:
            picHeight = 0
        case 1:
            picHeight = WIDTH / 3
        case 2:
            picHeight = WIDTH / 3 * 2
        default:
            picHeight = WIDTH
        }
        
        if self.info!.record != nil && self.info!.record != "" {
            print(self.info?.record)
            
            if self.info?.pic.count>0 {
                boFangButton = UIButton.init(frame: CGRectMake(20,
                    calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20) + picHeight+20,114, 30))
            }else{
                boFangButton = UIButton.init(frame: CGRectMake(20,
                    80 + calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20)-60,114, 30))
            }
            
            boFangButton.backgroundColor = UIColor.clearColor()
            boFangButton.setTitle(" 点击播放", forState: UIControlState.Normal)
            boFangButton.setBackgroundImage(UIImage(named: "ic_yinpinbeijing"), forState: UIControlState.Normal)
            boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            boFangButton.layer.masksToBounds = true
            //        boFangButton.layer.borderWidth = 1
            //        boFangButton.layer.borderColor = GREY.CGColor
            boFangButton.layer.cornerRadius = 10
            boFangButton.layer.shadowColor = UIColor.blackColor().CGColor
            boFangButton.layer.shadowOffset = CGSizeMake(20.0, 20.0)
            boFangButton.layer.shadowOpacity = 0.7
            imshow.addSubview(boFangButton)
            imshow.frame = CGRectMake(0, 80 + calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20) , WIDTH, picHeight+80)
            
        }else{
            imshow.frame = CGRectMake(0, 80 + calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20) , WIDTH, picHeight)
        }
        
//        if self.info?.pic.count>0 {
//            boFangButton.frame =  CGRectMake(20,
//                80 + calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20) + picHeight+60,114, 30)
//        }else{
//            boFangButton.frame =  CGRectMake(20,
//                calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20)-60,114, 30)
//        }
        
//        imshow.backgroundColor = UIColor.redColor()
        
        
        
    }
    func lookImage(sender:UIButton) {
        
        let myVC = LookPhotoVC()
        myVC.myPhotoArray =  myPhotoArray
        myVC.title = "查看图片"
        myVC.count = sender.tag
        print(sender.tag)
        myDelegate!.pushVC(myVC)
        
    }
    
    
    
    func callPhone(){
        print(self.info?.phone)
        if self.info?.phone == nil || self.info!.phone!.characters.count<0 {
            alert("未发布电话", delegate: self)
            return
        }else{
             UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://"+self.info!.phone!)!)
        }
    
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
