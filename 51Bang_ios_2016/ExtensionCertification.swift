//
//  ExtensionCertification.swift
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/12.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

extension CertificationViewController{
    
    func firmWay(){
        
        buttonfirm1.frame = CGRectMake(0, 0, WIDTH / 2, 43)
        buttonfirm1.setTitle("认证方式一", forState: UIControlState.Normal)
        buttonfirm1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonfirm1.backgroundColor = UIColor.whiteColor()
        buttonfirm1.setTitleColor(COLOR, forState: UIControlState.Normal)
//        self.view.addSubview(buttonfirm1)
        buttonfirm1.addTarget(self, action: #selector(action1), forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonfirm2.frame = CGRectMake(WIDTH / 2, 0, WIDTH / 2, 43)
        buttonfirm2.setTitle("认证方式二", forState: UIControlState.Normal)
        buttonfirm2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonfirm2.backgroundColor = UIColor.whiteColor()
        buttonfirm2.addTarget(self, action: #selector(action2), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(buttonfirm2)
        
        labelfirm2 = UILabel.init(frame: CGRectMake(0, 40, WIDTH/2, 3))
        labelfirm2.backgroundColor = COLOR
//        self.view.addSubview(labelfirm2)
        
        
    }
    
    func action1(){
        if butTag == 1{
            
            buttonfirm1.setTitleColor(COLOR, forState: UIControlState.Normal)
            buttonfirm2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            labelfirm2.frame =  CGRectMake(0, 40, WIDTH/2, 3)
            butTag = 2
            self.title = "身份认证"
            myTableView.hidden = false
            scrollView.hidden = true
            
        }
    }
    
    func action2(){
         if butTag == 2{
            
            buttonfirm2.setTitleColor(COLOR, forState: UIControlState.Normal)
            buttonfirm1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            labelfirm2.frame =  CGRectMake(WIDTH/2, 40, WIDTH/2, 3)
            butTag = 1
            myTableView.hidden = true
            scrollView.hidden = false
        }
    }

    
}


