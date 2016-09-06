//
//  ServiceViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
    }
    private  var mTable = UITableView()
    private  let Titles:[String] = ["培训教程","常见问题","法律协议","去评分","清除缓存"]
    override func viewDidLoad() {
        super.viewDidLoad()
        mTable = UITableView.init(frame: CGRectMake(0, 0, WIDTH, self.view.frame.height), style: UITableViewStyle.Grouped)
        mTable.delegate = self
        mTable.dataSource = self
        self.view.addSubview(mTable)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
        
            return 5
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if(indexPath.section == 1){
                
                logOut()
   
        }else if indexPath.section == 0{
            if indexPath.row == 3 {
                alert("暂未上架,无法评分", delegate: self)
            }else if indexPath.row == 4{
            
                alert("缓存已清除", delegate: self)
            }else{
                let vc = JiaoChengViewController()
                vc.sign = indexPath.row
                self.navigationController?.pushViewController(vc, animated: true)
            }
        
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if(indexPath.section == 0)
        {
            cell.textLabel?.text = Titles[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell.textLabel?.text = "退出登录"
            cell.textLabel?.textColor = COLOR
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    func logOut()
    {
        let userDatas = NSUserDefaults.standardUserDefaults()
        print(userDatas.objectForKey("userid"))
        userDatas.removeObjectForKey("userid");
        
        loginSign = 0
        let a = MineViewController()
        self.navigationController?.pushViewController(a, animated: true)
    }

   
}
