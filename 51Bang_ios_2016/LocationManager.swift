//
//  LocationManager.swift
//  MWN_user_2016
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

protocol LocationManagerDelegate{
    func locationCity(cityName:String);
}

class LocationManager: NSObject,CLLocationManagerDelegate {
    /** 获取城市位置代理*/
    var delegate:LocationManagerDelegate?;
    /** 位置管理*/
    var locationManager:CLLocationManager?;
    
    override init() {
        super.init();
    }
    
    /** 获取当前城市*/
    func startLocationCity(){
        
        if(CLLocationManager.locationServicesEnabled()){ //开启定位
            locationManager = CLLocationManager();
            locationManager!.delegate = self;
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager!.distanceFilter = 100;
            // self.location!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            if #available(iOS 8.0, *) {
                self.locationManager!.requestWhenInUseAuthorization()
            } else {
                // Fallback on earlier versions
            }
            
            
            
        }else{//未开启定位
            print("未开启gps");
        }
        locationManager!.startUpdatingLocation();
        
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.count >= 1){
            let  location:CLLocation = locations[locations.count - 1];
            self.locationManager!.stopUpdatingLocation();
            let geocoder:CLGeocoder = CLGeocoder();
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks:[CLPlacemark]?, NSError) -> Void in
                if(placemarks != nil && placemarks!.count >= 1){
                    let placemar:CLPlacemark = placemarks![0];
                    var city:String? = placemar.locality;
                    if(city == nil){ //当前城市为
                        city = placemar.administrativeArea;
                    }
                    if(self.delegate != nil){
                        self.delegate!.locationCity(city!);
                    }
                }
            })
        }
    }
    
}
