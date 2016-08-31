//
//  RenZhengBangHeaderViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/9.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RenZhengBangHeaderViewCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var label3: UILabel!

    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var button1: UIButton!
    
    
    @IBOutlet weak var button2: UIButton!
    
    
    @IBOutlet weak var button3: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftView.backgroundColor = RGREY
        rightView.backgroundColor = RGREY
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
