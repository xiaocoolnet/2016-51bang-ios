  //
//  NickNameView.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class NickNameView: UIViewController {
    var nickTextField = UITextField()
    var Rect  = UIApplication.sharedApplication().statusBarFrame
    var myDelegate:MineDelegate?
    let updateName = TCMoreInfoHelper()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:  242/255, green: 242 / 255, blue: 242 / 255, alpha: 1.0)
        nickTextField.frame = CGRectMake(0, 10, self.view.frame.width, 50)
        nickTextField.backgroundColor = UIColor(red:  0, green: 202 / 255, blue: 170 / 255, alpha: 1.0)
        nickTextField.placeholder = "  请输入昵称"
        nickTextField.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(nickTextField)
        setNavRightButton(self, Title: "保存", action: #selector(self.rightBrtnaction), color: UIColor.whiteColor())
    }
    
    func rightBrtnaction()
    {
        if(nickTextField.text?.characters.count==0)
        {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "昵称不可为空"
            hud.color = UIColor.grayColor()
            hud.alpha = 0.7
            hud.labelColor = UIColor.whiteColor()
            hud.xOffset = 0
            hud.yOffset = 0
            hud.hide(true, afterDelay: 2)
 
        
        }else{
            updateName.myDelegate = myDelegate
            updateName.updateName(nickTextField.text!,target:self)
            
            
        
        }
    }
    
    func setNavRightButton(target:UIViewController,Title:String,action:Selector,color:UIColor)
    {
        let navRItem = UIBarButtonItem.init(title: Title, style: UIBarButtonItemStyle.Plain, target: target, action: action)
        target.navigationItem.rightBarButtonItem = navRItem
        target.navigationItem.rightBarButtonItem?.tintColor = color
    }
    
        

    
}
