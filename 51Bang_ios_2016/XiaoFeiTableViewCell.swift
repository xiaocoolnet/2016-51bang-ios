//
//  XiaoFeiTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class XiaoFeiTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var yes: UIButton!
    
    @IBOutlet weak var no: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.layer.borderColor = COLOR.CGColor
        self.yes.backgroundColor = UIColor.orangeColor()
        self.no.backgroundColor = COLOR
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
