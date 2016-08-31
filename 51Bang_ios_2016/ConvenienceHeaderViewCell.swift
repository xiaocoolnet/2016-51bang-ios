//
//  ConvenienceHeaderViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ConvenienceHeaderViewCell: UITableViewCell {

    
    @IBOutlet weak var numOfEMS: UITextField!
    @IBOutlet weak var query: UIButton!
    @IBOutlet weak var choose: UIButton!
    @IBOutlet weak var jiantou: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
