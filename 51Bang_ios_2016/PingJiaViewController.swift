//
//  PingJiaViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class PingJiaViewController: UIViewController {
    
    let textView = UITextView()
    let array = ["服务态度","完成速度","完成效果"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价"
        self.view.backgroundColor = RGREY
        textView.frame = CGRectMake(0, 0, WIDTH, 150)
        textView.text = "希望我的服务您能够满意，请输入您的评价～"
        self.view.addSubview(textView)
        
        self.createView()
        
        // Do any additional setup after loading the view.
    }

    func createView(){
        for i in 0..<3 {
            let view = UIView.init(frame: CGRectMake(0, 160+50*CGFloat(i), WIDTH, 50))
            view.backgroundColor = UIColor.whiteColor()
            let label = UILabel.init(frame: CGRectMake(10, 10, 80, 30))
            label.text = array[i]
            view.addSubview(label)
            for j in 0..<5 {
                let button = UIButton.init(frame: CGRectMake(160+25*CGFloat(j), 10, 15, 15))
                button.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
                view.addSubview(button)
            }
          self.view.addSubview(view)
        }
    
        let button = UIButton.init(frame: CGRectMake(0, HEIGHT-108, WIDTH, 50))
        button.setTitle("发表评价", forState: UIControlState.Normal)
        button.backgroundColor = COLOR
        self.view.addSubview(button)
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
