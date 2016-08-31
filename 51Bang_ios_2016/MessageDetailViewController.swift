//
//  MessageDetailViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
   
    var taskInfo = TaskInfo()
//    var messageInfo = MessInfo()
    var arr = Array<MessInfo>()
    var index = Int()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        self.title = "系统消息"
        let titlelabel = UILabel.init(frame: CGRectMake(50, 0, WIDTH-50, 50))
        titlelabel.text = arr[index].title
//        titlelabel.backgroundColor = UIColor.redColor()
        let contentLabel = UILabel.init(frame: CGRectMake(10, 50, WIDTH-10, 100))
//        contentLabel.backgroundColor = UIColor.greenColor()
        contentLabel.text = arr[index].content
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        let button = UIButton.init(frame: CGRectMake(0, HEIGHT-120, WIDTH, 50))
        button.backgroundColor = COLOR
        button.setTitle("立即更新", forState: UIControlState.Normal)
        self.view.addSubview(button)
        self.view.addSubview(titlelabel)
        self.view.addSubview(contentLabel)
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
