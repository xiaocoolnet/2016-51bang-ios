//
//  BusnissViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

var isFavorite = Bool()
class BusnissViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIScrollViewDelegate {
    
    
    var bottom = UIView()
    var ShareButton = UIButton()
    var shareImage = UIImageView(image: UIImage(named: "57b017f4a9f26"))
    //    var TipLabel    = UILabel()
    var bottom_title = UILabel()
    let titleArray = ["微信好友","朋友圈"]
    var btn1 = UIButton()
    var btn2 = UIButton()
    var btn3 = UIButton()
    var btn4 = UIButton()
    var btn5 = UIButton()
    var btn6 = UIButton()
    var cancelBtn = UIButton()
    
    
    var goodsInfo = GoodsInfo2()
    var favoriteInfo = String()
    var isdetails = Bool()
    var footView : ShopFootViewCell!
    let myTableView = UITableView()
    let shopHelper = ShopHelper()
    var headerView = ShopHeaderViewCell()
    let buttonImageArr = ["ic_weixin-1","ic_pengyouquan","ic_weixin-1","ic_pengyouquan"];
    let nameArr = ["微信好友","微信朋友圈","支付宝好友","支付宝生活圈"]
    var dataSource : Array<commentlistInfo>?
    var geocoder = CLGeocoder()
    var photoArr = NSMutableArray()
    let mainHelper = MainHelper()
    var id = String()
    var myPhotoArray = NSMutableArray()
    var isShow = false
    var pageControl = UIPageControl()
    var current = CLLocation()
    override func viewWillAppear(animated: Bool) {
        myPhotoArray.removeAllObjects()
        getData()
        getIsfavorite()
        
        self.view.backgroundColor = RGREY
        self.title="特卖详情"
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        //        self.navigationController?.navigationBar.hidden = true
        //        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        createRightNavi()
        headerView.favorite.userInteractionEnabled = true
    }
    
