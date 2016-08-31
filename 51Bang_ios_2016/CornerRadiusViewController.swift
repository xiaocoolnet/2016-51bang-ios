//
//  CornerRadiusViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius:CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
//    @IBInspectable var PlaceholderColor:UIColor{
//        get{
//            return UIColor.blueColor()
//            
//        }
//        set{
//            UIColor()
//        }
//    }
    
}


class CornerRadiusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
