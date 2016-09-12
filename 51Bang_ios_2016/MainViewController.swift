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
    
    let mainHelper = MainHelper()
    var city = String()
    var dingWeiStr = String()
    var longitude = String()
    var latitude = String()
    let backView = UIView()
    let backMHView = UIView()
    var isDingwei = Bool()
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
    
    
    
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    override func viewWillAppear(animated: Bool) {
        CheckRenzheng()
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
         geocodeSearch.delegate = self
        locationService.delegate = self
        mapView.viewWillAppear()
        mapView.delegate = self
        CommitOrderViewController.ReturnTagForView = 0
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
       print(String(MainViewController.userLocationForChange.coordinate.latitude))
        if (userLocationCenter.objectForKey("myAddress") == nil) {
            
            
        }
        
        
        if (isDingwei) {
            userLocationCenter.setObject(self.dingWeiStr, forKey: "subLocality")
        }
        
        geocodeSearch.delegate = nil
        locationService.delegate = nil
        mapView.viewWillDisappear()
        mapView.delegate = nil
        self.backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
//        self.BeingBackMyPositonBtn.removeFromSuperview()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMyName(_:)), name:"NotificationIdentifier", object: nil)
        locationService = BMKLocationService()
        locationService.delegate = self
        locationService.startUserLocationService()
        mapView = BMKMapView.init()
        geocodeSearch = BMKGeoCodeSearch()
        createTopView()
        setBMKMpaview()
        scrollView.scrollEnabled = false
        let button = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(20, UIScreen.mainScreen().bounds.size.height - 130, 30, 30)
        button.setImage(UIImage(named: "sign.png"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.moveToUser), forControlEvents: UIControlEvents.TouchUpInside)
        self.BeingBackMyPositonBtn = button
//        self.mapView.addSubview(BeingBackMyPositonBtn)
    
    }
    func getMyName(notification:NSNotification){
        let name = notification.object?.valueForKey("name") as? String
        self.selectCity(name!)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "NotificationIdentifier", object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self)
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
                
            }
            
            else if(MainViewController.renZhengStatue == 0)
            {
                let vc  = WobangRenZhengController()
                
//                vc.cityName = self.cityName
//                vc.longitude = self.longitude
//                vc.latitude = self.latitude
//                vc.address = address

                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
            }else{
                
                
                
                let vc = CommitOrderViewController()
                //let string = self.administrativeArea+self.cityName+self.thoroughfare
               
//                vc.cityName = self.cityName
//                vc.longitude = self.longitude
//                vc.latitude = self.latitude
//                vc.address = address
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if btn.tag == 1{
            
            
            let vc = WoBangPageViewController()
            vc.navigationController?.title = "我帮"
            vc.longitude = self.longitude
            vc.latitude = self.latitude
                self.navigationController?.pushViewController(vc, animated: true)
            
            
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
    func selectCity(city: String) {
        print(city)
        self.city = city
        self.backView.removeFromSuperview()
        self.backMHView.removeFromSuperview()
        
//        let cityNsstring = city as NSString
        var count = Int()
        for a in city.characters{
            if a == "市" || a == "盟" || a == "旗" || a == "县" || a == "州" || a == "区"{
                break
            }
            count = count + 1
        }
        let cutyName = city.substringToIndex(city.startIndex.advancedBy(count+1))
        
        let quName = city.substringFromIndex(city.startIndex.advancedBy(count+1))
        print(cutyName)
        print(quName)
        location.setTitle(quName, forState: UIControlState.Normal)
        location.sizeToFit()
        let searcher = BMKGeoCodeSearch()
        searcher.delegate = self
        let geoCodeSearchOption = BMKGeoCodeSearchOption()
        geoCodeSearchOption.city = cutyName
        geoCodeSearchOption.address = quName
        let flog = searcher.geoCode(geoCodeSearchOption)
        print(flog)
        
        mainHelper.checkCity(city) { (success, response) in
            print(response)
            if !success{
                
                self.backMHView.frame = CGRectMake(0, 0, WIDTH, self.view.bounds.height+15)
                self.backMHView.backgroundColor = UIColor.grayColor()
                self.backMHView.alpha = 0.5
                UIApplication.sharedApplication().keyWindow!.addSubview(self.backMHView)
                
                self.backView.frame = CGRectMake(50,280, WIDTH-100, 150)
                self.backView.backgroundColor = UIColor.whiteColor()
                self.backView.layer.masksToBounds = true
                self.backView.layer.cornerRadius = 8
                
                let label11 = UILabel.init(frame: CGRectMake(0, 0, WIDTH-100, 30))
                label11.backgroundColor = UIColor.whiteColor()
                label11.text = "当前城市未开通51帮同城服务"
                label11.textColor = COLOR
                label11.textAlignment = NSTextAlignment.Center
                self.backView.addSubview(label11)
                
                let button11 = UIButton.init(frame: CGRectMake(0, 30, WIDTH-100, 50))
                button11.backgroundColor = UIColor.whiteColor()
                var titleStr = String()
                titleStr = "请拨打400-0608-856"
                let str = NSMutableAttributedString.init(string: titleStr)
                str.addAttribute(NSForegroundColorAttributeName, value:COLOR, range: NSMakeRange(0,3))
                str.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(3,12))
                //            str.addAttribute(NSUnderlineStyleAttributeName, value: UIColor.blackColor(), range: NSMakeRange(3,12))
                button11.setAttributedTitle(str, forState: UIControlState.Normal)
                
                
                //            button11.setTitleColor(COLOR, forState: UIControlState.Normal)
                button11.addTarget(self, action: #selector(self.phoneCall), forControlEvents: UIControlEvents.TouchUpInside)
                self.backView.addSubview(button11)
                let label22 = UILabel.init(frame: CGRectMake(0, 80, WIDTH-100, 30))
                label22.backgroundColor = UIColor.whiteColor()
                label22.text = "申请开通或代理"
                label22.textColor = COLOR
                label22.textAlignment = NSTextAlignment.Center
                self.backView.addSubview(label22)
                
                let backbutton = UIButton.init(frame: CGRectMake((WIDTH-100)/2, 110, (WIDTH-100)/2, 40))
                
                backbutton.backgroundColor = UIColor.whiteColor()
                backbutton.setTitle("返回城市选择", forState: UIControlState.Normal)
                backbutton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                backbutton.addTarget(self, action: #selector(self.backCityVc), forControlEvents: UIControlEvents.TouchUpInside)
                self.backView.addSubview(backbutton)
                
                UIApplication.sharedApplication().keyWindow!.addSubview(self.backView)
            }else{
                self.backView.removeFromSuperview()
                self.backMHView.removeFromSuperview()
            }
        }
//        if (city != "北京"||city != "烟台"||city != "上海"||city != "深圳"||city != "广州") {
//            
//            
//            
//        }
    }
    
    func phoneCall(){
        
        backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
        UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://400-0608-856")!)
    }
    
    func backCityVc(){
        backMHView.removeFromSuperview()
        self.backView.removeFromSuperview()
        
        cityController = CityViewController(nibName: "CityViewController", bundle: nil)
        cityController.delegate = self
        
        self.navigationController?.pushViewController(cityController, animated: true)
        
        cityController.title = "定位"
    }
    
    @IBAction func goToFriendList(sender: AnyObject) {
        print("认证帮")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FriendView")
        self.navigationController?.pushViewController(vc, animated: true)
        vc.title = "认证帮"
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
        mapView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 64.0)
        mapView.showsUserLocation = true
        mapView.zoomLevel = 19
        mapView.gesturesEnabled = true
        //交通实况
        mapView.trafficEnabled = true
//        mapView.updateLocationData
        scrollView.addSubview(mapView)
        
//        let annoImage = UIButton()
//        let point = CGPointMake(self.mapView.center.x, self.mapView.center.y - 13)
//        annoImage.center = point
//        annoImage.bounds = CGRectMake(0, 0, 20, 26)
//        annoImage.backgroundColor = UIColor.redColor()
//        self.annoImage = annoImage
//        self.view.addSubview(self.annoImage)
        
//        let button = UIButton.init(type: UIButtonType.Custom)
//        button.frame = CGRectMake(20, UIScreen.mainScreen().bounds.size.height - 130, 30, 30)
//        button.setImage(UIImage(named: "sign.png"), forState: UIControlState.Normal)
//        button.addTarget(self, action: #selector(self.moveToUser), forControlEvents: UIControlEvents.TouchUpInside)
//        self.BeingBackMyPositonBtn = button
//        UIApplication.sharedApplication().keyWindow!.addSubview(self.BeingBackMyPositonBtn)
        
        
    }
    
    func moveToUser(){
        mapView.updateLocationData(self.savedLocation)
        mapView.setCenterCoordinate(self.savedLocation.location.coordinate, animated: true)
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
        print(result.location.latitude)
        print(result.location.longitude)
        print(result.address)
        print(result.description)
        mapView.selectAnnotation(pointAnmation, animated: true)
//        self.WillShowName(result.location.longitude, longtitude: result.location.latitude)
    }
    
    //MARK: - BMKGeoCodeSearchDelegate
    //接收反向地理编码结果
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if result != nil {
            if( result.poiList.first != nil)
            {
                CommitOrderViewController.FirstLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                LocationViewController.firstAddress = result.address
                CommitOrderViewController.SecondLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                LocationViewController.secondAddress = result.address
                MainViewController.BMKname =  (result.poiList[0] as! BMKPoiInfo).name
                MainViewController.city = (result.poiList[0] as! BMKPoiInfo).city
                self.dingWeiStr = result.addressDetail.city + result.addressDetail.district
                address = MainViewController.BMKname
                print(result.addressDetail.city)
                print(result.addressDetail.streetName)
                print(result.addressDetail.district)
                
                pointAnmation.coordinate = mapView.region.center
                pointAnmation.title = MainViewController.BMKname
                mapView.addAnnotation(pointAnmation)
                
                mapView.selectAnnotation(pointAnmation, animated: true)
                
                
            }

        }
        
//        createPointAnmation(MainViewController.userLocationForChange)
//          address = MainViewController.BMKname
    }
    
    
    
    
    
    

    
}
