//
//  FaDanDetailViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FaDanDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    let myTableView = UITableView()
    let mainHelper = MainHelper()
    var dataSource = NSMutableArray()
    var dataSource1 = fadanDetaiInfo()
    var dataSource3 : Array<chatInfo>?
    var info = TaskInfo()
    var helper = TCVMLogModel()
    var headerView = faDanDetailHeaderTableViewCell()
    var button = UIButton()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.hidden = true
        myTableView.userInteractionEnabled = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        self.title = "订单详情"
//        button.hidden = false
        self.getData()
       //TaskDetailTableViewCell2
        // Do any additional setup after loading the view.
    }
    
    func getData(){
    
        mainHelper.getFaDanDetail(info.id!) { (success, response) in
            print("----")
            print(response)
            print("----")
            let myinfo1:fadanDetaiInfo = response as! fadanDetaiInfo
            print(myinfo1)
            self.dataSource.addObject(myinfo1)
            self.dataSource1 = response as! fadanDetaiInfo

            self.createTableView()
        }

    }
    
    func createTableView(){
    
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "TaskDetailTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell")
        
        headerView = NSBundle.mainBundle().loadNibNamed("faDanDetailHeaderTableViewCell", owner: nil, options: nil).first as! faDanDetailHeaderTableViewCell
        
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, 50))
        button = UIButton.init(frame: CGRectMake(WIDTH-60, 0, 50, 30))
        //        button.backgroundColor = UIColor.redColor()
        button.setTitle("取消", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.quxiao), forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = COLOR
        view.addSubview(button)
        headerview()
        myTableView.tableHeaderView = headerView
        self.myTableView.tableFooterView = view
        self.view.addSubview(myTableView)

    
    }
    
    func headerview(){
        
        if dataSource1.apply?.name != nil {
            headerView.name.text = dataSource1.apply?.name
        }

        if dataSource1.apply?.photo==nil {
            headerView.iconImage.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+(dataSource1.apply?.photo)!
            print(photoUrl)
            headerView.iconImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }
        
        
        if self.dataSource1.time != nil  {
            let time = timeStampToString(self.dataSource1.time!)
            headerView.time.text = time
        }
        
        if self.dataSource1.paytime != nil {
            headerView.fuwucishu.text = "服务"+(self.dataSource1.apply?.servicecount)!+"次"
        }
        
        switch dataSource1.state! as String {
        case "0":
            headerView.frame = CGRectMake(0, 0, WIDTH, 75)
            headerView.button1.backgroundColor = COLOR
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = UIColor.lightGrayColor()
            headerView.button4.backgroundColor = UIColor.lightGrayColor()
            button.hidden = false

            alert("系统出现错误，请上报", delegate: self)
            self.navigationController?.popViewControllerAnimated(true)
        case "-1":
            headerView.frame = CGRectMake(0, 0, WIDTH, 75)
            headerView.button1.backgroundColor = COLOR
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = UIColor.lightGrayColor()
            headerView.button4.backgroundColor = UIColor.lightGrayColor()
            button.hidden = false
            
            alert("系统出现错误，请上报", delegate: self)
            self.navigationController?.popViewControllerAnimated(true)
        case "1":
            headerView.frame = CGRectMake(0, 0, WIDTH, 75)
            headerView.button1.backgroundColor = COLOR
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = UIColor.lightGrayColor()
            headerView.button4.backgroundColor = UIColor.lightGrayColor()
            button.hidden = false
        case "2":
            headerView.frame = CGRectMake(0, 0, WIDTH, 130)
            headerView.button1.backgroundColor = UIColor.lightGrayColor()
            headerView.button2.backgroundColor = COLOR
            headerView.button3.backgroundColor = UIColor.lightGrayColor()
            headerView.button4.backgroundColor = UIColor.lightGrayColor()
            button.hidden = false
        case "3":
            headerView.frame = CGRectMake(0, 0, WIDTH, 130)
            headerView.button1.backgroundColor = UIColor.lightGrayColor()
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = COLOR
            headerView.button4.backgroundColor = UIColor.lightGrayColor()
            button.hidden = true
        case "4":
            headerView.frame = CGRectMake(0, 0, WIDTH, 130)
            headerView.button1.backgroundColor = UIColor.lightGrayColor()
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = COLOR
            headerView.button4.backgroundColor = UIColor.lightGrayColor()
            button.hidden = true
        case "5":
            headerView.frame = CGRectMake(0, 0, WIDTH, 130)
            headerView.button1.backgroundColor = UIColor.lightGrayColor()
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = UIColor.lightGrayColor()
            headerView.button4.backgroundColor = COLOR
            button.hidden = true
        default:
            headerView.frame = CGRectMake(0, 0, WIDTH, 130)
            headerView.button1.backgroundColor = UIColor.lightGrayColor()
            headerView.button2.backgroundColor = UIColor.lightGrayColor()
            headerView.button3.backgroundColor = UIColor.lightGrayColor()
            headerView.button4.backgroundColor = COLOR
            button.hidden = true
        }
        
        headerView.callPhone.addTarget(self, action: #selector(self.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.message.addTarget(self, action: #selector(self.messageButtonAction), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK:取消订单
    func quxiao(){
        let myInfo = self.dataSource[0] as! fadanDetaiInfo
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid") as! String
        helper.cancleOrder(userid, taskid: info.id!) { (success, response) in
        
            print(response)
            alert("取消成功", delegate: self)
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
    
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return (self.dataSource?.count)!
//        
//        
//    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TaskDetailTableViewCell2
        cell.selectionStyle = .None
//        let myInfo = self.dataSource[0] as! fadanDetaiInfo
        let myInfo = dataSource1
        if indexPath.row == 0 {
            cell.title.text = "任务号"
            cell.desc.text = myInfo.order_num
            
        }else if indexPath.row == 1{
            
            cell.title.text = "任务"
            cell.desc.text = myInfo.title
        }else if indexPath.row == 2{
            
            cell.title.text = "服务费"
            cell.desc.text = myInfo.price
        }else if indexPath.row == 3{
            
            cell.title.text = "联系电话"
            cell.desc.text = myInfo.apply?.phone
            
        }else if indexPath.row == 4{
            
            cell.title.text = "上门地址"
            cell.desc.text = myInfo.address
        }else if indexPath.row == 5{
            
            cell.title.text = "服务地址"
            cell.desc.text = myInfo.address
//        }else if indexPath.row == 7{
//            
//            cell.title.text = "上门时间"
//            let time = timeStampToString(myInfo.time!)
//            cell.desc.text = time
        }else{
            
            cell.title.text = "有效期"
            let time = timeStampToString(myInfo.expirydate!)
            cell.desc.text = time
//            cell.desc.text = myInfo.order_num
        }
        return cell
    }
    
    
    func callPhone(){
        //        print(self.info?.phone)
        if loginSign == 0 {
            
            alert("请先登录", delegate: self)
            
        }else{
            
            if dataSource1.apply!.phone == nil || dataSource1.apply!.phone!.characters.count<0 {
                alert("未发布电话", delegate: self)
                return
            }else{
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "是否要拨打电话？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                
                                                UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://"+self.dataSource1.apply!.phone!)!)
                                                print(self.dataSource1.apply!.phone!)
                                                
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
            }
        }
    }

    func messageButtonAction() {
        myTableView.userInteractionEnabled = false
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            let vc = ChetViewController()
            vc.receive_uid = self.dataSource1.apply!.userid!
            //        vc.datasource2 = NSMutableArray()
            vc.titleTop = self.dataSource1.apply!.name!
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            if userid == self.dataSource1.apply!.userid{
                myTableView.userInteractionEnabled = true
                alert("请不要和自己说话", delegate: self)
            }else{
                mainHelper.getChatMessage(userid, receive_uid: self.dataSource1.apply!.userid!) { (success, response) in
                    
                    if !success {
                        alert("加载错误", delegate: self)
                        return
                    }
                    let dat = NSMutableArray()
                    self.dataSource3 = response as? Array<chatInfo> ?? []
                    print(self.dataSource3)
                    if self.dataSource3?.count != 0{
                        for num in 0...self.dataSource3!.count-1{
                            let dic = NSMutableDictionary()
                            dic.setObject(self.dataSource3![num].id!, forKey: "id")
                            dic.setObject(self.dataSource3![num].send_uid!, forKey: "send_uid")
                            dic.setObject(self.dataSource3![num].receive_uid!, forKey: "receive_uid")
                            dic.setObject(self.dataSource3![num].content!, forKey: "content")
                            dic.setObject(self.dataSource3![num].status!, forKey: "status")
                            dic.setObject(self.dataSource3![num].create_time!, forKey: "create_time")
                            if self.dataSource3![num].send_face != nil{
                                dic.setObject(self.dataSource3![num].send_face!, forKey: "send_face")
                            }
                            
                            if self.dataSource3![num].send_nickname != nil{
                                dic.setObject(self.dataSource3![num].send_nickname!, forKey: "send_nickname")
                            }
                            
                            if self.dataSource3![num].receive_face != nil{
                                dic.setObject(self.dataSource3![num].receive_face!, forKey: "receive_face")
                            }
                            
                            if self.dataSource3![num].receive_nickname != nil{
                                dic.setObject(self.dataSource3![num].receive_nickname!, forKey: "receive_nickname")
                            }
                            
                            
                            dat.addObject(dic)
                            
                            //                vc.datasource2.addObject(dic)
                            
                        }
                        
                        print(dat)
                        vc.datasource2 = NSArray.init(array: dat) as Array
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
