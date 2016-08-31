//
//  shopCommentTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by 何明阳 on 16/8/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class shopCommentTableViewCell: UITableViewCell {
//    var userImage = UIImageView()
    var userName = UILabel()
    var add_time = UILabel()
    var contentLabel = UILabel()
    var photoButton = UIButton()
    
    var goodsInfo:commentlistInfo?
    
    init(goodsInfo:commentlistInfo,num:NSInteger) {
     super.init(style: UITableViewCellStyle.Default , reuseIdentifier: "resucell")
        self.sd_addSubviews([userName,add_time,contentLabel])
        userName.frame = CGRectMake(5, 5, 100, 30)
        self.userName.text = goodsInfo.name
        
        add_time.frame = CGRectMake(5, 35, 100, 20)
        self.add_time.text = goodsInfo.add_time
        
        contentLabel.sd_layout()
            .leftSpaceToView(self,10)
            .rightSpaceToView(self,10)
            .topSpaceToView(add_time,10)
            .autoHeightRatio(0)
        self.contentLabel.text = goodsInfo.content
       }

    
    
   required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
   }
}
