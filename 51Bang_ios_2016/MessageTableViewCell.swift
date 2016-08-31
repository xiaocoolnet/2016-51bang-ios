//
//  MessageTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.line.backgroundColor = RGREY
        // Initialization code
    }

    func setValueWithInfo(info:MessInfo){
    
        self.title.text = info.title
        self.content.text = info.content
        self.time.text = info.create_time
        let str = Bang_Image_Header+info.photo
        self.iconImage.sd_setImageWithURL(NSURL(string: str),placeholderImage:UIImage(named: "01"))
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
