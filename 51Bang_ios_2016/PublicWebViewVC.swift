//
//  PublicWebViewVC.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/25.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class PublicWebViewVC: UIViewController,UIWebViewDelegate {
    
    var url = NSURL()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.tabBarController?.tabBar.hidden = true
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        let webView = UIWebView()
        webView.backgroundColor = GREY
        webView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        webView.loadRequest(NSURLRequest(URL:url))
//        print(url.absoluteString)
        webView.delegate = self
        self.view.addSubview(webView)
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
