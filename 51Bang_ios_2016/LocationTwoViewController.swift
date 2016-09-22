//
//  LocationTwoViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LocationTwoViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UIAlertViewDelegate{
    
    private var locationView = MKMapView()
    var centerLatitudeArray = NSMutableArray()
    var centerLongitudeArray = NSMutableArray()
    var longitude = CLLocationDegrees()
    var latitude = CLLocationDegrees()
    //定位管理者
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    let objectAnnotation = MKPointAnnotation()
    var cityName = String()
    var administrativeArea = String()
    var thoroughfare = String()
    var subLocality = String()
    var address = String()
    var updataAddress = String()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建位置管理器
        //        self.locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistanceMax
        //制定需要的精度级别
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        //启动位置管理器
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined {
            let alert = UIAlertView.init(title: "温馨提示", message: "您需要开启定位服务,请到设置->隐私,打开定位服务", delegate: self, cancelButtonTitle: "确定", otherButtonTitles:"取消")
            alert.show()
        }else if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }else{
            let alert = UIAlertView.init(title: "温馨提示", message: "定位服务授权失败,请检查您的定位设置", delegate: self, cancelButtonTitle: "确定", otherButtonTitles:"取消")
            alert.show()
            
        }
        
        locationView = MKMapView(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        locationView.delegate = self
        //        self.scrollView.addSubview(locationView)
        locationView.mapType = .Standard
        locationView.showsUserLocation = true
        self.view.addSubview(locationView)
        let mTap = UITapGestureRecognizer.init(target: self, action: #selector(tapPress(_:)))
        locationView.addGestureRecognizer(mTap)
        self.getAddressWithString(self.address)
        
        
        
        //        self.createAnnotation(self.latitude, longitude: self.longitude)
        // Do any additional setup after loading the view.
    }
    
    //点击地图插入大头针
    func tapPress(gestureRecognizer : UIGestureRecognizer){
        
        //        self.locationView.removeAnnotations(locationView.annotations)
        //        let point = gestureRecognizer.locationInView(locationView)
        //        let touchMapCoordinate = locationView.convertPoint(point, toCoordinateFromView: locationView)
        //        self.createAnnotation(touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        
        
    }
    
    
    func getAddressWithString(str:String){
        
        self.geocoder.geocodeAddressString(str) { (placemarks,error) in
            if (placemarks!.count == 0 || error != nil) {
                return ;
            }
            
            let placemark = placemarks?.first
            self.longitude = (placemark?.location?.coordinate.longitude)!
            self.latitude = (placemark?.location?.coordinate.latitude)!
            print(self.longitude)
            print(self.latitude)
            self.createAnnotation(self.latitude, longitude: self.longitude)
        }
        
    }
    
    
    
    func createAnnotation(latitude:Double,longitude:Double){
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("cityName") != nil {
            self.cityName = ud.objectForKey("cityName")as! String
        }
        if (ud.objectForKey("thoroughfare") != nil) {
            self.thoroughfare = ud.objectForKey("thoroughfare")as! String
        }
        if (ud.objectForKey("subLocality") != nil && ud.objectForKey("subLocality") as! String != "0") {
            self.subLocality = ud.objectForKey("subLocality")as! String
        }
//        self.cityName = ud.objectForKey("cityName")as! String
//        self.thoroughfare = ud.objectForKey("thoroughfare")as! String
//        self.subLocality = ud.objectForKey("subLocality")as! String
        //获取上一次比例，重新赋值
        let latdelta = 0.06
        let longdelta = 0.06
        var currentLocationSpan = MKCoordinateSpan()
        currentLocationSpan = MKCoordinateSpanMake(latdelta, longdelta)
        //        位置坐标
        let center:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        
        //        设置显示区域
        locationView.setRegion(currentRegion, animated: true)
        //        创建大头针
        let loc = CLLocation.init(latitude: latitude, longitude: longitude)
        let coord:CLLocationCoordinate2D = loc.coordinate
        let mypoint = MyPoint.init(coordinate: coord, andTitle: self.address)
        self.locationView.addAnnotation(mypoint)
        locationView.showsUserLocation = false
        
        
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
