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
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var fuwuLocation: UIButton!
    
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
    
        self.orderDesc.text = info.order_num
        self.title.text = info.title
        self.shangmen.text = info.address
        self.fuwu.text = info.saddress
        self.price.text = info.price
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
