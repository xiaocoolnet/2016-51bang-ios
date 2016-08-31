//
//  sexView.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
class sexView: UITableViewController {
    
    var myDelegate:MineDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView.init(frame: self.tableView.frame, style: UITableViewStyle.Grouped)
        self.view.backgroundColor = UIColor(red:  242/255, green: 242 / 255, blue: 242 / 255, alpha: 1.0)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SexCell.init()
        if(indexPath.row==0&&indexPath.section==0)
        {
        cell.usrLabel.text = "男"
        
        }else{
        cell.usrLabel.text = "女"
       
        }
        return cell
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         var flag = "1"
        if(indexPath.row==0&&indexPath.section==0)
         {
            myDelegate?.updateSex(0)
            self.navigationController?.popViewControllerAnimated(true)
            flag = "1"
            
         }else{
        myDelegate?.updateSex(1)
        self.navigationController?.popViewControllerAnimated(true)
            flag = "0"
        }
        
            let urlHeader = Bang_URL_Header + "UpdateUserSex"
            let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
            
            let param = ["userid":id,"sex":flag]
            let userData = NSUserDefaults.standardUserDefaults()
            Alamofire.request(.GET, urlHeader, parameters: param).response
                {
                    request, response, json, error in
                    
                    let result = MineGetModel(JSONDecoder(json!))
                    if(result.status == "success")
                    {
                        print("修改性别成功")
                        userData.setObject(flag, forKey: "sex")
                    }else{
                    
                        print("修改性别失败")
                    }
        
        
        }
        
    }
    
    
}
