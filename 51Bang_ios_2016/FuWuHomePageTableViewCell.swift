//
//  FuWuHomePageTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/9.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FuWuHomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceStatus: UIButton!
    @IBOutlet weak var paimingNum: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var fuwuNum: UILabel!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setValueWithInfo(info:RzbInfo){
        
        self.name.text = info.name
        self.city.text = info.city
        self.serviceStatus.frame.size.width = WIDTH*75/375
        if info.photo == "" {
            
            self.iconImage.image = UIImage(named: ("01"))
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.photo
            print(photoUrl)
            //http://bang.xiaocool.net./data/product_img/4.JPG
            //self.myimage.setImage("01"), forState: UIControlState.Normal)
            //        self.myimage.image =
            self.iconImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "1.png"))
        }
        
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
