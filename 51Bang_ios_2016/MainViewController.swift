//
//  MainViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD


var address:String  = ""
class MainViewController: UIViewController,CityViewControllerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate{
    
    var count2 = 0
    var paopaoInfo : Array<RzbInfo> = []
    var dataSource3 :Array<chatInfo> = []
    let skillHelper = RushHelper()
    var infoMore : RzbInfo?
    let infoInmoreButton = UIButton.init(frame: CGRectMake(0, 0, WIDTH-60, 100))
    
    var countSelected = -1
    
    var dingweiCityDic = NSDictionary()
    
    var dataSource2 : Array<chatInfo>?
    var rzbDataSource : Array<RzbInfo>?
    var biaoZhuArray:Array<BMKPointAnnotation> = []
    var cutyName = String()
    var quName = String()
    let mainHelper = MainHelper()
    var city = String()
    var dingWeiStr = String()
    var godingwei = String()
    var dingweiCityID = String()
    var golocationForUser = CLLocationCoordinate2D.init()
    var goQuName = String()
    var streetNameStr = String()
    var longitude = String()
    var latitude = String()
    let backView = UIView()
    //    let backMHView = UIView()
    var isDingwei = Bool()
    let mainhelper = MainHelper()
    static var locationForUser = CLLocation.init()
    @IBOutlet weak var scrollView: UIScrollView!
    var cityController:CityViewController!
    static var renZhengStatue = 0
    @IBOutlet var location: UIButton!
    @IBOutlet weak var topView: UIView!
    let nameArr:[String] = ["下单","抢单","便民圈"]
    let imageArr = ["ic_bangwo","ic_wobang","ic_tongchenghudong"]
    let anPoin = MKPointAnnotation.init()
    var loadtag = true
    static var BMKname = ""
    static var city = ""
    var  isChanging = false
    static var userLocationForChange = CLLocation.init()
    //static var BMKuserLocationForUser = BMKUserLocation.init()
    var locationService: BMKLocationService!
    var geocodeSearch: BMKGeoCodeSearch!
    var mapView:BMKMapView!
    var pointAnmation = BMKPointAnnotation.init()
    var showRegion = BMKCoordinateRegion.init()
    
    // 位置选择图标
    var annoImage = UIButton()
    // 回到我的位置按钮
    var BeingBackMyPositonBtn = UIButton()
    // 用户位置经纬度信息（及时）
    var savedLocation = BMKUserLocation()
    var flagLocation = BMKUserLocation()//价格flag标记，记录变化
    var infoBackView = RenZhengBangTableViewCell()
    
    
    
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if self.userLocationCenter.objectForKey("quName") != nil{
            self.location.setTitle(self.userLocationCenter.objectForKey("quName") as? String, forState: UIControlState.Normal)
        }
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
//        self.selectCityFromCity(self.dingweiCityDic)
//
        
//
        //        self.mapView.removeFromSuperview()
        //        setBMKMpaview()
        
        
        //        let annoImage = UIButton()
        //        let point = CGPointMake(self.mapView.center.x, self.mapView.center.y - 13)
        //        annoImage.center = point
        //        annoImage.bounds = CGRectMake(0, 0, 20, 26)
        //        annoImage.backgroundColor = UIColor.redColor()
        //        self.annoImage = annoImage
        //        self.view.addSubview(self.annoImage)
        
        let buttons = UIButton.init(type: UIButtonType.Custom)
        buttons.frame = CGRectMake(20, 100, 30, 30)
        buttons.setImage(UIImage(named: "sign.png"), forState: UIControlState.Normal)
        buttons.addTarget(self, action: #selector(self.moveToUser), forControlEvents: UIControlEvents.TouchUpInside)
        self.BeingBackMyPositonBtn = buttons
//        UIApplication.sharedApplication().keyWindow!.addSubview(self.BeingBackMyPositonBtn)
        self.mapView.addSubview(self.BeingBackMyPositonBtn)
        
        self.infoBackView = NSBundle.mainBundle().loadNibNamed("RenZhengBangTableViewCell", owner: nil, options: nil).first as! RenZhengBangTableViewCell
        self.infoBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 175)
        UIApplication.sharedApplication().keyWindow!.addSubview(self.infoBackView)
        
