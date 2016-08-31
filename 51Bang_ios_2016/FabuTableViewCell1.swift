//
//  FabuTableViewCell1.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FabuTableViewCell1: UITableViewCell {

    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.text1()
        // Initialization code
    }
    func text1(){
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGPathCreateMutable()
        dotteShapLayer.fillColor = UIColor.clearColor().CGColor
        dotteShapLayer.strokeColor = UIColor.grayColor().CGColor
        dotteShapLayer.lineWidth = 2.0
        CGPathMoveToPoint(mdotteShapePath, nil, 0, 0)
        CGPathAddLineToPoint(mdotteShapePath, nil, self.frame.size.width,0 )
//        CGPathAddLineToPoint(mdotteShapePath, nil, 200, 200)
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [10,5])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
    
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
