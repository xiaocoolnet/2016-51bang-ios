//
//  YwcTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class YwcTableViewCell: UITableViewCell {

    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var pingjia: UIButton!
    
    @IBOutlet weak var goZhuye: UIButton!
    
    @IBOutlet weak var renwuNum: UILabel!
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var faqiren: UILabel!
    
    @IBOutlet weak var jiedanren: UILabel!
    
    
    @IBOutlet weak var status: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.whiteColor()
        self.view1.backgroundColor = RGREY
        self.view2.backgroundColor = RGREY
        // Initialization code
    }

    func setValueWithInfo(info:TaskInfo){
        self.view1.backgroundColor = RGREY
        self.view2.backgroundColor = RGREY
        if info.title != nil {
            self.title.text = info.title
        }
        
        if info.order_num != nil {
            self.renwuNum.text = info.order_num
        }
        
        if info.apply?.name != nil {
//            self.jiedanren.text = info.apply?.name
            self.jiedanren.textColor = UIColor.blueColor()
            
            let str1 = NSMutableAttributedString(string: (info.apply?.name)!)
            let range1 = NSRange(location: 0, length: str1.length)
            let number = NSNumber(integer:NSUnderlineStyle.StyleSingle.rawValue)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
            str1.addAttribute(NSUnderlineStyleAttributeName, value: number, range: range1)
            str1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range1)
            self.jiedanren.attributedText = str1
        }else if info.apply?.name == nil && info.apply?.phone != nil{
            self.jiedanren.textColor = UIColor.blueColor()
            
            let str1 = NSMutableAttributedString(string: (info.apply?.phone)!)
            let range1 = NSRange(location: 0, length: str1.length)
            let number = NSNumber(integer:NSUnderlineStyle.StyleSingle.rawValue)//此处需要转换为NSNumber 不然不对,rawValue转换为integer
            str1.addAttribute(NSUnderlineStyleAttributeName, value: number, range: range1)
            str1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range1)
            self.jiedanren.attributedText = str1
        }else{
            self.jiedanren.text = "无人接单"
        }
        
        
    
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
