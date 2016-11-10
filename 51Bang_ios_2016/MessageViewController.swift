//
//  MessageViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
//    let helper = TCVMLogModel()
//    var dataSource = Array<MessInfo>()
    
    let mainhelper = MainHelper()
    var dataSource = Array<chatListInfo>()
    var dataSource2 = Array<chatInfo>()
    var receive_uid = String()
//    var dic = NSMutableDictionary()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        self.getData()
        myTableView.userInteractionEnabled = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        self.view.backgroundColor = UIColor.whiteColor()
        createTableView()
        
        // Do any additional setup after loading the view.
    }


    func getData(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        print(userid)
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"

        mainhelper.getChatList(userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success {
                hud.hidden = true
                alert("暂无数据", delegate: self)
                return
            }
            hud.hidden = true
            self.dataSource = response as? Array<chatListInfo> ?? []
            self.createTableView()
            print(self.dataSource)
            print(self.dataSource.count)
            self.myTableView.reloadData()
            })
        }
    }
        
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.delegate = self
        myTableView.dataSource = self

        myTableView.registerNib(UINib(nibName: "MessageTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
    
    }
    
    func headerRefresh(){
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        print(userid)
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        mainhelper.getChatList(userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success {
                hud.hidden = true
                self.myTableView.mj_header.endRefreshing()
                alert("暂无数据", delegate: self)
                return
            }
            hud.hidden = true
            self.dataSource = response as? Array<chatListInfo> ?? []
            self.myTableView.mj_header.endRefreshing()
            self.createTableView()
            print(self.dataSource)
            print(self.dataSource.count)
            self.myTableView.reloadData()
            })
        }

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
        
        tableView.userInteractionEnabled = false
        self.receive_uid = dataSource[indexPath.row].chat_uid!
        let vc = ChetViewController()
        vc.receive_uid = dataSource[indexPath.row].chat_uid!
//        vc.datasource2 = NSMutableArray()
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        
        mainhelper.getChatMessage(userid, receive_uid: receive_uid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success {
                alert("加载错误", delegate: self)
                return
            }
            let dat = NSMutableArray()
            self.dataSource2 = response as? Array<chatInfo> ?? []
            print(self.dataSource2)

            for num in 0...self.dataSource2.count-1{
                let dic = NSMutableDictionary()
                dic.setObject(self.dataSource2[num].id!, forKey: "id")
                dic.setObject(self.dataSource2[num].send_uid!, forKey: "send_uid")
                dic.setObject(self.dataSource2[num].receive_uid!, forKey: "receive_uid")
                if self.dataSource2[num].content != nil{
                    dic.setObject(self.dataSource2[num].content!, forKey: "content")
                }else{
                    dic.setObject("", forKey: "content")
                }
                if self.dataSource2[num].status != nil{
                    dic.setObject(self.dataSource2[num].status!, forKey: "status")
                }
                if self.dataSource2[num].create_time != nil{
                    dic.setObject(self.dataSource2[num].create_time!, forKey: "create_time")
                }
                
                if self.dataSource2[num].send_face != nil{
                    dic.setObject(self.dataSource2[num].send_face!, forKey: "send_face")
                }
                
                if self.dataSource2[num].send_nickname != nil{
                    dic.setObject(self.dataSource2[num].send_nickname!, forKey: "send_nickname")
                }
               
                if self.dataSource2[num].receive_face != nil{
                    dic.setObject(self.dataSource2[num].receive_face!, forKey: "receive_face")
                }
                
                if self.dataSource2[num].receive_nickname != nil{
                     dic.setObject(self.dataSource2[num].receive_nickname!, forKey: "receive_nickname")
                }
                
                
                dat.addObject(dic)
                
//                vc.datasource2.addObject(dic)
                
            }
                
            
            print(dat)
            vc.datasource2 = NSArray.init(array: dat) as Array
            vc.titleTop = self.dataSource[indexPath.row].other_nickname
//            if self.dataSource[indexPath.row].other_face! != ""{
//            let photoUrl:String = Bang_Open_Header+"uploads/images/"+self.dataSource[indexPath.row].my_face!
////                let url = NSURL(string: photoUrl)
//                vc.urlphoto = NSString.init(string: photoUrl) as String
//                print(vc.urlphoto)
//            }
            
            self.navigationController?.pushViewController(vc, animated: true)

            self.myTableView.reloadData()
            })
        }

        
        
//        getchatData()
        
        
        
        
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
