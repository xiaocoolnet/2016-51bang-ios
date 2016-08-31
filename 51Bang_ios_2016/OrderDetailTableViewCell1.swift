//
//  OrderDetailTableViewCell1.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell1: UITableViewCell {

    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var location: UIButton!
    override func awakeFromNib() {
        self.bottomView.backgroundColor = RGREY
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
