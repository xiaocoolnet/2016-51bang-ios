//
//  CityViewController.swift
//  CityListDemo
//
//  Created by ray on 15/11/24.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

protocol CityViewControllerDelegate{
    func selectCity(info:NSDictionary);
}

class CityViewController: UIViewController,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,LocationManagerDelegate {
    
    @IBOutlet weak var layoutTopConstraint: NSLayoutConstraint!
    @IBOutlet var searchDC: UISearchDisplayController!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    let mainhelper = MainHelper()
    
    //是否是定位按钮过来
    var isNotDingwei = Bool()
    
    var dingweiCity : String?
    var dingweiCityID : String?
    
    var golocationForUser = CLLocationCoordinate2D.init()
    var goQuName = String()
    
    /** 回调接口*/
    var delegate:CityViewControllerDelegate?;
    
    //城市数据库
    var dict:Array<cityInfo>!;
    //所有城市名称
    var cityArray:NSMutableArray!;
    //所有城市id
    var cityIdArray:Array<String>!=[""];
    //所有城市拼音首字母
    var citySpell:NSMutableArray!;
    //所有城市拼音首字母
    var sectionCitySpell:NSMutableArray!;
    //搜索到得城市
    var searchCityArray:NSArray!;
    //城市管理
    var locationManager:LocationManager!;
    //当前定位城市名称
    var cityName:String = "正在获取...";
    //最近访问城市
    var historyCitys = ["北京市朝阳区"];
    //热门城市
    let hotCitys = ["上海","北京","广州","深圳","武汉","天津","西安","南京","杭州"];
    //最近访问城市数据
    var dataHistoryCitys:SpecifyArray!;
    let keyHistory = "keyHistory";
    let keyHistoryInfo = "keyHistoryInfo";
    var HistoryInfo:[NSDictionary] = []
    var History:[AnyObject] = []
    let quName = NSMutableArray()
    let quIDArray = NSMutableArray()
    var seachDic = NSMutableDictionary()
    let mycityNmmeAndQu = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择城市";
        //接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getMyName(_:)), name:"NotificationIdentifier", object: nil)
        self.tabBarController?.tabBar.hidden = true
        cityArray = NSMutableArray();
        citySpell = NSMutableArray();
        self.tableview.delegate = self
        self.tableview.dataSource = self
        searchCityArray = NSArray()
        dataHistoryCitys = SpecifyArray(max: 2);
        if isNotDingwei {
            tableview.sectionHeaderHeight = 0
        }
        getCityData();
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
//        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = true

    }
    
    
    /**
     装在城市数据信息
     */
    private func getCityData(){
        //获取当前城市
        locationManager = LocationManager();
        locationManager.delegate = self;
        locationManager.startLocationCity();
        
        mainhelper.checkCity(self.dingweiCity!) { (success, response) in
            if success{
                self.dingweiCityID = response as? String
            }else{
                self.dingweiCityID = ""
            }
        }
        
        //获取最近放问城市
        let object = NSUserDefaults.standardUserDefaults().arrayForKey(keyHistory);
        let objectInfo = NSUserDefaults.standardUserDefaults().objectForKey(keyHistoryInfo)
        if objectInfo != nil{
            
            if objectInfo!.count>2{
                History.removeAtIndex(0)
                
            }
            HistoryInfo = objectInfo as! [NSDictionary]
        }
        debugPrint(HistoryInfo)
        if(object == nil){
            self.dataHistoryCitys.addObject("北京市");
        }else{
            History = object!
            if History.count>2{
                History.removeAtIndex(0)
                
            }
            print(History)
            
            self.dataHistoryCitys.addArray([History[0]]);
        }
        
        self.historyCitys = self.dataHistoryCitys.getaArray() as! [String];
//        
//        let path = NSBundle.mainBundle().pathForResource("area副本", ofType: "plist");
//        self.dict = NSMutableDictionary(contentsOfFile: path!);
        mainhelper.GetCityList { (success, response) in
            if success{
                self.dict = response as! Array<cityInfo>
                print(response)
                for oneArr in self.dict{
                    self.cityArray.addObject(oneArr.name);
//                    print(oneArr.haschild!)
//                    for cityName in oneArr.childlist! {
//                        print(cityName.name)
////                        if cityName.childlist == nil||cityName.childlist?.count<1{
////                            self.cityArray.addObject(oneArr.name);
////                            self.cityIdArray.append(oneArr.cityid);
////                            
////                        }else{
////                            self.cityArray.addObject(cityName.name);
////                            self.cityIdArray.append(cityName.cityid);
////                        }
//                        
//                        
//                    }
                    
                }
                self.tableview.reloadData()
            }
        }

        self.sectionCitySpell = NSMutableArray();
        self.sectionCitySpell.addObjectsFromArray(["定位城市","最近访问城市","省份列表"]);
//        let allValue:NSArray = self.dict.allValues;
        
        
        
        
    }
    
    /** 对城市名称进行排序*/
    private func cityNameSort(str1:NSString,str2:String,context:Void)->NSComparisonResult{
        return str1.localizedCompare(str2);
    }
    private func handlerSearch(searchString:String?){
        if(searchString == nil){
            return;
        }
        
        //判断是否清空数据
        
            if(searchString!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0){
            for city in self.dict {
                let mycity = city
                for citynames in mycity.childlist! {
                    if citynames.childlist == nil||citynames.childlist?.count<1{
                        mycityNmmeAndQu.addObject(city.name+citynames.name)
                        quName.addObject(citynames.name)
                        quIDArray.addObject(citynames.cityid)
                        seachDic.setValue([citynames.name,citynames.latitude,citynames.longitude,citynames.cityid], forKey: city.name+citynames.name)
                        
                    }else{
                        for quname1dic in citynames.childlist! {
                            mycityNmmeAndQu.addObject(citynames.name+quname1dic.name)
                            quName.addObject(quname1dic.name)
                            quIDArray.addObject(quname1dic.cityid)
                            
                            seachDic.setValue([quname1dic.name,quname1dic.latitude,quname1dic.longitude,quname1dic.cityid], forKey: citynames.name+quname1dic.name)
                        }
                    }
                    
//                        for cityname2dic in cityname1dic.childlist! {
//                            
//                            let  quname = (cityname1dic.objectForKey(cityname2dic)) as! NSArray
//                            for quNames in quname {
//                                mycityNmmeAndQu.addObject((cityname2dic as! String)+(quNames as! String))
////                                print(quName)
//                                quName.addObject(quNames as! String)
////                                print(mycityNmmeAndQu)
//                            }
//                        }
                    
                }
                
            }
            let array:NSArray = mycityNmmeAndQu;
                
                
            let result:NSArray = ZYPinYinSearch.searchWithOriginalArray(array as [AnyObject], andSearchText: searchString, andSearchByPropertyName: "");
            self.searchCityArray = result.sortedArrayUsingSelector(#selector(NSNumber.compare(_:)));
        }else{ //清空数据
            
        }
    }
    
    
    func getMyName(notification:NSNotification){
        let name = notification.object?.valueForKey("name") as? String
        print(notification.object)
        dataHistoryCitys.addObject(name!);
        self.History.append((notification.object as! NSDictionary).objectForKey("name")!)
        self.HistoryInfo.append(notification.object as! NSDictionary)
        if self.History.count>2{
            self.History.removeFirst()
        }
        if self.HistoryInfo.count>2{
            self.HistoryInfo.removeFirst()
        }
        
        NSUserDefaults.standardUserDefaults().setObject(self.History, forKey: keyHistory);
        NSUserDefaults.standardUserDefaults().setObject(self.HistoryInfo, forKey: keyHistoryInfo);
    }
    
    /**
     将选中城市名称返回并关闭当前页面
     - parameter city: 城市名称
     */
    private func selectCity(dic:NSDictionary){
        if dic.objectForKey("name") == nil{
            return
        }
        if dic.objectForKey("name") as! String == "正在获取..." {
            return
        }
        
        if(self.delegate != nil){
            
            dataHistoryCitys.addObject(dic.objectForKey("name") as! String);
            if dataHistoryCitys.getaArray().count>0{
                 self.History.append(dataHistoryCitys.getaArray()[0])
            }else{
                 self.History.append("正在获取...")
            }
            
           
            self.HistoryInfo.append(dic)
            if self.History.count>2{
                self.History.removeFirst()
            }
            if self.HistoryInfo.count>2{
                self.HistoryInfo.removeFirst()
            }
            
            NSUserDefaults.standardUserDefaults().setObject(self.History, forKey: keyHistory);
            NSUserDefaults.standardUserDefaults().setObject(self.HistoryInfo, forKey: keyHistoryInfo);
            
            
//            NSUserDefaults.standardUserDefaults().setObject(dic, forKey: keyHistoryInfo);
//            NSUserDefaults.standardUserDefaults().setObject(dataHistoryCitys.getaArray(), forKey: keyHistory);
//            let dic = NSMutableDictionary()
//            dic.setValue(city, forKey: "cityname")
//            dic.setValue(quname, forKey: "quname")
            self.delegate!.selectCity(dic);
            self.navigationController?.popViewControllerAnimated(true)
            //            self.dismissViewControllerAnimated(true , completion: { () -> Void in
            //            })
        }
        
    }
    
    //////////////////// UITableViewDataSource  ////////////////////
    
    internal func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(!self.tableview.isEqual(table)){ //搜索结果时
            return self.searchCityArray.count;
        }
        if section < 2 && isNotDingwei == true{
            return 0
        }

        if(section < 2){
            
            return 1;
        }
        
//        let key:NSString = self.sectionCitySpell.objectAtIndex(section) as! NSString;
//        print(self.cityArray.count)
        return self.cityArray.count;
        
    }
    
    func numberOfSectionsInTableView(table: UITableView) -> Int {
        
        if(!self.tableview.isEqual(table)){ //搜索结果时
            return 1;
        }
        return 3;
    }
    
