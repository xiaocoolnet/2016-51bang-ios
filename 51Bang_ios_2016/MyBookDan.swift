//
//  MyBookDan.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class BookDanDataModel {
    var  DshowImage = UIImage()
    var  DtitleLabel = ""
    var  DtipLabel = ""
    var  DPrice = ""
    var  DStatue = ""
    var  DBtn = UIButton()
    var  DDistance = ""
    var  Dflag = 1
}

class MyBookDan: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var mTableview = UITableView()
    var isNotSigle = Bool()
    let topView = UIView()
    let allBtn = UIButton()
    let willPayBtn = UIButton()
    let willUserBtn = UIButton()
    let willCommentBtn = UIButton()
    var hud = MBProgressHUD()
    let deView = UIView()
    var Data:[BookDanDataModel] = []
    var Data2:[BookDanDataModel] = []
    var Data3:[BookDanDataModel] = []
    var Data4:[BookDanDataModel] = []
    var Source:[BookDanDataModel] = []
    var mTable = UITableView()
    var sign = Int()
    var AllDataSource : Array<MyOrderInfo>?
    var DFKDataSource : Array<MyOrderInfo>?
    var DXFDataSource : Array<MyOrderInfo>?
    var DPJDataSource : Array<MyOrderInfo>?
    let mainHelper = MainHelper()
    let Btn = UIButton()
    var row = Int()
    
    let rect = UIApplication.sharedApplication().statusBarFrame
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        Btn.tag = 1
//        sign = 0
        self.createTableView()
