//
//  MyTaskViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class MyTaskViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView = UITableView()
//    var leftTableView = UITableView()
//    var rightTableView = UITableView()
    let label = UILabel()
    var info = TaskInfo()
    let mainHelper = MainHelper()
    var dataSource : Array<TaskInfo>?
    var dataSource1 : Array<TaskInfo>?
    var dataSource2 : Array<TaskInfo>?
    var myDataSource : Array<TaskInfo>?
    var sign = Int()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.createTableView()
        self.myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
        self.headerRefresh()
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sign = 0
//        label.frame = CGRectMake(WIDTH/3, 50, WIDTH/3, 2)
        label.backgroundColor = COLOR
//        self.GetWKSData("2")
        self.showLeft()
        self.title = "我的任务"
        self.view.backgroundColor = RGREY
//        leftTableView.frame = CGRectMake(0,62, WIDTH, HEIGHT - 64 - 50)
//        leftTableView.tag = 0
////        leftTableView.hidden = true
//        leftTableView.registerNib(UINib(nibName: "myOrderLocationTableViewCell",bundle: nil), forCellReuseIdentifier: "location")
//        leftTableView.registerNib(UINib(nibName: "MyTaskTableViewCell1",bundle: nil), forCellReuseIdentifier: "cell1")
//        leftTableView.registerNib(UINib(nibName: "MyTaskTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell2")
//        leftTableView.backgroundColor = UIColor.redColor()
//        rightTableView.frame = CGRectMake(0, 62, WIDTH, HEIGHT - 64 - 50)
//        rightTableView.tag = 2
////        rightTableView.hidden = true
//        rightTableView.backgroundColor = UIColor.blueColor()
//        rightTableView.registerNib(UINib(nibName: "myOrderLocationTableViewCell",bundle: nil), forCellReuseIdentifier: "location")
//        rightTableView.registerNib(UINib(nibName: "MyTaskTableViewCell1",bundle: nil), forCellReuseIdentifier: "cell1")
//        rightTableView.registerNib(UINib(nibName: "MyTaskTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell2")
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, 52))
        view.backgroundColor = UIColor.whiteColor()
        let button1 = UIButton.init(frame: CGRectMake(0, 0, WIDTH/3, 50))
        button1.setTitle("未开始", forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.showLeft), forControlEvents: UIControlEvents.TouchUpInside)
        button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        let button2 = UIButton.init(frame: CGRectMake(WIDTH/3, 0, WIDTH/3, 50))
        button2.setTitle("进行中", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button2.addTarget(self, action: #selector(self.showMid), forControlEvents: UIControlEvents.TouchUpInside)
        let button3 = UIButton.init(frame: CGRectMake(WIDTH*2/3, 0, WIDTH/3, 50))
        button3.setTitle("已取消", forState: UIControlState.Normal)
        button3.addTarget(self, action: #selector(self.showRight), forControlEvents:  UIControlEvents.TouchUpInside)
        button3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(label)
        self.view.addSubview(view)
       
        
//        self.view.addSubview(leftTableView)
//        self.view.addSubview(rightTableView)
        
       
        // Do any additional setup after loading the view.
    }
    
    func GetWKSData(state:NSString){
    
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
//        hud.mode = .Text
        hud.labelText = "正在努力加载"
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        mainHelper.getMyGetOrder (userid,state: state,handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.myTableView.mj_header.endRefreshing()
                    hud.hidden = true
                    return
                    
                }
                self.myTableView.mj_header.endRefreshing()
                print(response)
                hud.hidden = true
                if state == "2"{
                    self.dataSource?.removeAll()
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    print(self.dataSource?.count)
//                    alert("还没有未开始的任务", delegate: self)
//                    if self.dataSource!.count == 0{
//                        alert("还没有未开始的任务", delegate: self)
//                        self.myTableView.reloadData()
//                        return
//                    }
                }else if state == "3"{
                    self.dataSource1?.removeAll()
                    self.dataSource1 = response as? Array<TaskInfo> ?? []
                     print(self.dataSource1?.count)
                    
                }else if state == "-1"{
                    self.dataSource2?.removeAll()
                    self.dataSource2 = response as? Array<TaskInfo> ?? []
                     print(self.dataSource2?.count)
                }

                print(self.dataSource?.count)
                print(self.dataSource1?.count)
                print(self.dataSource2?.count)
                
                self.myTableView.reloadData()
                //self.configureUI()
            })
            
            })
    }
    
    func createTableView(){
    
        
        self.myTableView.frame = CGRectMake(0, 62, WIDTH, HEIGHT - 64 - 50 )
        self.myTableView.tag = 1
        self.myTableView.backgroundColor = UIColor.whiteColor()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.myTableView.registerNib(UINib(nibName: "MyOrderTableViewCell",bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
        self.myTableView.registerNib(UINib(nibName: "myOrderLocationTableViewCell",bundle: nil), forCellReuseIdentifier: "location")
        self.myTableView.registerNib(UINib(nibName: "MyTaskTableViewCell1",bundle: nil), forCellReuseIdentifier: "cell1")
        self.myTableView.registerNib(UINib(nibName: "MyTaskTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell2")
        
        
        
//        let button4 = UIButton.init(frame: CGRectMake(10, HEIGHT-150, WIDTH/2-20, 50))
//        button4.tag = 4
//        button4.setTitle("联系对方", forState: UIControlState.Normal)
//        button4.backgroundColor = UIColor.orangeColor()
//        button4.layer.cornerRadius = 10
//        let button5 = UIButton.init(frame: CGRectMake(WIDTH/2+10, HEIGHT-150, WIDTH/2-20, 50))
//        button5.setTitle("完成服务", forState: UIControlState.Normal)
//        button5.tag = 5
//        button5.backgroundColor = COLOR
//        button5.layer.cornerRadius = 10
        self.view.addSubview(self.myTableView)
//        self.view.addSubview(button4)
//        self.view.addSubview(button5)
    }
    
    func headerRefresh(){
        if sign == 0 {
            self.GetWKSData("2")
        }else if sign == 1{
            self.GetWKSData("3")
        }else{
            self.GetWKSData("-1")
        }
        
    }
    
    
    func showLeft(){
        label.frame = CGRectMake(0, 50, WIDTH/3, 2)
        sign = 0
        self.GetWKSData("2")
//        self.myTableView.reloadData()
//        myTableView.hidden = true
//        leftTableView.hidden = false
//        rightTableView.hidden = true
//        leftTableView.reloadData()
    }
    
    func showMid(){
    
        label.frame = CGRectMake(WIDTH/3, 50, WIDTH/3, 2)
        sign = 1
        self.GetWKSData("3")
//        self.myTableView.reloadData()
//        myTableView.hidden = false
//        leftTableView.hidden = true
//        rightTableView.hidden = true
//        myTableView.reloadData()
//        let button5 = self.view.viewWithTag(5)as! UIButton
    }
    
    func showRight(){
        label.frame = CGRectMake(WIDTH*2/3, 50, WIDTH/3, 2)
        sign = 2
        self.GetWKSData("-1")
//        self.myTableView.reloadData()
//        myTableView.hidden = true
//        leftTableView.hidden = true
//        rightTableView.hidden = false
//        rightTableView.reloadData()
    }
    
    func  numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
//        if sign == 0 {
////            print(self.dataSource?.count)
//            if dataSource != nil{
//                return dataSource!.count
//            }else{
//                return 0
//            }
//        }else if sign == 1{
//            if dataSource1 != nil{
//                return dataSource1!.count
//            }else{
//           return 0
//            }
//        }else{
//            if dataSource2 != nil{
//                return dataSource2!.count
//            }else{
//                return 0
//            }
//        }
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, 10))
        view.backgroundColor = RGREY
        return view
    }

