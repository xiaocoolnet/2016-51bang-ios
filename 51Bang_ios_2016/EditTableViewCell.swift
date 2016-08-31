//
//  EditTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    let dirImageview = UIImageView()
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let rect = UIScreen.mainScreen().bounds
        dirImageview.hidden = true
        dirImageview.image = UIImage.init(named: "ic_arrow_right")
        dirImageview.frame = CGRectMake(rect.width - 20, (self.frame.height - 10) / 2 - 5, 10,15)
        self.addSubview(dirImageview)
        let ud = NSUserDefaults.standardUserDefaults()
        label.text = ud.objectForKey("phone") as? String
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
