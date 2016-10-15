//
//  ShopHeaderViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ShopHeaderViewCell: UITableViewCell {

    
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var desciption: UITextView!
    
    @IBOutlet weak var desciptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var price: UILabel!
    
    
//    @IBOutlet weak var back: UIButton!
    
    
    @IBOutlet weak var favorite: UIButton!
    
//    @IBOutlet weak var share: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desciption.userInteractionEnabled = false

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
