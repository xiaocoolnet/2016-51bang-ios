//
//  MessageViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
//    let helper = TCVMLogModel()
//    var dataSource = Array<MessInfo>()
    
    let mainhelper = MainHelper()
    var dataSource = Array<chatListInfo>()
    var dataSource2 = Array<chatInfo>()
    var receive_uid = String()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        self.getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        self.view.backgroundColor = UIColor.whiteColor()
        createTableView()
        
        // Do any additional setup after loading the view.
    }

//    func getData(){
//    
//        let ud = NSUserDefaults.standardUserDefaults()
//        let userid = ud.objectForKey("userid")as! String
//        helper.getMessage(userid) { (success, response) in
//            if !success {
//                return
//            }
//            self.dataSource = response as? Array<MessInfo> ?? []
//            self.createTableView()
//            print(self.dataSource)
//            print(self.dataSource.count)
//            
//        }
//    
//    }
    
    func getData(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        print(userid)
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"

        mainhelper.getChatList(userid) { (success, response) in
            if !success {
                return
            }
            hud.hidden = true
            self.dataSource = response as? Array<chatListInfo> ?? []
            self.createTableView()
            print(self.dataSource)
            print(self.dataSource.count)
            self.myTableView.reloadData()
        }
    }
    
        func getchatData(){
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            
            mainhelper.getChatMessage(userid, receive_uid: receive_uid) { (success, response) in
                
            if !success {
                return
            }
            self.dataSource2 = response as? Array<chatInfo> ?? []
            print(self.dataSource2)
            print(self.dataSource2.count)
            self.myTableView.reloadData()
            }
            
        }
//        helper.getMessage(userid) { (success, response) in
//            if !success {
//                return
//            }
//            self.dataSource = response as? Array<MessInfo> ?? []
//            self.createTableView()
//            print(self.dataSource)
//            print(self.dataSource.count)
//            
//        }
        
        
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.delegate = self
        myTableView.dataSource = self

        myTableView.registerNib(UINib(nibName: "MessageTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorStyle = .None
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MessageTableViewCell
//        print(self.dataSource[indexPath.row])
        cell.selectionStyle = .None
        if self.dataSource.count != 0 {
            cell.setValueWithInfo(self.dataSource[indexPath.row])
        }
        
//        dataSource[indexPath.row].chat_uid
        return cell
        
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.dataSource.count != 0 {
            
            return self.dataSource.count
            
        }else{
            
            return 0
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
//        let vc = MessageDetailViewController()
//        vc.index = indexPath.row
//        vc.arr = self.dataSource
//        self.navigationController?.pushViewController(vc, animated: true)
        self.receive_uid = dataSource[indexPath.row].chat_uid!
        let vc = ChetViewController()
        vc.receive_uid = dataSource[indexPath.row].chat_uid!
        
        getchatData()
//        vc.datasource2 = self.dataSource2
        self.navigationController?.pushViewController(vc, animated: true)
        
        
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
