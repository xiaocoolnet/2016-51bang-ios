//
//  MyAddressTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var moren: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var xuanze: UIButton!
    @IBOutlet weak var midView: UIView!
    
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    @IBOutlet weak var address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomView.backgroundColor = RGREY
        self.midView.backgroundColor = RGREY
        self.selectedButton.hidden = true
//        self.moren.textColor = RGREY
//        self.delete.setTitleColor(RGREY, forState: UIControlState.Normal)
        // Initialization code
    }

    func setValueWithInfo(info:addressInfo){
        self.address.text = info.address
        if info.mydefault == "1"{
          self.xuanze.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
