//
//  faDanDetailHeaderTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class faDanDetailHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var fuwucishu: UILabel!
    
    
    @IBOutlet weak var callPhone: UIButton!
    
    @IBOutlet weak var message: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
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
