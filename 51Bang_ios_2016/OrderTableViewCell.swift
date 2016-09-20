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
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var snatchButton: UIButton!
    
    
    @IBOutlet weak var fuwudidian: UILabel!
    
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
        
        if info.title != "" || info.title != nil{
            self.title.text = info.title
        }
        if info.price != "" || info.price != nil{
            self.price.text = info.price
        }
        if info.expirydate != "" || info.expirydate != nil{
            self.desc.text = info.expirydate
        }
        if info.address != "" || info.address != nil{
            self.location.text = info.address
        }
        if info.saddress != "" || info.saddress != nil{
            self.fuwudidian.text = info.saddress
        }
        if info.name != "" || info.name != nil{
            self.username.text = info.name        }
        
        
        
        
        if info.expirydate != "" || info.expirydate != nil{
            let str = timeStampToString(info.expirydate!)
//            self.time.text = str
            self.desc.text = str+"前有效"
        }
        if info.time != "" || info.time != nil{
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
