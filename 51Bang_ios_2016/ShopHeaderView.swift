//
//  ShopHeaderView.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ShopHeaderView: UIView {

//    
    func instanceView()->ShopHeaderView{
    
        let headerView = NSBundle.mainBundle().loadNibNamed("ShopHeaderView", owner: nil, options: nil)
        return headerView[0] as! ShopHeaderView
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
