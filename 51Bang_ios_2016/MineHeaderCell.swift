//
//  MineHeaderCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineHeaderCell: UITableViewCell {

    
    @IBOutlet weak var iconBtn: UIButton!
    
    @IBOutlet weak var sex: UIImageView!
    
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var baoxianRenZheng: UIButton!
    
    
    @IBOutlet weak var renzheng: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = COLOR
        let ud = NSUserDefaults.standardUserDefaults()
        phone.text = ud.objectForKey("phone") as? String
        name.text = ud.objectForKey("name") as? String
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getData()
    {
        
    }
    
}
