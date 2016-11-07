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
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var fuwuNum: UILabel!
    
    @IBOutlet weak var city: AutoScrollLabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setValueWithInfo(info:RzbInfo){
        
        if info.Ranking != "" {
            rankingLabel.text = info.Ranking
        }
        
        if info.isworking == "0" {
            serviceStatus.setTitle("休息中", forState: UIControlState.Normal)
        }
        if info.serviceCount != ""{
            
            self.fuwuNum.text = info.serviceCount
        }else{
            self.fuwuNum.text = "0"
        }
        
        self.name.text = info.name
        city.labelSpacing = 30 // distance between start and end labels
        //        taskName.font = UIFont.systemFontOfSize(15)
        city.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        city.scrollSpeed = 30 // pixels per second
        city.fadeLength = 12
        city.scrollDirection = AutoScrollDirection.Left
        city.textColor = UIColor.whiteColor()
        self.city.text = info.address
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
