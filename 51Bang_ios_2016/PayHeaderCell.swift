//
//  PayHeaderCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class PayHeaderCell: UITableViewCell {

    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.backgroundColor = RGREY
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
