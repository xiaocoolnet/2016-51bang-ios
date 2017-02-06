 //
//  FriendListViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class FriendListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var isNextGrade = Bool()//我的业务或认证帮标记
    
    
    let myTableView = UITableView()
    var isShow1 = Bool()
    var isShow2 = Bool()
    var isShow3 = Bool()
    
    var headerView = RenZhengBangHeaderViewCell()
    var sort = String()
    var types = String()
//    var isworking = String()
    let coverView = UIView()
    let leftTableView = UITableView()
    let middleTableView = UITableView()
    let rightTableView = UITableView()
    let skillHelper = RushHelper()
    let mainHelper = MainHelper()
    var dataSource : Array<SkillModel>?
    var tchdDataSource:Array<TCHDInfo>?
    var rzbDataSource : Array<RzbInfo>?
    var dataSource3 : Array<chatInfo>?
    var onLine = String()
//    let middleArr = ["服务最多","离我最近"]
    let middleArr = ["服务最多","评分最多","离我最近"]
    let rightArr = ["全部","在线"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        myTableView.userInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShow1 = false
        isShow2 = false
        isShow3 = false
        self.types = ""
        self.sort = "1"
        self.onLine = "0"
        self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-WIDTH*50/375)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.backgroundColor = RGREY
        self.myTableView.tag = 0
        
        
        self.myTableView.registerNib(UINib(nibName: "RenZhengBangTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(self.myTableView)
//        isworking = "0"
        self.myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.myTableView.mj_footer.endRefreshing()
            if self.isNextGrade {
                self.createrTableViewUI()
                self.getNextGradeData("0")
                self.navigationController?.navigationBar.hidden = false
            }else{
                self.headerRefresh()
            }
            
        })
        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            print("MJ:(上拉加载)")
            self.footerRefresh()
            
        })
        
        self.view.backgroundColor = RGREY
        if isNextGrade {
            self.createrTableViewUI()
            self.getNextGradeData("0")
            self.navigationController?.navigationBar.hidden = false
        }else{
            self.GetData1(sort,types: self.types,isBegin: true,isOnLine: self.onLine)
        }
        
        
        //        let view = UIView.init(frame: CGRectMake(0, 0, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>))
        self.view.backgroundColor = UIColor.whiteColor()