    func orderList(){
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            let ud = NSUserDefaults.standardUserDefaults()
            if ud.objectForKey("userid") != nil{
                if goodsInfo.userid != nil {
                    if goodsInfo.userid as String == ud.objectForKey("userid") as! String {
                        alert("不能购买自己的商品", delegate: self)
                        return
                    }
                }
            }
//
//            if(ud.objectForKey("ss") as! String == "no")
//            {
//                let vc  = WobangRenZhengController()
//                self.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(vc, animated: true)
//                self.hidesBottomBarWhenPushed = false
//                return
            
//            }
            let vc = AffirmOrderViewController()
            vc.info = self.goodsInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getData(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        mainHelper.getshowshopping(id, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success == false {
                    
                    return
                }else{
                    hud.hide(true)
//                    print(response)
                    //                  Http(JSONDecoder(data))
                    if response?.isKindOfClass(GoodsInfo2) == true{
                        self.goodsInfo = response as! GoodsInfo2
                        self.dataSource = self.goodsInfo.commentlist
                    }
                    
//                    print(self.goodsInfo)
//                    print(self.goodsInfo.id)
//                    print(self.goodsInfo.price)
//                    print(self.goodsInfo.pic)
//                    print(self.goodsInfo.goodsname)
//                    print(self.goodsInfo.address)
//                    print(self.goodsInfo.longitude)
//                    print(self.goodsInfo.latitude)
                    self.viewDidLoad()
                    self.myTableView.reloadData()
                }
            })
            })
        
        
    }
    
    
    func click(){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func createRightNavi(){
        
        let rightNaviItem = UIView.init(frame: CGRectMake(0, 0, 60, 30))
        
        let share = UIButton.init(frame: CGRectMake(0, 0, 60, 30))
        share.setTitle("分享", forState: UIControlState.Normal)
        share.addTarget(self, action: #selector(self.shareAction), forControlEvents: UIControlEvents.TouchUpInside)
        rightNaviItem.addSubview(share)
        
        let rightNavigationItem = UIBarButtonItem.init(customView: rightNaviItem)
        self.navigationItem.rightBarButtonItem = rightNavigationItem
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        if tableView.tag == 0 {
        if indexPath.row == 0 {
            return 80
        }else if indexPath.row == 1{
            return 60
        }else if indexPath.row == 2{
            return 50
        }else {
            
            let str = dataSource![indexPath.row-3].content
            let height = calculateHeight( str!, size: 15, width: WIDTH - 10 )
            return 75 + height + 20 + 40
        }
        
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isdetails {
            return 1
        }else{
            if dataSource?.count>0 {
                return 3+(dataSource?.count)!
            }else{
                
                return 2
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.myTableView.separatorStyle = .None
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("site")as! SiteTableViewCell
            cell.callPhone.addTarget(self, action: #selector(self.call), forControlEvents: UIControlEvents.TouchUpInside)
            let ud = NSUserDefaults.standardUserDefaults()
            //            print(ud.objectForKey("longitude"))
            if ud.objectForKey("longitude") == nil || ud.objectForKey("latitude") == nil{
                
            }else{
                let longitude = ud.objectForKey("longitude")as! String
                let latitude = ud.objectForKey("latitude")as! String
                let myLongitude = removeOptionWithString(longitude)
                let myLatitude = removeOptionWithString(latitude)
                self.current = CLLocation.init(latitude: CLLocationDegrees(myLatitude)!, longitude: CLLocationDegrees(myLongitude)!)
            }
            //            let longitude = ud.objectForKey("longitude")as! String
            //            let latitude = ud.objectForKey("latitude")as! String
            
            
            print(current)
            if goodsInfo.latitude != "0.0"&&goodsInfo.latitude != "" && goodsInfo.longitude != "0.0"&&goodsInfo.longitude != ""  && goodsInfo.latitude != nil&&goodsInfo.longitude != nil{
                print(goodsInfo.latitude! as String,goodsInfo.longitude! as String,"00000000")
                
                let before = CLLocation.init(latitude: CLLocationDegrees(self.goodsInfo.latitude! as String)!, longitude: CLLocationDegrees(self.goodsInfo.longitude! as String)!)
                
                
                
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
            if self.goodsInfo.address != nil{
                print(self.goodsInfo.address)
                cell.title.text = self.goodsInfo.address
                cell.title.adjustsFontSizeToFitWidth = true
            }
//            print(cell.title.text)
            cell.title.adjustsFontSizeToFitWidth = true
            cell.selectionStyle = .None
            return cell
            
        }else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2")as!EditTableViewCell2
            cell.title.text = "商家发布"
            cell.selectionStyle = .None
            let view = UIView.init(frame: CGRectMake(0, 59, WIDTH, 1))
            view.backgroundColor = UIColor.whiteColor()
            cell.addSubview(view)
            
            return cell
        }else if (indexPath.row == 2){
            let cell = UITableViewCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let view1 = UIView.init(frame: CGRectMake(0, 0, WIDTH, 10))
            view1.backgroundColor = RGREY
            view1.userInteractionEnabled = false
            cell.addSubview(view1)
            
            let labelcomment = UILabel.init(frame: CGRectMake(20, 15, 60, 38))
            labelcomment.text = "评价"
            labelcomment.userInteractionEnabled = true
            cell.addSubview(labelcomment)
            
            let view2 = UIView.init(frame: CGRectMake(0, 48, WIDTH, 2))
            view2.backgroundColor = RGREY
            view2.userInteractionEnabled = false
            cell.addSubview(view2)
            
            return cell
        }
        else{
            
            if self.dataSource?.count>0 {
                let cell = ConveniceCell.init(myinfo: self.dataSource![indexPath.row-3] )
//                print(self.dataSource![indexPath.row-3].add_time)
//                print(self.dataSource![indexPath.row-3].id)
//                print(self.dataSource![indexPath.row-3].content)
//                print(self.dataSource![indexPath.row-3].name)
//                print(self.dataSource![indexPath.row-3].userid)
//                print(self.dataSource![indexPath.row-3].photo)
                //                print(self.dataSource![indexPath.row-2].add_time)
                return cell
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.clearColor()
                return cell
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        isFavorite = false
        self.view.backgroundColor = RGREY
        //        getData()
//        self.dataSource = self.goodsInfo.commentlist
        //        let ud = NSUserDefaults.standardUserDefaults()
        //        let userid = ud.objectForKey("userid")as! String
        
        //        mainHelper.getDingDanDetail(userid,handle:{[unowned self] (success, response) in
        //            dispatch_async(dispatch_get_main_queue(), {
        //                if !success {
        //                    return
        //                }
        //                print(response)
        //                self.dataSource?.removeAll()
        //                print(self.dataSource?.count)
        //                self.dataSource = response as? Array<GoodsInfo2> ?? []
        //                print(self.dataSource)
        //                print(self.dataSource?.count)
        //
        //
        //            })
        //
        //            })
        
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        //        self.getAddress()
        self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 50 -  20)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.backgroundColor = RGREY
        self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.myTableView.registerNib(UINib(nibName:"EditTableViewCell2",bundle:nil), forCellReuseIdentifier: "cell2")
        myTableView.registerNib(UINib(nibName: "SiteTableViewCell",bundle: nil), forCellReuseIdentifier: "site")
        
        headerView =  (NSBundle.mainBundle().loadNibNamed("ShopHeaderViewCell", owner: nil, options: nil).first as? ShopHeaderViewCell)!
        
        let scrollView = UIScrollView.init(frame:CGRectMake(0, 0, WIDTH, 220))
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = CGSizeMake(WIDTH * CGFloat (goodsInfo.pic.count) , 0)
        scrollView.contentOffset = CGPoint(x: 0,y: 0)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.directionalLockEnabled = true
        scrollView.delegate = self
        headerView.addSubview(scrollView)
        
        pageControl = UIPageControl.init(frame: CGRectMake(WIDTH-80-CGFloat(goodsInfo.pic.count)*10, 200, 80+CGFloat(goodsInfo.pic.count)*10, 20))
        pageControl.numberOfPages = goodsInfo.pic.count
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        if goodsInfo.pic.count > 1{
            headerView.addSubview(pageControl)
        }

        //
        if goodsInfo.pic.count > 0  {
            for num in 0...goodsInfo.pic.count-1{
                let headerPhotoView = UIImageView()
                headerPhotoView.contentMode = .ScaleAspectFill
                headerPhotoView.frame = CGRectMake(CGFloat(num) * WIDTH, 0, WIDTH, 220)
                headerPhotoView.sd_setImageWithURL(NSURL(string:Bang_Image_Header+goodsInfo.pic[num].pictureurl!), placeholderImage: UIImage.init(named: "01"))
                scrollView.addSubview(headerPhotoView)
//                headerPhotoView.userInteractionEnabled = true
                //
                //                let backButton = UIButton()
                //                backButton.frame = CGRectMake(CGFloat(num) * WIDTH, 0, WIDTH, 220)
                ////                backButton.frame.origin.y = headerPhotoView.frame.origin.y + 98
                //                backButton.backgroundColor = UIColor.clearColor()
                //                backButton.tag = num
                //                headerView.addSubview(backButton)
                //                backButton .addTarget(self, action:#selector(self.lookImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//                let tapGR = UITapGestureRecognizer(target: self, action: #selector(BusnissViewController.lookImage(_:)))
//                headerPhotoView.addGestureRecognizer(tapGR)
                myPhotoArray.addObject(headerPhotoView)
                let mybutton = UIButton.init(frame: headerPhotoView.frame)
                mybutton.backgroundColor = UIColor.clearColor()
                mybutton.tag = num
                mybutton.addTarget(self, action: #selector(self.lookImage(_:)), forControlEvents: .TouchUpInside)
                scrollView.addSubview(mybutton)
            }
            
        }else{
            let headerPhotoView1 = UIImageView()
            headerPhotoView1.frame = CGRectMake(0, 0, WIDTH, 220)
            headerPhotoView1.image = UIImage(named: "01")
            scrollView.addSubview(headerPhotoView1)
        }
        
        //        headerView.headerImage.setImageWithURL(NSURL.init(string:Bang_Image_Header+arrayphoto[1])!, placeholderImage: UIImage.init(named: "01"))
        headerView.frame = CGRectMake(0, 0, WIDTH, 250)
        //        print(goodsInfo.price)
        if goodsInfo.price != nil {
            headerView.price.text = "¥"+goodsInfo.price!
        }else{
            headerView.price.text = "¥"
        }
        if goodsInfo.description !=  nil{
            //            if goodsInfo.description.characters.count > 60 {
            //
            //              let newDescription = (goodsInfo.description as NSString).substringToIndex(60)
            //              headerView.desciption.text = newDescription
            //            }
            headerView.desciption.text = goodsInfo.description
            //            headerView.desciption.adjustsFontSizeToFitWidth = true
            let height = calculateHeight(goodsInfo.description!, size: 16, width:WIDTH-16)
            print(height)
            headerView.desciptionHeight.constant = height+10
            headerView.desciption.frame.size.height = height+10
            headerView.frame.size.height = 275 + height+10
        }else{
            headerView.desciption.text = ""
            headerView.desciption.removeFromSuperview()
            headerView.frame.size.height = 250
        }
        
        //        if goodsInfo.description == nil {
        //
        //
        //        }else{
        //
        //        }
        //
        
        headerView.favorite.addTarget(self, action: #selector(self.favorite), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.favorite.tag = 10
        headerView.favorite.userInteractionEnabled = true
        print(isFavorite)
        //        if loginSign == 1 {
        //
        //            let ud = NSUserDefaults.standardUserDefaults()
        //            let uid = ud.objectForKey("userid")as! String
        //            let shoucang = ud.objectForKey(uid)
        //            print(shoucang)
        //            if shoucang == nil {
        //                print("sdf")
        //            }
        //            if shoucang != nil && shoucang as! Bool == true {
        //
        //                isFavorite = true
        //            }else{
        //
        //                isFavorite = false
        //            }
        //            //
        //        }else{
        //            headerView.favorite.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
        //
        //        }
        
        
        
        //        headerView.backgroundColor = UIColor.redColor()
        myTableView.tableHeaderView = headerView
        //        headerView.back.addTarget(self, action: #selector(click), forControlEvents: UIControlEvents.TouchUpInside)
        footView = NSBundle.mainBundle().loadNibNamed("ShopFootViewCell", owner: nil, options: nil).first as? ShopFootViewCell
        footView?.buy.addTarget(self, action: #selector(self.orderList), forControlEvents: UIControlEvents.TouchUpInside)
        footView?.buy.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        footView?.buy.backgroundColor = UIColor.orangeColor()
        if isdetails {
            footView?.buy.hidden = true
        }else{
            footView?.buy.hidden = false
        }
        if goodsInfo.price != nil{
            footView?.price.text = "¥"+goodsInfo.price!
        }
        
        //        myTableView.tableFooterView = footView
        //        myTableView.tableFooterView?.frame.size.height = WIDTH*50/375
        footView?.frame = CGRectMake(0, HEIGHT-WIDTH*50/375 - 64, WIDTH, WIDTH*50/375)
        self.view.addSubview(myTableView)
        self.view.addSubview(footView!)
        self.getBottom()
        UIView.animateWithDuration(0.4) {
            self.bottom.frame = CGRectMake(0, HEIGHT, WIDTH , 500+50)
        }
        // Do any additional setup after loading the view.
    }
    
    //scroller代理方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int(CGFloat((scrollView.contentOffset.x + WIDTH/2))/WIDTH)
        pageControl.currentPage = index
    }
    
    func call(){
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            let alertController = UIAlertController(title: "系统提示",
                                                    message: "是否要拨打电话？", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .Default,
                                         handler: { action in
                                            
                                            let url1 = NSURL(string: "tel://"+self.goodsInfo.phone!)
                                            UIApplication.sharedApplication().openURL(url1!)
                                            
                                            
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            
        }
    }
    
    func lookImage(sender:UIButton) {
        
        
       
        
        let myVC = LookPhotoVC()
        myVC.hidesBottomBarWhenPushed = true
        myVC.myPhotoArray =  myPhotoArray
        myVC.pic = goodsInfo.pic
//        print(myPhotoArray)
        myVC.title = "查看图片"
        myVC.count = sender.tag
        self.navigationController?.pushViewController(myVC, animated: true)
        myVC.hidesBottomBarWhenPushed = false
    }
    
    func myfabu(){
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            let vc = MenuViewController()
            vc.userid = self.goodsInfo.userid as String!
            vc.isShow = self.isShow
            vc.title = "商家发布"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 1)
        {
            self.myfabu()
        }
        if indexPath.row == 0 {
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
            if goodsInfo.latitude != nil && goodsInfo.longitude != nil && goodsInfo.latitude != "" && goodsInfo.longitude != ""{
                coor2.latitude = CLLocationDegrees(goodsInfo.latitude! as String)!
                coor2.longitude = CLLocationDegrees(goodsInfo.longitude! as String)!
            }else{
                alert("地址不能为空", delegate: self)
                return
            }
            end.pt = coor2
            //指定终点名称
            if self.goodsInfo.address != nil {
                end.name = self.goodsInfo.address!
            }else{
                alert("地址不能为空", delegate: self)
                return
            }
            
            opt.endPoint = end
            
            
            BMKOpenRoute.openBaiduMapDrivingRoute(opt)
            
            
            
        }
    }
    func shareAction(){
//        bottom.hidden = false
        UIView.animateWithDuration(0.4) {
            self.bottom.frame = CGRectMake(0, self.view.frame.size.height - 250-250-50+50, WIDTH , 500+50)
        }
    }
    
    //MARK:分享
    func getBottom(){
        
        bottom.frame = CGRectMake(0, HEIGHT, WIDTH , 500+50)
        bottom.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(bottom)
        
        bottom_title.frame = CGRectMake(0, 0, WIDTH, 35)
        bottom_title.text = "分享到"
        bottom.addSubview(bottom_title)
        bottom_title.textAlignment = NSTextAlignment.Center
        btn1.frame = CGRectMake(WIDTH / 5, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
        btn1.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn1.tag = 1
        btn1.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn1.layer.masksToBounds = true
        btn1.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn1)
        
        btn2.frame = CGRectMake(WIDTH / 5 * 3, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
        btn2.tag = 2
        btn2.setImage(UIImage.init(named: "ic_pengyouquan"), forState: UIControlState.Normal )
        btn2.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn2.layer.masksToBounds = true
        btn2.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn2)
        
        btn3.frame = CGRectMake(WIDTH / 5, bottom_title.frame.size.height+WIDTH / 5+50, WIDTH / 5, WIDTH / 5)
        //        btn3.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn3.tag = 3
        //        btn3.backgroundColor = UIColor.redColor()
        //        btn3.setTitle(" 支付宝好友", forState: UIControlState.Normal)
        //        btn3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn3.setImage(UIImage.init(named: "zhifubao"), forState: UIControlState.Normal )
        
        btn3.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn3.layer.masksToBounds = true
        btn3.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn3)
        let label = UILabel()
        label.text = "支付宝好友"
        label.textAlignment = NSTextAlignment.Center
        label.frame = CGRectMake(WIDTH / 5-15, btn3.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label)
        
        btn4.frame = CGRectMake(WIDTH / 5 * 3, bottom_title.frame.size.height+WIDTH / 5+50, WIDTH / 5, WIDTH / 5)
        //        btn3.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn4.tag = 4
        //        btn4.backgroundColor = UIColor.redColor()
        //        btn4.setTitle(" 支付宝生活圈", forState: UIControlState.Normal)
        //        btn4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn4.setImage(UIImage.init(named: "ic_支付宝shenghuoquan"), forState: UIControlState.Normal )
        
        btn4.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn4.layer.masksToBounds = true
        btn4.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn4)
        let label4 = UILabel()
        label4.text = "支付宝生活圈"
        label4.textAlignment = NSTextAlignment.Center
        label4.frame = CGRectMake(WIDTH / 5*3-15, btn3.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label4)
        
        //
        
        btn5.frame = CGRectMake(WIDTH  / 5, bottom_title.frame.size.height+WIDTH / 5*2+50+50, WIDTH / 5, WIDTH / 5)
        btn5.tag = 5
        btn5.setImage(UIImage.init(named: "ic_QQ"), forState: UIControlState.Normal)
        btn5.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn5.layer.masksToBounds = true
        btn5.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn5)
        
        let label5 = UILabel()
        label5.text = "QQ好友"
        label5.textAlignment = NSTextAlignment.Center
        label5.frame = CGRectMake(WIDTH / 5-15, btn5.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label5)
        
        btn6.frame = CGRectMake(WIDTH / 5 * 3, bottom_title.frame.size.height+WIDTH / 5*2+50+50, WIDTH / 5, WIDTH / 5)
        //        btn3.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn6.tag = 9
        //        btn4.backgroundColor = UIColor.redColor()
        //        btn4.setTitle(" 支付宝生活圈", forState: UIControlState.Normal)
        //        btn4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn6.setImage(UIImage.init(named: "ic_kongjianF"), forState: UIControlState.Normal )
        
        btn6.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn6.layer.masksToBounds = true
        btn6.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn6)
        let label6 = UILabel()
        label6.text = "QQ空间"
        label6.textAlignment = NSTextAlignment.Center
        label6.frame = CGRectMake(WIDTH / 5*3-15, btn5.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label6)
        
        
        var count:CGFloat = 0
        for title in titleArray {
            
            let label = UILabel()
            label.text = title
            label.textAlignment = NSTextAlignment.Center
            label.frame = CGRectMake( (count+1) * WIDTH / 5, btn1.origin.y + WIDTH / 5 + 10, WIDTH / 5, 20)
            count += 2
            bottom.addSubview(label)
        }
        cancelBtn.tag = 6
        cancelBtn.frame = CGRectMake(0, btn1.origin.y + WIDTH / 5 + 30+100+100+20+50+20, WIDTH , 250 - 35 - WIDTH / 5 - 75 - 20 )
        cancelBtn.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn.backgroundColor = COLOR
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 10
        bottom.addSubview(cancelBtn)
        
    }
    
    func btnAction(btn:UIButton)
    {
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
//            let ut = NSUserDefaults.standardUserDefaults()
//            var userid = String()
//            if ut.objectForKey("userid") != nil {
//                userid = ut.objectForKey("userid") as! String
//            }
            
            var shangHuid = String()
            if goodsInfo.userid != nil {
                 shangHuid = goodsInfo.userid!
            }
            
            let img = UIImagePNGRepresentation(UIImage.init(named: "图标")!)
            let newsObj = QQApiNewsObject(URL: NSURL(string: Bang_Open_Header+"index.php?g=portal&m=article&a=shop&id="+shangHuid), title: "我注册了51bang，发布了商品，来加入吧", description: "基于同城个人，商户服务 。商品购买。给个人，商户提供交流与服务平台", previewImageData: img, targetContentType: QQApiURLTargetTypeNews)
            
            
            let req = SendMessageToQQReq(content: newsObj)
            switch btn.tag {
            case 1:
                print("微信")
                let sendReq = SendMessageToWXReq.init()
                sendReq.bText = false
                sendReq.scene = 0
                let urlMessage = WXMediaMessage.init()
                urlMessage.setThumbImage(UIImage(named: "图标"))
                urlMessage.title = "我注册了51bang，发布了商品，来加入吧"
                urlMessage.description = "基于同城个人，商户服务 。商品购买。给个人，商户提供交流与服务平台"
                let webObj = WXWebpageObject.init()
                webObj.webpageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=shop&id="+shangHuid
                urlMessage.mediaObject = webObj
                sendReq.message = urlMessage
                WXApi.sendReq(sendReq)
                
            case 2:
                print("朋友圈")
                let sendReq = SendMessageToWXReq.init()
                sendReq.bText = false
                sendReq.scene = 1
                //sendReq.text = "测试，请忽略"
                let urlMessage = WXMediaMessage.init()
                urlMessage.title = "我注册了51bang，发布了商品，来加入吧"
                urlMessage.description = "基于同城个人，商户服务 。商品购买。给个人，商户提供交流与服务平台"
                urlMessage.setThumbImage(UIImage(named: "图标"))
                let webObj = WXWebpageObject.init()
                webObj.webpageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=shop&id="+shangHuid
                urlMessage.mediaObject = webObj
                sendReq.message = urlMessage
                WXApi.sendReq(sendReq)
                
            case 3:
                //支付宝分享
                let message = APMediaMessage()
                let webObj = APShareWebObject()
                //            let textObj = APShareTextObject()
                webObj.wepageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=shop&id="+shangHuid;
                
                message.title = "我注册了51bang，发布了商品，来加入吧";
                message.desc = "基于同城个人，商户服务 。商品购买。给个人，商户提供交流与服务平台";
                
                //            message.thumbUrl = "http://img.sucaifengbao.com/vector/logosjbz/31_309_bp.jpg";
                message.mediaObject = webObj
                
                message.thumbData = UIImagePNGRepresentation(UIImage(named: "图标")!)
                
                let request = APSendMessageToAPReq()
                
                request.message = message
                
                request.scene = APSceneSession
                let result = APOpenAPI.sendReq(request)
                if !result {
                    alert("分享失败", delegate: self)
                }
            //
            case 4:
                //支付宝分享
                let message = APMediaMessage()
                let webObj = APShareWebObject()
                //            let textObj = APShareTextObject()
                webObj.wepageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=shop&id="+shangHuid;
                
                message.title = "我注册了51bang，发布了商品，来加入吧";
                message.desc = "基于同城个人，商户服务 。商品购买。给个人，商户提供交流与服务平台";
                message.thumbData = UIImagePNGRepresentation(UIImage(named: "图标")!)
                //            message.thumbUrl = "http://img.sucaifengbao.com/vector/logosjbz/31_309_bp.jpg";
                message.mediaObject = webObj
                
                
                
                let request = APSendMessageToAPReq()
                
                request.message = message
                message.thumbUrl = "a51bang"
                
                request.scene = APSceneTimeLine
                let result = APOpenAPI.sendReq(request)
                if !result {
                    alert("分享失败", delegate: self)
                }
            case 5:
                //            var newsObj = QQApiNewsObject()
                
                
                
                _ = QQApiInterface.sendReq(req)
                UIView.animateWithDuration(0.4) {
                    self.bottom.frame = CGRectMake(0, HEIGHT, WIDTH , 500+50)
                }
            case 6:
                UIView.animateWithDuration(0.4) {
                    self.bottom.frame = CGRectMake(0, HEIGHT, WIDTH , 500+50)
                }
            case 9:
                //            var newsObj = QQApiNewsObject()
                
                
                
                _ = QQApiInterface.SendReqToQZone(req)
                UIView.animateWithDuration(0.4) {
                    self.bottom.frame = CGRectMake(0, HEIGHT, WIDTH , 500+50)
                }
            default:
                print("微博")
            }
                }
    }
    


    //分享
    func goToShare(btn:UIButton){
        
        let shareParames = NSMutableDictionary()
        // let image : UIImage = UIImage(named: "btn_setting_qq_login")!
        //判断是否有图片,如果没有设置默认图片
        //        let url = Bang_Image_Header+goodsInfo.picture!
        print(self.goodsInfo.goodsname!)
        shareParames.SSDKSetupShareParamsByText("分享内容",
                                                images : UIImage(named: "01"),
                                                url : nil,
                                                title : self.goodsInfo.goodsname!,
                                                type : SSDKContentType.Auto)
        if btn.tag == 0 {
            
            
            if WXApi.isWXAppInstalled() {
                //微信好友分享
                ShareSDK.share(SSDKPlatformType.SubTypeWechatSession , parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                    
                    switch state{
                        
                    case SSDKResponseState.Success:
                        print("分享成功")
                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        
                    case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
                    case SSDKResponseState.Cancel:  print("分享取消")
                        
                    default:
                        break
                    }
                }
            }else{
                let alertView = UIAlertView.init(title:"提示" , message: "没有安装微信", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                
            }
            
        }else if btn.tag == 1{
            
            if WXApi.isWXAppInstalled() {
                
                //微信朋友圈分享
                ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
                    
                    switch state{
                        
                    case SSDKResponseState.Success:
                        print("分享成功")
                        
                        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                        
                    case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
                    case SSDKResponseState.Cancel:  print("分享取消")
                        
                    default:
                        break
                    }
                }
            }
        }else if btn.tag == 2{
                let message = APMediaMessage()
                let webObj = APShareWebObject()
                //            let textObj = APShareTextObject()
                webObj.wepageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7";
                
                message.title = "红包";
                message.desc = "红包";
                //            message.thumbUrl = "http://img.sucaifengbao.com/vector/logosjbz/31_309_bp.jpg";
                message.mediaObject = webObj
                
                
                
                let request = APSendMessageToAPReq()
                
                request.message = message
                
                request.scene = APSceneSession
                let result = APOpenAPI.sendReq(request)
                if !result {
                    alert("分享失败", delegate: self)
                }
                //
                
                
            }else if btn.tag == 3{
                let message = APMediaMessage()
                let webObj = APShareWebObject()
                //            let textObj = APShareTextObject()
                webObj.wepageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7";
                
                message.title = "红包";
                message.desc = "红包";
                //            message.thumbUrl = "http://img.sucaifengbao.com/vector/logosjbz/31_309_bp.jpg";
                message.mediaObject = webObj
                
                
                
                let request = APSendMessageToAPReq()
                
                request.message = message
                
                request.scene = APSceneTimeLine
                let result = APOpenAPI.sendReq(request)
                if !result {
                    alert("分享失败", delegate: self)
                }
            }
            
        }

    
    
    
    
    //MARK:收藏
    
    func getIsfavorite(){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        //        let userid = ud.objectForKey("userid") as! String
        mainHelper.getCheckHadFavorite(userid, refid: id, type: "3") { (success, response) in
            if success == false {
                isFavorite = false
                self.headerView.favorite.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
                return
            }else{
                
                isFavorite = true
                self.headerView.favorite.setImage(UIImage(named: "ic_yishoucang"), forState: UIControlState.Normal)
            }
        }
    }
    
    func favorite(){
        headerView.favorite.userInteractionEnabled = false
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            
            print("收藏商品")
            print(isFavorite)
            let ud = NSUserDefaults.standardUserDefaults()
            var uid = String()
            if ud.objectForKey("userid") != nil {
                uid = ud.objectForKey("userid")as! String
            }
            //            let uid = ud.objectForKey("userid")as! String
            print(uid)
            if isFavorite == false {
                
                shopHelper.favorite(uid, type: "3", goodsid: self.goodsInfo.id!, title: self.goodsInfo.goodsname!, desc: self.goodsInfo.description!) { (success, response) in
                    dispatch_async(dispatch_get_main_queue(), {
                    print(response)
                    let button = self.view.viewWithTag(10)as! UIButton
                    button.setImage(UIImage(named: "ic_yishoucang"), forState: UIControlState.Normal)
                    alert("已收藏", delegate: self)
                    self.headerView.favorite.userInteractionEnabled = true
                    isFavorite = true
                    ud.setObject(isFavorite, forKey: uid)
                    })
                }
            }else{
                
                //取消收藏
                shopHelper.cancelFavoritefunc(uid, type: "3", goodsid: self.goodsInfo.id!, handle: { (success, response) in
                    dispatch_async(dispatch_get_main_queue(), {
                    print(response)
                    let button = self.view.viewWithTag(10)as! UIButton
                    button.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
                    alert("已取消", delegate: self)
                    self.headerView.favorite.userInteractionEnabled = true
                    isFavorite = false
                    ud.setObject(isFavorite, forKey: uid)
                    })
                })
                
            }
            
        }
        //
        
        
    }
    
    func getAddress(){
        
        let location = CLLocation.init(latitude: Double(self.goodsInfo.latitude!)!, longitude: Double(self.goodsInfo.longitude!)!)
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if (error != nil){
                
                alert("您确定还在地球上吗?",delegate: self)
            }
            
            let placemark = placemarks!.last
            print(placemark?.name)
            
            //            for placemark in placemarks!{
            
            //                let dict:NSDictionary = placemark.addressDictionary!
            print(placemark!.administrativeArea)
            print(placemark!.locality)
            print(placemark!.subLocality)
            print(placemark!.thoroughfare)
            if placemark!.thoroughfare == nil{
                //                self.updataAddress = placemark!.locality!+placemark!.subLocality!
            }else{
                //                self.updataAddress = placemark!.locality!+placemark!.subLocality!+placemark!.thoroughfare!
            }
            
            let ud = NSUserDefaults.standardUserDefaults()
            //            ud.setObject(self.updataAddress, forKey: "updataAddress")
            //                let address =
            //            }
        }
        
        
    }
    
    
    func lookPhotos(sender:UIButton)  {
        
        
        
        let myVC = LookPhotoVC()
        myVC.myPhotoArray =  self.photoArr
        myVC.title = "查看图片"
        myVC.count = sender.tag
        print(sender.tag)
        
        self.navigationController?.pushViewController(myVC, animated: true)
        
//        let lookPhotosImageView = UIImageView()
//        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
//        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
//        
//        let image = photoArr[sender.tag]
//        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
//        var myImagess = UIImage()
//        myImagess = UIImage.init(data: data)!
//        lookPhotosImageView.image = myImagess
//        
//        lookPhotosImageView.contentMode = .ScaleAspectFit
//        
//        let myVC = UIViewController()
//        myVC.title = "查看图片"
//        self.navigationController?.navigationBar.hidden = false
//        self.tabBarController?.tabBar.hidden = true
//        myVC.tabBarController?.tabBar.hidden = true
//        myVC.view.addSubview(lookPhotosImageView)
//        self.navigationController?.pushViewController(myVC, animated: true)
        
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
