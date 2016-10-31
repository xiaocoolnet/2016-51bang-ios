//
//  LocationViewController.swift
//  51Bang_ios_2016
//
//  Created by zhan g on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit



class SarchModel {

    var name = ""
    var adress = ""
    var location = CLLocationCoordinate2D.init()

}

class LocationViewController: UIViewController,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate ,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
    
    static var Destion = CLLocation.init()
    static var myAddressOfpoint = ""
    static var pointOfSelected = CLLocationCoordinate2D.init()
    var isWobangPush = Bool()
    var longitudeStr = NSString()
    var latitudeStr = NSString()
    var addressPoint = NSString()
    
    var searchBar = UISearchBar.init(frame: CGRectMake(0, 0, WIDTH, 35))
    var mapView:BMKMapView!
    var geocodeSearch: BMKGeoCodeSearch!
    var pointAnmation = BMKPointAnnotation.init()
    var showRegion = BMKCoordinateRegion.init()
    var searcher = BMKSuggestionSearch.init()
    var LocationForView = CLLocation.init()
    var isChanging = false
    var isTap = false
    var interstTableView = UITableView()
    var currentSelectRow = NSIndexPath.init()
    var interstArray:[BMKPoiInfo]  = []
    var searchTableView = UITableView()
    var option = BMKSuggestionSearchOption.init()
    var searchResult:[SarchModel] = []
    var ifFirst = true
    var updataAddress = String()
    static var firstAddress = ""
    static var secondAddress = ""
    var ViewTag = 1
    override func viewWillAppear(animated: Bool) {
        geocodeSearch.delegate = self
        mapView.viewWillAppear()
        mapView.delegate = self
        searcher.delegate = self
        CommitOrderViewController.ReturnTagForView = 1
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        geocodeSearch.delegate = nil
        mapView.viewWillDisappear()
        mapView.delegate = nil
        searcher.delegate = nil
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        showRegion.span.latitudeDelta = 0.05
        showRegion.span.longitudeDelta = 0.05
        
        geocodeSearch = BMKGeoCodeSearch()
        setSearchBar()
        setMapView()
        if isWobangPush {
            print(latitudeStr)
            print(longitudeStr)
            print(addressPoint)
            createPointAnmation(CLLocation.init(latitude: latitudeStr.doubleValue, longitude: longitudeStr.doubleValue), Title: addressPoint as String )
            WillShowName(latitudeStr.doubleValue, longtitude: longitudeStr.doubleValue)
            LocationForView = CLLocation.init(latitude: latitudeStr.doubleValue, longitude: longitudeStr.doubleValue)
        }else{
            if( ViewTag == 1 )
            {
                
                
                
                createPointAnmation(CommitOrderViewController.FirstLocation, Title: LocationViewController.firstAddress )
                WillShowName(CommitOrderViewController.FirstLocation.coordinate.latitude, longtitude: CommitOrderViewController.FirstLocation.coordinate.longitude)
                LocationForView = CommitOrderViewController.FirstLocation
                print(CommitOrderViewController.FirstLocation)
                
                
            }else
            {
                
                createPointAnmation(CommitOrderViewController.SecondLocation, Title: LocationViewController.secondAddress)
                LocationForView = CommitOrderViewController.SecondLocation
                WillShowName(CommitOrderViewController.SecondLocation.coordinate.latitude, longtitude: CommitOrderViewController.SecondLocation.coordinate.longitude)
            }

        }
        
        setInterstTableView()
        setSearchTable()
        
        
    }

    func setSearchBar()
    {
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        self.view.addSubview(searchBar)
    
    }
    
    func setMapView()
    {
        mapView = BMKMapView.init(frame: CGRectMake(0, 35, WIDTH, self.view.frame.size.height / 2 - 35))
        mapView.showsUserLocation = true
        mapView.gesturesEnabled = true
        self.view.addSubview(mapView)
        
    }
    
    func setInterstTableView()
    {
        interstTableView.frame = CGRectMake(0,  self.view.frame.size.height / 2 , WIDTH, self.view.frame.size.height - (self.view.frame.size.height / 2-35)-64-35)
        interstTableView.tag = 0
        interstTableView.delegate = self
        interstTableView.dataSource = self
        self.view.addSubview(interstTableView)
    }
    
    func setSearchTable()
    {
        
        searchTableView.frame = CGRectMake(0, 35, WIDTH, self.view.frame.height - 35-64)
        searchTableView.tag = 1
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.hidden = true
        self.view.addSubview(searchTableView)
    }
    
    func createPointAnmation(location:CLLocation,Title:String)
    {
        let coor = location.coordinate
        showRegion.center = coor
        mapView.setRegion(showRegion, animated: true)
        
        
        pointAnmation.coordinate = coor
        mapView.addAnnotation(pointAnmation)
        if isWobangPush {
            pointAnmation.title = Title
            mapView.selectAnnotation(pointAnmation, animated: true)
        }
        if(isTap == false)
        {
        pointAnmation.title = Title
        mapView.selectAnnotation(pointAnmation, animated: true)
        }
        
//        if isWobangPush {
//            print(latitudeStr.doubleValue)
//            print(longitudeStr)
//            print(CLLocationCoordinate2D.init(latitude: latitudeStr.doubleValue, longitude: longitudeStr.doubleValue))
//            showRegion.center = CLLocationCoordinate2D.init(latitude: latitudeStr.doubleValue, longitude: longitudeStr.doubleValue)
//        }else{
        
        isTap = false
        
    }
    
    
    //在线建议搜索
    func suggestionResult(keyWord:String)
    {
        option.cityname = MainViewController.city
        option.keyword = keyWord
        if( searcher.suggestionSearch(option) )
        {
            print("建议检索成功")
        }else
        {
            print("建议检索失败")
        }
    
    }
    
    
    //反地理检索
    
    func  WillShowName( latitude:CLLocationDegrees,longtitude:CLLocationDegrees)
    {
        
        let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(latitude,longtitude)
        
        
        let flag = geocodeSearch.reverseGeoCode(reverseGeocodeSearchOption)
        if flag {
            
        } else {
            print("反geo 检索发送失败")
        }
        
        
    }
    

    //MARK: -UISarchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchTableView.hidden = false
        print("将要开始编辑")
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        suggestionResult(searchText)
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchTableView.hidden = true
    }
    
    //MARK: -TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(tableView.tag == 0)
        {
            
           return interstArray.count
            
        }else{
        
            return searchResult.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if( tableView.tag == 0)
        {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "InterstableView")
        
        cell.textLabel?.text = interstArray[indexPath.row].name
        
        cell.detailTextLabel?.text = interstArray[indexPath.row].address
        
        return cell
        }else{
        
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "SearchtableView")
            cell.textLabel?.text = searchResult[indexPath.row].name
            cell.detailTextLabel?.text = searchResult[indexPath.row].adress
        return cell
        
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(tableView.tag == 0)
        {
            let index = NSIndexPath.init(forRow: 0, inSection: 0)
            currentSelectRow = index
            let loc = CLLocation.init(latitude: interstArray[indexPath.row].pt.latitude, longitude: interstArray[indexPath.row].pt.longitude)
            tableView.reloadData()
            createPointAnmation(loc, Title: "")

        }else{
            
        
            createPointAnmation(CLLocation.init(latitude: searchResult[indexPath.row].location.latitude, longitude: searchResult[indexPath.row].location.longitude), Title: "")
            searchTableView.hidden = true
        
        }
    }
    
    
    func tableView(tableView: UITableView, accessoryTypeForRowWithIndexPath indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
        
        if(tableView.tag == 0)
        {
            
            if(currentSelectRow == indexPath)
            {
                return UITableViewCellAccessoryType.Checkmark
            }else
            {
                
                
                return UITableViewCellAccessoryType.None
            }
        }else{
            
            
            
            return UITableViewCellAccessoryType.None
        }
        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - SuggestionDelegate
    
    func onGetSuggestionResult(searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        print("建议代理")
        searchTableView.hidden = false
        if result == nil{
            return
        }
        
        if result.keyList == nil{
            return
        }
        searchResult.removeAll()
        for count in 1...result.keyList.count {
            
            let re = SarchModel.init()
            re.name = result.keyList[ count-1 ] as! String
            let coor = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(1)  //CLLocationCoordinate2D.init()
            ( result.ptList[count-1] as! NSValue ).getValue( coor )
            re.location = coor.memory
            searchResult.append(re)
            
        }
//        searchTableView.reloadData()
        
//        for ( var count = 1 ; count < result.keyList.count ; count++ )
//            {
//                
//                let re = SarchModel.init()
//                re.name = result.keyList[ count ] as! String
//                let coor = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(1)  //CLLocationCoordinate2D.init()
//                ( result.ptList[count] as! NSValue ).getValue( coor )
//                re.location = coor.memory
//                searchResult.append(re)
//            }
        
        searchTableView.reloadData()
        
    }
    
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
        LocationForView = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        
        WillShowName(location.latitude, longtitude: location.longitude)
        
    }
    
    
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        print("点击了地图")
        print(coordinate)
        LocationForView = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        isTap = true
        createPointAnmation(LocationForView, Title: "")
    }
    
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        
    }
    
    
    //MARK: - BMKGeoCodeSearchDelegate
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        pointAnmation.coordinate = mapView.region.center
        mapView.addAnnotation(pointAnmation)
        mapView.selectAnnotation(pointAnmation, animated: true)
        
        if result == nil || result.poiList == nil || result.poiList.count == 0{
             pointAnmation.title = "无地址名称"
            return
        }
        
        if isWobangPush {
            LocationViewController.myAddressOfpoint = result.addressDetail.city + result.addressDetail.district + (result.poiList[0] as! BMKPoiInfo).name
            LocationViewController.pointOfSelected = result.location
        }
        
        
        if( interstArray.count !=  0)
        {
            
            interstArray.removeAll()
        }
        
        for info in result.poiList
        {
            interstArray.append(info as! BMKPoiInfo)
        }
        
        if result.poiList.count == 0 {
            return
        }
        
        if( result.poiList.first != nil)
        {
        
//                createPointAnmation( LocationForView, Title: (result.poiList[0] as! BMKPoiInfo).name)
            
            if( ViewTag == 1 )
            {
                if !isWobangPush {
                    CommitOrderViewController.firstString = result.addressDetail.city + result.addressDetail.district + (result.poiList[0] as! BMKPoiInfo).name
                    
                    print((result.poiList[0] as! BMKPoiInfo).address)
                    print((result.poiList[0] as! BMKPoiInfo).city)
                    CommitOrderViewController.FirstLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                }
                
                
            }else{
                if !isWobangPush{
                    CommitOrderViewController.secondstring = result.addressDetail.city + result.addressDetail.district + (result.poiList[0] as! BMKPoiInfo).name
                    CommitOrderViewController.SecondLocation = CLLocation.init(latitude: result.location.latitude, longitude: result.location.longitude)
                }
            
                
            
            }
                interstTableView.reloadData()
            
            
        }
        
        
        pointAnmation.title = (result.poiList[0] as! BMKPoiInfo).name
        
        
    }
    

    


}
