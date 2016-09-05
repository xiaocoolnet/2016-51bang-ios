//
//  MyBookDan.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

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
    let topView = UIView()
    let allBtn = UIButton()
    let willPayBtn = UIButton()
    let willUserBtn = UIButton()
    let willCommentBtn = UIButton()
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
        Btn.tag = 1
        sign = 0
        self.getAllData()
        self.getDFKData()
        self.getDXFData()
        self.getDPJData()
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
       
        self.title = "我的订单"
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
        mTableview = UITableView.init(frame: CGRectMake(0, 45, WIDTH, self.view.frame.size.height - 45.1 - rect.height )
            )
        mTableview.delegate = self
        mTableview.dataSource  = self
        self.view.addSubview(mTableview)
    
    }
    
    func getAllData(){
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "0,1,2,3,4") { (success, response) in
            print(response)
            self.AllDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.AllDataSource?.count)
            print(self.AllDataSource)
            self.createTableView()
            
        }
    
    }
    
    
    
    func getDFKData(){
    
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "0") { (success, response) in
            print(response)
            self.DFKDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.DFKDataSource)
            print(self.DFKDataSource?.count)
        }
    
    }
    
    func getDXFData(){
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "1") { (success, response) in
            print(response)
            self.DXFDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.DXFDataSource)
            print(self.DXFDataSource?.count)
        }
    
    }
    
    func getDPJData(){
        let ud = NSUserDefaults.standardUserDefaults()
        let uid = ud.objectForKey("userid")as! String
        mainHelper.getMyOrder(uid, state: "3") { (success, response) in
            print(response)
            self.DPJDataSource = response as? Array<MyOrderInfo> ?? []
            print(self.DPJDataSource)
            print(self.DPJDataSource?.count)
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
        
    }
    
    func changeColorAndDeView(Btn:UIButton)
    {
        switch Btn.tag {
        case 1:
            sign = 0
            allBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            deView.frame = CGRectMake(0, 35, WIDTH / 4, 5)
            Source = Data
            
        case 2:
            sign = 1
            allBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willPayBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            deView.frame = CGRectMake(WIDTH / 4, 35, WIDTH / 4, 5)
            Source = Data2
            
        case 3:
            sign = 2
            allBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willUserBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            deView.frame = CGRectMake(WIDTH  * 2 / 4, 35, WIDTH / 4, 5)
            Source = Data3
            
        default:
            sign = 3
            allBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willPayBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willUserBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            willCommentBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            deView.frame = CGRectMake(WIDTH  * 3 / 4, 35, WIDTH / 4, 5)
            Source = Data4
            
            
        }
        
        mTableview.reloadData()
        
        
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sign == 0)
        {
            print(self.AllDataSource?.count)
            return (self.AllDataSource?.count)!
            
        }else if sign == 1{
            print(self.DFKDataSource?.count)
            return (self.DXFDataSource?.count
                )!
            
        }else if sign == 2{
            print(self.DXFDataSource?.count)
            return (self.DXFDataSource?.count
                )!
        }else{
            print(self.DPJDataSource?.count)
            return (self.DXFDataSource?.count
                )!
        }

    }
    
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(sign == 0)
        {
            print(self.AllDataSource!)
            print(self.AllDataSource!.count)
            print(self.AllDataSource![indexPath.section])
            let cell = MyBookDanCell.init(Data: self.AllDataSource![indexPath.section],sign: sign)
            cell.targets = self
            return  cell
        }else if sign == 1{
            let cell = MyBookDanCell.init(Data: self.DFKDataSource![indexPath.section],sign: sign)
            cell.targets = self
            return  cell
        }else if sign == 2{
            let cell = MyBookDanCell.init(Data: self.DXFDataSource![indexPath.section],sign: sign)
            cell.targets = self
            cell.Btn.tag = indexPath.row
            cell.Btn.addTarget(self, action: #selector(self.Cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return  cell
        }else{
            let cell = MyBookDanCell.init(Data: self.DPJDataSource![indexPath.section],sign: sign)
            cell.targets = self
            return  cell
        }

//        return MyBookDanCell.init(Data: Source[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func Cancel(btn:UIButton)
    {
        self.row = btn.tag
        print(self.row)
        if DXFDataSource?.count != 0{
            print("取消订单")
            
            let MyOrderInfo = self.DXFDataSource![btn.tag]
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            mainHelper.quXiaoDingdan(MyOrderInfo.order_num!, userid: userid) { (success, response) in
                if !success {
                    print("..........")
                    print(MyOrderInfo.order_num)
                    return
                }else{
                    
                let alertController = UIAlertController(title: "系统提示",
                                                            message: "您确定要取消订单吗？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                handler: { action in
                self.DXFDataSource?.removeAtIndex(self.row)
                let myindexPaths = NSIndexPath.init(forRow: btn.tag, inSection: 0)
                                                    
                self.mTableview.deleteRowsAtIndexPaths([myindexPaths],       withRowAnimation: UITableViewRowAnimation.Right)
                                                    
//                self.mTableview.reloadData()
                                                    
                self.Btn.tag = 3
                                  
                    })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                    
//                    alert("取消订单", delegate: self)
//                    let myindexPaths = NSIndexPath.init(forRow:0 inSection: 0)

                }
                
                
            }
            
        }
        
    }

    
}
