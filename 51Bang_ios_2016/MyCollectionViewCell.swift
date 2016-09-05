//
//  MyCollectionViewCell.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UITableViewCell {
    
    var Images = UIImageView()
    var Title  = UILabel()
    var catLog = UILabel()
    var Price  = UILabel()
    var Button = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    
    init()
    {
    
        
        
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "collectionviewcell")
        
        self.addSubview(Images)
        
        
        Images.sd_layout()
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .widthIs(100)
        .heightIs(70)
        Images.backgroundColor = UIColor.redColor()
        
        self.setupAutoHeightWithBottomView(Images, bottomMargin: 10)
        
        
        
    }
}