        infoInmoreButton.backgroundColor = UIColor.clearColor()
        infoInmoreButton.addTarget(self, action: #selector(self.infoInmoreButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.infoBackView.addSubview(infoInmoreButton)
        
        
       getWeiZhi()
        
        
        
        
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.count2 = 0
        self.mapView.removeAnnotations(self.biaoZhuArray)
        self.paopaoInfo.removeAll()
        self.biaoZhuArray.removeAll()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        
        
        
        if (userLocationCenter.objectForKey("myAddress") == nil) {
            
            
        }
//        print(self.dingWeiStr)
        
        //        if (isDingwei) {
        //
        //            userLocationCenter.setObject(self.dingWeiStr, forKey: "subLocality")
        //            userLocationCenter.setObject(self.streetNameStr, forKey: "streetName")
        //            isDingwei = false
        //        }else{
        //            userLocationCenter.setObject("0", forKey: "subLocality")
        //        }
        
//        geocodeSearch.delegate = nil
//        locationService.delegate = nil
        mapView.viewWillDisappear()
//        mapView.delegate = nil
        //        self.backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
        self.BeingBackMyPositonBtn.removeFromSuperview()
        self.infoBackView.removeFromSuperview()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dingWeiStr = "0"
        
       
        
        locationService = BMKLocationService()
        locationService.delegate = self
        locationService.startUserLocationService()
        let ud = NSUserDefaults.standardUserDefaults()
            
        if ud.objectForKey("removeInfo") == nil{
            ud.removeObjectForKey("quName")
            ud.removeObjectForKey("cityName")
            ud.removeObjectForKey("cityid")
            ud.setObject("1", forKey: "removeInfo")
        }
            
        

        
        
        let vc = MineViewController()
        vc.resignTongZhi()
        self.flagLocation = self.savedLocation
        let function = BankUpLoad()
        function.CheckRenzheng()
        
        
        let ud1 = NSUserDefaults.standardUserDefaults()
        if ud1.objectForKey("userid") != nil {
            let userid = ud1.objectForKey("userid")as! String
            JPUSHService.setTags(nil, aliasInbackground:userid)
        }
        
        
        //接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMyName(_:)), name:"NotificationIdentifier", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.newTask), name:"newTasksss", object: nil)
        
        
        
        
        
       
        
        
        
        mapView = BMKMapView.init()
        geocodeSearch = BMKGeoCodeSearch()
        for view in self.topView.subviews {
            view.removeFromSuperview()
        }
        //        self.topView.removeFromSuperview()
        self.mapView.removeFromSuperview()
        setBMKMpaview()
        createTopView()
        scrollView.scrollEnabled = false
        //        let button = UIButton.init(type: UIButtonType.Custom)
        //        button.frame = CGRectMake(20, UIScreen.mainScreen().bounds.size.height - 130, 30, 30)
        //        button.setImage(UIImage(named: "sign.png"), forState: UIControlState.Normal)
        //        button.addTarget(self, action: #selector(self.moveToUser), forControlEvents: UIControlEvents.TouchUpInside)
        //        self.BeingBackMyPositonBtn = button
        CheckRenzheng()
        
        
        geocodeSearch.delegate = self
        //        locationService.delegate = self
        mapView.viewWillAppear()
        mapView.delegate = self
        CommitOrderViewController.ReturnTagForView = 0
        
        
    }
    
