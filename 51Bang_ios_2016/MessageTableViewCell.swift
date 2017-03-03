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
    
    var countsLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.line.backgroundColor = RGREY
        // Initialization code
    }

    func setValueWithInfo(info:chatListInfo){
        
        countsLabel.frame = CGRectMake(WIDTH-30, 35, 18, 18)
        countsLabel.backgroundColor = UIColor.redColor()
        countsLabel.textAlignment = .Center
        countsLabel.textColor = UIColor.whiteColor()
        countsLabel.font = UIFont.systemFontOfSize(11)
        countsLabel.layer.masksToBounds = true
        countsLabel.layer.cornerRadius = 9
        if info.noreadcount != nil&&info.noreadcount != "0"&&info.noreadcount != ""{
            self.countsLabel.hidden = false
            self.countsLabel.text = info.noreadcount!
            let counts = Int(info.noreadcount!)
            if counts>99{
                self.countsLabel.text = "99+"
                self.countsLabel.frame = CGRectMake(WIDTH-30, 35, 25, 18)
                self.countsLabel.layer.cornerRadius = 9
            }
        }else{
            self.countsLabel.hidden = true
        }
        
        self.addSubview(self.countsLabel)
        
        
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
