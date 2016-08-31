//
//  myOrderLocationTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class myOrderLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var location: UIButton!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
