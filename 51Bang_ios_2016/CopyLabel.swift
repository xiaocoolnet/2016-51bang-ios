//
//  CopyLabel.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/2/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class CopyLabel: UILabel {
    
    override func canBecomeFirstResponder()->Bool{
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        return action == #selector(copy(_:));
    }
    
    override func copy(sender: AnyObject?) {
        let  pboard = UIPasteboard.generalPasteboard()
        pboard.string = self.text
    }
    func attachTapHandler(){
        self.userInteractionEnabled = true
        let touch = UILongPressGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(touch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachTapHandler()
    }
    
    func handleTap(recognizer:UIGestureRecognizer){
        self.becomeFirstResponder()
//        let copyLink =  UIMenuItem.init(title: "复制", action: #selector(copy(_:)))
        UIMenuController.sharedMenuController().setTargetRect(self.frame, inView: self.superview!)
        UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
//         UIMenuController.sharedMenuController().menuItems = [copyLink]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.attachTapHandler()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