//           self.GetData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func getNextGradeData(beginid:String){
        let ud = NSUserDefaults.standardUserDefaults()
        var useridstr = String()
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        if ud.objectForKey("userid") != nil {
            useridstr = ud.objectForKey("userid") as! String
        }
        mainHelper.GetNextGrade(useridstr,beginid:beginid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
//                    alert("暂无数据", delegate: self)
                    self.myTableView.mj_header.endRefreshing()
                    self.myTableView.mj_footer.endRefreshing()
                    self.rzbDataSource = nil
                    self.myTableView.reloadData()
                    hud.hide(true)
                    return
                    
                }
                hud.hide(true)
                
                if beginid == "0"{
                    self.rzbDataSource = response as? Array<RzbInfo> ?? []
                    if self.rzbDataSource?.count == 0{
                        alert("暂无数据", delegate: self)
                    }
                    self.myTableView.mj_header.endRefreshing()
                }else{
                    let datasss = response as? Array<RzbInfo> ?? []
                    if datasss.count < 1{
                        self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                        return
                    }
                    for datas in datasss{
                        self.rzbDataSource?.append(datas)
                    }
                    self.myTableView.mj_footer.endRefreshing()
                }
                
                
                print(self.rzbDataSource!.count)
                
                
                self.myTableView.reloadData()
            })
        }
        
    }
    
    
    func GetData1(sort:String,types:String,isBegin:Bool,isOnLine:String){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        var cityname = String()
//        var latitude = String()
//        var longitude = String()
        if userLocationCenter.objectForKey("quName") != nil {
            cityname = userLocationCenter.objectForKey("quName") as! String
        }
//        if userLocationCenter.objectForKey("latitude") != nil && userLocationCenter.objectForKey("longitude") != nil{
//            latitude = userLocationCenter.objectForKey("latitude") as! String
//            longitude = userLocationCenter.objectForKey("longitude") as! String
//        }
        
        
        if isBegin {
            mainHelper.GetRzbList (cityname ,beginid:"0",sort:sort,type:types,isOnLine:isOnLine, handle: {[unowned self](success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        alert("暂无数据", delegate: self)
                        self.myTableView.mj_header.endRefreshing()
                        self.rzbDataSource = nil
                        self.myTableView.reloadData()
                        //                    self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-WIDTH*50/375-15)
                        ////                    self.myTableView.delegate = self
                        ////                    self.myTableView.dataSource = self
                        //                    self.myTableView.backgroundColor = RGREY
                        //                    self.myTableView.tag = 0
                        //
                        //
                        //                    self.myTableView.registerNib(UINib(nibName: "RenZhengBangTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
                        //                    self.view.addSubview(self.myTableView)
                        hud.hide(true)
                        return
                    }
                    hud.hide(true)
                    self.myTableView.mj_header.endRefreshing()
                    self.rzbDataSource = response as? Array<RzbInfo> ?? []
                    print(self.rzbDataSource!.count)
                    
                    
                    self.myTableView.reloadData()
                    
                    if  types == "" && sort == "1"&&isOnLine == "0"{
                        self.GetData()
                        
                    }
                    
                    
                    
                    
                })
                })
        }else{
            
            let beginids  = self.rzbDataSource![(self.rzbDataSource?.count)!-1].id as String
            
            mainHelper.GetRzbList (cityname ,beginid:beginids,sort:sort,type:types,isOnLine: isOnLine,handle: {[unowned self](success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        
                        self.myTableView.mj_footer.endRefreshing()

                        self.myTableView.reloadData()
                      print(response as! String)
                        if response as! String == "no data"{
                            self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                            
                        }
                        hud.hide(true)
                        return
                    }
                    hud.hide(true)
                    self.myTableView.mj_footer.endRefreshing()
                    let datasss = response as? Array<RzbInfo> ?? []
                    if datasss.count < 1{
                        self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                        return
                    }
                    for datas in datasss{
                        self.rzbDataSource?.append(datas)
                    }
//                    print(self.rzbDataSource!.count)
                    
                    
                    self.myTableView.reloadData()
                    
                    if  types == "" && sort == "1"&&isOnLine == "0"{
                        self.GetData()
                        
                    }
                    
                    
                    
                    
                })
                })
        }
        
        
        
    }
    
    
    func GetData(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        skillHelper.getSkillList({[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.myTableView.mj_header.endRefreshing()
                    hud.hide(true)
                    return
                }
                
                hud.hide(true)
                print(response)
                self.myTableView.mj_header.endRefreshing()
                if response != nil{
                    if (response?.isKindOfClass(NSArray)) == true{
                        if (response as! NSArray).count>0{
                            if ((response as! NSArray)[0]).isKindOfClass(SkillModel){
                                self.dataSource = response as? Array<SkillModel> ?? []
                            }else{
                                alert("加载错误", delegate: self)
                            }
                            
                        }else{
                            alert("加载错误", delegate: self)
                        }
                        
                    }else{
                        alert("加载错误", delegate: self)
                    }
                }else{
                    alert("加载错误", delegate: self)
                }
                self.headerView =  (NSBundle.mainBundle().loadNibNamed("RenZhengBangHeaderViewCell", owner: nil, options: nil).first as? RenZhengBangHeaderViewCell)!
                
                self.headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*50/375)
                self.headerView.tag = 5
                //                headerView?.label1.
                let gesture1 = UITapGestureRecognizer(target: self, action:#selector(self.onClick1))
                //附加识别器到视图
                self.headerView.label1.addGestureRecognizer(gesture1)
                self.headerView.label1.userInteractionEnabled = true
                let gesture2 = UITapGestureRecognizer(target: self, action:#selector(self.onClick2))
                //附加识别器到视图
                self.headerView.label2.addGestureRecognizer(gesture2)
                self.headerView.label2.userInteractionEnabled = true
                
                let gesture3 = UITapGestureRecognizer(target: self, action:#selector(self.onClick3))
                //附加识别器到视图
                self.headerView.label3.addGestureRecognizer(gesture3)
                self.headerView.label3.userInteractionEnabled = true
                self.headerView.button1.addTarget(self, action: #selector(self.onClick1), forControlEvents: UIControlEvents.TouchUpInside)
                self.headerView.button2.addTarget(self, action: #selector(self.onClick2), forControlEvents: .TouchUpInside)
                self.headerView.button3.addTarget(self, action: #selector(self.onClick3), forControlEvents: .TouchUpInside)
                self.myTableView.tableHeaderView = self.headerView
                self.myTableView.reloadData()
                self.createrTableViewUI()
                
            })
            })
    }
    
    //MARK:--创建选择列表
    
    func createrTableViewUI(){
        coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
        coverView.backgroundColor = UIColor.grayColor()
        coverView.alpha = 0.5
        coverView.hidden = true
        middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
        middleTableView.tag = 2
        middleTableView.delegate = self
        middleTableView.dataSource = self
        middleTableView.separatorStyle = .None
        middleTableView.registerNib(UINib(nibName: "FuWuTableViewCell",bundle: nil), forCellReuseIdentifier: "FuWu")
        middleTableView.backgroundColor = UIColor.whiteColor()
        leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,0)
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        leftTableView.tag = 1
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.registerNib(UINib(nibName: "QuanBuFenLeiTableViewCell",bundle: nil), forCellReuseIdentifier: "QuanBuFenLei")
        leftTableView.backgroundColor = UIColor.whiteColor()
        
        rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
        rightTableView.tag = 3
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.separatorStyle = .None
        rightTableView.registerNib(UINib(nibName: "FuWuTableViewCell",bundle: nil), forCellReuseIdentifier: "FuWu")
        rightTableView.backgroundColor = UIColor.whiteColor()
        //        self.view.addSubview(coverView)
        self.view.addSubview(coverView)
        self.view.addSubview(rightTableView)
        
        //        self.view.addSubview(coverView)
        self.view.addSubview(leftTableView)
        
        
        self.view.addSubview(middleTableView)
    }
    
    
    func onClick1(){
        if isShow2 == true {

            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                self.middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, 0)
            })

            isShow2 = false
        }
        if isShow3 == true {
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                self.rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
            })
            isShow3 = false
        }
        if isShow1 == false {
//            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48-64)
//            coverView.backgroundColor = UIColor.grayColor()
//            coverView.alpha = 0.5
//            self.leftTableView.hidden = false
            self.coverView.hidden = false
            UIView.animateWithDuration(0.5, animations: {
                
                
                self.leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,HEIGHT-WIDTH*50/375-64)
            })
            
            isShow1 = true
        }else{
            
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                
                self.leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,0)
            })
            isShow1 = false
            
        }
        
    }
    
    
   
    
    func onClick2(){
        if isShow1 == true {
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                
                self.leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,0)
            })
            isShow1 = false
        }
        if isShow3 == true {
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                self.rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
            })
            isShow3 = false
        }
        if isShow2 == false {
            self.coverView.hidden = false
            self.middleTableView.hidden = false
            UIView.animateWithDuration(0.5, animations: {
                
                self.middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, 60*CGFloat(self.middleArr.count))
            })
            
            isShow2 = true
        }else{
            
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                self.middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, 0)
            })
            isShow2 = false
            
        }
        
    }
    func onClick3(){
        if isShow1 == true {
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                
                self.leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,0)
            })
            isShow1 = false
        }
        if isShow2 == true {
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                self.middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, 0)
            })
            isShow2 = false
        }
        if isShow3 == false {
//            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
//            coverView.backgroundColor = UIColor.grayColor()
//            coverView.alpha = 0.5
            self.coverView.hidden = false
            self.rightTableView.hidden = false
            UIView.animateWithDuration(0.5, animations: {
                
                self.rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,60*CGFloat(self.rightArr.count))
            })
            isShow3 = true
        }else{
            
            coverView.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                
                self.rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
            })
            isShow3 = false
            
        }
        
    }
    
    func headerRefresh(){
        
        if isNextGrade{
            self.getNextGradeData("0")
        }else{
            self.GetData1(sort,types: self.types,isBegin: true,isOnLine: self.onLine)
            if self.onLine == "1"{
                self.headerView.label3.text = "在线"
            }else{
                self.headerView.label3.text = "全部"
            }
            
        }
        
    }
    
    func footerRefresh(){
        
        if isNextGrade{
            self.getNextGradeData(self.rzbDataSource![(self.rzbDataSource?.count)!-1].id)
        }else{
            self.GetData1(sort,types: self.types,isBegin: false,isOnLine: self.onLine)
            if self.onLine == "1"{
                self.headerView.label3.text = "在线"
            }else{
                self.headerView.label3.text = "全部"
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .None
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")as!RenZhengBangTableViewCell
            
            let info : RzbInfo?
            info = self.rzbDataSource![indexPath.row]
//            var meter1 = Double()
            
            
//
            let ut =  NSUserDefaults.standardUserDefaults()
            
            if info!.latitude != "" && info!.longitude != "" && ut.objectForKey("latitude") != nil && ut.objectForKey("longitude") != nil {
                
                let current = CLLocation.init(latitude: CLLocationDegrees(info!.latitude)!, longitude: CLLocationDegrees(info!.longitude)!)
                let before = CLLocation.init(latitude: CLLocationDegrees(ut.objectForKey("latitude") as! String)!, longitude: CLLocationDegrees(ut.objectForKey("longitude") as! String)!)
                let meters = current.distanceFromLocation(before)
                var distance = String()
                let meter1  = meters/1000
                if meter1>1000 {
                    distance = "1000+"
                }
                
                distance = String(format:"%.1f",meter1)
                //            print(distance)
                cell.distance.text = "\(distance)km"
                cell.distance.hidden = false
                
            }else{
                cell.distance.hidden = true
            }
            
            if isNextGrade {
                cell.distance.hidden = true
            }else{
                cell.distance.hidden = false
            }
            
            
            //tableView.separatorStyle = .None
            
            cell.selectionStyle = .None
            cell.weizhiButton.tag = indexPath.row + 100
            cell.weizhiButton.addTarget(self, action: #selector(self.dingWeiAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.message.addTarget(self, action: #selector(self.message(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.message.tag = indexPath.row
            cell.setValueWithInfo(self.rzbDataSource![indexPath.row])
            return cell
            
        }else if tableView.tag == 1{
            
            var cell = tableView.dequeueReusableCellWithIdentifier("QuanBuFenLei")as? QuanBuFenLeiTableViewCell
            if cell==nil {
                cell = QuanBuFenLeiTableViewCell(style: UITableViewCellStyle.Default,reuseIdentifier: "QuanBuFenLei")
                
            }
            if indexPath.row == 0 {
                cell!.title.text =  "全部分类"
                //                cell!.title.textColor = UIColor.greenColor()
            }else{
                let model = self.dataSource![indexPath.row-1]
                
                cell!.title.text = model.name
            }
            return cell!
            
        }else if tableView.tag == 2{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FuWu")as! FuWuTableViewCell
            cell.title.text = middleArr[indexPath.row]
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FuWu")as! FuWuTableViewCell
            cell.title.text = rightArr[indexPath.row]
            return cell
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.myTableView {
            if self.rzbDataSource == nil {
                return 0
            }
            return self.rzbDataSource!.count
        }else if tableView.tag == 1 {
            if self.dataSource == nil {
                return 0
            }
            return self.dataSource!.count+1
        }else if tableView.tag == 2{
            
            return middleArr.count
        }else{
            
            return rightArr.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return 175
        }else if tableView.tag == 1{
            return 50
        }else{
            return 60
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.myTableView.mj_footer.endRefreshing()
        
        tableView.separatorStyle = .None
        if tableView.tag == 0 {
            let vc = FuWuHomePageViewController()
            vc.info = self.rzbDataSource![indexPath.row]
            //            vc.rzbDataSource = self.rzbDataSource!
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tableView.tag == 1{
            
            coverView.hidden = true
            leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,0)
            isShow1 = false
            let cell = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
//            cell?.selectedBackgroundView = UIView.init(frame: (cell?.frame)!)
////            cell?.backgroundColor = UIColor.whiteColor()
//             cell?.selectedBackgroundView?.backgroundColor = UIColor.whiteColor()
            if indexPath.row == 0 {
                cell?.label1.text = "全部分类"
                
                self.types = ""
                self.GetData1(self.sort, types: self.types,isBegin: true,isOnLine: self.onLine)
            }else{
                cell?.label1.text = self.dataSource![indexPath.row-1].name
                self.types = self.dataSource![indexPath.row-1].id!
                self.GetData1(self.sort, types: self.types,isBegin: true,isOnLine: self.onLine)
            }
            
        }else if tableView.tag == 2{
            
            coverView.hidden = true
//            middleTableView.hidden = true
            middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
            isShow2 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            
            
            view?.label2.text = middleArr[indexPath.row]
            self.sort = String(indexPath.row+1)
//            if middleArr[indexPath.row] == "服务最多" {
//                self.sort  =  "1"
//            }else{
//                self.sort  =  "3"
//            }
            self.GetData1(self.sort, types: self.types,isBegin: true,isOnLine: self.onLine)
            
        }else{
            coverView.hidden = true
            rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,0)
            isShow3 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            view?.label3.text = rightArr[indexPath.row]
            if indexPath.row == 1 {
                self.onLine = "1"
                self.GetData1(sort,types: self.types,isBegin: true,isOnLine: self.onLine)
                self.myTableView.reloadData()
            }else if indexPath.row == 0 {
                self.onLine = "0"
                self.GetData1(sort,types: self.types,isBegin: true,isOnLine: self.onLine)
                
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
        if  self.rzbDataSource![sender.tag-100].latitude != "" && self.rzbDataSource![sender.tag-100].longitude != ""{
            coor2.latitude = CLLocationDegrees(self.rzbDataSource![sender.tag-100].latitude as String)!
            coor2.longitude = CLLocationDegrees(self.rzbDataSource![sender.tag-100].longitude as String)!
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        end.pt = coor2
        //指定终点名称
        if self.rzbDataSource![sender.tag-100].address != "" {
            end.name = self.rzbDataSource![sender.tag-100].address
        }else{
            alert("地址不能为空", delegate: self)
            return
        }
        
        opt.endPoint = end
        
        
        BMKOpenRoute.openBaiduMapDrivingRoute(opt)
    }
    
    func message(sender:UIButton){
        myTableView.userInteractionEnabled = false
        let vc = ChetViewController()
        vc.receive_uid = rzbDataSource![sender.tag].id
        vc.titleTop = rzbDataSource![sender.tag].name
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        if userid == rzbDataSource![sender.tag].id{
             myTableView.userInteractionEnabled = true
            alert("请不要和自己说话", delegate: self)
        }else{
            mainHelper.getChatMessage(userid, receive_uid: rzbDataSource![sender.tag].id) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    alert("加载错误", delegate: self)
                    return
                }
                let dat = NSMutableArray()
                self.dataSource3 = response as? Array<chatInfo> ?? []
                if self.dataSource3?.count != 0{
                    for num in 0...self.dataSource3!.count-1{
                        let dic = NSMutableDictionary()
                        dic.setObject(self.dataSource3![num].id!, forKey: "id")
                        dic.setObject(self.dataSource3![num].send_uid!, forKey: "send_uid")
                        dic.setObject(self.dataSource3![num].receive_uid!, forKey: "receive_uid")
                        dic.setObject(self.dataSource3![num].content!, forKey: "content")
                        dic.setObject(self.dataSource3![num].status!, forKey: "status")
                        dic.setObject(self.dataSource3![num].create_time!, forKey: "create_time")
                        if self.dataSource3![num].send_face != nil{
                            dic.setObject(self.dataSource3![num].send_face!, forKey: "send_face")
                        }
                        
                        if self.dataSource3![num].send_nickname != nil{
                            dic.setObject(self.dataSource3![num].send_nickname!, forKey: "send_nickname")
                        }
                        
                        if self.dataSource3![num].receive_face != nil{
                            dic.setObject(self.dataSource3![num].receive_face!, forKey: "receive_face")
                        }
                        
                        if self.dataSource3![num].receive_nickname != nil{
                            dic.setObject(self.dataSource3![num].receive_nickname!, forKey: "receive_nickname")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
}
