//
//  RushHomePageViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RushHomePageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var myTableView = UITableView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "抢单"
        self.createTableView()
        self.view.backgroundColor = UIColor.redColor()
        self.createRightItemWithTitle("我的任务")
        self.createLeftItem()
        // Do any additional setup after loading the view.
    }
    
    
    
    func createLeftItem(){
        let mySwitch = UISwitch.init(frame: CGRectMake(0, 0, 30, 30))
        
//        mySwitch.onImage = UIImage(named: "ic_xuanze")
//        mySwitch.offImage = UIImage(named: "")
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: mySwitch)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func createRightItemWithTitle(title:String){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 80, 40);
        button.setTitle(title, forState: UIControlState.Normal)
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = item
    }

    func createTableView(){
        myTableView.backgroundColor = RGREY
//        myTableView.backgroundColor = UIColor.blackColor()
        //        myTableView.style
        self.myTableView = UITableView.init(frame: CGRectMake(0, -64, WIDTH, self.view.frame.size.height), style: .Grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(SkillTableViewCell.self, forCellReuseIdentifier: "OneCell")
        myTableView.registerNib(UINib(nibName: "OrderTableViewCell",bundle: nil), forCellReuseIdentifier: "order")
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 120))
        let btn = UIButton(frame: CGRectMake(15, 30, WIDTH-30, 50))
        btn.layer.cornerRadius = 8
        btn.setTitle("确认提交", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
//        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        bottom.addSubview(btn)
//        myTableView.tableFooterView = bottom
        self.view.addSubview(myTableView)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order")
        return cell!
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
}
