//
//  OrderRWTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class OrderRWTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
