//
//  WalletDetail2ViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class WalletDetail2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let mytableView = UITableView()
    let mainHelper = TCVMLogModel()
    var info = tiXianInfo()
    var dataSource = Array<tiXianInfo>()

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        self.getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现记录"
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }

    
    func getData(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as!String
        mainHelper.getTiXian(uid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success{
                hud.hidden = true
                alert("暂无数据或数据加载失败", delegate: self)
                return
            }
            self.dataSource = response as? Array<tiXianInfo> ?? []
            hud.hidden = true
            print(self.dataSource.count)
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
        mytableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()

        })
        self.view.addSubview(mytableView)
        
    }
    
    func headerRefresh(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as!String
        mainHelper.getTiXian(uid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success{
                hud.hidden = true
                self.mytableView.mj_header.endRefreshing()
                alert("暂无数据或数据加载失败", delegate: self)
                return
            }
            self.dataSource = response as? Array<tiXianInfo> ?? []
            self.mytableView.mj_header.endRefreshing()
            hud.hidden = true
            print(self.dataSource.count)
            self.createTableView()
            })
            
        }
        

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")as! walletDetailTableViewCell
        cell.shouRu.text = "提取金额："
        let info = self.dataSource[indexPath.row]
        cell.setValueWithMyInfo(info)
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
