//
//  WoBangViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class WoBangPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    var myTableView = UITableView()
    let mainHelper = MainHelper()
    let pushMapButton = UIButton()
    let cityName = String()
    var longitude = String()
    var latitude = String()
    var dataSource : Array<TaskInfo>?
    var geocoder = CLGeocoder()
    var distance = NSString()
//    var qiangdanButton = true
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        self.title = ""
//        self.navigationController!.title = "我帮"
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        self.GetData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
      
        print(self.latitude)
        print(self.longitude)

        self.title = "抢单"
        self.createRightItemWithTitle("我的任务")
//        self.createTableView()
//        self.GetData()

//        self.view.backgroundColor = UIColor.redColor()
//        self.createLeftItemWithTitle("")
//        self.createRightItem()
        // Do any additional setup after loading the view.
    }
    
    
    
    func createRightItemWithTitle(title:String){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 80, 40);
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.myTask), forControlEvents: UIControlEvents.TouchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func myTask(){
        
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            let vc = MyTaskViewController()
            vc.navigationController?.title = "我的任务"
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    
    func GetData(){
    
//        shopHelper.getGoodsList({[unowned self] (success, response) in
//            dispatch_async(dispatch_get_main_queue(), {
//                if !success {
//                    return
//                }
//                print(response)
//                self.dataSource = response as? Array<GoodsInfo> ?? []
//                print(self.dataSource)
//                print(self.dataSource?.count)
//                self.createTableView()
//                //                self.ClistdataSource = response as? ClistList ?? []
//                self.myTableView.reloadData()
//                //self.configureUI()
//            })
//            })
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.labelText = "正在努力加载"
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            print(self.latitude)
            print(self.latitude)
            mainHelper.getTaskList (userid,beginid:"-1",cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        print(success)
                        return
//                        alert("暂无数据", delegate: self)
                    }
                    hud.hide(true)
                    print(response)
                    
                   
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    print(self.dataSource)
                    print(self.dataSource?.count)
                    if self.dataSource?.count == 0{
                        alert("暂无数据", delegate: self)
                    }
                    print(self.dataSource?.count)
                    self.createTableView()
                    //                self.ClistdataSource = response as? ClistList ?? []
                    self.myTableView.reloadData()
                    //self.configureUI()
                })
                
            })
        }
 
    }
    
    func createRightItem(){
        let mySwitch = UISwitch.init(frame: CGRectMake(0, 0, 40, 40))
        //        mySwitch.onImage = UIImage(named: "ic_xuanze")
        //        mySwitch.offImage = UIImage(named: "")
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: mySwitch)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func createLeftItemWithTitle(title:String){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 40, 40);
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func createTableView(){
        myTableView.backgroundColor = RGREY
        self.myTableView = UITableView.init(frame: CGRectMake(0, -38, WIDTH, HEIGHT - 64 + 38), style: .Grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerNib(UINib(nibName: "OrderTableViewCell",bundle: nil), forCellReuseIdentifier: "order")
        myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
//        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH/2, 120))
        let btn = UIButton(frame: CGRectMake(0, HEIGHT-110, WIDTH/2,50))
        btn.alpha = 0.7
        btn.setTitle("我的任务", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.grayColor()
        let label = UILabel()
        label.frame = CGRectMake(WIDTH/2, HEIGHT-109, 1, btn.frame.size.height-2)
        label.backgroundColor = UIColor.whiteColor()
        let btn2 = UIButton(frame: CGRectMake(WIDTH/2, HEIGHT-110, WIDTH/2,50))
        btn2.alpha = 0.7
        btn2.setTitle("刷新列表", forState: .Normal)
        btn2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn2.backgroundColor = UIColor.grayColor()
        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(myTableView)
//        self.view.addSubview(btn)
//        self.view.addSubview(btn2)
//        self.view.addSubview(label)
       
    }
    
    func headerRefresh(){
        if loginSign == 0 {
            self.tabBarController?.selectedIndex = 3
        }else{
            
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String

            mainHelper.getTaskList (userid,beginid: "-1",cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        print(success)
                        self.myTableView.mj_header.endRefreshing()
                        return
                    }
                    print(response)
                    self.dataSource?.removeAll()
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    self.myTableView.mj_header.endRefreshing()
                    print(self.dataSource)
                    print(self.dataSource?.count)
                    if self.dataSource?.count == 0{
                        alert("暂无数据", delegate: self)
                    }
                    print(self.dataSource?.count)
                    self.createTableView()
                    
                    self.myTableView.reloadData()
                    
                })
                
                })
        }

        
    }
    
    func nextToView(){
        let vc = MyTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.dataSource?.count)
        return (self.dataSource?.count)!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order") as! OrderTableViewCell
