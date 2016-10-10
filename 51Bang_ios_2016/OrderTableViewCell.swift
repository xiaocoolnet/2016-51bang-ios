//
//  OrderTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var typeLabel: UIButton!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var location: AutoScrollLabel!
    
    @IBOutlet weak var snatchButton: UIButton!
    
    
    @IBOutlet weak var fuwudidian: AutoScrollLabel!
    
    @IBOutlet weak var distnce: UILabel!
    
    @IBOutlet weak var pushMapButton: UIButton!
    @IBOutlet weak var pushFuwuButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topView.backgroundColor = RGREY
        self.leftView.backgroundColor = RGREY
        self.rightView.backgroundColor = RGREY
        self.snatchButton.layer.borderWidth = 1
        self.snatchButton.layer.cornerRadius = 5
        self.snatchButton.layer.borderColor =  COLOR.CGColor
        // Initialization code
    }

    func setValueWithInfo(info:TaskInfo){
        
        if info.state != "1"{
            self.snatchButton.setTitle("已被抢", forState: UIControlState.Normal)
            self.snatchButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            self.snatchButton.enabled = false
            
        }else{
            self.snatchButton.setTitle("立即抢单", forState: UIControlState.Normal)
            self.snatchButton.setTitleColor(COLOR, forState: UIControlState.Normal)
            self.snatchButton.enabled = true
        }
        
        
        if info.photo == nil {
            self.icon.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.photo!
//            print(photoUrl)
            self.icon.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }
        
//        if info.photo {
//            <#code#>
//        }
        
        if info.title != "" && info.title != nil{
            self.title.text = info.title
        }else{
            self.title.text = ""
        }
        if info.price != "" && info.price != nil{
            self.price.text = info.price
        }else{
            self.price.text = "0"
        }
        if info.expirydate != "" && info.expirydate != nil{
            self.desc.text = info.expirydate
        }else{
            self.desc.text = ""
        }
        if info.address != "" && info.address != nil{
            
            self.location.labelSpacing = 30 // distance between start and end labels
            self.location.pauseInterval = 1.7 // seconds of pause before scrolling starts again
            self.location.scrollSpeed = 30 // pixels per second
            self.location.fadeLength = 12
            self.location.scrollDirection = AutoScrollDirection.Left
            self.location.text = info.address! as String
        }else{
            self.location.text = ""
        }
        if info.saddress != "" && info.saddress != nil{
            
            self.fuwudidian.labelSpacing = 30 // distance between start and end labels
            self.fuwudidian.pauseInterval = 1.7 // seconds of pause before scrolling starts again
            self.fuwudidian.scrollSpeed = 30 // pixels per second
            self.fuwudidian.fadeLength = 12
            self.fuwudidian.scrollDirection = AutoScrollDirection.Left
            self.fuwudidian.text = info.saddress! as String
        }else{
            self.fuwudidian.text = ""
        }
        if info.name != "" && info.name != nil{
            self.username.text = info.name
        }else{
            if info.phone != nil {
                self.username.text = info.phone
            }
            
        }
        
        if info.description != "" && info.description != nil{
            self.typeLabel.setTitle(info.description!, forState: .Normal)
        }else{
            self.typeLabel.setTitle("", forState: .Normal)
        }
        
        
        if info.expirydate != "" && info.expirydate != nil{
            let str = timeStampToString(info.expirydate!)
//            self.time.text = str
            self.desc.text = str+"前有效"
        }else{
            self.desc.text = ""
        }
        if info.time != "" && info.time != nil{
            let str = timeStampToString(info.time!)
            self.time.text = str
//            self.desc.text = str+"前有效"
        }
//        if info.photo != "" || info.photo != nil{
//            print(info.photo!)
//            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.photo!
//            self.icon.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
//        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
