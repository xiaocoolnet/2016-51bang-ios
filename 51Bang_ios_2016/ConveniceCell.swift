//
//  ConveniceCell.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AVKit

protocol pushDelegate{
    func pushVC(myVC:UIViewController)
}
class ConveniceCell: UITableViewCell{
    static var heighArray = []
    var myPhotoArray = NSMutableArray()
    var myDelegate:pushDelegate?
    let backView = UIView()
    var boFangButton = UIButton()
    var userImage = UIImageView()
    var userImageBackButton = UIButton()
    var userName = UILabel()
    var timeLabel = UILabel()
    var messageButton = UIButton()
    var phone = UIButton()
    var deletebutton = UIButton()
    var accountnumberButton = UIButton()
    var predicate = NSPredicate()
    var openButton = UIButton()
    var openButtonBackView = UIView()
    var closeButton = UIButton()
    var boFangMp4Button = UIButton()
    var targets = UIViewController()
    
    var lineView = UIView()
    
    
    var audioSession = AVAudioSession.sharedInstance()
    
    //    var phoneStr = String()
    
    var contenLabel = CopyLabel()
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
    var info:TCHDInfo? = nil
    var info1:commentlistInfo? = nil
    var photoArray = NSMutableArray()
    let imshow = UIView()
    init (myinfo:commentlistInfo){
        self.info1 = myinfo
         super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "resucell")
        self.sd_addSubviews([userImage,userName,timeLabel,contenLabel,backView,lineView,userImageBackButton])
        
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
//            userImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
            userImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"), completed: { (image, error, type, user) in
                self.photoArray.addObject(self.userImage)
            })
        }
        userImageBackButton.frame = userImage.frame
        userImageBackButton.backgroundColor = UIColor.clearColor()
        userImageBackButton.addTarget(self, action: #selector(self.userImageBackButtonAction), forControlEvents: .TouchUpInside)
        userName.sd_layout()
            .widthIs(100)
            .heightIs(25)
            .topEqualToView(userImage)
            .leftSpaceToView(userImage,5)
        if myinfo.name == nil || myinfo.name == "" {
            userName.text = myinfo.username
        }else{
            userName.text = myinfo.name
        }
        
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
        
        
        
        backView.backgroundColor = UIColor.whiteColor()
        backView.sd_layout()
            .widthIs(WIDTH+2)
            .heightIs(40)
            .leftSpaceToView(self,-1)
//            .rightSpaceToView(self,10)
            .bottomSpaceToView(self,-1)
        backView.layer.masksToBounds =  true
        backView.layer.borderWidth = 1
        backView.layer.borderColor = COLOR.CGColor
        var count = Int()
        count = 1
        if myinfo.score != nil {
            count = Int(myinfo.score!)!
        }
        
        let myLabel = UILabel()
        myLabel.frame = CGRectMake(10, 0, 55, 40)
        myLabel.text = "积分:"
        myLabel.backgroundColor = UIColor.whiteColor()
        myLabel.textColor = COLOR
        myLabel.font = UIFont.systemFontOfSize(15)
        backView.addSubview(myLabel)
        
        
        for  index in 0...count-1 {
            let imageView = UIImageView.init(frame: CGRectMake(70+CGFloat(index*40), 5, 24, 24))
            imageView.image = UIImage(named: "ic_yellowstar_quan")
            backView.addSubview(imageView)
        }
        for index in 0...5-count  {
            let imageView = UIImageView.init(frame: CGRectMake(70+CGFloat((5-index-1)*40), 5, 24, 24))
            imageView.image = UIImage(named: "ic_yellow_bian")
            backView.addSubview(imageView)
        }
        self.addSubview(backView)
        
        
        
    }
    init(info:TCHDInfo) {
        
        super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "resucell")
        
        self.sd_addSubviews([userImage,userName,timeLabel,messageButton,phone,deletebutton,accountnumberButton,contenLabel,imshow,lineView,userImageBackButton])
        
        userImage.frame = CGRectMake(10, 10, 50, 50)
        userImage.layer.masksToBounds = true
        userImage.cornerRadius = 25
        userImage.backgroundColor = UIColor.redColor()
        
        userImageBackButton.frame = userImage.frame
        userImageBackButton.backgroundColor = UIColor.clearColor()
        userImageBackButton.addTarget(self, action: #selector(self.userImageBackButtonAction), forControlEvents: .TouchUpInside)
        
        lineView.backgroundColor = LGBackColor
        lineView.sd_layout()//添加约束
            .widthIs(WIDTH)
            .heightIs(1)
            .leftSpaceToView(self,0)
            .bottomSpaceToView(self,0)
        
        if info.photo==nil {
            userImage.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.photo!
//            print(photoUrl)
//            userImage.sd_setImageWithURL(<#T##url: NSURL!##NSURL!#>, placeholderImage: <#T##UIImage!#>, completed: <#T##SDWebImageCompletionBlock!##SDWebImageCompletionBlock!##(UIImage!, NSError!, SDImageCacheType, NSURL!) -> Void#>)
            userImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"), completed: { (image, error, type, user) in
                self.photoArray.addObject(self.userImage)
            })
            
        }
        
        
        
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
        
        deletebutton.sd_layout()
            .widthIs(35)
            .heightIs(35)
            .rightSpaceToView(messageButton,0)
            .topEqualToView(messageButton)
        deletebutton.setImage(UIImage.init(named: "ic_delete"), forState: UIControlState.Normal)
        
        accountnumberButton.sd_layout()
            .widthIs(35)
            .heightIs(35)
            .rightSpaceToView(messageButton,0)
            .topEqualToView(messageButton)
        accountnumberButton.setImage(UIImage.init(named: "ic_jubao"), forState: UIControlState.Normal)
        
        
        
        
