//
//  MenuViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    var row = Int()
    let myTableView = UITableView()
    let  shopHelper = ShopHelper()
    var dataSource : Array<GoodsInfo>?
    var userid = String()
    var  isShow = Bool()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.getData()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "商家发布"
        self.view.backgroundColor = RGREY
        self.createTableView()
        
        // Do any additional setup after loading the view.
    }
    
    
    func getData(){
        
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.labelText = "正在努力加载"
//            let ud = NSUserDefaults.standardUserDefaults()
//            let userid = ud.objectForKey("userid")as! String
            
            shopHelper.getMyFaBu(userid) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    hud.hide(true)
                    alert("暂无数据", delegate: self)
                    return
                }
                hud.hide(true)
//                print(response)
                    if response != nil {
                        self.dataSource = response as? Array<GoodsInfo> ?? []
                    }
                
//                print(self.dataSource)
//                print(self.dataSource?.count)
//                print(self.dataSource![0].id)
//                print(self.dataSource![0].price)
//                print(self.dataSource![0].oprice)
//                print(self.dataSource![0].delivery)
//                print(self.dataSource![0].address)
                
                self.myTableView.reloadData()
                })
            }
        }
        
    }
    
    func createTableView(){
        self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.tableFooterView = UIView()
        myTableView.backgroundColor = RGREY
        self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName: "MyFabuTableViewCell",bundle: nil), forCellReuseIdentifier: "MyFabuTableViewCell")
        
        myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
            
        })
        
        self.view.addSubview(myTableView)
    }
    
    func headerRefresh(){
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.labelText = "正在努力加载"
            
            shopHelper.getMyFaBu(userid) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.myTableView.mj_header.endRefreshing()
                     hud.hide(true)
                    return
                }
                hud.hide(true)
                print(response)
                self.myTableView.mj_header.endRefreshing()
                self.dataSource = response as? Array<GoodsInfo> ?? []
                self.myTableView.reloadData()
                })
            }
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource != nil{
            return self.dataSource!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyFabuTableViewCell")as! MyFabuTableViewCell
        
        
        if isShow{
            cell.delete.hidden = false
            cell.edit.hidden = false
            cell.pingjiaLabel.hidden = true
//            cell.distance.hidden = false
        }else{
            cell.delete.hidden = true
            cell.edit.hidden = true
            cell.pingjiaLabel.hidden = false
        }
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action:#selector(self.onClick(_:)) , forControlEvents: UIControlEvents.TouchUpInside)
//        cell.edit.hidden = true
        cell.edit.tag = indexPath.row+100
        cell.edit.addTarget(self, action:#selector(self.editAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.setValueWithInfo(self.dataSource![indexPath.row])
        let ud = NSUserDefaults.standardUserDefaults()
        var longitude = String()
        if ud.objectForKey("longitude") != nil {
            longitude = ud.objectForKey("longitude")as! String
        }else{
            longitude = "0.0"
        }
        var latitude = String()
        if ud.objectForKey("latitude") != nil {
            latitude = ud.objectForKey("latitude")as! String
        }else{
            latitude = "0.0"
        }
//        let longitude = ud.objectForKey("longitude")as! String
//        let latitude = ud.objectForKey("latitude")as! String
        let myLongitude = removeOptionWithString(longitude)
        let myLatitude = removeOptionWithString(latitude)
        print(myLongitude)
        print(myLatitude)
        let current = CLLocation.init(latitude: CLLocationDegrees(myLatitude)!, longitude: CLLocationDegrees(myLongitude)!)
        print(current)
        let goodsInfo = dataSource![indexPath.row] as GoodsInfo
                if goodsInfo.latitude != "0.0"&&goodsInfo.latitude != "" && goodsInfo.longitude != "0.0"&&goodsInfo.longitude != ""  && goodsInfo.latitude != nil&&goodsInfo.longitude != nil{
            print(goodsInfo.latitude! as String,goodsInfo.longitude! as String,"00000000")
            
            let before = CLLocation.init(latitude: CLLocationDegrees(goodsInfo.latitude! as String)!, longitude: CLLocationDegrees(goodsInfo.longitude! as String)!)
            print(myLongitude)
            print(myLatitude)
            print(before)
            let meters = (current.distanceFromLocation(before))/1000
            //                let meter:String = "\(meters)"
            //                let array = meter.componentsSeparatedByString(".")
            print(meters)
                    
            
            if meters > 1000{
                cell.distance.text = "1000+km"
            }else{
                let distance = String(format:"%.2f",meters)
                print(distance)
                cell.distance.text = "\(distance)km"
                
            }
            
        }else{
            cell.distance.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsVC = BusnissViewController()
        if isShow{
            detailsVC.isdetails = true
        }else{
            detailsVC.isdetails = false
        }
        
        detailsVC.id = self.dataSource![indexPath.row].id!
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func editAction(btn:UIButton){
        self.row = btn.tag-100
        if self.dataSource?.count == 0 {
            return
        }
        let info = self.dataSource![self.row]
        shopHelper.deleteOrder(info.id!) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success {
                alert("操作失败，请重试", delegate: self)
                return
            }else{
                self.dataSource?.removeAtIndex(self.row)
                let myindexPaths = NSIndexPath.init(forRow: self.row, inSection: 0)
                self.myTableView.deleteRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Right)

                self.getData()
                self.myTableView.reloadData()
                alert("已删除", delegate: self)
        }
            })
        }
//        let addVC = AddViewController()
//        addVC.isEdit = true
//        addVC.isEditsss = true
//        addVC.myDatas = [self.dataSource![btn.tag-100]]
////        print(self.dataSource![btn.tag-100].address)
////        print(self.dataSource![btn.tag-100].goodsname)
////        print(self.dataSource![btn.tag-100].id)
//        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    
    func onClick(btn:UIButton){
        self.row = btn.tag
        if self.dataSource?.count == 0 {
            return
        }
        let info = self.dataSource![btn.tag]
        print(info.id)
        
        let types = self.dataSource![btn.tag].racking! as String
        var alertStr = ""
        if types == "0" {
            alertStr = "商品已下架"
        }else{
            alertStr = "商品已上架"
        }
        
        shopHelper.XiaJia(info.id!,isShangjia: types) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success {
                alert("操作失败，请重试", delegate: self)
                return
            }else{
                self.getData()
                self.myTableView.reloadData()
                //             self.dataSource = response as? Array<GoodsInfo> ?? []
                //            print(self.dataSource?.count)
                //            print(self.dataSource)
                //             self.myTableView.reloadData()
                alert(alertStr, delegate: self)
            }
            })
            
            
        }
        //        let alert = UIAlertView.init(title: "提示", message: "确定删除吗", delegate: self, cancelButtonTitle: "确定")
        //        let alert = UIAlertView.init(title: "提示", message: "确定删除吗", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        //        alert.tag = 100
        //        alert.show()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == 0 {
            //            self.removeCell()
        }else{
            self.cancle()
        }
    }
    
    func removeCell(){
        
        //        let indexPath = NSIndexPath.init(forRow: self.row, inSection: 0)
        //        let cell = myTableView.cellForRowAtIndexPath(indexPath)
        
        self.dataSource?.removeAtIndex(self.row)
        
        self.myTableView.reloadData()
        
    }
    
    func cancle(){
        
        let alert = self.view.viewWithTag(100)
        alert?.hidden = true
        
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
