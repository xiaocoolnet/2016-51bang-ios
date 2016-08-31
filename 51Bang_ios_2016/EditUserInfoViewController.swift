//
//  EditUserInfoViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class EditUserInfoViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = RGREY
//        
//        // Do any additional setup after loading the view.
//    }
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
////        super.init()
//        //println(nibName);
//    }
//     convenience init() {
//        //super.init()
//        let nibNameOrNil = String?("EditUserInfoViewController")
//        
//        //        //考虑到xib文件可能不存在或被删，故加入判断
//        //        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil{   nibNameOrNil = nil}
//        
//        self.init(nibName: nibNameOrNil, bundle: nil)
//    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
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
