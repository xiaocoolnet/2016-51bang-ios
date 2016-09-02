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
        self.title.text = info.title
        self.renwuNum.text = info.order_num
        
    
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
