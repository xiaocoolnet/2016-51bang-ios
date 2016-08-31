//
//  OrderDetailHeaderTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class OrderDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var button2: UIButton!
    
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view1.backgroundColor = RGREY
        self.view2.backgroundColor = RGREY
        self.view3.backgroundColor = RGREY
        self.label1.textColor = COLOR
        self.bottomView.backgroundColor = RGREY
        self.button1.layer.cornerRadius = 15
        self.button2.layer.cornerRadius = 15
        self.button3.layer.cornerRadius = 15
        self.button4.layer.cornerRadius = 15
        self.button1.backgroundColor = COLOR
        self.button2.backgroundColor = RGREY
        self.button3.backgroundColor = RGREY
        self.button4.backgroundColor = RGREY
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
