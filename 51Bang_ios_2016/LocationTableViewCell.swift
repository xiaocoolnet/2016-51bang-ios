//
//  LocationTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/1.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var locationButton: UIButton!
    
    
    @IBOutlet weak var topView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
