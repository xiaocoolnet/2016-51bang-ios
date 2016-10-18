//
//  MineHeaderCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineHeaderCell: UITableViewCell {

    
    @IBOutlet weak var iconBtn: UIButton!
    
    @IBOutlet weak var sex: UIImageView!
    
    
    @IBOutlet weak var name: AutoScrollLabel!
    
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var baoxianRenZheng: UIButton!
    
    
    @IBOutlet weak var renzheng: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = COLOR
        let ud = NSUserDefaults.standardUserDefaults()
        phone.text = ud.objectForKey("phone") as? String
        name.text = ud.objectForKey("name") as? String
        name.labelSpacing = 30 // distance between start and end labels
        //        taskName.font = UIFont.systemFontOfSize(15)
        name.pauseInterval = 1.7 // seconds of pause before scrolling starts again
        name.scrollSpeed = 30 // pixels per second
        name.fadeLength = 12
        name.textColor = UIColor.whiteColor()
        name.scrollDirection = AutoScrollDirection.Left
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getData()
    {
        
    }
    
}
