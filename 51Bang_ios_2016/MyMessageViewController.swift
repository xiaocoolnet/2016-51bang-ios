//
//  MyMessageViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/2/28.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit


class MyMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false

        self.title = "我的便民圈"
        self.view.backgroundColor = LGBackColor
        let assignSeverVC = MyMessageChildViewController()
        assignSeverVC.status = "1"
        let selfHelpServerVC = MyMessageChildViewController()
        selfHelpServerVC.status = "-2"
        assignSeverVC.title = "已发布"
        selfHelpServerVC.title = "待发布"
        
        
        let viewControllers = [selfHelpServerVC,assignSeverVC]
        let options = PagingMenuOptions()
        options.menuHeight = 40
        options.menuItemMode = .Underline(height: 2, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = COLOR
        options.selectedFont = UIFont.systemFontOfSize(14)
        options.font = UIFont.systemFontOfSize(14)
        options.menuItemMargin = 3
        options.menuDisplayMode = .SegmentedControl
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
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