    func postMyaddress(){
        let ud = NSUserDefaults.standardUserDefaults()
        
        if ud.objectForKey("userid") != nil {
            mainHelper.GetWorkingState(ud.objectForKey("userid") as! String) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success{
                        alert("数据加载出错", delegate: self)
                        return
                    }
                    
                    
                    
                    if response as! String == "1"{
                        let ud = NSUserDefaults.standardUserDefaults()
                        var subLocality = String()
                        var longitude = String()
                        var latitude = String()
                        var isworking = String()
                        var cutyName = String()
                        isworking = "1"
                        
                        let strrr = String( ud.objectForKey("subLocality")! as! String)
                        
                        
                        if ud.objectForKey("subLocality") != nil && strrr != "0" && ud.objectForKey("streetName") != nil && ud.objectForKey("streetName") as! String != ""{
                            subLocality = ud.objectForKey("subLocality") as! String
                            cutyName = subLocality + (ud.objectForKey("streetName") as! String)
                            
                            //            cutyName = ud.objectForKey("subLocality") as! String
                        }
                        if ud.objectForKey("longitude") != nil {
                            longitude = ud.objectForKey("longitude") as! String
                        }
                        if ud.objectForKey("latitude") != nil {
                            latitude = ud.objectForKey("latitude") as! String
                        }
                        
                        
                        if ud.objectForKey("userid") != nil {
                            self.mainHelper.BeginWorking(ud.objectForKey("userid") as! String, address: cutyName, longitude: longitude, latitude: latitude, isworking: isworking) { (success, response) in
                                dispatch_async(dispatch_get_main_queue(), {
                                    if !success {
                                        alert("数据加载出错", delegate: self)
                                        return
                                    }
                                })
                                
                            }
                        }
                        
                        
                    }else{
                        
                    }
                })
                
                
            }
            
        }
        
    }
    
    
    func getMyName(notification:NSNotification){
//        let name = notification.object?.valueForKey("name") as? String
//        let quname = notification.object?.valueForKey("quname") as? String
        self.selectCity(notification.object! as! NSDictionary)
        //        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotificationIdentifier", object: nil)
        //        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func newTask(){
        //        self.GetData()
        
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "您附近有新订单，是否查看？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            
            
            
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            self.tabBarController?.selectedIndex = 1
//                                            let vc = WoBangPageViewController()
//                                            self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.tabBarController?.selectedIndex = 1
//            let vc = WoBangPageViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            //            self.window.rootViewController = vc
        }
        
        
    }
    
    
    
    func CheckRenzheng()
    {
        
        let function = BankUpLoad()
        function.CheckRenzheng()
    }
    
    //建立顶部
    func createTopView()
    {
        for i in 0...2 {
            let helpBtn = UIButton(frame: CGRectMake(WIDTH/6-25+WIDTH/3*CGFloat(i), 15, 50, 50))
            helpBtn.layer.cornerRadius = 25
            helpBtn.setImage(UIImage(named: imageArr[i]), forState: UIControlState.Normal)
            helpBtn.tag = i
            helpBtn.addTarget(self, action: #selector(self.helpWithWho(_:)), forControlEvents: .TouchUpInside)
            topView.addSubview(helpBtn)
            let nameLab = UILabel(frame: CGRectMake(WIDTH/6-25+WIDTH/3*CGFloat(i), 70, 50, 20))
            nameLab.textAlignment = .Center
            nameLab.font = UIFont.systemFontOfSize(12)
            nameLab.text = nameArr[i]
            topView.addSubview(nameLab)
        }
        
    }
    
    
    
    
    
    
    func helpWithWho(btn:UIButton) {
        
        
        
        
        
        if btn.tag == 0 {
            
            if loginSign == 0 {
                
                self.tabBarController?.selectedIndex = 3
                return
                
            }

            
            
            
            
            let vc = CommitOrderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if btn.tag == 1{

            self.tabBarController?.selectedIndex = 1
            
        }else{
            let vc = ConvenientPeople()
            self.navigationController?.pushViewController(vc, animated: true)
            //            print("同城互动")
        }
        
        
    }
    @IBAction func goToLocation(sender: AnyObject) {
        print("定位")
        cityController = CityViewController(nibName: "CityViewController", bundle: nil)
        cityController.dingweiCity = self.godingwei
        cityController.golocationForUser = self.golocationForUser
        cityController.goQuName = self.goQuName
        cityController.delegate = self
        self.navigationController?.pushViewController(cityController, animated: true)
        
        
        cityController.title = "定位"
    }
    
    func selectCityFromCity(info:NSDictionary){
                if info.objectForKey("latitude") != nil&&info.objectForKey("longitude") != nil&&info.objectForKey("latitude") as! String != ""&&info.objectForKey("longitude") as! String != ""{
            
            showRegion.center = CLLocation.init(latitude: CLLocationDegrees(info.objectForKey("latitude") as! String)!, longitude: CLLocationDegrees(info.objectForKey("longitude")as! String)!).coordinate
            showRegion.span.latitudeDelta = 0.02
            showRegion.span.longitudeDelta = 0.02
            mapView.setRegion(showRegion, animated: true)
             mapView.setCenterCoordinate(CLLocation.init(latitude: CLLocationDegrees(info.objectForKey("latitude") as! String)!, longitude: CLLocationDegrees(info.objectForKey("longitude")as! String)!).coordinate, animated: true)
                    
                    
                    userLocationCenter.setObject(info.objectForKey("latitude") as! String, forKey: "latitude")
                    userLocationCenter.setObject(info.objectForKey("longitude") as! String, forKey: "longitude")
            
        }else{
            let searcher = BMKGeoCodeSearch()
            searcher.delegate = self
            let geoCodeSearchOption = BMKGeoCodeSearchOption()
            let cityname11 = self.dingweiCityDic.objectForKey("name") as? String
            geoCodeSearchOption.city = ""
            geoCodeSearchOption.address = cityname11
            _ = searcher.geoCode(geoCodeSearchOption)
                    userLocationCenter.setObject("", forKey: "latitude")
                    userLocationCenter.setObject("", forKey: "longitude")
        }
    }
    
    func selectCity(info:NSDictionary) {
        
        var objectInfo = NSUserDefaults.standardUserDefaults().objectForKey("keyHistoryInfo") as? Array<NSDictionary>
        if objectInfo != nil{
            if objectInfo!.count>2{
                objectInfo = [objectInfo![(objectInfo?.count)!-2],(objectInfo?.last)!]
                
            }
            objectInfo?.append(info)
        }else{
            objectInfo = [info]
        }
        
        
        
        
        
        NSUserDefaults.standardUserDefaults().setObject(objectInfo, forKey: "keyHistoryInfo");
        
        
        
        
        
        self.dingweiCityDic = info
        
        if info.objectForKey("name") != nil{
            userLocationCenter.setObject(info.objectForKey("name") as! String, forKey: "cityName")
            
            var object = NSUserDefaults.standardUserDefaults().arrayForKey("keyHistory")
            debugPrint(object)
            if(object != nil){
                if object!.count>2{
                    object = [object![(object?.count)!-2],(object?.last)!]
                    
                }
                object?.append(info.objectForKey("name") as! String)
            }else{
                object = [info.objectForKey("name") as! String]
            }
            
            
            NSUserDefaults.standardUserDefaults().setObject(object, forKey: "keyHistory");
            
        }
        if info.objectForKey("quname") != nil{
            userLocationCenter.setObject(info.objectForKey("quname") as! String, forKey: "quName")
            self.quName = info.objectForKey("quname") as! String
            location.setTitle(quName, forState: UIControlState.Normal)
        }
        if info.objectForKey("cityid") != nil{
            userLocationCenter.setObject(info.objectForKey("cityid") as! String, forKey: "cityid")
            debugPrint(info.objectForKey("cityid"))
        }

        
        
        
        self.selectCityFromCity(info)
        
//        print(city)
////        self.city = city
//        
//        self.backView.removeFromSuperview()
//        //        self.backMHView.removeFromSuperview()
//        
//        //        let cityNsstring = city as NSString
//        var count = Int()
//        let myArray1 = NSMutableArray()
//        for a in city.characters{
//            if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
//                break
//            }
//            count = count + 1
//        }
//        print(count)
//        cutyName = (city as NSString).substringToIndex(count+1)
//        userLocationCenter.setObject(cutyName, forKey: "cityName")
//        
//        quName = city.substringFromIndex(city.startIndex.advancedBy(count+1))
//        var quCount = Int()
//        for a in quName.characters{
//            if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
//                myArray1.addObject(quCount)
//            }
//            
//            quCount = quCount + 1
//        }
//        if myArray1.count>1 {
//            if city == "重庆市万州区" {
//                
//            }else{
//                quName = quName.substringFromIndex(quName.startIndex.advancedBy((myArray1[0] as! Int)+1))
//                cutyName = (city as NSString).substringToIndex((count+1+(myArray1[0] as! Int)+1))
//                print(cutyName)
//                userLocationCenter.setObject(cutyName, forKey: "cityName")
//            }
//            
//            
//        }
//        print(cutyName)
//        print(quName)
//        let cityname1 = (city as NSString).substringToIndex(city.characters.count - quName.characters.count)
//        
//        print(cityname1)
//        
//        
//        if quname == ""{
//            userLocationCenter.setObject(quName, forKey: "quName")
//            
//            location.setTitle(quName, forState: UIControlState.Normal)
//            location.sizeToFit()
//            let searcher = BMKGeoCodeSearch()
//            searcher.delegate = self
//            let geoCodeSearchOption = BMKGeoCodeSearchOption()
//            geoCodeSearchOption.city = cutyName
//            geoCodeSearchOption.address = quName
//            let flog = searcher.geoCode(geoCodeSearchOption)
//            print(flog)
//            
//        }else{
//            cutyName = cityname1
//            quName = quname
//            userLocationCenter.setObject(quname, forKey: "quName")
//            
//            location.setTitle(quname, forState: UIControlState.Normal)
//            location.sizeToFit()
//            let searcher = BMKGeoCodeSearch()
//            searcher.delegate = self
//            let geoCodeSearchOption = BMKGeoCodeSearchOption()
//            geoCodeSearchOption.city = cutyName
//            geoCodeSearchOption.address = quname
//            let flog = searcher.geoCode(geoCodeSearchOption)
//            userLocationCenter.setObject(cityname1, forKey: "cityName")
//            print(flog)
//        }
//        
        
       
        
           }
    
    func phoneCall(){
        
        //        backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
        UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://400-0608-856")!)
    }
    
    func backCityVc(){
        location.setTitle("定位", forState: UIControlState.Normal)
        //        backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
        
        cityController = CityViewController(nibName: "CityViewController", bundle: nil)
        cityController.delegate = self
        
        self.navigationController?.pushViewController(cityController, animated: true)
        
        cityController.title = "定位"
    }
    
    @IBAction func goToFriendList(sender: AnyObject) {
        print("认证帮")
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FriendView")
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "认证帮"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func getWeiZhi(){
        var cityname = String()
        if userLocationCenter.objectForKey("cityName") != nil {
            cityname = userLocationCenter.objectForKey("cityName") as! String
        }
        print(cityname)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        mainHelper.GetHomeRzbList (cityname,beginid: "-1",sort:"" ,type: "", handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                hud.hide(true)
                if !success {
                    
                    return
                }
                self.rzbDataSource = response as? Array<RzbInfo> ?? []
                if self.rzbDataSource == nil||self.rzbDataSource?.count == 0{
                    return
                }
                var counts = NSInteger()
                counts = 0
                for RZB in self.rzbDataSource!{
                    let biaozhu = BMKPointAnnotation()
                    
                    if  RZB.latitude != ""{
                        
                        biaozhu.coordinate.latitude = CLLocationDegrees(RZB.latitude)!
                        
                    }
                    if  RZB.longitude != ""{
                        biaozhu.coordinate.longitude = CLLocationDegrees(RZB.longitude)!
                    }
                    if RZB.isworking as String == "1"{
                        self.biaoZhuArray.append(biaozhu)
                        self.mapView.selectAnnotation(biaozhu, animated: true)
                        
                        self.paopaoInfo.append(RZB)
//                        self.mapView.addAnnotation(biaozhu)
                    }
                    counts+=1
                    
                    //
                }
                self.mapView.addAnnotations(self.biaoZhuArray)
                
            })
            })
        
    }
    
    
    
    
    //
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation .isEqual(pointAnmation) {
            let newAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "myAnnotations")
            //            newAnnotationView.image = UIImage.init(named: "girl")
            newAnnotationView.annotation = annotation
            return newAnnotationView
        }else{
            
            let newAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "myAnnotation")
            //        newAnnotationView.animatesDrop = true
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+self.paopaoInfo[count2].photo
            let button = UIButton.init(frame: CGRectMake(0, 0, 42, 42))
            button.sd_setImageWithURL(NSURL(string:photoUrl), forState: .Normal, placeholderImage: UIImage(named: "ic_moren"))
            button.layer.masksToBounds = true
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.layer.borderWidth = 2
            button.tag = self.count2+600
            button.addTarget(self, action: #selector(self.showServerInfo(_:)), forControlEvents: .TouchUpInside)
            button.layer.cornerRadius = 21
            button.backgroundColor = UIColor.redColor()
            
            newAnnotationView.frame = CGRectMake(0, 0, 67, 67)
            newAnnotationView.contentMode = .Center
            newAnnotationView.backgroundColor = UIColor.clearColor()
            newAnnotationView.addSubview(button)
            newAnnotationView.centerOffset = CGPointMake(0, -33)
            newAnnotationView.image = UIImage(named: "ic_shuidi")
            
            
            self.count2+=1
            return newAnnotationView
        }
        
        
    }
    
    
    func showServerInfo(sender:UIButton){
        
        
        if sender.tag == self.countSelected{
            UIView.animateWithDuration(0.2, animations: {
                self.infoBackView.frame = CGRectMake(0, HEIGHT-43-175, WIDTH, 175)
            })
            return
        }
        sender.frame = CGRectMake(-5, 0, 52, 52)
        sender.layer.cornerRadius = 26
        sender.layer.borderColor = UIColor.orangeColor().CGColor
        
        if self.countSelected != -1{
            mapView.viewWithTag(self.countSelected)?.frame = CGRectMake(0, 0, 42, 42)
            mapView.viewWithTag(self.countSelected)?.layer.borderColor = UIColor.whiteColor().CGColor
            mapView.viewWithTag(self.countSelected)?.layer.cornerRadius = 21

        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        self.countSelected = sender.tag
        print(sender.tag-600)
        let ud = NSUserDefaults.standardUserDefaults()
        let longitude1 = ud.objectForKey("longitude")
        let latitude1 = ud.objectForKey("latitude")
        if longitude1 != nil&&latitude1 != nil{
            
            
        skillHelper.getAuthenticationInfoByUserId(self.paopaoInfo[sender.tag-600].id,longitude:longitude1 as! String,latitude:latitude1 as! String, handle: { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                hud.hide(true)
                if success{
                    self.infoMore = response as! RzbInfo!
                    self.showInfo(response as! RzbInfo!)
                    self.infoBackView.hidden = false
                    self.infoBackView.weizhiButton.addTarget(self, action: #selector(self.dingWeiAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    
                    self.infoBackView.message.addTarget(self, action: #selector(self.message(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }else{
                    alert("数据加载出错", delegate: self)
                }
                
            })
        })
        }else{
            hud.hide(true)
        }
        UIView.animateWithDuration(0.2) { 
            self.infoBackView.frame = CGRectMake(0, HEIGHT-43-175, WIDTH, 175)
        }
        
        
        
        
        
    }
    
    func showInfo(info:RzbInfo){
        
        self.infoBackView.setValueWithInfo(self.infoMore!)
        if self.infoMore!.distance != 0{
            let dis = Double(self.infoMore!.distance)
            if dis>999999{
                self.infoBackView.distance.text = "999+km"
            }else{
                self.infoBackView.distance.text = (String(format:"%.2f",dis/1000))+"km"
                print(String(format:"%.2f",dis/1000))
            }
        }else{
             self.infoBackView.distance.text = "0km"
        }
        
    }
    
    
    
    /***********************百度地图******************************/
    //创建动画并且创建大头针
    func createPointAnmation(location:CLLocation)
    {
        let coor = location.coordinate
        pointAnmation.coordinate = coor
        pointAnmation.title = MainViewController.BMKname
        mapView.addAnnotation(pointAnmation)
        mapView.selectAnnotation(pointAnmation, animated: true)
        showRegion.center = coor
        showRegion.span.latitudeDelta = 0.05
        showRegion.span.longitudeDelta = 0.05
        mapView.setRegion(showRegion, animated: true)
        
        
        //
    }
    //设置百度地图
    func setBMKMpaview()
    {
        
        mapView.frame = CGRectMake(0, 100, UIScreen.mainScreen().bounds.size.width+10, UIScreen.mainScreen().bounds.size.height - 100)
        mapView.showsUserLocation = true
        mapView.zoomLevel = 18
        mapView.gesturesEnabled = true
        //交通实况
        mapView.trafficEnabled = true
        
        
        //        mapView.updateLocationData
        scrollView.addSubview(mapView)
        
        
        
        
    }
    
    func moveToUser(){
        
        locationService.startUserLocationService()
        
        if self.savedLocation != self.flagLocation {
            mapView.updateLocationData(self.savedLocation)
            mapView.setCenterCoordinate(self.savedLocation.location.coordinate, animated: true)
        }else{
            alert("请打开定位功能", delegate: self)
            return
        }
        
        
        
    }
    
    
    
    
    //反地理检索
    
    func  WillShowName( latitude:CLLocationDegrees,longtitude:CLLocationDegrees)
    {
        
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(latitude,longtitude)
        
        let flag = geocodeSearch.reverseGeoCode(reverseGeocodeSearchOption)
        if flag {
            print("反geo 检索发送成功")
        } else {
            print("反geo 检索发送失败")
        }
        
        
    }
    
    
    /***************************以下是代理*******************************/
    
    //MARK: -MapViewDelegate
    
    /**
     *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
     *@param mapview 地图View
     *@param status 此时地图的状态
     */
    func mapView(mapView: BMKMapView!, onDrawMapFrame status: BMKMapStatus!) {
        
        
    }
    
    
    func mapView(mapView: BMKMapView!, regionDidChangeAnimated animated: Bool)
    {
        
        UIView.animateWithDuration(0.2) { 
            self.infoBackView.frame = CGRectMake(0, HEIGHT, WIDTH, 175)
        }
        
        let point :CGPoint = CGPointMake( self.mapView.frame.size.width * 0.5, self.mapView.frame.size.height * 0.5)
        let location = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        MainViewController.userLocationForChange = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        WillShowName(location.latitude, longtitude: location.longitude)
    }
    
    
    func mapView(mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        let ud = NSUserDefaults.standardUserDefaults()
        
        if ud.objectForKey("ss") != nil {
            if(ud.objectForKey("ss") as! String == "no")
            {
                let vc  = WobangRenZhengController()
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
                return
                
            }
        }
        
        
        
        let vc = CommitOrderViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //BMKLocationSerevenceDelegate
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        
        MainViewController.userLocationForChange = userLocation.location
        if(userLocation.location != nil)
        {
            WillShowName(userLocation.location.coordinate.latitude, longtitude: userLocation.location.coordinate.longitude)
            showRegion.center = userLocation.location.coordinate
            showRegion.span.latitudeDelta = 0.05
            showRegion.span.longitudeDelta = 0.05
            mapView.setRegion(showRegion, animated: true)
            mapView.updateLocationData(userLocation)
            self.savedLocation = userLocation
            
            //            print(userLocation.title)
            pointAnmation.coordinate = userLocation.location.coordinate
            pointAnmation.title = userLocation.title
            
            
            mapView.addAnnotation(pointAnmation)
            
            mapView.selectAnnotation(pointAnmation, animated: true)
            isDingwei = true
            
            userLocationCenter.setObject(String(userLocation.location.coordinate.latitude), forKey: "latitude")
            userLocationCenter.setObject(String(userLocation.location.coordinate.longitude), forKey: "longitude")
            if userLocation.title != nil {
                userLocationCenter.setObject(userLocation.title, forKey: "myAddress")
                
            }
            //            print(userLocation.)
            
            
            locationService.stopUserLocationService()
            print("用户的位置已经更新")
        }
        
    }
    
    
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        //print("用户的方向已经改变")
    }
    
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        
        print("用户定位停止")
    }
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if result == nil {
            return
        }
        var showRegion = BMKCoordinateRegion.init()
        showRegion.center = result.location
        self.mapView.setRegion(showRegion, animated: true)
        pointAnmation.coordinate = result.location
        pointAnmation.title = result.address
        mapView.addAnnotation(pointAnmation)

        mapView.selectAnnotation(pointAnmation, animated: true)
        //        self.WillShowName(result.location.longitude, longtitude: result.location.latitude)
    }
    
    //MARK: - BMKGeoCodeSearchDelegate
    //接收反向地理编码结果
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if result != nil {
            
            if( result.poiList.first != nil)
            {
                
                self.dingWeiStr = result.addressDetail.city + result.addressDetail.district
                self.streetNameStr = (result.poiList[0] as! BMKPoiInfo).name
                if self.city != ""{
                    userLocationCenter.setObject(self.city+streetNameStr, forKey: "RealTimeLocation")
                }else{
                    userLocationCenter.setObject(self.dingWeiStr+streetNameStr, forKey: "RealTimeLocation")
                }
                
                userLocationCenter.setObject(String(result.location.latitude), forKey: "RealTimelatitude")
                userLocationCenter.setObject(String(result.location.longitude), forKey: "RealTimelongitude")
                CommitOrderViewController.FirstLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                LocationViewController.firstAddress = dingWeiStr+streetNameStr
                CommitOrderViewController.firstString = dingWeiStr+streetNameStr
                CommitOrderViewController.secondstring = dingWeiStr+streetNameStr
                CommitOrderViewController.SecondLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                LocationViewController.secondAddress = dingWeiStr+streetNameStr
                MainViewController.BMKname =  dingWeiStr+streetNameStr
                MainViewController.city = (result.poiList[0] as! BMKPoiInfo).city
                
                //                print(dingWeiStr)
                //                print(result.addressDetail.district)
                if (isDingwei) {
                    
                    if userLocationCenter.objectForKey("userid") != nil {
                        mainHelper.GetWorkingState(userLocationCenter.objectForKey("userid") as! String) { (success, response) in
                            if success{
                              if response as! String == "1"{
                                self.mainHelper.BeginWorking(self.userLocationCenter.objectForKey("userid") as! String, address: self.dingWeiStr+self.streetNameStr, longitude: String(result.location.longitude), latitude: String(result.location.latitude), isworking: "1") { (success, response) in
                                    
                                    
                                    
                                }
                                }
                                
                            }
                        }
                        
                }
                    
                    
                    
                    self.godingwei = self.dingWeiStr
                    self.golocationForUser = result.location
                    self.goQuName = result.addressDetail.district
                    userLocationCenter.setObject(dingWeiStr+streetNameStr, forKey: "UserLocation")
                    userLocationCenter.setObject(self.dingWeiStr, forKey: "subLocality")
                    if userLocationCenter.objectForKey("quName") == nil {
                        userLocationCenter.setObject(result.addressDetail.district, forKey: "quName")
                        
                        
                        let alertController = UIAlertController(title: "系统提示",
                                                                message: "亲，您当前定位城市为"+self.dingWeiStr+"，是否选择当前城市？", preferredStyle: .Alert)
                        let cancelAction = UIAlertAction(title: "选择其他", style: .Cancel, handler: { action in
                            
                            self.cityController = CityViewController(nibName: "CityViewController", bundle: nil)
                            self.cityController.delegate = self
                            self.navigationController?.pushViewController(self.cityController, animated: true)
                            
                            self.cityController.title = "定位"
                            
                        })
                        let okAction = UIAlertAction(title: "确定", style: .Default,
                                                     handler: { action in
                                                        
                                                        
                                                        self.userLocationCenter.setObject(result.addressDetail.city, forKey: "cityName")
                                                        
                                                        self.userLocationCenter.setObject(result.addressDetail.district, forKey: "quName")
                                                        
                                                        
                                                        self.mainhelper.checkCity(result.addressDetail.district) { (success, response) in
                                                            if success{
                                                                self.dingweiCityID = (response as? String)!
                                                            }else{
                                                                self.dingweiCityID = ""
                                                            }
                                                            self.userLocationCenter.setObject(self.dingweiCityID, forKey: "cityid")
                                                        }
                                                        
                                                  
                                                        
                                                        self.location.setTitle(self.userLocationCenter.objectForKey("quName") as? String, forState: UIControlState.Normal)
                                                        //                                                    }
                                                        
                                                        
                        })
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    //                    print(self.dingWeiStr)
                    userLocationCenter.setObject(self.streetNameStr, forKey: "streetName")
                    //                    print(self.streetNameStr)
                    postMyaddress()
                    isDingwei = false
                }
                address = MainViewController.BMKname
                //                print(result.addressDetail.city)
                //                print(result.addressDetail.streetName)
                //                print(result.addressDetail.district)
                
                pointAnmation.coordinate = mapView.region.center
                pointAnmation.title = (result.poiList[0] as! BMKPoiInfo).name
                mapView.addAnnotation(pointAnmation)
                
                mapView.selectAnnotation(pointAnmation, animated: true)
                
                
            }
            
        }
        
    }
    
    
    
    func dingWeiAction(sender:UIButton)  {
        let opt = BMKOpenDrivingRouteOption()
        opt.appScheme = "a51bang://a51bang"
        let start = BMKPlanNode()
        var coor1 = CLLocationCoordinate2D.init()
        let ud = NSUserDefaults.standardUserDefaults()
        let longitude = ud.objectForKey("longitude")
        let latitude = ud.objectForKey("latitude")
        let address = ud.objectForKey("myAddress")
        
        if latitude != nil && longitude != nil{
            coor1.latitude = CLLocationDegrees(latitude as! String)!
            coor1.longitude = CLLocationDegrees(longitude as! String)!
        }else{
            alert("请打开定位", delegate: self)
            return
        }
        //指定起点名称
        if address != nil {
            start.name = address as! String
        }else{
            alert("请打开定位", delegate: self)
            return
        }
        //            start.name = self.info.address!
        start.pt = coor1
        //指定起点
        opt.startPoint = start
        
        
        //初始化终点节点
        let end = BMKPlanNode.init()
        
        var coor2 = CLLocationCoordinate2D.init()
        if  self.infoMore!.latitude != "" && self.infoMore!.longitude != ""{
            coor2.latitude = CLLocationDegrees(self.infoMore!.latitude as String)!
            coor2.longitude = CLLocationDegrees(self.infoMore!.longitude as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.infoMore!.address != "" {
            end.name = self.infoMore!.address
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
    }
    
    func message(sender:UIButton){
//        myTableView.userInteractionEnabled = false
        let vc = ChetViewController()
        vc.receive_uid = self.infoMore!.id
        vc.titleTop = self.infoMore!.name
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        if userid == self.infoMore!.id{
//            myTableView.userInteractionEnabled = true
            alert("请不要和自己说话", delegate: self)
        }else{
            mainHelper.getChatMessage(userid, receive_uid: self.infoMore!.id) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        alert("加载错误", delegate: self)
                        return
                    }
                    let dat = NSMutableArray()
                    self.dataSource3 = response as? Array<chatInfo> ?? []
                    if self.dataSource3.count != 0{
                        for num in 0...self.dataSource3.count-1{
                            let dic = NSMutableDictionary()
                            dic.setObject(self.dataSource3[num].id!, forKey: "id")
                            dic.setObject(self.dataSource3[num].send_uid!, forKey: "send_uid")
                            dic.setObject(self.dataSource3[num].receive_uid!, forKey: "receive_uid")
                            dic.setObject(self.dataSource3[num].content!, forKey: "content")
                            dic.setObject(self.dataSource3[num].status!, forKey: "status")
                            dic.setObject(self.dataSource3[num].create_time!, forKey: "create_time")
                            if self.dataSource3[num].send_face != nil{
                                dic.setObject(self.dataSource3[num].send_face!, forKey: "send_face")
                            }
                            
                            if self.dataSource3[num].send_nickname != nil{
                                dic.setObject(self.dataSource3[num].send_nickname!, forKey: "send_nickname")
                            }
                            
                            if self.dataSource3[num].receive_face != nil{
                                dic.setObject(self.dataSource3[num].receive_face!, forKey: "receive_face")
                            }
                            
                            if self.dataSource3[num].receive_nickname != nil{
                                dic.setObject(self.dataSource3[num].receive_nickname!, forKey: "receive_nickname")
                            }
                            
                            
                            dat.addObject(dic)
                            
                            //                vc.datasource2.addObject(dic)
                            
                        }
                        
                        vc.datasource2 = NSArray.init(array: dat) as Array
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
                
            }
            
        }
        
    }
    func infoInmoreButtonAction(sender:UIButton){
        if self.infoMore != nil{
            let vc = FuWuHomePageViewController()
            vc.ismainCome = true
            vc.info = self.infoMore
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            alert("慢点点人家，人家还在加载", delegate: self)
        }
        
    }
    
    
}