//        var regex:String?
//        regex = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
        
//        predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
//        print(predicate)
//        let flags = predicate.evaluateWithObject(contenLabel.text! as NSString)
//        if flags{
//            print("..........................")
//        }
        
        var imcount = 0
        for ima in info.pic
        {
            let imview = UIImageView()
            
            imview.tag = imcount+100
            if imcount > 8 {
                break
            }
            
            
            let url = Bang_Image_Header+info.pic[imcount].pictureurl!
            
            print(url)
            
            
            imview.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "01.png"))
            
            if info.pic.count == 1{
                imview.frame = CGRectMake( 60 , 10, (WIDTH-120) , (WIDTH-120))
                imview.contentMode = .ScaleAspectFit
            }else{
                switch imcount / 3 {
                case 0:
                    imview.frame = CGRectMake( CGFloat( imcount ) * (WIDTH-60) / 3 + 40  , ( CGFloat (imcount / 3) ) * (WIDTH-60) / 3+15, (WIDTH) / 3 - 30 , WIDTH / 3-30)
                case 1:
                    imview.frame = CGRectMake( CGFloat( imcount-3) * (WIDTH-60) / 3 + 40  , ( CGFloat (imcount / 3) ) * (WIDTH-60) / 3+15 , (WIDTH) / 3 - 30 , WIDTH / 3-30 )
                case 2:
                    imview.frame = CGRectMake( CGFloat( imcount-6 ) * (WIDTH-60) / 3 + 40  , ( CGFloat (imcount / 3) ) * (WIDTH-60) / 3 + 15, (WIDTH) / 3 - 30 , WIDTH / 3 - 30 )
                default:
                    return
                }

            }
            if imcount == info.pic.count-1 && info.video != nil && info.video != ""{
                
                self.boFangMp4Button.addTarget(self, action: #selector(self.boFangMp4ButtonAction), forControlEvents: .TouchUpInside)
                if info.pic.count == 1{
                    self.boFangMp4Button.frame = CGRectMake((WIDTH-120)/2-30, (WIDTH-120)/2-30, 60, 60)
                    self.boFangMp4Button.setImage(UIImage(named:"ic_bofang1" ), forState: .Normal)
                }else{
                    self.boFangMp4Button.frame = CGRectMake((WIDTH / 3-30)/2-12, (WIDTH / 3-30)/2-12, 24, 24)
                    self.boFangMp4Button.setImage(UIImage(named:"ic_bofang" ), forState: .Normal)
                }
                
                imview.addSubview(self.boFangMp4Button)
            }
            
//            imview.contentMode = .Redraw
                        let backButton = UIButton()
            backButton.frame = imview.frame
//            backButton.backgroundColor = UIColor.redColor()
            backButton.frame.origin.y = imview.frame.origin.y
            backButton.backgroundColor = UIColor.clearColor()
            backButton.tag = imcount
           
            backButton .addTarget(self, action:#selector(self.lookImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            
            imshow.addSubview(imview)
            imshow.addSubview(backButton)
            imcount += 1
            myPhotoArray.addObject(imview)
        }
        imshow.backgroundColor = UIColor.whiteColor()
        if info.pic.count == 1{
            picHeight = WIDTH-120
        }else{
            switch (info.pic.count+2) / 3 {
                
            case 0:
                picHeight = 0
            case 1:
                picHeight = (WIDTH-80) / 3
            case 2:
                picHeight = (WIDTH-80) / 3 * 2
            default:
                picHeight = WIDTH-80
            }
        }
        
        
        var str = String()
        contenLabel.text = info.content
        contenLabel.font = UIFont.systemFontOfSize(15)
        if contenLabel.text != nil {
            str = contenLabel.text!
        }else{
            str = ""
        }
        var testHeight = calculateHeight( str, size: 15, width: WIDTH - 20)
        print(testHeight)
        if testHeight>95{
            if info.isOpen! == false{
                testHeight = 90 + 30
                openButtonBackView.frame = CGRectMake(0, 90+70, WIDTH, 30)
                openButtonBackView.backgroundColor = UIColor.whiteColor()
                openButton.frame = CGRectMake(20, 0, 60, 30)
                let str1 = NSMutableAttributedString.init(string: "全文")
                str1.addAttribute(NSUnderlineStyleAttributeName, value: 0x01, range: NSRange.init(location: 0, length: str1.length))
                str1.addAttribute(NSForegroundColorAttributeName, value: COLOR, range: NSRange.init(location: 0, length: str1.length))
                openButton.setAttributedTitle(str1, forState: .Normal)
                openButton.setTitleColor(COLOR, forState: .Normal)
                openButton.titleLabel?.font = UIFont.systemFontOfSize(15)
                openButtonBackView.addSubview(openButton)
                self.addSubview(openButtonBackView)
                contenLabel.sd_layout()
                    .leftSpaceToView(self,10)
                    .widthIs(WIDTH-20)
//                    .autoHeightRatio(0)
                    .topSpaceToView(userImage,10)
                    .heightIs(90)
                contenLabel.numberOfLines = 0
                contenLabel.lineBreakMode = .ByWordWrapping
                contenLabel.text = info.content
                contenLabel.font = UIFont.systemFontOfSize(15)
            }else{
                contenLabel.sd_layout()
                    .leftSpaceToView(self,10)
                    .rightSpaceToView(self,10)
                    .topSpaceToView(userImage,10)
                    .autoHeightRatio(0)
                contenLabel.text = info.content
                contenLabel.font = UIFont.systemFontOfSize(15)
                testHeight = calculateHeight( str, size: 15, width: WIDTH - 20)+40
                closeButton.frame = CGRectMake(WIDTH-70, testHeight+35, 40, 30)
                let str1 = NSMutableAttributedString.init(string: "收起")
                str1.addAttribute(NSUnderlineStyleAttributeName, value: 0x01, range: NSRange.init(location: 0, length: str1.length))
                str1.addAttribute(NSForegroundColorAttributeName, value: COLOR, range: NSRange.init(location: 0, length: str1.length))
                closeButton.setAttributedTitle(str1, forState: .Normal)

                closeButton.setTitle("收起", forState: .Normal)
                closeButton.setTitleColor(COLOR, forState: .Normal)
                closeButton.titleLabel?.font = UIFont.systemFontOfSize(15)
                self.addSubview(closeButton)
            }
            
        }else{
            contenLabel.sd_layout()
                .leftSpaceToView(self,10)
                .rightSpaceToView(self,10)
                .topSpaceToView(userImage,10)
                .autoHeightRatio(0)
            contenLabel.text = info.content
            contenLabel.font = UIFont.systemFontOfSize(15)
        }
        
        if self.info!.record != nil && self.info!.record != "" {
            print(self.info?.record)
            
            if self.info?.pic.count>0 {
                boFangButton = UIButton.init(frame: CGRectMake(20,
                    testHeight + picHeight+20,114, 30))
            }else{
                boFangButton = UIButton.init(frame: CGRectMake(20,
                    80 + testHeight-60,114, 30))
            }
            
            boFangButton.backgroundColor = UIColor.clearColor()
            if info.soundtime != nil&&info.soundtime != ""{
                boFangButton.setTitle((info.soundtime! as String + "\""), forState: UIControlState.Normal)
            }else{
                boFangButton.setTitle("0" + "\"", forState: UIControlState.Normal)
            }
            
            boFangButton.setBackgroundImage(UIImage(named: "ic_yuyino3"), forState: UIControlState.Normal)
            boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            boFangButton.layer.masksToBounds = true
            //        boFangButton.layer.borderWidth = 1
            //        boFangButton.layer.borderColor = GREY.CGColor
            boFangButton.layer.cornerRadius = 10
            boFangButton.layer.shadowColor = UIColor.blackColor().CGColor
            boFangButton.layer.shadowOffset = CGSizeMake(20.0, 20.0)
            boFangButton.layer.shadowOpacity = 0.7
            imshow.addSubview(boFangButton)
            imshow.frame = CGRectMake(0, 70 + testHeight , WIDTH, picHeight+80)
            
        }else{
            
            imshow.frame = CGRectMake(0, 70 + testHeight , WIDTH, picHeight)
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
        
        if sender.tag == info!.pic.count-1 && info!.video != nil && info!.video != ""{
            if let urls = NSURL.init(string: Bang_Image_Header+(info?.video!)! ){
                let player = AVPlayer(URL: urls)
                let playerController = AVPlayerViewController()
                playerController.player = player
                targets.presentViewController(playerController, animated: true, completion: nil)
            }
            return
        }
        
        let myVC = LookPhotoVC()
         myVC.hidesBottomBarWhenPushed = true
        myVC.myPhotoArray =  myPhotoArray
        myVC.pic1 = info!.pic
        myVC.title = "查看图片"
        myVC.count = sender.tag
        print(sender.tag)
        myDelegate!.pushVC(myVC)
         myVC.hidesBottomBarWhenPushed = false
        
        
    }
    func boFangMp4ButtonAction(){
        
        
        audioSession = AVAudioSession.sharedInstance()
        do{
            //            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
            try audioSession.setActive(true)
        }catch{
            
        }
        if let urls = NSURL.init(string: Bang_Image_Header+(info?.video!)! ){
            let player = AVPlayer(URL: urls)
            let playerController = AVPlayerViewController()
            playerController.player = player
            targets.presentViewController(playerController, animated: true, completion: nil)
        }
    }
    
    func userImageBackButtonAction(){
        
        let vc = FuWuHomePageViewController()
        vc.isUserid = true
        
        if self.info != nil&&self.info?.userid != nil{
            vc.userid = (self.info?.userid!)!
            targets.navigationController?.pushViewController(vc, animated: true)
        }else if self.info1 != nil && self.info1?.userid != nil{
            vc.userid = (self.info1?.userid!)!
            targets.navigationController?.pushViewController(vc, animated: true)
        }
        
        
//        
//        if self.info != nil{
//            let pic = PicInfo()
//            pic.pictureurl = info?.photo
//            let lookvc = LookPhotoVC()
//            lookvc.count = 0
//            lookvc.pic1 = [pic]
//            lookvc.title = "查看图片"
//            lookvc.myPhotoArray = self.photoArray
//            targets.navigationController?.pushViewController(lookvc, animated: true)
//        }
       
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
