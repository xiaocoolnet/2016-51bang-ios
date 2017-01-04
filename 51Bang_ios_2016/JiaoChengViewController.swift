//
//  JiaoChengViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class JiaoChengViewController: UIViewController {

    let webView = UIWebView()
    var sign = Int()
    var url = NSURL()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if sign == 0 {
            self.title = "培训教程"
            self.url = NSURL(string:Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=6")!
        }else if sign == 1{
            self.title = "常见问题"
            self.url = NSURL(string:Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=5")!
        }else if sign == 2{
            self.title = "用户者服务协议"
            self.url = NSURL(string:Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=4")!
            
        }else if sign == 3{
            self.title = "评分"
            self.url = NSURL(string:"https://itunes.apple.com/us/app/51bang/id1126234890?l=zh&ls=1&mt=8")!
            
        }else if sign == 100{
            self.title = "推荐人机制"
            self.url = NSURL(string:Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=9")!
            
        }else if sign == 4{
            self.title = "用户提现"
            self.url = NSURL(string:Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=3")!
            
        }
        else{
            self.title = "关于51帮"
            self.url = NSURL(string:Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=8")!
        }
        self.view.backgroundColor = UIColor.whiteColor()
        webView.frame = CGRectMake(0, 0, WIDTH,HEIGHT)
        webView.loadRequest(NSURLRequest(URL: url))
        self.view.addSubview(webView)
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
