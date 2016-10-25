//
//  ConnectionViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var info = TaskInfo()
    let button5 = UIButton()
    let mainHelper = MainHelper()
    var sign = Int()
    let myTableView = UITableView()
    var shangMenLocation = NSString()
    var fuWuLocation = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.backgroundColor = RGREY
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.registerNib(UINib(nibName: "MyOrderTableViewCell",bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
        let button4 = UIButton.init(frame: CGRectMake(10, HEIGHT-150, WIDTH/2-20, 40))
        button4.tag = 4
        button4.setTitle("联系对方", forState: UIControlState.Normal)
        button4.backgroundColor = UIColor.orangeColor()
        button4.addTarget(self, action: #selector(self.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
        button4.layer.cornerRadius = 10
        button5.frame = CGRectMake(WIDTH/2+10, HEIGHT-150, WIDTH/2-20, 40)
        if info.state == "2" {
            button5.setTitle("已上门", forState: UIControlState.Normal)
            button5.backgroundColor = COLOR
            button5.addTarget(self, action: #selector(self.button5Action), forControlEvents: UIControlEvents.TouchUpInside)
        }else if info.state == "3" || info.state == "4"{
        
            button5.setTitle("完成服务", forState: UIControlState.Normal)
            button5.backgroundColor = COLOR
            button5.addTarget(self, action: #selector(self.button5Action), forControlEvents: UIControlEvents.TouchUpInside)
        }else if info.state == "-1"{
        
            button5.setTitle("完成服务", forState: UIControlState.Normal)
            button5.enabled = false
            button5.backgroundColor = RGREY
            
        }
        
        button5.tag = 5
        button5.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button5.layer.cornerRadius = 10
        self.view.addSubview(myTableView)
        self.view.addSubview(button4)
        self.view.addSubview(button5)
        // Do any additional setup after loading the view.
    }
    
    func button5Action() {
        button5.enabled = false
        print(info.order_num!)
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        print(userid)
        if info.state == "2" {
            mainHelper.gaiBianRenWu(userid,ordernum: info.order_num!, state: "3", handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                     alert("通知失败，请重试", delegate: self)
                    self.button5.enabled = true
                    return
                }
                 alert("已通知对方,请等待对方确认", delegate: self)
                })
            })
        }else if info.state == "3" {
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            mainHelper.gaiBianRenWu(userid,ordernum: info.order_num!, state: "4", handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    self.button5.enabled = true
                    alert("通知失败，请重试", delegate: self)
                    return
                }
                alert("已通知对方,请等待对方确认", delegate: self)
                
            })
            })
            
        }
        
//        let vc = MyTaskViewController()
//        vc.info = self.info
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func callPhone() {
        
        let alertController = UIAlertController(title: "系统提示",
                                                message: "是否要拨打电话？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        
                                        UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://"+self.info.phone! as String)!)
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 180
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(self.info)
        tableView.separatorStyle = .None
        let cell = tableView.dequeueReusableCellWithIdentifier("MyOrderTableViewCell")as! MyOrderTableViewCell
        cell.shangmenMap.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        cell.fuwuMap.addTarget(self, action: #selector(self.nextView1), forControlEvents: UIControlEvents.TouchUpInside)
        self.shangMenLocation = cell.shangmen.text!
        cell.selectionStyle = .None
        cell.setValueWithInfo(info)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = TaskDetailViewController()
        vc.taskInfo = info
        vc.qiangdanBut = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func nextView(){
        
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        if info.latitude != nil && info.longitude != nil && info.latitude != "" && info.longitude != ""{
            coor1.latitude = CLLocationDegrees(info.latitude! as String)!
            coor1.longitude = CLLocationDegrees(info.longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if self.info.address != nil && self.info.address != ""{
            start.name = self.info.address!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
//        start.name = self.info.address!
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if info.slatitude != nil && info.slongitude != nil && info.slatitude != "" && info.slongitude != ""{
            coor2.latitude = CLLocationDegrees(info.slatitude! as String)!
            coor2.longitude = CLLocationDegrees(info.slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.info.saddress != nil && self.info.saddress != ""{
            end.name = self.info.saddress!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
        
//        let locationVc = LocationViewController()
//        //        LocationViewController.myAddressOfpoint = self.dataSource![sender.tag].address!
//        //        let latitudeStr1 = self.dataSource![sender.tag].latitude! as NSString
//        //        let longitudeStr1 = self.dataSource![sender.tag].longitude! as NSString
//        //        LocationViewController.pointOfSelected = CLLocationCoordinate2D.init(latitude: latitudeStr1.doubleValue, longitude: longitudeStr1.doubleValue)
//        print(self.info.latitude)
//        //        print(self.dataSource![sender.tag].longitude)
//        locationVc.isWobangPush = true
//        locationVc.addressPoint = self.info.address!
//        if info.latitude == nil {
//            locationVc.latitudeStr = ""
//        }else{
//            locationVc.latitudeStr = info.latitude!
//        }
//        if info.longitude == nil{
//            locationVc.longitudeStr = ""
//        }else{
//            locationVc.longitudeStr = self.info.longitude!
//        }
//        
//        
//        self.navigationController?.pushViewController(locationVc, animated: true)

    }

    func nextView1(){
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        if info.latitude != nil && info.longitude != nil && info.latitude != "" && info.longitude != ""{
            coor1.latitude = CLLocationDegrees(info.latitude! as String)!
            coor1.longitude = CLLocationDegrees(info.longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if self.info.address != nil && self.info.address != ""{
            start.name = self.info.address!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        //        start.name = self.info.address!
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if info.slatitude != nil && info.slongitude != nil && info.slatitude != "" && info.slongitude != ""{
            coor2.latitude = CLLocationDegrees(info.slatitude! as String)!
            coor2.longitude = CLLocationDegrees(info.slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.info.saddress != nil && self.info.saddress != ""{
            end.name = self.info.saddress!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)

    
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
