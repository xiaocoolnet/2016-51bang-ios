//
//  RushViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class RushViewController: UIViewController,myDelegate ,UITableViewDelegate,UITableViewDataSource{

    
    var distance = NSString()
    var cityName = String()
    var longitude = String()
    var latitude = String()
    let mainHelper = MainHelper()
    var dataSource : Array<TaskInfo>?
    let myTableView = UITableView()
    let certifyImage = UIImageView()
    let certiBtn = UIButton()
    var kai = false
    var sign = Int()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        let function = BankUpLoad()
        function.CheckRenzheng()
        let ud = NSUserDefaults.standardUserDefaults()
        print(ud.objectForKey("ss"))
        if(ud.objectForKey("ss") != nil){
            
            
            
        if(ud.objectForKey("ss") as! String == "yes")
            
        {
//            certiBtn.setTitle("已认证", forState: UIControlState.Normal)
            certiBtn.userInteractionEnabled = false
            certiBtn.hidden = true
        certifyImage.hidden = true
            self.title = "抢单"
//            self = WoBangPageViewController()
//        self.GetData()
            }
        }
        self.tabBarController?.selectedIndex = 1
        if(ud.objectForKey("userid")==nil)
        {
            
            self.tabBarController?.selectedIndex = 3
            
            
        }
       
     
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.view = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sign = 0
        self.createRightItemWithTitle("我的任务")
        self.createLeftItem()
        setBtnAndImage()
        self.GetData()
        // Do any additional setup after loading the view.
    }
    
  
    
    func setBtnAndImage()
    {
        certifyImage.frame = CGRectMake(WIDTH / 2 - 100, HEIGHT / 2 - 150, 200,100)
        certifyImage.image =  UIImage.init(named: "未认证")
        self.view.addSubview(certifyImage)
        certiBtn.frame = CGRectMake(15, certifyImage.frame.origin.y + 150, WIDTH - 30, 50)
        certiBtn.layer.cornerRadius = 10
        certiBtn.layer.masksToBounds = true
        certiBtn.backgroundColor = COLOR
        certiBtn.addTarget(self, action: #selector(self.nowToCertification(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(certiBtn)
        certiBtn.setTitle("立即认证", forState: UIControlState.Normal)
        
    }
    func createLeftItem(){
        let ud = NSUserDefaults.standardUserDefaults()
        
        if ud.objectForKey("userid") != nil {
            mainHelper.GetWorkingState(ud.objectForKey("userid") as! String) { (success, response) in
                if !success{
                    alert("数据加载出错", delegate: self)
                    return
                }
                print(response! as! String)
                
                let button = UIButton.init(frame: CGRectMake(0, 10, 50, 92 * 50 / 174))
                if response as! String == "1"{
                    button.setImage(UIImage(named: "ic_kai-3"), forState: UIControlState.Normal)
                    self.sign = 1
                }else{
                    button.setImage(UIImage(named: "ic_guan-2"), forState: UIControlState.Normal)
                    self.sign = 0
                }
                
                button.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                //        button.selected = true
                //        let mySwitch = UISwitch.init(frame: CGRectMake(0, 0, 30, 30))
                
                //        mySwitch.onImage = UIImage(named: "ic_kai-1")
                //        mySwitch.offImage = UIImage(named: "ic_guan-0")
                let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
                self.navigationItem.leftBarButtonItem = item
            }

        }
        
        
    }
    //174/92
    func click(btn:UIButton){
        
        
        let type = CLLocationManager.authorizationStatus()
        
        if !CLLocationManager.locationServicesEnabled() || type == CLAuthorizationStatus.Denied{
            alert("请打开定位", delegate: self)
            return
        }
        let ud = NSUserDefaults.standardUserDefaults()
        var subLocality = String()
        var longitude = String()
        var latitude = String()
        var isworking = String()
        var cutyName = String()
        
        if ud.objectForKey("subLocality") != nil || ud.objectForKey("subLocality") as! String != "" {
            subLocality = ud.objectForKey("subLocality") as! String
            
            var count = Int()
            for a in subLocality.characters{
                if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
                    break
                }
                count = count + 1
            }
            
            cutyName = subLocality.substringToIndex(subLocality.startIndex.advancedBy(count+1))
        }
        if ud.objectForKey("longitude") != nil {
            longitude = ud.objectForKey("longitude") as! String
        }
        if ud.objectForKey("latitude") != nil {
            latitude = ud.objectForKey("latitude") as! String
        }
        
        
        
        
        print(longitude)
        print(latitude)
        
        if self.sign == 0 {
            isworking = "1"
        }else{
            isworking = "0"
        }
        if ud.objectForKey("userid") != nil {
            mainHelper.BeginWorking(ud.objectForKey("userid") as! String, address: cutyName, longitude: longitude, latitude: latitude, isworking: isworking) { (success, response) in
                if !success {
                    alert("数据加载出错", delegate: self)
                    return
                }
                if self.sign == 0 {
                    btn.setImage(UIImage(named: "ic_kai-3"), forState: UIControlState.Normal)
                    self.sign = 1
                }else{
                    btn.setImage(UIImage(named: "ic_guan-2"), forState: UIControlState.Normal)
                    self.sign = 0
                }
                
            }
        }
       
        
        print(self.sign)
        
//        print(btn.selected)
//        if btn.selected == true {
//            btn.setImage(UIImage(named: "ic_guan-0"), forState: UIControlState.Selected)
//               btn.selected = false
//        }else{
//            btn.setImage(UIImage(named: "ic_kai-1"), forState: UIControlState.Normal)
//            btn.selected = true
//        }
        

    }
    
    
    func createRightItemWithTitle(title:String){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 80, 40);
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.myTask), forControlEvents:UIControlEvents.TouchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = item
    }

    func myTask(){
    
        let vc = MyTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }

    
    

        func nowToCertification(sender: AnyObject) {
        
        if loginSign == 0 {//未登陆
            
            self.tabBarController?.selectedIndex = 3
            
        }else{//已登陆
            print("立即认证")
            let vc = CertificationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "身份认证"
        
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createView() {

//        myTableView.hidden = false
        
//        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)
//        myTableView.reloadData()
//        self.view.addSubview(myTableView)
//        self.createTableView()
//        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)
//        myTableView.backgroundColor = UIColor.redColor()

    }
    
    func createTableView(){
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)

        myTableView.backgroundColor = RGREY
//        self.myTableView = UITableView.init(frame: CGRectMake(0, -38, WIDTH, self.view.frame.size.height), style: .Grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerNib(UINib(nibName: "OrderTableViewCell",bundle: nil), forCellReuseIdentifier: "order")
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
//        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
//        myTableView.hidden = false
        self.view.addSubview(myTableView)
        //        self.view.addSubview(btn)
        //        self.view.addSubview(btn2)
        //        self.view.addSubview(label)
        
    }
    

    
    func GetData(){
        
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
            mainHelper.getTaskList (userid,cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        print(success)
                        return
                        //                        alert("暂无数据", delegate: self)
                    }
                    hud.hide(true)
                    print(response)
                    self.dataSource?.removeAll()
                    
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
    func headerRefresh(){
        if loginSign == 0 {
            self.tabBarController?.selectedIndex = 3
        }else{
            
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            
            mainHelper.getTaskList (userid,cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
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
       
        
        cell.setValueWithInfo(self.dataSource![indexPath.row])
        //        cell.location.text
        cell.selectionStyle = .None
        cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
        cell.icon.clipsToBounds = true
        if self.dataSource![indexPath.row].state == "1" {
            cell.snatchButton.addTarget(self, action: #selector(self.qiangdan(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }else{
            cell.snatchButton.setTitle("已被抢", forState: UIControlState.Normal)
            cell.snatchButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            cell.snatchButton.enabled = false
        }
        
        cell.snatchButton.tag = indexPath.row+10000
        print(cell.location.text!)
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
        
        
        let opt = BMKOpenWalkingRouteOption()
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
        
        
        BMKOpenRoute.openBaiduMapWalkingRoute(opt)
     
    }
    
    
    func pushFuwuButton(sender:UIButton){
        
        
        
        
        let opt = BMKOpenWalkingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        if dataSource![sender.tag].latitude != nil && dataSource![sender.tag].longitude != nil && dataSource![sender.tag].latitude! as String != "" && dataSource![sender.tag].longitude! as String != ""{
            print(dataSource![sender.tag].latitude)
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
        
        
        BMKOpenRoute.openBaiduMapWalkingRoute(opt)
        
        
        
    }
    
    func qiangdan(sender:UIButton){
        
        let vc = MineViewController()
        vc.Checktoubao()
        let ud = NSUserDefaults.standardUserDefaults()
        if (ud.objectForKey("baoxiangrenzheng") != nil && ud.objectForKey("baoxiangrenzheng") as! String == "no") {
            
            let vc2 = MyInsure()
            self.navigationController?.pushViewController(vc2, animated: true)
            return
        }
        
        (self.myTableView.viewWithTag(sender.tag)as! UIButton).enabled = false
        
        print("抢单")
//        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        let longitude = ud.objectForKey("longitude")as! String
        let latitude = ud.objectForKey("latitude")as! String
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
            
            let vc = MyTaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    func getAddressWithString(row:Int){
        print("检测数据*********")
       
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
        self.navigationController?.pushViewController(vc, animated: true)
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
