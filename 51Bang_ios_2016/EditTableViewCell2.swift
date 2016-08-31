//
//  EditTableViewCell2.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class EditTableViewCell2: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let rect = UIScreen.mainScreen().bounds
        let dirImageview = UIImageView()
        dirImageview.image = UIImage.init(named: "ic_arrow_right")
        dirImageview.frame = CGRectMake(rect.width - 20, (self.frame.height - 10) / 2 - 5, 10,15)
        self.addSubview(dirImageview)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
