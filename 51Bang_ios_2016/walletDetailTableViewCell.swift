//
//  walletDetailTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class walletDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var money: UILabel!
    
    @IBOutlet weak var yu: UILabel!
    
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.backgroundColor = RGREY
        // Initialization code
    }

    
    func setValueWithInfo(info:walletDetailInfo){
    
        self.yu.text = info.money
        if info.type == "0" {
            self.money.text = "-"+info.balance!
//            self.money.textColor = UIColor.greenColor()
        }else{
            self.money.text = "+"+info.balance!
//            self.money.textColor = UIColor.redColor()
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Double(info.time!)!)
        time.text = dateFormatter.stringFromDate(date)
    
    }
    
    func setValueWithMyInfo(info:tiXianInfo){
        self.yu.text = info.money
        if info.state == "0" {
            self.money.text = "-"+info.balance!
//            self.money.textColor = UIColor.greenColor()
        }else{
            self.money.text = "+"+info.balance!
//            self.money.textColor = UIColor.redColor()
        }
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Double(info.time!)!)
        time.text = dateFormatter.stringFromDate(date)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