//        for view in cell.contentView.subviews {
//            view.removeFromSuperview()
//        }
//        print(self.dataSource![(self.dataSource?.count)!-1-indexPath.row].record)
//        cell.snatchButton.removeFromSuperview()
        
        cell.setValueWithInfo(self.dataSource![indexPath.row])
//        cell.location.text
        cell.selectionStyle = .None
        cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
        cell.icon.clipsToBounds = true
        if self.dataSource![indexPath.row].state == "1" {
            cell.snatchButton.addTarget(self, action: #selector(self.qiangdan(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
        cell.snatchButton.tag = indexPath.row+10000

//        pushMapButton.removeFromSuperview()
        
        cell.pushMapButton.tag = indexPath.row
        cell.pushFuwuButton.tag = 1000+indexPath.row
        if  self.dataSource![indexPath.row].saddress == nil{
            cell.pushFuwuButton.userInteractionEnabled = false
        }
        if  self.dataSource![indexPath.row].address == nil{
            cell.pushMapButton.userInteractionEnabled = false
        }
        cell.pushMapButton.addTarget(self, action: #selector(self.pushMapButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
         cell.pushFuwuButton.addTarget(self, action: #selector(self.pushFuwuButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if cell.location.text != ""{
            self.getAddressWithString(indexPath.row)
           
            let distance = self.distance.componentsSeparatedByString(".")
             cell.distnce.text = distance[0]
        }
        
        return cell
        
    }
    
    func pushMapButton(sender:UIButton){
        
        
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        print(dataSource![sender.tag].latitude!)
        print(dataSource![sender.tag].longitude!)
        print(dataSource![sender.tag].slatitude!)
        print(dataSource![sender.tag].slongitude!)
        
        print(self.dataSource![sender.tag].address!)
         print(self.dataSource![sender.tag].saddress!)
        if dataSource![sender.tag].latitude != nil && dataSource![sender.tag].longitude != nil && dataSource![sender.tag].latitude! as String != "" && dataSource![sender.tag].longitude! as String != ""{
            print(dataSource![sender.tag].latitude!)
            coor1.latitude = CLLocationDegrees(dataSource![sender.tag].latitude! as String)!
            coor1.longitude = CLLocationDegrees(dataSource![sender.tag].longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if self.dataSource![sender.tag].address != nil && self.dataSource![sender.tag].address! as String != ""{
            start.name = self.dataSource![sender.tag].address!
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
        if dataSource![sender.tag].slatitude != nil && dataSource![sender.tag].slongitude != nil && dataSource![sender.tag].slatitude! as String != "" && dataSource![sender.tag].slongitude! as String != ""{
            print(dataSource![sender.tag].slatitude)
            coor2.latitude = CLLocationDegrees(dataSource![sender.tag].slatitude! as String)!
            coor2.longitude = CLLocationDegrees(dataSource![sender.tag].slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.dataSource![sender.tag].saddress != nil && self.dataSource![sender.tag].saddress != "" {
            end.name = self.dataSource![sender.tag].saddress!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
//        let locationVc = LocationViewController.init()
////        LocationViewController.myAddressOfpoint = self.dataSource![sender.tag].address!
////        let latitudeStr1 = self.dataSource![sender.tag].latitude! as NSString
////        let longitudeStr1 = self.dataSource![sender.tag].longitude! as NSString
////        LocationViewController.pointOfSelected = CLLocationCoordinate2D.init(latitude: latitudeStr1.doubleValue, longitude: longitudeStr1.doubleValue)
//        print(self.dataSource![sender.tag].latitude)
//        print(self.dataSource![sender.tag].longitude)
//        locationVc.isWobangPush = true
//        locationVc.addressPoint = self.dataSource![sender.tag].address!
//        if self.dataSource![sender.tag].latitude == nil {
//            locationVc.latitudeStr = ""
//        }else{
//            locationVc.latitudeStr = self.dataSource![sender.tag].latitude!
//        }
//        if self.dataSource![sender.tag].longitude == nil{
//            locationVc.longitudeStr = ""
//        }else{
//            locationVc.longitudeStr = self.dataSource![sender.tag].longitude!
//        }
//        
//        
//        self.navigationController?.pushViewController(locationVc, animated: true)
    }
    
    
    func pushFuwuButton(sender:UIButton){
        
        
        
        
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        if dataSource![sender.tag-1000].latitude != nil && dataSource![sender.tag-1000].longitude != nil && dataSource![sender.tag-1000].latitude! as String != "" && dataSource![sender.tag-1000].longitude! as String != ""{
            print(dataSource![sender.tag-1000].latitude)
            coor1.latitude = CLLocationDegrees(dataSource![sender.tag-1000].latitude! as String)!
            coor1.longitude = CLLocationDegrees(dataSource![sender.tag-1000].longitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        //指定起点名称
        if self.dataSource![sender.tag-1000].address != nil && self.dataSource![sender.tag-1000].address! as String != ""{
            start.name = self.dataSource![sender.tag-1000].address!
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
        if dataSource![sender.tag-1000].slatitude != nil && dataSource![sender.tag-1000].slongitude != nil && dataSource![sender.tag-1000].slatitude! as String != "" && dataSource![sender.tag-1000].slongitude! as String != ""{
            print(dataSource![sender.tag-1000].slatitude)
            coor2.latitude = CLLocationDegrees(dataSource![sender.tag-1000].slatitude! as String)!
            coor2.longitude = CLLocationDegrees(dataSource![sender.tag-1000].slongitude! as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.dataSource![sender.tag-1000].saddress != nil && self.dataSource![sender.tag-1000].saddress != "" {
            end.name = self.dataSource![sender.tag-1000].saddress!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
        
//        let locationVc = LocationViewController.init()
//        locationVc.isWobangPush = true
//        print(sender.tag)
//        locationVc.addressPoint = self.dataSource![sender.tag-1000].saddress!
//        if self.dataSource![sender.tag-1000].slatitude == nil {
//            locationVc.latitudeStr = ""
//        }else{
//            locationVc.latitudeStr = self.dataSource![sender.tag-1000].slatitude!
//        }
//        if self.dataSource![sender.tag-1000].slongitude == nil{
//            locationVc.longitudeStr = ""
//        }else{
//            locationVc.longitudeStr = self.dataSource![sender.tag-1000].slongitude!
//        }
//        
//        
//        self.navigationController?.pushViewController(locationVc, animated: true)

    }
    
    func qiangdan(sender:UIButton){
        
        var userid = String()
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        //         = ud.objectForKey("userid")as! String
        if userid == self.dataSource![sender.tag-10000].userid {
            alert("不能抢自己的单", delegate: self)
            return
        }
        
        
        let vc = MineViewController()
        vc.Checktoubao()
//        let ud = NSUserDefaults.standardUserDefaults()
        if (ud.objectForKey("baoxiangrenzheng") != nil && ud.objectForKey("baoxiangrenzheng") as! String == "no") {
            
            
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "请先投保在抢单，是否去投保？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            print(ud.objectForKey("baoxiangrenzheng") as! String)
                                            let vc2 = MyInsure()
                                            self.navigationController?.pushViewController(vc2, animated: true)
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            
           
            return
        }
        
        
        
        (self.myTableView.viewWithTag(sender.tag)as! UIButton).enabled = false
        
        print("抢单")
//        let ud = NSUserDefaults.standardUserDefaults()
        var longitude = String()
        var latitude = String()
//        let address = String()
//        let userid = ud.objectForKey("userid")as! String
        if ud.objectForKey("longitude") != nil && ud.objectForKey("latitude") != nil && ud.objectForKey("myAddress") != nil {
            longitude = ud.objectForKey("longitude") as! String
            latitude = ud.objectForKey("latitude") as! String
//            address = ud.objectForKey("myAddress")
        }
//        let longitude = ud.objectForKey("longitude")as! String
//        let latitude = ud.objectForKey("latitude")as! String
        print(longitude)
        
        print(latitude)
        
        let str = String(longitude)
        let array:NSArray = str.componentsSeparatedByString("(")
        let str2 = array[0]as! String
        let array2 = str2.componentsSeparatedByString(")")
        let str3 = array2[0]
        print(str3)
        
        let str4 = String(latitude)
        let array3:NSArray = str4.componentsSeparatedByString("(")
        let str5 = array3[0]as! String
        let array4 = str5.componentsSeparatedByString(")")
        let str6 = array4[0]
        print(str6)
        
        
        mainHelper.qiangDan(userid, taskid: dataSource![sender.tag-10000].id!, longitude: str3, latitude: str6) { (success, response) in
            print(response)
            if !success {
                alert("抢单失败！", delegate: self)
                return
            }
//            let ud = NSUserDefaults.standardUserDefaults()
//            let userid = ud.objectForKey("userid")as! String
//            self.mainHelper.gaiBianRenWu(userid,ordernum: self.dataSource![sender.tag-10000].order_num! as String, state: "2") { (success, response) in
//                if !success {
//                    alert("提交数据出错", delegate: self)
//                    return
//                }
            
//            }

//            let vc = MyTaskViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = MyTaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

//        let ud = NSUserDefaults.standardUserDefaults()
//        let userid = ud.objectForKey("userid")as! String

//        mainHelper.gaiBianRenWu(userid,ordernum: dataSource![sender.tag].order_num! as String, state: "2") { (success, response) in
//            if !success {
//                return
//            }
//            let vc = MyTaskViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        mainHelper.qiangDan(userid, taskid: dataSource![sender.tag].id!, longitude: str3, latitude: str6) { (success, response) in
//            print(response)
//            if !success {
//                return
//            }
//            let vc = MyTaskViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//            
//        }
        
    }
    
    func getAddressWithString(row:Int){
        print("检测数据*********")
//        print(str)
//        self.geocoder.geocodeAddressString(str) { (placemarks,error) in
////            if (placemarks!.count == 0 || error != nil) {
////                return ;
////            }
//        //bug:我已经修改过，去掉此处判断可能会触发模拟器崩溃
//            //**********************
//            if placemarks == nil {
//                return
//            }
//            //**********************
//            let placemark = placemarks?.first
//            let  longitude = (placemark?.location?.coordinate.longitude)!
//            let  latitude = (placemark?.location?.coordinate.latitude)!
//            print(longitude)
//            print(latitude)
//            print("-----")
//            print("---------------",self.latitude)
//            self.latitude = String(latitude)
//            self.longitude = String(longitude)
//            //bug:此处可能会存在为空的bug,其方法会使字符串为空
//            let str = removeOptionWithString(self.latitude)
//            print("唯独为-----"+str)
//            let str2 = removeOptionWithString(self.longitude)
//            print(str)
//            print(CLLocationDegrees(str)!)
        if self.dataSource![row].latitude == "" || self.dataSource![row].longitude == ""  ||  self.dataSource![row].slatitude == "" || self.dataSource![row].slongitude  ==  "" || self.dataSource![row].latitude == nil || self.dataSource![row].longitude == nil  ||  self.dataSource![row].slatitude == nil || self.dataSource![row].slongitude  ==  nil {
            self.distance = "0"
            return
        }
        
            let current = CLLocation.init(latitude: CLLocationDegrees(self.dataSource![row].latitude!)!, longitude: CLLocationDegrees(self.dataSource![row].longitude!)!)
            let before = CLLocation.init(latitude: CLLocationDegrees(self.dataSource![row].slatitude!)!, longitude: CLLocationDegrees(self.dataSource![row].slongitude!)!)
            let meters = current.distanceFromLocation(before)
            print("-----")
            self.distance = String(meters)
            print(meters)
            print(self.distance)
            print("-----")
            //self.createAnnotation(self.latitude, longitude: self.longitude)
//        }
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = TaskDetailViewController()
        let taskInfo = dataSource![indexPath.row]
        vc.taskInfo = taskInfo
        vc.qiangdanBut = false
        vc.title = "任务详情"
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
