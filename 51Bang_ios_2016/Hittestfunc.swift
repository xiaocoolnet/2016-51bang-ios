//
//  Hittestfunc.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class HittestfuncView: UIView {
    var button = UIButton.init()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   init(frame: CGRect,btn:UIButton) {
        
        super.init(frame: frame)
        button = btn
    }
    
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, withEvent: event)
        
        let buttonPoint = button.convertPoint(point, fromView: self)
        if(button.pointInside(buttonPoint, withEvent: event))
        {
        
            return button
            
        }else{
        
        return result
        }
    }
}
