//
//  LogisticsViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LogisticsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {

    let myTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查看物流"
        let headerView = NSBundle.mainBundle().loadNibNamed("LogisticsHeaderCell", owner: self, options: nil).first as! LogisticsHeaderCell
        headerView.frame = CGRectMake(0, 0, WIDTH, 100)
        
        myTableView.frame = CGRectMake(0, 100, WIDTH, HEIGHT-164)
//        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName: "LoginsticsTableViewCell",bundle: nil), forCellReuseIdentifier: "LoginsticsCell")
        let view = UIView.init(frame: CGRectMake(0, 100, 50, HEIGHT-100))
        view.backgroundColor = UIColor.whiteColor()
//   
//        let lineView = UIView.init(frame: CGRectMake(24, 18, 2, 100))
//        lineView.backgroundColor = RGREY
//        let imageView = UIImageView.init(frame: CGRectMake(21, 8, 10, 10))
//        imageView.backgroundColor = COLOR
   
        let lineView = UIView.init(frame: CGRectMake(24, 18, 2, 100))
        lineView.backgroundColor = RGREY
        let imageView = UIImageView.init(frame: CGRectMake(21, 8, 10, 10))
        imageView.backgroundColor = COLOR
        view.addSubview(imageView)
        view.addSubview(lineView)
        
        imageView.layer.cornerRadius = 5
//        self.view.addSubview(view)
        self.view.addSubview(headerView)
        self.view.addSubview(myTableView)
        
        // Do any additional setup after loading the view.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
            return 100

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        tableView.separatorStyle = .None
        let cell = tableView.dequeueReusableCellWithIdentifier("LoginsticsCell")
        cell?.selectionStyle = .None
    
        return cell!
    
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
