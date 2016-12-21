
//
//  CommentListCell.swift
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
import UIKit

class CommentListCell : UITableViewCell{
    
    static var heighArray = []
    var myPhotoArray = NSMutableArray()
    var myDelegate:pushDelegate?
    
    var userImage = UIImageView()
    var userName = UILabel()
    var timeLabel = UILabel()
    var messageButton = UIButton()
    var photo = UIImage()
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
    //    var info:TCHDInfo?
    let imshow = UIView()
    //    init(info:TCHDInfo) {
    
    init( ){
        super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "resucell")
        
        self.sd_addSubviews([userImage,userName,timeLabel,messageButton,contenLabel,imshow])
        
        userImage.frame = CGRectMake(10, 10, 50, 50)
        userImage.layer.masksToBounds = true
        userImage.cornerRadius = 25
        userImage.backgroundColor = UIColor.redColor()
        
        //        if info.photo==nil {
        
        userImage.image = UIImage(named:"ic_moren")
                userName.sd_layout()
            .widthIs(100)
            .heightIs(25)
            .topEqualToView(userImage)
            .leftSpaceToView(userImage,5)
        //        userName.text = info.name
        userName.textColor = COLOR
        
        timeLabel.sd_layout()
            .widthIs(120)
            .heightIs(35)
            .topSpaceToView(userName,-8)
            .leftSpaceToView(userImage,5)
        //        timeLabel.text = info.create_time
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.grayColor()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        timeLabel.text = dateStr
        
        
        contenLabel.sd_layout()
            .leftSpaceToView(self,10)
            .rightSpaceToView(self,10)
            .topSpaceToView(userImage,10)
            .autoHeightRatio(0)
        //        contenLabel.text = info.content
        
        //        var imcount = 0
        //        for ima in info.pic
        //        {
        //            let imview = UIImageView()
        //
        //            imview.tag = imcount+100
        //
        //            let url = Bang_Image_Header+info.pic[imcount].pictureurl!
        //
        //            print(url)
        //
        //
        //            imview.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "1.png"))
        //
        //            switch imcount / 3 {
        //            case 0:
        //                imview.frame = CGRectMake( CGFloat( imcount ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3, (WIDTH) / 3 - 5 , WIDTH / 3 )
        //            case 1:
        //                imview.frame = CGRectMake( CGFloat( imcount-3) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 5, (WIDTH) / 3 - 5 , WIDTH / 3 )
        //            case 2:
        //                imview.frame = CGRectMake( CGFloat( imcount-6 ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 10, (WIDTH) / 3 - 5 , WIDTH / 3 )
        //            default:
        //                return
        //            }
        //            let backButton = UIButton()
        //            backButton.frame = imview.frame
        //            backButton.frame.origin.y = imview.frame.origin.y + 98
        //            backButton.backgroundColor = UIColor.clearColor()
        //            backButton.tag = imcount
        //            self.addSubview(backButton)
        //            backButton .addTarget(self, action:#selector(self.lookImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //
        //
        //
        //            imshow.addSubview(imview)
        //            imcount += 1
        //            myPhotoArray.addObject(imview)
        //        }
        //
        //        switch info.pic.count / 3 {
        //        case 0:
        //            picHeight = 0
        //        case 1:
        //            picHeight = WIDTH / 3
        //        case 2:
        //            picHeight = WIDTH / 3 * 2
        //        default:
        //            picHeight = WIDTH
        //        }
        //
        //
        //        imshow.frame = CGRectMake(0, 80 + calculateHeight( contenLabel.text!, size: 15, width: WIDTH - 20) , WIDTH, picHeight)
        //
        //
    }
    //    func lookImage(sender:UIButton) {
    //
    //        let myVC = LookPhotoVC()
    //        myVC.myPhotoArray =  myPhotoArray
    //        myVC.title = "查看图片"
    //        myDelegate!.pushVC(myVC)
    //
    //    }
    
    func callPhone(){
        
        
        UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://"+"10086")!)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