//    func sectionIndexTitlesForTableView(table: UITableView) -> [String]? {
//        if(!self.tableview.isEqual(table)){ //搜索结果时
//            return nil;
//        }
//        let arr01:NSArray = self.citySpell;
//        let arr02:NSArray = NSArray(array: ["#","$"," *"]).arrayByAddingObjectsFromArray(arr01 as [AnyObject]);
//        
//        return arr02 as? [String];
//    }
    
    func tableView(table: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:SectionView = SectionView.viewFromNibNamed();
        if(!self.tableview.isEqual(table)){ //搜索结果时
            view.addData(self.citySpell.objectAtIndex(section) as! String);
        }else{
            if section<4 {
            view.addData(self.sectionCitySpell.objectAtIndex(section) as! String);
            }
            
        }
        
        return view;
    }
    
    func tableView(tableView: UITableView, section: Int) -> CGFloat {
        if section < 4 && isNotDingwei == true{
            return 0
        }
        if section == 3 {
            return 0
        }
        print(section)
        return 30;
    }
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if((indexPath.section == 0 || indexPath.section == 1) && self.tableview.isEqual(table)){
            return 70;
        }
//        if(indexPath.section == 2 && self.tableview.isEqual(table)){
//            return 0;
//        }
        return 50;
    }
    
    internal func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let identifierHead = "cellHead";
        let identifier = "cell";
        var cellHead:TableViewHeadSectionCell? = table.dequeueReusableCellWithIdentifier(identifierHead) as? TableViewHeadSectionCell;
        var cell:TableViewCell? = table.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell;
        let section = indexPath.section;
        
        if((section == 0 || section == 1) && self.tableview.isEqual(table)){  //如果为头部Section
            
            if(cellHead == nil){
                let nib:UINib = UINib(nibName: "TableViewHeadSectionCell", bundle: NSBundle.mainBundle());
                table.registerNib(nib, forCellReuseIdentifier: identifierHead);
                cellHead = table.dequeueReusableCellWithIdentifier(identifierHead) as? TableViewHeadSectionCell;
            }
            //添加数据
            switch(section){
            case 0: //定位城市
                
                if self.dingweiCity == nil||self.dingweiCity == ""{
                    cellHead!.addData(["正在获取..."], city: selectCity)
                    cellHead!.reloadData();
                }else{
                    cellHead!.addData([dingweiCity!], city: selectCity)
                    cellHead!.reloadData();
                }
//                let ud = NSUserDefaults.standardUserDefaults()
//                if ud.objectForKey("subLocality") == nil || ud.objectForKey("subLocality") as! String == "0" {
//                    let th = ""
////                    print(<#T##items: Any...##Any#>)
//                    if th.isEmpty {
//                        cellHead!.addData([dingweiCity!], city: selectCity)
//                        cellHead!.reloadData();
//                    }else{
//                        cityName = ""
//                        cellHead!.addData([dingweiCity!], city: selectCity)
//                        cellHead!.reloadData();
//                        
//                    }
//
//                }else{
//                    var th = String()
//                    if ud.objectForKey("subLocality") != nil && ud.objectForKey("subLocality") as! String != "0" {
//                        th = ud.objectForKey("subLocality")as! String
//                    }
//                    
//                    if th.isEmpty {
//                        cellHead!.addData([dingweiCity!], city: selectCity)
//                        cellHead!.reloadData();
//                    }else{
//                        cityName = ""
//                        cellHead!.addData([dingweiCity!], city: selectCity)
//                        cellHead!.reloadData();
//                        
//                    }
//                }
                
                break;
            case 1: // 最近使用城市
                
                
                if historyCitys[0] == "北京市" {
                    cellHead!.addData(["北京市朝阳区"], city: selectCity);
                }else{
                    cellHead!.addData(historyCitys, city: selectCity);
                }
                
                print(historyCitys)
                print(selectCity)
                break;
                
            default:
                break;
            }
            cellHead?.selectionStyle = .None
            return cellHead!;
            
        }
        // 普通城市数据
        if(cell == nil){
            let nib:UINib = UINib(nibName: "TableViewCell", bundle: NSBundle.mainBundle());
            table.registerNib(nib, forCellReuseIdentifier: identifier);
            cell = table.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell;
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //添加数据
//        var key:NSString = "";
        if(self.tableview.isEqual(table)){
//            key = self.sectionCitySpell.objectAtIndex(indexPath.section) as! NSString;
            cell!.setData(self.cityArray[indexPath.row] as! String)
        }else{
            cell!.setData(self.searchCityArray[indexPath.row] as! String);
        }
        cell?.selectionStyle = .None
        return cell!;
    }
    
    //////////////////// UITableViewDelegate  ////////////////////
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if table == self.tableview{
            if indexPath.section == 0{
                let dic = NSMutableDictionary()
                dic.setValue(self.dingweiCity, forKey: "name")
                dic.setValue(self.goQuName, forKey: "quname")
                dic.setValue(String(self.golocationForUser.latitude), forKey: "latitude")
                dic.setValue(self.dingweiCityID, forKey: "cityid")
                dic.setValue(String(self.golocationForUser.longitude), forKey: "longitude")
                self.selectCity(dic);
                return
            }else if indexPath.section == 1{
                if self.HistoryInfo.count != 0{
                    self.selectCity((self.HistoryInfo[0]) );
                }
                
                return
            }
            
        }
        
        
        
        if isNotDingwei {
            
            if table != self.tableview {
               cityName = self.searchCityArray[indexPath.row] as! String;
                
                let dic = ["cityName":cityName]
                
                NSNotificationCenter.defaultCenter().postNotificationName("changeCityStr", object: dic)
                
//                let a = self.navigationController?.viewControllers[2]
                self.navigationController?.popViewControllerAnimated(true)
                return
            }else{
                
                if self.dict[indexPath.row].childlist != nil&&self.dict[indexPath.row].childlist?.count != 0{
                    let citynameVC = CityNameViewController()
                    citynameVC.title = "城市选择"
                    citynameVC.isDingwei = true
                    citynameVC.myinfo = self.dict[indexPath.row].childlist!
                    citynameVC.mycityStr = self.dict[indexPath.row].name!
                    
                    citynameVC.isNotDingwei = self.isNotDingwei
                    navigationController?.pushViewController(citynameVC, animated: true)
                    return

                }
        }
            
            
        }else{
            
            if(self.delegate != nil ){
                var cityName:String = "";
                var quName1:String = "";
                if(table != self.tableview){
                    cityName = self.searchCityArray[indexPath.row] as! String;
                    quName1 = (self.seachDic.objectForKey(cityName) as! Array)[0] as String
                    debugPrint(self.seachDic.objectForKey(cityName))
                    let dic = NSMutableDictionary()
                    dic.setValue(cityName, forKey: "name")
                    dic.setValue(quName1, forKey: "quname")
                    dic.setValue((self.seachDic.objectForKey(cityName) as! Array)[1] as String, forKey: "latitude")
                    dic.setValue((self.seachDic.objectForKey(cityName) as! Array)[2] as String, forKey: "longitude")
                    dic.setValue((self.seachDic.objectForKey(cityName) as! Array)[3] as String, forKey: "cityid")
                    
                    self.History.append(cityName)
                    self.HistoryInfo.append(dic)
                    if self.History.count>2{
                        self.History.removeFirst()
                        
                    }
                    if self.HistoryInfo.count>2{
                        self.HistoryInfo.removeFirst()
                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(self.History, forKey: keyHistory);
                    NSUserDefaults.standardUserDefaults().setObject(self.HistoryInfo, forKey: keyHistoryInfo);
                    
//                    NSUserDefaults.standardUserDefaults().setObject([cityName], forKey: keyHistory);
//                    NSUserDefaults.standardUserDefaults().setObject(dic, forKey: keyHistoryInfo);
                    self.selectCity(dic);
                }else{
                    
                    
                    if self.dict[indexPath.row].childlist != nil&&self.dict[indexPath.row].childlist?.count != 0{
                        let citynameVC = CityNameViewController()
                        citynameVC.title = "城市选择"
                        citynameVC.isNotDingwei = self.isNotDingwei
                        citynameVC.myinfo = self.dict[indexPath.row].childlist!
                        citynameVC.mycityStr = self.dict[indexPath.row].name!
                        
                        self.navigationController?.pushViewController(citynameVC, animated: true)
                    }

                    
                    
                }
                //
            }
        }
        
        
    }
    
    
    
    //////////////////// UISearchDisplayDelegate  ////////////////////
    
    /**
     即将开始搜索
     */
    internal func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController){
        self.layoutTopConstraint.constant = 20;
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded();
        }
    }
    
    /**
     搜索结束
     */
    internal func searchDisplayControllerWillEndSearch(controller: UISearchDisplayController){
        self.layoutTopConstraint.constant = 0;
    }
    
    //shouldReloadTableForSearchString
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        self.handlerSearch(searchString);
        return true;
    }
    
    //////////////////// LocationManagerDelegate  ////////////////////
    
    /**
     获取到当前城市
     - parameter cityName: 城市名称
     */
    func locationCity(cityName: String) {
        self.cityName = cityName;
//        let indexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0);
//        self.tableview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None);
    }
    
}
