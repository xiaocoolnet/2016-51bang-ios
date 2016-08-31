//
//  EditTableViewCell1.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class EditTableViewCell1: UITableViewCell {
    let rect = UIScreen.mainScreen().bounds
    let dirImageview = UIImageView()
    
    
    @IBOutlet weak var womenImage: UIButton!
    @IBOutlet weak var MenImage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        womenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
        womenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Selected)
        dirImageview.image = UIImage.init(named: "ic_arrow_right")
        dirImageview.frame = CGRectMake(rect.width - 20, (self.frame.height - 10) / 2 - 5, 10,15)
        self.addSubview(dirImageview)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
