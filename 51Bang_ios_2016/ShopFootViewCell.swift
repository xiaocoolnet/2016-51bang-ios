//
//  ShopFootViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ShopFootViewCell: UITableViewCell {

    @IBOutlet weak var buy: UIButton!
    
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var yunfei: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
