//
//  ExtensionCommitViewController.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

extension CommitOrderViewController{

    
    func calculDistence(notification:NSDictionary)
    {
//        let name = notification.object?.valueForKey("name") as? String
        if(location.text.characters.count == 0 || shangmen.text.characters.count == 0)
        {
            return
        }
        
        useGeoTag = 1
        setCodeSearch(shangmen.text)
        self.DistanceForShow(notification)
    
    }

    func setCodeSearch(Keyword:String)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        geoCodeSearchOption.city = MainViewController.city
        geoCodeSearchOption.address = Keyword
        
        if( searcher.geoCode(geoCodeSearchOption))
        {
            print("检索成功")
        
        }else{
        
            print("检索失败")
        }
    }
    
    func DistanceForShow(notification:NSDictionary)
    {
        
        
//        ["latitude":latitude,"longitude":longitude,"slatitude":slatitude,"slongitude":slongitude];
        
        let current = BMKMapPointForCoordinate(CLLocation.init(latitude: CLLocationDegrees((notification.valueForKey("latitude") as? String)!)!, longitude: CLLocationDegrees((notification.valueForKey("longitude") as? String)!)!).coordinate)
        let before = BMKMapPointForCoordinate(CLLocation.init(latitude: CLLocationDegrees((notification.valueForKey("slatitude") as? String)!)!, longitude: CLLocationDegrees((notification.valueForKey("slongitude") as? String)!)!).coordinate)
        
//        let point1:BMKMapPoint = BMKMapPointForCoordinate ( CommitOrderViewController.FirstLocation.coordinate)
//        let point2:BMKMapPoint = BMKMapPointForCoordinate( CommitOrderViewController.SecondLocation.coordinate )
         BMKdistance = BMKMetersBetweenMapPoints( current , before)
        var distanceString = String(BMKdistance / 1000)
        if(BMKdistance == 0)
        {
            distanceString = "0.1"
        }
        else{
        let temp:[String] = distanceString.componentsSeparatedByString(".")
        distanceString = temp[0] + "." + (temp[1] as NSString).substringToIndex(2)
        
        }
        
        
        print(BMKdistance)
        distanceLabel.text =  "距离： " + distanceString + "km"
        myTableView.reloadData()
        
        
    }
    
    //MARK: -GeoDelegate
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        if( error == BMK_SEARCH_NO_ERROR )
        {
            
            if( useGeoTag == 1 )
            {
                CommitOrderViewController.FirstLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                LocationViewController.firstAddress = result.address
                print(result.address)
                print(result.location.latitude,result.location.longitude)
                useGeoTag = 2
                setCodeSearch(location.text)
            }else
            {
            
                CommitOrderViewController.SecondLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                 LocationViewController.secondAddress = result.address
//                DistanceForShow()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            
        }else{
        
            print("地理编码未查到结果")
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        
    }


}