//        self.getAllData()
//        self.getDFKData()
//        self.getDXFData()
//        self.getDPJData()
//        let da = BookDanDataModel()
//        da.DshowImage = UIImage.init(named: "01")!
//        da.Dflag = 1
//        da.DPrice = "123"
//        da.DtitleLabel = "哈哈哈海鲜自助"
//        da.DtipLabel = "在注册呢"
//        da.DStatue = "待评价"
//        let da1 = BookDanDataModel()
//        da1.DshowImage = UIImage.init(named: "01")!
//        da1.Dflag = 2
//        da1.DPrice = "123"
//        da1.DtitleLabel = "哈哈哈海鲜自助"
//        da1.DtipLabel = "在注册呢"
//        da1.DStatue = "待付款"
//        
//        let da2 = BookDanDataModel()
//        da2.DshowImage = UIImage.init(named: "01")!
//        da2.Dflag = 3
//        da2.DPrice = "123"
//        da2.DtitleLabel = "哈哈哈海鲜自助"
//        da2.DtipLabel = "在注册呢"
//        da2.DStatue = "待评价"
//        
//        let da3 = BookDanDataModel()
//        da3.DshowImage = UIImage.init(named: "01")!
//        da3.Dflag = 4
//        da3.DPrice = "123"
//        da3.DtitleLabel = "哈哈哈海鲜自助"
//        da3.DtipLabel = "在注册呢"
//        da3.DStatue = "待评价"
//        
//        
//        
//        Data = [da,da1,da2,da3,da2,da3,da3,da,da,da,da]
//        Data2 = [da1,da1]
//        Data3 = [da2,da2,da2]
//        Data4 = [da3]
        
        
        self.navigationController?.navigationBar.hidden = false
        self.view.backgroundColor = RGREY
        super.viewDidLoad()
        if self.isNotSigle{
            self.title = "收到的订单"
        }else{
            self.title = "我的订单"
        }
       
        
        topView.frame = CGRectMake(0, 0, WIDTH, 40)
        self.view.addSubview(topView)
        deView.frame = CGRectMake(0, 35, WIDTH / 4, 5)
        deView.backgroundColor = COLOR
        topView.backgroundColor = UIColor.whiteColor()
        topView.addSubview(deView)
        setBtn()
        
        Source = Data
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleRight))
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.headerRefresh()
//        self.mTableview.mj_header.beginRefreshing()
    }
    
    func headerRefresh(){
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        if sign == 0 {
            self.getAllData()
        }else if sign == 1{
            self.getDFKData()
        }else if sign == 2{
            self.getDXFData()
        }else{
            self.getDPJData()
        }
        
        
    }
    
    
    func handleRight(){
        if Btn.tag>1 {
            Btn.tag = Btn.tag - 1
            self.changeColorAndDeView(Btn)
        }else{
            self.changeColorAndDeView(Btn)
        }
    }
    
    func handleLeft(){
        if Btn.tag < 4 {
            Btn.tag = Btn.tag + 1
            self.changeColorAndDeView(Btn)
        }else{
            self.changeColorAndDeView(Btn)
        }
    }
    
    func createTableView(){
        
        
        mTableview = UITableView.init(frame: CGRectMake(0, 45, WIDTH, HEIGHT - 45.1 - rect.height - 48 )
            )
        mTableview.delegate = self
        mTableview.dataSource  = self
        self.view.addSubview(mTableview)
        mTableview.separatorStyle = UITableViewCellSeparatorStyle.None
    
        mTableview.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh()
//            self.mTableview.mj_header.beginRefreshing()
            
        })
    }
    
    func getAllData(){
        let ud = NSUserDefaults.standardUserDefaults()
        
        var uid = String()
        if ud.objectForKey("userid") != nil {
            uid = ud.objectForKey("userid")as! String
        }
        mainHelper.getMyOrder(uid, state: "0,1,2,3,4,5,6,7,8,9,10",type:self.isNotSigle) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            print(response)
            if !success{
                self.mTableview.mj_header.endRefreshing()
                alert("加载失败", delegate: self)
                self.hud.hidden = true
                return
            }
            self.hud.hidden = true
            self.AllDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.AllDataSource?.count)
            print(self.AllDataSource)
            self.reloadMTableviwe(self.sign+1)
            self.mTableview.mj_header.endRefreshing()
            })
        }
    
    }
    
    
    
    func getDFKData(){
    
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "1",type:self.isNotSigle) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            print(response)
            if !success{
                self.hud.hidden = true
                self.mTableview.mj_header.endRefreshing()
                alert("加载失败", delegate: self)
                return
            }
            self.hud.hidden = true
            self.DFKDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.DFKDataSource)
            print(self.DFKDataSource?.count)
            self.reloadMTableviwe(self.sign+1)
            self.mTableview.mj_header.endRefreshing()
            })
        }
    
    }
    
    func getDXFData(){
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "2,3",type:self.isNotSigle) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            print(response)
            if !success{
                self.hud.hidden = true
                self.mTableview.mj_header.endRefreshing()
                alert("加载失败", delegate: self)
                return
            }
            self.DXFDataSource = response as? Array<MyOrderInfo> ?? []
            self.hud.hidden = true
            print(self.DXFDataSource)
            print(self.DXFDataSource?.count)
            self.reloadMTableviwe(self.sign+1)
            self.mTableview.mj_header.endRefreshing()
            })
        }
    
    }
    
    func getDPJData(){
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "4",type:self.isNotSigle) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            print(response)
            if !success{
                self.hud.hidden = true
                self.mTableview.mj_header.endRefreshing()
                alert("加载失败", delegate: self)
                return
            }
            self.hud.hidden = true
            self.DPJDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.DPJDataSource)
            print(self.DPJDataSource?.count)
            self.reloadMTableviwe(self.sign+1)
            self.mTableview.mj_header.endRefreshing()
            })
        }
    
    }
    
    func setBtn()
    {
        allBtn.frame = CGRectMake(0, 0, WIDTH / 4, 35)
        willPayBtn.frame = CGRectMake( WIDTH / 4, 0, WIDTH / 4, 35)
        willUserBtn.frame = CGRectMake(WIDTH * 2 / 4, 0, WIDTH / 4, 35)
        willCommentBtn.frame = CGRectMake(WIDTH * 3 / 4, 0, WIDTH / 4, 35)
        allBtn.setTitle("全部", forState: UIControlState.Normal)
        willPayBtn.setTitle("待付款", forState: UIControlState.Normal)
        willUserBtn.setTitle("待消费", forState: UIControlState.Normal)
        willCommentBtn.setTitle("待评价", forState: UIControlState.Normal)
        allBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        allBtn.addTarget(self, action: #selector(self.changeColorAndDeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        willPayBtn.addTarget(self, action: #selector(self.changeColorAndDeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        willUserBtn.addTarget(self, action: #selector(self.changeColorAndDeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        willCommentBtn.addTarget(self, action: #selector(self.changeColorAndDeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        allBtn.tag = 1
        willPayBtn.tag = 2
        willUserBtn.tag  = 3
        willCommentBtn.tag = 4
        topView.addSubview(allBtn)
        topView.addSubview(willPayBtn)
        topView.addSubview(willUserBtn)
        topView.addSubview(willCommentBtn)
//        self.changeColorAndDeView(<#T##Btn: UIButton##UIButton#>)
    }
    
    func reloadMTableviwe(count:Int){
        switch count {
        case 1:
            sign = 0
            allBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            deView.frame = CGRectMake(0, 35, WIDTH / 4, 5)
            
            
        case 2:
            sign = 1
            allBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willPayBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            deView.frame = CGRectMake(WIDTH / 4, 35, WIDTH / 4, 5)
            
            
        case 3:
            sign = 2
            allBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willUserBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            deView.frame = CGRectMake(WIDTH  * 2 / 4, 35, WIDTH / 4, 5)
            
            
        default:
            sign = 3
            allBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            deView.frame = CGRectMake(WIDTH  * 3 / 4, 35, WIDTH / 4, 5)
            
            
            
        }
        
        mTableview.reloadData()
        mTable.reloadData()

    }
    
    func changeColorAndDeView(Btn:UIButton)
    {
        self.reloadMTableviwe(Btn.tag)
        self.Btn.tag = Btn.tag
        self.headerRefresh()
        
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sign == 0)
        {
//            print(self.AllDataSource?.count)
            if self.AllDataSource == nil {
                return 0
            }
            return (self.AllDataSource?.count)!
            
        }else if sign == 1{
//            print(self.DFKDataSource?.count)
            if self.self.DFKDataSource == nil {
                return 0
            }
            return (self.self.DFKDataSource?.count
                )!
            
        }else if sign == 2{
            if self.DXFDataSource == nil {
                return 0
            }
//            print(self.DXFDataSource?.count)
            return (self.DXFDataSource?.count
                )!
        }else{
            if self.DPJDataSource == nil {
                return 0
            }
//            print(self.DPJDataSource?.count)
            return (self.DPJDataSource?.count
                )!
        }

    }
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isNotSigle{
            
        }
        
        
        if(sign == 0)
        {
//            print(self.AllDataSource!)
//            print(self.AllDataSource!.count)
//            print(self.AllDataSource![indexPath.section])
            
            if self.AllDataSource != nil {
                let cell = MyBookDanCell.init(Data: self.AllDataSource![indexPath.row],sign: sign,isSigle:self.isNotSigle)
                cell.targets = self
                if self.isNotSigle{
                    cell.Btn1.hidden = true
                }
                
                cell.Btn1.tag = 300 + indexPath.row
                
                if self.AllDataSource![indexPath.row].delivery == "送货上门" &&  self.AllDataSource![indexPath.row].state == "3"{
                    cell.Btn1.addTarget(self, action: #selector(self.querenFahuo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    
                }else{
                    cell.Btn1.addTarget(self, action: #selector(self.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
                
                if self.AllDataSource![indexPath.row].state == "1" {
                    cell.Btn.tag = 100 + indexPath.row
                    cell.Btn.addTarget(self, action: #selector(self.payMeony(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    
                }else if self.AllDataSource![indexPath.row].state == "2"{
                    cell.tag = indexPath.row
//                    cell.Btn.addTarget(self, action: #selector(self.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                return  cell
            }else{
                let cell = UITableViewCell()
                return cell
            }
            
            
        }else if sign == 1{
            if self.DFKDataSource != nil {
                let cell = MyBookDanCell.init(Data: self.DFKDataSource![indexPath.row],sign: sign,isSigle:self.isNotSigle)
                if self.isNotSigle{
                    cell.Btn1.hidden = true
                }
                cell.Btn1.tag = 600 + indexPath.row
                cell.Btn1.addTarget(self, action: #selector(self.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.targets = self
                cell.Btn.tag = indexPath.row+100
                cell.Btn.addTarget(self, action: #selector(self.payMeony(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                return  cell
            }else{
                let cell = UITableViewCell()
                return cell
            }
            
            
        }else if sign == 2{
            
            
            
             if self.DXFDataSource != nil {
                let cell = MyBookDanCell.init(Data: self.DXFDataSource![indexPath.row],sign: sign,isSigle:self.isNotSigle)
                cell.targets = self
                if self.isNotSigle{
                    cell.Btn1.hidden = true
                }
                cell.Btn1.tag = 400 + indexPath.row
                
                if self.AllDataSource![indexPath.row].delivery == "送货上门" &&  self.AllDataSource![indexPath.row].state == "3"{
                    cell.Btn1.addTarget(self, action: #selector(self.querenFahuo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    
                }else{
                    cell.Btn1.addTarget(self, action: #selector(self.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
                cell.Btn.tag = indexPath.row
//                cell.Btn.addTarget(self, action: #selector(self.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                return  cell
             }else{
                let cell = UITableViewCell()
                return cell
            }
            
            
            
        }else{
            if self.DPJDataSource != nil {
                let cell = MyBookDanCell.init(Data: self.DPJDataSource![indexPath.row],sign: sign,isSigle:self.isNotSigle)
                cell.targets = self
                return  cell
                
            }else{
                let cell = UITableViewCell()
                return cell
            }
            
            
            
        }

//        return MyBookDanCell.init(Data: Source[indexPath.row])
    }
    
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let vc = MyDingDanXiangQingViewController()
        vc.sign = sign
        vc.isDingdan = true
        vc.isSigle = self.isNotSigle
        if(sign == 0)
        {
            if self.AllDataSource != nil {
                vc.info = self.AllDataSource![indexPath.row]
            }
            
            
        }else if sign == 1{

            if self.self.DFKDataSource != nil {
                vc.info = self.DFKDataSource![indexPath.row]
            }
            
        }else if sign == 2{
            if self.DXFDataSource != nil {
                vc.info = self.DXFDataSource![indexPath.row]
            }
            
        }else{
            if self.DPJDataSource != nil {
                vc.info = self.DPJDataSource![indexPath.row]
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func querenFahuo(sender:UIButton)
    {
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定已经收到货了？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        
                                        if self.sign == 0{
                                            self.mainHelper.gaiBianDingdan(self.AllDataSource![sender.tag - 300].order_num!, state: "4") { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    if !success {
                                                        alert("确认收货失败请重试", delegate: self)
                                                        return
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                })
                                            }
                                            
                                            
                                            
                                            
                                        }else if self.sign == 2{
                                            self.mainHelper.gaiBianDingdan(self.DXFDataSource![sender.tag - 400].order_num!, state: "4") { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    if !success {
                                                        alert("订单取消失败请重试", delegate: self)
                                                        return
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                })
                                            }
                                            
                                        }
                                        
                                        self.headerRefresh()
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func Cancel(sender:UIButton)
    {
        
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定要取消订单吗？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        
                                        
                                        //                let ud = NSUserDefaults.standardUserDefaults()
                                        //                let userid = ud.objectForKey("userid")as! String
                                        if self.sign == 0{
                                            self.mainHelper.gaiBianDingdan(self.AllDataSource![sender.tag - 300].order_num!, state: "-1") { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                if !success {
                                                    alert("订单取消失败请重试", delegate: self)
                                                    return
                                                    
                                                    
                                                    
                                                    
                                                }else{
                                                     self.headerRefresh()
                                                    }
                                                })
                                        }
                                        
                                            
                                            
                                        }else if self.sign == 1{
                                            self.mainHelper.gaiBianDingdan(self.DFKDataSource![sender.tag - 600].order_num!, state: "-1") { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                if !success {
                                                    alert("订单取消失败请重试", delegate: self)
                                                    return
                                                    
                                                    
                                                    
                                                    
                                                }
                                                     self.headerRefresh()
                                                })
                                            }

                                        }else if self.sign == 2{
                                            self.mainHelper.gaiBianDingdan(self.DXFDataSource![sender.tag - 400].order_num!, state: "-1") { (success, response) in
                                                dispatch_async(dispatch_get_main_queue(), {
                                                if !success {
                                                    alert("订单取消失败请重试", delegate: self)
                                                    return
                                                    
                                                    
                                                    
                                                    
                                                }
                                                     self.headerRefresh()
                                                })
                                            }
                                            
                                        }
                                        
                                  
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    
    
    func payMeony(sender:UIButton){
        if sign == 0 {
            let vc = PayViewController()
            if self.AllDataSource![sender.tag-100].order_num == "" {
                alert("订单错误", delegate: self)
                return
            }
            vc.numForGoodS = self.AllDataSource![sender.tag-100].order_num!
            vc.price = ((self.AllDataSource![sender.tag-100].money!) as NSString).doubleValue
            vc.subject = self.AllDataSource![sender.tag-100].goodsname! as NSString
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sign == 1{
            let vc = PayViewController()
            if self.DFKDataSource![sender.tag-100].order_num == "" {
                alert("订单错误", delegate: self)
                return
            }
            vc.numForGoodS = self.DFKDataSource![sender.tag-100].order_num!
            vc.price = ((self.DFKDataSource![sender.tag-100].money!) as NSString).doubleValue
            vc.subject = self.DFKDataSource![sender.tag-100].goodsname! as NSString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
