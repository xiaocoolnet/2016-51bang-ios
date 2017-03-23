//
//  MyAdvertisementPublishViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class MyAdvertisementPublishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的广告发布"
        self.view.backgroundColor = GREY

        let assignSeverVC = MyAdvertisementPublishListViewController()
        assignSeverVC.status = "1"
        let selfHelpServerVC = MyAdvertisementPublishListViewController()
        selfHelpServerVC.status = "-2"
        assignSeverVC.title = "已发布"
        selfHelpServerVC.title = "待发布"
        
        
        let viewControllers = [selfHelpServerVC,assignSeverVC]
        let options = PagingMenuOptions()
        options.menuHeight = 40
        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = COLOR
        options.selectedFont = UIFont.systemFontOfSize(14)
        options.font = UIFont.systemFontOfSize(14)
        options.menuItemMargin = 3
        options.menuDisplayMode = .SegmentedControl
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
        let rightButton = UIButton.init(frame: CGRectMake(0, 0, 40, 30))
        rightButton.setTitle("发布", forState: .Normal)
        rightButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightButton.addTarget(self, action: #selector(self.rightButtonAction), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    func rightButtonAction(){
        let vc = GoAdvertisementPublishViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
