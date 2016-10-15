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
    private  let Titles:[String] = ["培训教程","常见问题","用户者服务协议","去评分","清除缓存"]
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
                var fileArray = [String]()
                let defauleManager = NSFileManager.defaultManager
                let tempPath = NSTemporaryDirectory()
                var dic = NSDictionary()
                var pathNum = UInt64()
                do{
                   try fileArray = defauleManager().contentsOfDirectoryAtPath(tempPath)
                    
                }catch{
                    
                }
                print(dic)
                print(fileArray)
                if fileArray.count>0 {
                    for path in fileArray {
                        do{
                            try dic = defauleManager().attributesOfItemAtPath(tempPath+"/"+path)
                            try defauleManager().removeItemAtPath(tempPath+"/"+path)
                            pathNum = pathNum + dic.fileSize()
                        }catch{
                            
                        }
                    }
                }
                
                let string = String(format: "%.2f" , pathNum/1024/1024)
            
                alert("已清除"+string  + "M缓存", delegate: self)
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
        userDatas.removeObjectForKey("userid")
        if userDatas.objectForKey("name") != nil {
            userDatas.removeObjectForKey("name")
        }
        
        if userDatas.objectForKey("photo") != nil {
            userDatas.removeObjectForKey("photo")
        }
        if userDatas.objectForKey("sex") != nil {
            userDatas.removeObjectForKey("sex")
        }
        
        if userDatas.objectForKey("pwd") != nil {
            userDatas.removeObjectForKey("pwd")
        }
         if userDatas.objectForKey("userphoto") != nil {
           userDatas.removeObjectForKey("userphoto")
        }
        
        if userDatas.objectForKey("ss") != nil {
            userDatas.removeObjectForKey("ss")
        }
        
        
        JPUSHService.setTags(nil, aliasInbackground: "99999999")
        NSNotificationCenter.defaultCenter().postNotificationName("getRegistrationID", object: nil)
        
        loginSign = 0
        let a = MineViewController()
        self.navigationController?.pushViewController(a, animated: true)
    }

   
}
