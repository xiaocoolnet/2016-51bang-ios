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
    let middleArr = ["服务最多","评分最多","离我最近"]
    let rightArr = ["全部","在线"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShow1 = false
        isShow2 = false
        isShow3 = false
        self.types = ""
        self.sort = "1"
//        isworking = "0"
        self.myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
        self.view.backgroundColor = RGREY
        self.GetData1(sort,types: self.types)
        
        //        let view = UIView.init(frame: CGRectMake(0, 0, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>))
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func GetData1(sort:String,types:String){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        var cityname = String()
        if userLocationCenter.objectForKey("cityName") != nil {
            cityname = userLocationCenter.objectForKey("cityName") as! String
        }
        
        mainHelper.GetRzbList (cityname ,sort:sort,type:types, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    alert("暂无数据", delegate: self)
                    self.myTableView.mj_header.endRefreshing()
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
                print(self.rzbDataSource)
                print(self.rzbDataSource!.count)
                
                self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-WIDTH*50/375-15)
                self.myTableView.delegate = self
                self.myTableView.dataSource = self
                self.myTableView.backgroundColor = RGREY
                self.myTableView.tag = 0
                

                self.myTableView.registerNib(UINib(nibName: "RenZhengBangTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
                self.view.addSubview(self.myTableView)
                self.myTableView.reloadData()
                self.GetData()
                

                
            })
            })
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
                self.dataSource = response as? Array<SkillModel> ?? []
                print(self.dataSource)
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
                
            })
            })
    }
    
    func onClick1(){
        if isShow2 == true {
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
        }
        if isShow3 == true {
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
        }
        if isShow1 == false {
            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48-64)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,HEIGHT-200)
            leftTableView.tag = 1
            leftTableView.delegate = self
            leftTableView.dataSource = self
            leftTableView.registerNib(UINib(nibName: "QuanBuFenLeiTableViewCell",bundle: nil), forCellReuseIdentifier: "QuanBuFenLei")
            leftTableView.backgroundColor = UIColor.whiteColor()
            
            self.view.addSubview(coverView)
            self.view.addSubview(leftTableView)
            isShow1 = true
        }else{
            
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
            
        }
        
    }
    
    func onClick2(){
        if isShow1 == true {
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
        }
        if isShow3 == true {
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
        }
        if isShow2 == false {
            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,30*CGFloat(middleArr.count))
            middleTableView.tag = 2
            middleTableView.delegate = self
            middleTableView.dataSource = self
            middleTableView.registerNib(UINib(nibName: "FuWuTableViewCell",bundle: nil), forCellReuseIdentifier: "FuWu")
            middleTableView.backgroundColor = UIColor.whiteColor()
            
            
            self.view.addSubview(coverView)
            self.view.addSubview(middleTableView)
            isShow2 = true
        }else{
            
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
            
        }
        
    }
    func onClick3(){
        if isShow1 == true {
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
        }
        if isShow2 == true {
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
        }
        if isShow3 == false {
            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,30*CGFloat(rightArr.count))
            rightTableView.tag = 3
            rightTableView.delegate = self
            rightTableView.dataSource = self
            rightTableView.registerNib(UINib(nibName: "FuWuTableViewCell",bundle: nil), forCellReuseIdentifier: "FuWu")
            rightTableView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(coverView)
            self.view.addSubview(rightTableView)
            isShow3 = true
        }else{
            
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
            
        }
        
    }
    
    func headerRefresh(){
        self.GetData1(sort,types: self.types)
        self.headerView.label3.text = "全部"
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
            
            
            
            
            //tableView.separatorStyle = .None
            
            cell.selectionStyle = .None
            cell.weizhiButton.addTarget(self, action: #selector(self.dingWeiAction), forControlEvents: UIControlEvents.TouchUpInside)
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
            return self.rzbDataSource!.count
        }else if tableView.tag == 1 {
            
            return self.dataSource!.count+1
        }else if tableView.tag == 2{
            
            return middleArr.count
        }else{
            
            return rightArr.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return 170
        }else{
            
            return 30
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.separatorStyle = .None
        if tableView.tag == 0 {
            let vc = FuWuHomePageViewController()
            vc.info = self.rzbDataSource![indexPath.row]
            //            vc.rzbDataSource = self.rzbDataSource!
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tableView.tag == 1{
            
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            if indexPath.row == 0 {
                view?.label1.text = "全部分类"
                
                self.types = ""
                self.GetData1(self.sort, types: self.types)
            }else{
                view?.label1.text = self.dataSource![indexPath.row-1].name
                self.types = self.dataSource![indexPath.row-1].id!
                self.GetData1(self.sort, types: self.types)
            }
            
        }else if tableView.tag == 2{
            
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            
            
            view?.label2.text = middleArr[indexPath.row]
            self.sort = String(indexPath.row)
            self.GetData1(self.sort, types: self.types)
            
        }else{
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            view?.label3.text = rightArr[indexPath.row]
            let myDatass = NSMutableArray()
            if indexPath.row == 1 {
                for data in self.rzbDataSource! {
                    if data.isworking as String == "1" {
                        myDatass.addObject(data)
                    }
                }
                
                let aa = myDatass as Array
              self.rzbDataSource = aa as? Array<RzbInfo>
                self.myTableView.reloadData()
            }else if indexPath.row == 0 {
                self.GetData1(sort,types: self.types)
                
            }
            
            
            
        }
    }
    
    func dingWeiAction()  {
        let vc = LocationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func message(sender:UIButton){
        let vc = ChetViewController()
        vc.receive_uid = rzbDataSource![sender.tag].id
        //        vc.datasource2 = NSMutableArray()
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        if userid == rzbDataSource![sender.tag].id{
            alert("请不要和自己说话", delegate: self)
        }else{
            mainHelper.getChatMessage(userid, receive_uid: rzbDataSource![sender.tag].id) { (success, response) in
                
                if !success {
                    alert("加载错误", delegate: self)
                    return
                }
                let dat = NSMutableArray()
                self.dataSource3 = response as? Array<chatInfo> ?? []
                print(self.dataSource3)
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
                    
                }
                
                
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
}
