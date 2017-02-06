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


var address:String  = ""
class MainViewController: UIViewController,CityViewControllerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate{
    
    var dataSource2 : Array<chatInfo>?
    var rzbDataSource : Array<RzbInfo>?
    var biaoZhuArray = NSMutableArray()
    var cutyName = String()
    var quName = String()
    let mainHelper = MainHelper()
    var city = String()
    var dingWeiStr = String()
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
    let nameArr:[String] = ["帮我","抢单","便民圈"]
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
    
    
    
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    override func viewWillAppear(animated: Bool) {
        
        
        if self.userLocationCenter.objectForKey("quName") != nil{
            self.location.setTitle(self.userLocationCenter.objectForKey("quName") as? String, forState: UIControlState.Normal)
        }
        
        
        locationService = BMKLocationService()
        locationService.delegate = self
        locationService.startUserLocationService()
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
        let button = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(20, UIScreen.mainScreen().bounds.size.height - 130, 30, 30)
        button.setImage(UIImage(named: "sign.png"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.moveToUser), forControlEvents: UIControlEvents.TouchUpInside)
        self.BeingBackMyPositonBtn = button
        CheckRenzheng()
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        geocodeSearch.delegate = self
        //        locationService.delegate = self
        mapView.viewWillAppear()
        mapView.delegate = self
        CommitOrderViewController.ReturnTagForView = 0
        
        let searcher = BMKGeoCodeSearch()
        searcher.delegate = self
        let geoCodeSearchOption = BMKGeoCodeSearchOption()
        geoCodeSearchOption.city = cutyName
        geoCodeSearchOption.address = quName
        let flog = searcher.geoCode(geoCodeSearchOption)
        print(flog)
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
        buttons.frame = CGRectMake(20, UIScreen.mainScreen().bounds.size.height - 130, 30, 30)
        buttons.setImage(UIImage(named: "sign.png"), forState: UIControlState.Normal)
        buttons.addTarget(self, action: #selector(self.moveToUser), forControlEvents: UIControlEvents.TouchUpInside)
        self.BeingBackMyPositonBtn = buttons
        UIApplication.sharedApplication().keyWindow!.addSubview(self.BeingBackMyPositonBtn)
        
        
        
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        print(String(MainViewController.userLocationForChange.coordinate.latitude))
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
        
        geocodeSearch.delegate = nil
        locationService.delegate = nil
        mapView.viewWillDisappear()
        mapView.delegate = nil
        //        self.backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
        self.BeingBackMyPositonBtn.removeFromSuperview()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dingWeiStr = "0"
        
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
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.newMessage(_:)), name:"newMessage", object: nil)
        //
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sendTaskType(_:)), name:"sendTaskType", object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.acceptTaskType(_:)), name:"acceptTaskType", object: nil)
        //
        //         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.buyOrderType(_:)), name:"buyOrderType", object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.businessOrderType(_:)), name:"businessOrderType", object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loginFromOther), name:"loginFromOther", object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.certificationType(_:)), name:"certificationType", object: nil)
        
        
        
        
        //        self.mapView.addSubview(BeingBackMyPositonBtn)
        
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
                    print(response! as! String)
                    
                    
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
        let name = notification.object?.valueForKey("name") as? String
        let quname = notification.object?.valueForKey("quname") as? String
        self.selectCity(name!,quname:quname!)
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
//            let ud = NSUserDefaults.standardUserDefaults()
//            if ud.objectForKey("ss") != nil{
//                if(ud.objectForKey("ss") as! String == "no")
//                {
//                    
//                    
//                    
//                    let alertController = UIAlertController(title: "系统提示",
//                                                            message: "亲，您还没实名认证，是否去认证？", preferredStyle: .Alert)
//                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//                    let okAction = UIAlertAction(title: "确定", style: .Default,
//                                                 handler: { action in
//                                                    
//                                                    
//                                                    self.tabBarController?.selectedIndex = 1
//                                                    
//                    })
//                    alertController.addAction(cancelAction)
//                    alertController.addAction(okAction)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                    return
//                    
//                    
//                    
//                }
//            }
            
            
            
            
            
            let vc = CommitOrderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if btn.tag == 1{
//            let ud = NSUserDefaults.standardUserDefaults()
//            if ud.objectForKey("ss") != nil{
//                if(ud.objectForKey("ss") as! String == "no")
//                {
//                    
//                    
//                    
//                    let alertController = UIAlertController(title: "系统提示",
//                                                            message: "亲，您还没实名认证，是否去认证？", preferredStyle: .Alert)
//                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//                    let okAction = UIAlertAction(title: "确定", style: .Default,
//                                                 handler: { action in
//                                                    
//                                                    self.tabBarController?.selectedIndex = 1
//                                                    
//                    })
//                    alertController.addAction(cancelAction)
//                    alertController.addAction(okAction)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                    return
//                    
//                }
//            }
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
        cityController.delegate = self
        self.navigationController?.pushViewController(cityController, animated: true)
        
        cityController.title = "定位"
    }
    func selectCity(city: String,quname:String) {
        print(city)
        self.city = city
        
        self.backView.removeFromSuperview()
        //        self.backMHView.removeFromSuperview()
        
        //        let cityNsstring = city as NSString
        var count = Int()
        let myArray1 = NSMutableArray()
        for a in city.characters{
            if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
                break
            }
            count = count + 1
        }
        print(count)
        cutyName = (city as NSString).substringToIndex(count+1)
        userLocationCenter.setObject(cutyName, forKey: "cityName")
        
        quName = city.substringFromIndex(city.startIndex.advancedBy(count+1))
        var quCount = Int()
        for a in quName.characters{
            if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
                myArray1.addObject(quCount)
            }
            
            quCount = quCount + 1
        }
        if myArray1.count>1 {
            if city == "重庆市万州区" {
                
            }else{
                quName = quName.substringFromIndex(quName.startIndex.advancedBy((myArray1[0] as! Int)+1))
                cutyName = (city as NSString).substringToIndex((count+1+(myArray1[0] as! Int)+1))
                print(cutyName)
                userLocationCenter.setObject(cutyName, forKey: "cityName")
            }
            
            
        }
        print(cutyName)
        print(quName)
        let cityname1 = (city as NSString).substringToIndex(city.characters.count - quName.characters.count)
        
        print(cityname1)
        
        
        if quname == ""{
            userLocationCenter.setObject(quName, forKey: "quName")
            
            location.setTitle(quName, forState: UIControlState.Normal)
            location.sizeToFit()
            let searcher = BMKGeoCodeSearch()
            searcher.delegate = self
            let geoCodeSearchOption = BMKGeoCodeSearchOption()
            geoCodeSearchOption.city = cutyName
            geoCodeSearchOption.address = quName
            let flog = searcher.geoCode(geoCodeSearchOption)
            print(flog)
            
        }else{
            cutyName = cityname1
            quName = quname
            userLocationCenter.setObject(quname, forKey: "quName")
            
            location.setTitle(quname, forState: UIControlState.Normal)
            location.sizeToFit()
            let searcher = BMKGeoCodeSearch()
            searcher.delegate = self
            let geoCodeSearchOption = BMKGeoCodeSearchOption()
            geoCodeSearchOption.city = cutyName
            geoCodeSearchOption.address = quname
            let flog = searcher.geoCode(geoCodeSearchOption)
            userLocationCenter.setObject(cityname1, forKey: "cityName")
            print(flog)
        }
        
        
       
        
        //        mainHelper.checkCity(quName) { (success, response) in
        //            print(response)
        //            if !success{
        ////
        //                self.backMHView.frame = CGRectMake(0, 0, WIDTH, self.view.bounds.height+15)
        //                self.backMHView.backgroundColor = UIColor.grayColor()
        //                self.backMHView.alpha = 0.5
        //                UIApplication.sharedApplication().keyWindow!.addSubview(self.backMHView)
        //
        //                self.backView.frame = CGRectMake(50,280, WIDTH-100, 150)
        //                self.backView.backgroundColor = UIColor.whiteColor()
        //                self.backView.layer.masksToBounds = true
        //                self.backView.layer.cornerRadius = 8
        //
        //                let label11 = UILabel.init(frame: CGRectMake(0, 0, WIDTH-100, 30))
        //                label11.backgroundColor = UIColor.whiteColor()
        //                label11.text = "当前城市未开通51帮同城服务"
        //                label11.textColor = COLOR
        //                label11.textAlignment = NSTextAlignment.Center
        //                self.backView.addSubview(label11)
        //
        //                let button11 = UIButton.init(frame: CGRectMake(0, 30, WIDTH-100, 50))
        //                button11.backgroundColor = UIColor.whiteColor()
        //                var titleStr = String()
        //                titleStr = "请拨打400-0608-856"
        //                let str = NSMutableAttributedString.init(string: titleStr)
        //                str.addAttribute(NSForegroundColorAttributeName, value:COLOR, range: NSMakeRange(0,3))
        //                str.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(3,12))
        //                //            str.addAttribute(NSUnderlineStyleAttributeName, value: UIColor.blackColor(), range: NSMakeRange(3,12))
        //                button11.setAttributedTitle(str, forState: UIControlState.Normal)
        //
        //
        //                //            button11.setTitleColor(COLOR, forState: UIControlState.Normal)
        //                button11.addTarget(self, action: #selector(self.phoneCall), forControlEvents: UIControlEvents.TouchUpInside)
        //                self.backView.addSubview(button11)
        //                let label22 = UILabel.init(frame: CGRectMake(0, 80, WIDTH-100, 30))
        //                label22.backgroundColor = UIColor.whiteColor()
        //                label22.text = "申请开通或代理"
        //                label22.textColor = COLOR
        //                label22.textAlignment = NSTextAlignment.Center
        //                self.backView.addSubview(label22)
        //
        //                let backbutton = UIButton.init(frame: CGRectMake((WIDTH-100)/2, 110, (WIDTH-100)/2, 40))
        //
        //                backbutton.backgroundColor = UIColor.whiteColor()
        //                backbutton.setTitle("返回城市选择", forState: UIControlState.Normal)
        //                backbutton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //                backbutton.addTarget(self, action: #selector(self.backCityVc), forControlEvents: UIControlEvents.TouchUpInside)
        //                self.backView.addSubview(backbutton)
        //
        //                UIApplication.sharedApplication().keyWindow!.addSubview(self.backView)
        //            }else{
        //                self.backView.removeFromSuperview()
        //                self.backMHView.removeFromSuperview()
        //            }
        //        }
        //        if (city != "北京"||city != "烟台"||city != "上海"||city != "深圳"||city != "广州") {
        //
        //
        //
        //        }
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
        
        
        mainHelper.GetHomeRzbList (cityname,beginid: "-1",sort:"" ,type: "", handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    
                    return
                }
                self.rzbDataSource = response as? Array<RzbInfo> ?? []
                if self.rzbDataSource == nil{
                    return
                }
                for RZB in self.rzbDataSource!{
                    let biaozhu = BMKPointAnnotation()
                    
                    if  RZB.latitude != ""{
                        
                        biaozhu.coordinate.latitude = CLLocationDegrees(RZB.latitude)!
                        
                    }
                    if  RZB.longitude != ""{
                        biaozhu.coordinate.longitude = CLLocationDegrees(RZB.longitude)!
                    }
                    if RZB.isworking as String == "1"{
                        self.mapView.addAnnotation(biaozhu)
                        self.biaoZhuArray.addObject(biaozhu)
                    }
                    
                    
                    //
                }
                //                self.mapView.addAnnotations(self.biaoZhuArray as [AnyObject])
                
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
            
            newAnnotationView.annotation = annotation
            newAnnotationView.image = UIImage.init(named: "蓝色小人")
            return newAnnotationView
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
        mapView.zoomLevel = 19
        mapView.gesturesEnabled = true
        //交通实况
        mapView.trafficEnabled = true
        
        getWeiZhi()
        //        mapView.updateLocationData
        scrollView.addSubview(mapView)
        
        
        
        
    }
    
    func moveToUser(){
        
        //        print(self.savedLocation.location)
        //        print(self.savedLocation.location.coordinate)
        if self.savedLocation != self.flagLocation {
            mapView.updateLocationData(self.savedLocation)
            mapView.setCenterCoordinate(self.savedLocation.location.coordinate, animated: true)
        }else{
            alert("请打开定位功能", delegate: self)
            return
        }
        
        if userLocationCenter.objectForKey("subLocality") != nil && userLocationCenter.objectForKey("subLocality") as! String != "0"&&userLocationCenter.objectForKey("quName") != nil{
            userLocationCenter.setObject(userLocationCenter.objectForKey("subLocality") as! String, forKey: "cityName")
            
            let strr = userLocationCenter.objectForKey("subLocality") as! String
            
            var count = Int()
            for a in strr.characters{
                if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
                    break
                }
                count = count + 1
            }
            cutyName = (strr as NSString).substringFromIndex(strr.characters.count-quName.characters.count)
            userLocationCenter.setObject(cutyName, forKey: "cityName")
            
            quName = userLocationCenter.objectForKey("quName") as! String
//            let myArray1 = NSMutableArray()
//            var quCount = Int()
//            for a in quName.characters{
//                if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
//                    myArray1.addObject(quCount)
//                }
//                
//                quCount = quCount + 1
//            }
//            if myArray1.count>1 {
//                quName = quName.substringFromIndex(quName.startIndex.advancedBy((myArray1[0] as! Int)+1))
//            }
            self.mapView.removeAnnotations(self.biaoZhuArray as [AnyObject])
            self.getWeiZhi()
        }
        
        
        
        
    }
    
    
    
    
    //反地理检索
    
    func  WillShowName( latitude:CLLocationDegrees,longtitude:CLLocationDegrees)
    {
        
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(latitude,longtitude)
        
        print(latitude,longtitude)
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
            print(userLocation.title)
            
            mapView.addAnnotation(pointAnmation)
            
            mapView.selectAnnotation(pointAnmation, animated: true)
            isDingwei = true
            print(userLocation.location.coordinate.latitude)
            print(userLocation.location.coordinate.longitude)
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
//        print(result.location.latitude)
//        print(result.location.longitude)
//        print(result.address)
//        print(result.description)
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
                CommitOrderViewController.SecondLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                LocationViewController.secondAddress = dingWeiStr+streetNameStr
                MainViewController.BMKname =  dingWeiStr+streetNameStr
                MainViewController.city = (result.poiList[0] as! BMKPoiInfo).city
                
                //                print(dingWeiStr)
                //                print(result.addressDetail.district)
                if (isDingwei) {
                    print(self.dingWeiStr+self.streetNameStr)
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
                                                        
                                                        //
                                                        //                                                    if self.userLocationCenter.objectForKey("quName") == nil{
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
        
        //        createPointAnmation(MainViewController.userLocationForChange)
        //          address = MainViewController.BMKname
    }
    
    
    
    //    func addPointAnnotation() {
    //        
    //            
    //            let ary1:NSArray = ["31.222771","39.915 ","31.229003"]
    //            let ary2:NSArray = ["121.490317","116.404","121.448224"]
    //            
    //            var coor: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    //        
    //            for i in 0 ..< ary1.count {
    //                
    //                pointAnmation = BMKPointAnnotation.init() //必须放在循环里初始化
    //                coor.latitude  = ary1[i].doubleValue
    //                coor.longitude = ary2[i].doubleValue
    //                pointAnmation.coordinate = coor
    //                mapView.addAnnotation(pointAnmation)
    //                
    //            }
    //    }
    
    
    
}
