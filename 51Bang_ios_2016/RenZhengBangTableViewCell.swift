//
//  RenZhengBangTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RenZhengBangTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var names: AutoScrollLabel!
    
    @IBOutlet weak var rightView: UIView!
    
    
    @IBOutlet weak var leftView: UIView!
    
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var FuwuNum: UILabel!
    @IBOutlet weak var pingjia: UILabel!
    @IBOutlet weak var message: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var weizhiButton: UIButton!
  
    @IBOutlet weak var otherView: UIView!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.backgroundColor = RGREY
        leftView.backgroundColor = RGREY
        rightView.backgroundColor = RGREY
        otherView.backgroundColor = UIColor.whiteColor()
//        oterView2.backgroundColor = RGREY
        // Initialization code
    }

    func setValueWithInfo(info:RzbInfo){
        
        self.name.hidden = true
        
        if info.serviceCount != "" {
            FuwuNum.text = "服务"+info.serviceCount+"次"
        }else{
            FuwuNum.text = "服务"+"0"+"次"
        }
        
        
        self.names.text = info.name
        if info.name == "" {
            self.names.text = info.phone
        }
        //        self.desc.text = info.
        self.address.text = info.address
        if info.photo == ""{
            
            self.iconImage.image = UIImage(named: ("01"))
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.photo
            print(photoUrl)
            //http://bang.xiaocool.net./data/product_img/4.JPG
            //self.myimage.setImage("01"), forState: UIControlState.Normal)
            //        self.myimage.image =
            self.iconImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "1.png"))
            
        }
        
        if info.time != ""{
            let todayDate: NSDate = NSDate()
            print(todayDate)
            let date = NSDate(timeIntervalSince1970: Double(info.time)!)
            print(date)
            let second = todayDate.timeIntervalSinceDate(date)
            print(second)
            if second/3600 < 1 {
                
            }
            
            if second/3600 > 1 && second/86400 < 1 {
                
            }
            
            if second/86400 > 1 {
                
            }

        }

            }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
