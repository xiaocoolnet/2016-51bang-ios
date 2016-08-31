//
//  PayMethodTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class PayMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomView.backgroundColor = RGREY
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
