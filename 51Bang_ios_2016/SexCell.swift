//
//  SexCell.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class SexCell: UITableViewCell {
    var userImage = UIImageView()
    var usrLabel = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init()
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "SexCell")
        self.usrLabel.frame = CGRectMake(20, 0, 40, 40)
        self.selectionStyle = UITableViewCellSelectionStyle.Blue
        self.addSubview(usrLabel)
    }
}
