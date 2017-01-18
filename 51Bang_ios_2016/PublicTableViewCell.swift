//
//  PublicTableViewCell.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/2.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class PublicTableViewCell: UITableViewCell {

    

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    init(style:UITableViewCellStyle){
        super.init(style: style, reuseIdentifier: "PublicTableViewCell")
        
        let lineView = UIView()
        self.sd_addSubviews([lineView])
        lineView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
//        lineView.frame = CGRectMake(0, 1, Screen_W, 1)
        lineView.sd_layout()//添加约束
        .widthIs(WIDTH)
        .heightIs(1)
        .leftSpaceToView(self,0)
        .bottomSpaceToView(self,0)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
