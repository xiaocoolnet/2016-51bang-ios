//
//  TaskDetailTableViewCell2.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class TaskDetailTableViewCell2: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var desc: AutoScrollLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.desc.labelSpacing = 30 // distance between start and end labels
        self.desc.font = UIFont.systemFontOfSize(13)
        self.desc.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        self.desc.scrollSpeed = 30 // pixels per second
        self.desc.fadeLength = 12
        self.desc.scrollDirection = AutoScrollDirection.Left
//        self.location.text = info.address! as String
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
