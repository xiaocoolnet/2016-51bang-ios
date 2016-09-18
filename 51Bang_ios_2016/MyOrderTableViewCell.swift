//
//  MyOrderTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var orderNum: UILabel!
    
    @IBOutlet weak var orderDesc: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    
    @IBOutlet weak var priceDesc: UILabel!
    
    
    @IBOutlet weak var shangmen: UILabel!
    
    
    @IBOutlet weak var fuwu: UILabel!
    
    @IBOutlet weak var shangmenMap: UIButton!
    
    @IBOutlet weak var fuwuMap: UIButton!
    @IBOutlet weak var shangmenLocation: UIButton!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var fuwuLocation: UIButton!
//    let timeLabel  = UILabel()
    @IBOutlet weak var view3: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topView.backgroundColor = RGREY
        self.view1.backgroundColor = RGREY
        self.view2.backgroundColor = RGREY
        self.view3.backgroundColor = RGREY
        // Initialization code
    }
    
    func setValueWithInfo(info:TaskInfo){
        
//        self.timeLabel.frame = CGRectMake(width/3, 0, width, 40)
        self.timeLabel.textAlignment = NSTextAlignment.Left
        self.timeLabel.textColor = COLOR
//        self.timeLabel.backgroundColor = UIColor.whiteColor()
        self.timeLabel.font = UIFont.systemFontOfSize(13)
//        self.addSubview(self.timeLabel)
        if info.time != nil {
            let string = NSString(string:info.time!)
            let dateFormatter = NSDateFormatter()
            let timeSta:NSTimeInterval = string.doubleValue
            dateFormatter.dateFormat = "MM:dd HH:mm:ss"
            //            dateFormatter.timeStyle = .ShortStyle
            //            dateFormatter.dateStyle = .ShortStyle
            //            let data = dateFormatter.dateFromString(model.time!)
            //            print(data)
            let date = NSDate(timeIntervalSince1970: timeSta)
            let dateStr = dateFormatter.stringFromDate(date)
            self.timeLabel.text = dateStr
            
        }
    
        self.orderDesc.text = info.order_num!
        if info.description == nil {
            self.title.text = ""
        }else{
            self.title.text = info.description!
        }
        if info.address == nil {
            self.shangmen.text = ""
        }else{
            self.shangmen.text = info.address!
        }
        if info.saddress == nil {
            self.fuwu.text = ""
        }else{
            self.fuwu.text = info.saddress!
        }
        
        
        self.price.text = info.price!
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
