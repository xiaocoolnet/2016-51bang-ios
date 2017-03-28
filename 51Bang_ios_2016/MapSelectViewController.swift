//
//  MapSelectViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/3.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class SearchModel {
    
    var name = ""
    var adress = ""
    var location = CLLocationCoordinate2D.init()
    
}

typealias backForMapInfo = (adressInfo:BMKPoiInfo)->Void

class MapSelectViewController: UIViewController,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate ,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var mapBlock = backForMapInfo?()

    
    var searchBar = UISearchBar.init(frame: CGRectMake(0, 0, WIDTH, 50))
    var mapView:BMKMapView!
    var searchTableView = UITableView()//搜索结果tableView
    var interstTableView = UITableView()//底部推荐tableView
    var geocodeSearch: BMKGeoCodeSearch!
    var pointAnmation = BMKPointAnnotation.init()
    var showRegion = BMKCoordinateRegion.init()
    var searcher = BMKSuggestionSearch.init()
    var userLocation = BMKUserLocation()//定位位置
    
    var locationService: BMKLocationService!//定位
    
    var option = BMKSuggestionSearchOption.init()
    
    
    var interstArray:[BMKPoiInfo]  = []//推荐地点数组
    var searchResult:[SearchModel] = []//搜索地点数组
    var currentSelectRow = NSIndexPath.init()
    var LocationForView = CLLocation.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "请选择地址"
        self.view.backgroundColor = LGBackColor
        
        showRegion.span.latitudeDelta = 0.05
        showRegion.span.longitudeDelta = 0.05
        
        locationService = BMKLocationService()
        locationService.delegate = self
        locationService.startUserLocationService()
        
        geocodeSearch = BMKGeoCodeSearch()
        setMapView()
        setSearchBar()
        setInterstTableView()
        setSearchTable()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        mapView.viewWillAppear()
        mapView.delegate = self
        searcher.delegate = self
        geocodeSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        geocodeSearch.delegate = nil
        
        mapView.delegate = nil
        searcher.delegate = nil
        locationService.delegate = nil
        mapView.viewWillDisappear()
        
    }
    
    //MARK: set
    
    func setSearchBar()
    {
        
        searchBar.showsCancelButton = true
        searchBar.placeholder = "输入社区名称或拼音"
        searchBar.barStyle = .Default
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.whiteColor()
        for views in searchBar.subviews[0].subviews {
            if views.isKindOfClass(NSClassFromString("UINavigationButton")!) {
                (views as! UIButton).setTitle("取消", forState: .Normal)
                (views as! UIButton).titleLabel?.font = UIFont.systemFontOfSize(13)
                (views as! UIButton).setTitleColor(UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1), forState: .Normal)
        
            }
        }
        
        let searchBarSearchField = searchBar.valueForKey("_searchField") as! UITextField
        searchBarSearchField.font = UIFont.systemFontOfSize(13)
        (searchBar.valueForKey("_searchField") as! UITextField).backgroundColor = LGBackColor
        searchBarSearchField.setValue(UIFont.systemFontOfSize(13), forKeyPath: "_placeholderLabel.font")
        self.view.addSubview(searchBar)
        
    }
    func setMapView()
    {
        mapView = BMKMapView.init(frame: CGRectMake(0, 50, WIDTH, self.view.frame.size.height / 2 - 35))
        mapView.showsUserLocation = true
        mapView.gesturesEnabled = true
        self.view.addSubview(mapView)
        
    }
    func setSearchTable()
    {
        
        searchTableView.frame = CGRectMake(0, 50, WIDTH, self.view.frame.height - 35-64)
        searchTableView.tag = 1
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.hidden = true
        searchTableView.tableFooterView = UIView()
        searchTableView.separatorStyle = .None
        self.view.addSubview(searchTableView)
    }
    
    func setInterstTableView()
    {
        interstTableView.frame = CGRectMake(0,  self.view.frame.size.height / 2 , WIDTH, self.view.frame.size.height - (self.view.frame.size.height / 2-35)-64-35)
        interstTableView.tag = 0
        interstTableView.delegate = self
        interstTableView.dataSource = self
        interstTableView.backgroundColor = LGBackColor
        interstTableView.tableFooterView = UIView()
        interstTableView.separatorStyle = .None
        self.view.addSubview(interstTableView)
    }
    
    
    func createPointAnmation(location:CLLocation,Title:String)
    {
        let coor = location.coordinate
        showRegion.center = coor
        mapView.setRegion(showRegion, animated: true)
        pointAnmation.coordinate = coor
        mapView.addAnnotation(pointAnmation)
        pointAnmation.title = Title
        mapView.selectAnnotation(pointAnmation, animated: true)
    }
    
    
    
    //在线建议搜索
    func suggestionResult(keyWord:String)
    {
//        option.cityname = "青岛市"
        option.keyword = keyWord
        if( searcher.suggestionSearch(option) )
        {
            debugPrint("建议检索成功")
        }else
        {
            debugPrint("建议检索失败")
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
            debugPrint("反geo 检索发送失败")
        }
        
        
    }
    
    //MARK: -UISarchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchTableView.hidden = false
        
        
        debugPrint("将要开始编辑")
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
        
        if(tableView == interstTableView)
        {
            
            return interstArray.count
            
        }else{
            
            return searchResult.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if( tableView == interstTableView)
        {
            let cell = PublicTableViewCell.init(style: UITableViewCellStyle.Subtitle)
            cell.accessoryType = .None
            cell.textLabel?.text = interstArray[indexPath.row].name
            cell.textLabel?.font = UIFont.systemFontOfSize(13)
            
            var distance = String()
            if self.userLocation.location != nil{
                let distance1 = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate(CLLocationCoordinate2DMake(interstArray[indexPath.row].pt.latitude, interstArray[indexPath.row].pt.longitude)),BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.userLocation.location.coordinate.latitude,self.userLocation.location.coordinate.longitude)))
                distance = "距您"+String(format: "%.0f", distance1)+"米|"
            }else{
                distance = "未定位|"
            }
            
            
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
            cell.detailTextLabel?.text = distance+interstArray[indexPath.row].address
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            
            return cell
        }else{
            
            let cell = PublicTableViewCell.init(style: UITableViewCellStyle.Subtitle)
            cell.textLabel?.text = searchResult[indexPath.row].name
            cell.textLabel?.font = UIFont.systemFontOfSize(13)
            cell.detailTextLabel?.text = searchResult[indexPath.row].adress
            cell.accessoryType = .None
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == interstTableView)
        {
            let index = NSIndexPath.init(forRow: 0, inSection: 0)
            currentSelectRow = index
            let loc = CLLocation.init(latitude: interstArray[indexPath.row].pt.latitude, longitude: interstArray[indexPath.row].pt.longitude)
            tableView.reloadData()
            createPointAnmation(loc, Title: "")
            if self.mapBlock != nil{
                self.mapBlock!(adressInfo: self.interstArray[indexPath.row])
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            
            
        }else{
            
            
            createPointAnmation(CLLocation.init(latitude: searchResult[indexPath.row].location.latitude, longitude: searchResult[indexPath.row].location.longitude), Title: "")
            searchTableView.hidden = true
            
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(tableView: UITableView, accessoryTypeForRowWithIndexPath indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
        
        if(tableView == interstTableView)
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
        debugPrint("推荐代理")
        searchTableView.hidden = false
        if result == nil{
            return
        }
        
        if result.keyList == nil{
            return
        }
        searchResult.removeAll()
        for count in 1...result.keyList.count {
            
            let re = SearchModel.init()
            re.name = result.keyList[ count-1 ] as! String
            let coor = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(1)  //CLLocationCoordinate2D.init()
            ( result.ptList[count-1] as! NSValue ).getValue( coor )
            re.location = coor.memory
            searchResult.append(re)
            
        }
        searchTableView.reloadData()
        
    }
    
    /**
     *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
     *@param mapview 地图View
     *@param status 此时地图的状态
     */
    func mapView(mapView: BMKMapView!, onDrawMapFrame status: BMKMapStatus!) {
        
        
    }
    
    //BMKLocationSerevenceDelegate
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            self.userLocation = userLocation
            WillShowName(userLocation.location.coordinate.latitude, longtitude: userLocation.location.coordinate.longitude)
            showRegion.center = userLocation.location.coordinate
            showRegion.span.latitudeDelta = 0.05
            showRegion.span.longitudeDelta = 0.05
            mapView.setRegion(showRegion, animated: true)
            mapView.updateLocationData(userLocation)
            mapView.showsUserLocation = true
            
            pointAnmation.coordinate = userLocation.location.coordinate
            pointAnmation.title = userLocation.title
            
            mapView.addAnnotation(pointAnmation)
            
            mapView.selectAnnotation(pointAnmation, animated: true)
            locationService.stopUserLocationService()
        }
    }
    
    func mapView(mapView: BMKMapView!, regionDidChangeAnimated animated: Bool)
    {
        searchBar.resignFirstResponder()
        let point :CGPoint = CGPointMake( self.mapView.frame.size.width * 0.5, self.mapView.frame.size.height * 0.5)
        let location = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        LocationForView = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
        
        WillShowName(location.latitude, longtitude: location.longitude)
        
    }
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        debugPrint("点击了地图")
        debugPrint(coordinate)
        LocationForView = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
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
        interstTableView.reloadData()
         pointAnmation.title = (result.poiList[0] as! BMKPoiInfo).name
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
