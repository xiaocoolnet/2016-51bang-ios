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

    func setValueWithInfo(info:chatListInfo){
        if info.other_nickname != nil {
            self.title.text = info.other_nickname
        }else{
            
            self.title.text = "userid"+info.chat_uid!
        }
        
        if info.last_content != nil {
            self.content.text = info.last_content
        }else{
            self.content.text = "无内容"
        }
        
        if info.create_time != nil {
            self.time.text = info.create_time
        }else{
            self.time.text = "时间不详"
        }
        
//        let str = Bang_Image_Header+info.photo
//        self.iconImage.sd_setImageWithURL(NSURL(string: str),placeholderImage:UIImage(named: "01"))
        iconImage.layer.masksToBounds = true
        iconImage.layer.cornerRadius = iconImage.bounds.size.width*0.5
        if info.other_face != nil {
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.other_face!
            print(photoUrl)
            iconImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }else{
            iconImage.image = UIImage(named: "girl")
        }
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
