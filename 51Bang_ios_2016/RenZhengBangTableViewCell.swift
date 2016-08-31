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
        
        self.name.text = info.name
        //        self.desc.text = info.
        self.address.text = info.city
        if info.photo == "" {
            
            self.iconImage.image = UIImage(named: ("01"))
        }else{
            let photoUrl:String = "http://bang.xiaocool.net/uploads/images/"+info.photo
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