//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
        if sign == 0 {
//            print(self.dataSource?.count)
            if dataSource != nil{
                return dataSource!.count
            }else{
                return 0
            }
        }else if sign == 1{
            
            if dataSource1 != nil{
                return dataSource1!.count
            }else{
                return 0
            }
            
        }else{
            if dataSource2 != nil{
                return dataSource2!.count
            }else{
                return 0
            }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            return 200
    }
    
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
            tableView.separatorStyle = .None
        
            if sign == 0 {
                label.frame = CGRectMake(0, 50, WIDTH/3, 2)
                print(self.dataSource?.count)
                if self.dataSource!.count == 0{
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier("cell")
                    return cell!
                }else{
                    info = self.dataSource![indexPath.row]
                    self.myDataSource = self.dataSource
                    print(info)
                }
                
                
            }else if sign == 1{
                label.frame = CGRectMake(WIDTH/3, 50, WIDTH/3, 2)
                if self.dataSource1!.count == 0{
                    alert("还没有进行中的任务", delegate: self)
                    let cell = tableView.dequeueReusableCellWithIdentifier("cell")
                    return cell!
                }else{
                    info = self.dataSource1![indexPath.row]
                    self.myDataSource = self.dataSource1
                    print(info)
                }
 
            }else{
                label.frame = CGRectMake(WIDTH*2/3, 50, WIDTH/3, 2)
                if self.dataSource2!.count == 0{
                    alert("还没有已取消的任务", delegate: self)
                    let cell = tableView.dequeueReusableCellWithIdentifier("cell")
                    return cell!
                }else{
                    print(self.dataSource2?.count)
                    info = self.dataSource2![indexPath.row]
                    self.myDataSource = self.dataSource2
                    print(info)
                }
                
            }
        
            let cell = tableView.dequeueReusableCellWithIdentifier("MyOrderTableViewCell")as! MyOrderTableViewCell
        cell.shangmenMap.addTarget(self, action: #selector(self.dingwei(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.shangmenMap.tag = indexPath.row
        cell.fuwuMap.tag = indexPath.row+100

        cell.fuwuMap.addTarget(self, action: #selector(self.nextView1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.selectionStyle = .None
            cell.setValueWithInfo(info)
        
            return cell
     }
    
    func dingwei(sender:UIButton){
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        var mydataSource : Array<TaskInfo>?
        
        
        
        if sign == 0 {
            
            mydataSource = dataSource
        }else if sign == 1{
            mydataSource = dataSource1
            
            
        }else{
            mydataSource = dataSource2
        }
//        print(dataSource)
//        print(dataSource![sender.tag])
//        print(dataSource![sender.tag].latitude!)
//        print(dataSource![sender.tag].longitude!)
//        print(dataSource![sender.tag].slatitude!)
//        print(dataSource![sender.tag].slongitude!)
        
        if mydataSource![sender.tag].latitude != nil && mydataSource![sender.tag].longitude != nil && mydataSource![sender.tag].latitude != "" && mydataSource![sender.tag].longitude != ""{
            coor1.latitude = CLLocationDegrees(mydataSource![sender.tag].latitude! as String)!
            coor1.longitude = CLLocationDegrees(mydataSource![sender.tag].longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if mydataSource![sender.tag].address != nil && mydataSource![sender.tag].address != ""{
            start.name = mydataSource![sender.tag].address!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if mydataSource![sender.tag].slatitude != nil && mydataSource![sender.tag].slongitude != nil && mydataSource![sender.tag].slatitude != "" && mydataSource![sender.tag].slongitude != ""{
            coor2.latitude = CLLocationDegrees(mydataSource![sender.tag].slatitude! as String)!
            coor2.longitude = CLLocationDegrees(mydataSource![sender.tag].slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if mydataSource![sender.tag].saddress != nil && mydataSource![sender.tag].saddress != "" {
            end.name = mydataSource![sender.tag].saddress!
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
////        print(self.info.latitude)
////        print(self.dataSource![sender.tag].longitude)
//        locationVc.isWobangPush = true
//        locationVc.addressPoint = self.myDataSource![sender.tag].address!
//        if info.latitude == nil {
//            locationVc.latitudeStr = ""
//        }else{
//            locationVc.latitudeStr = self.myDataSource![sender.tag].latitude!
//        }
//        if info.longitude == nil{
//            locationVc.longitudeStr = ""
//        }else{
//            locationVc.longitudeStr = self.myDataSource![sender.tag].longitude!
//        }
//        
//        
//        self.navigationController?.pushViewController(locationVc, animated: true)
        
    }
    func nextView1(sender:UIButton){
        
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        var mydataSource : Array<TaskInfo>?
        
        
        
        if sign == 0 {
            
            mydataSource = dataSource
        }else if sign == 1{
            mydataSource = dataSource1
            
            
        }else{
            mydataSource = dataSource2
        }
        //        print(dataSource)
        //        print(dataSource![sender.tag])
        //        print(dataSource![sender.tag].latitude!)
        //        print(dataSource![sender.tag].longitude!)
        //        print(dataSource![sender.tag].slatitude!)
        //        print(dataSource![sender.tag].slongitude!)
        
        if mydataSource![sender.tag-100].latitude != nil && mydataSource![sender.tag-100].longitude != nil && mydataSource![sender.tag-100].latitude != "" && mydataSource![sender.tag-100].longitude != ""{
            coor1.latitude = CLLocationDegrees(mydataSource![sender.tag-100].latitude! as String)!
            coor1.longitude = CLLocationDegrees(mydataSource![sender.tag-100].longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if mydataSource![sender.tag-100].address != nil && mydataSource![sender.tag-100].address != ""{
            start.name = mydataSource![sender.tag-100].address!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if mydataSource![sender.tag-100].slatitude != nil && mydataSource![sender.tag-100].slongitude != nil && mydataSource![sender.tag-100].slatitude != "" && mydataSource![sender.tag-100].slongitude != ""{
            coor2.latitude = CLLocationDegrees(mydataSource![sender.tag-100].slatitude! as String)!
            coor2.longitude = CLLocationDegrees(mydataSource![sender.tag-100].slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if mydataSource![sender.tag-100].saddress != nil && mydataSource![sender.tag-100].saddress != "" {
            end.name = mydataSource![sender.tag-100].saddress!
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
//        locationVc.addressPoint = self.myDataSource![sender.tag-100].saddress!
//        if info.slatitude == nil {
//            locationVc.latitudeStr = ""
//        }else{
//            locationVc.latitudeStr = self.myDataSource![sender.tag-100].slatitude!
//        }
//        if info.longitude == nil{
//            locationVc.longitudeStr = ""
//        }else{
//            locationVc.longitudeStr = self.myDataSource![sender.tag-100].slongitude!
//        }
//        
//        
//        self.navigationController?.pushViewController(locationVc, animated: true)
//        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ConnectionViewController()
       
        vc.info = self.myDataSource![indexPath.row]
        vc.sign = sign
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
