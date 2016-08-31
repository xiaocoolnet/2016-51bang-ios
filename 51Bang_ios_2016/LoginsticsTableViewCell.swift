//
//  LoginsticsTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LoginsticsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var circleView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomView.backgroundColor = RGREY
        self.time.textColor = UIColor.blackColor()
        self.content.textColor = UIColor.blackColor()
        self.circleView.backgroundColor = RGREY
        self.lineView.backgroundColor = RGREY
        self.circleView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
