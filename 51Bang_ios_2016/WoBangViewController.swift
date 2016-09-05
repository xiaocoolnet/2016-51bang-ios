//
//  WoBangViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        print(self.latitude)
        print(self.longitude)

        self.title = "我帮"
        self.createRightItemWithTitle("任务(0)")
//        self.createTableView()
        self.GetData()

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
            mainHelper.getTaskList (userid,cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        return
                    }
                    hud.hide(true)
                    print(response)
                    self.dataSource?.removeAll()
                    print(self.dataSource?.count)
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    print(self.dataSource)
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
        self.myTableView = UITableView.init(frame: CGRectMake(0, -38, WIDTH, self.view.frame.size.height), style: .Grouped)
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
        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(myTableView)
//        self.view.addSubview(btn)
//        self.view.addSubview(btn2)
//        self.view.addSubview(label)
       
    }
    
    func nextToView(){
        let vc = MyTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        print(self.dataSource![(self.dataSource?.count)!-1-indexPath.row].record)
        cell.setValueWithInfo(self.dataSource![(self.dataSource?.count)!-1-indexPath.row])
//        cell.location.text
        cell.selectionStyle = .None
        cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
        cell.icon.clipsToBounds = true
        cell.snatchButton.addTarget(self, action: #selector(self.qiangdan(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.snatchButton.tag = (self.dataSource?.count)!-1-indexPath.row
        print(cell.location.text!)
//        pushMapButton.removeFromSuperview()
        
        cell.pushMapButton.tag = (self.dataSource?.count)!-1-indexPath.row
        cell.pushFuwuButton.tag = 1000+(self.dataSource?.count)!-1-indexPath.row
        if  self.dataSource![(self.dataSource?.count)!-1-indexPath.row].saddress == nil{
            cell.pushFuwuButton.userInteractionEnabled = false
        }
        if  self.dataSource![(self.dataSource?.count)!-1-indexPath.row].address == nil{
            cell.pushMapButton.userInteractionEnabled = false
        }
        cell.pushMapButton.addTarget(self, action: #selector(self.pushMapButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
         cell.pushFuwuButton.addTarget(self, action: #selector(self.pushFuwuButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if cell.location.text != ""{
            self.getAddressWithString((self.dataSource?.count)!-1-indexPath.row)
           
            let distance = self.distance.componentsSeparatedByString(".")
             cell.distnce.text = distance[0]
        }
        
        return cell
        
    }
    
    func pushMapButton(sender:UIButton){
        let locationVc = LocationViewController.init()
//        LocationViewController.myAddressOfpoint = self.dataSource![sender.tag].address!
//        let latitudeStr1 = self.dataSource![sender.tag].latitude! as NSString
//        let longitudeStr1 = self.dataSource![sender.tag].longitude! as NSString
//        LocationViewController.pointOfSelected = CLLocationCoordinate2D.init(latitude: latitudeStr1.doubleValue, longitude: longitudeStr1.doubleValue)
        print(self.dataSource![sender.tag].latitude)
        print(self.dataSource![sender.tag].longitude)
        locationVc.isWobangPush = true
        locationVc.addressPoint = self.dataSource![sender.tag].address!
        if self.dataSource![sender.tag].latitude == nil {
            locationVc.latitudeStr = ""
        }else{
            locationVc.latitudeStr = self.dataSource![sender.tag].latitude!
        }
        if self.dataSource![sender.tag].longitude == nil{
            locationVc.longitudeStr = ""
        }else{
            locationVc.longitudeStr = self.dataSource![sender.tag].longitude!
        }
        
        
        self.navigationController?.pushViewController(locationVc, animated: true)
    }
    
    
    func pushFuwuButton(sender:UIButton){
        
        let locationVc = LocationViewController.init()
        locationVc.isWobangPush = true
        print(sender.tag)
        locationVc.addressPoint = self.dataSource![sender.tag-1000].saddress!
        if self.dataSource![sender.tag-1000].slatitude == nil {
            locationVc.latitudeStr = ""
        }else{
            locationVc.latitudeStr = self.dataSource![sender.tag-1000].slatitude!
        }
        if self.dataSource![sender.tag-1000].slongitude == nil{
            locationVc.longitudeStr = ""
        }else{
            locationVc.longitudeStr = self.dataSource![sender.tag-1000].slongitude!
        }
        
        
        self.navigationController?.pushViewController(locationVc, animated: true)

    }
    
    func qiangdan(sender:UIButton){
        
        print("抢单")
        let ud = NSUserDefaults.standardUserDefaults()
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
        
        
        mainHelper.qiangDan(userid, taskid: dataSource![sender.tag].id!, longitude: str3, latitude: str6) { (success, response) in
            print(response)
            if !success {
                return
            }
            let vc = MyTaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
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
        let taskInfo = dataSource![(self.dataSource?.count)!-1-indexPath.row]
        vc.taskInfo = taskInfo
        vc.qiangdanBut = false
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
