//
//  WallectDetailViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class WallectDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    let mytableView = UITableView()
    let mainHelper = TCVMLogModel()
    var info = walletDetailInfo()
    var dataSource = Array<walletDetailInfo>()
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收支记录"
        self.view.backgroundColor = UIColor.whiteColor()
        self.getData()
        //http://bang.xiaocool.net/index.php?g=apps&m=index&a=GetMyWalletLog&userid=127
        // Do any additional setup after loading the view.
    }

    
    func getData(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.mode = .Text
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        var uid = String()
        if ud.objectForKey("userid") != nil{
            uid = ud.objectForKey("userid")as!String
        }
        
        mainHelper.getShouZhi(uid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            self.dataSource = response as? Array<walletDetailInfo> ?? []
            hud.hidden = true
            print(self.dataSource.count)
//            self.info = response as! walletDetailInfo
            self.createTableView()
            })

        }

    
    }
    
    func createTableView(){
    
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        mytableView.delegate = self
        mytableView.dataSource = self
        mytableView.registerNib(UINib(nibName: "walletDetailTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        let view = UIView()
        mytableView.tableFooterView = view
        mytableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
        print("MJ:(下拉刷新)")
        self.headerRefresh()
        
        })

        self.view.addSubview(mytableView)
    
    }
    
    func headerRefresh(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.mode = .Text
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as!String
        mainHelper.getShouZhi(uid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            self.mytableView.mj_header.endRefreshing()
            self.dataSource = response as? Array<walletDetailInfo> ?? []
            hud.hidden = true
            print(self.dataSource.count)
            self.createTableView()
            })
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")as! walletDetailTableViewCell
        let info = self.dataSource[indexPath.row]
        cell.setValueWithInfo(info)
        return cell
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
