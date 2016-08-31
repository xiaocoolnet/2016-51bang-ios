//
//  OrderDetailAlertTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class OrderDetailAlertTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var leave: UIButton!
    
    
    @IBOutlet weak var wait: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
