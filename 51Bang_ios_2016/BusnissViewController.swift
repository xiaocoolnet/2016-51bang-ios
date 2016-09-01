//
//  BusnissViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

var isFavorite = Bool()
class BusnissViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    var goodsInfo = GoodsInfo()
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
    override func viewWillAppear(animated: Bool) {
        
        self.view.backgroundColor = RGREY
        self.title="特卖详情"
        self.tabBarController?.tabBar.hidden = true
        //        self.navigationController?.navigationBar.hidden = true
        //        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        createRightNavi()
    }
    
    func orderList(){
        
        let vc = AffirmOrderViewController()
        vc.info = self.goodsInfo
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func click(){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func createRightNavi(){
        
        let rightNaviItem = UIView.init(frame: CGRectMake(0, 0, 60, 30))
        
        let share = UIButton.init(frame: CGRectMake(0, 0, 60, 30))
        share.setTitle("分享", forState: UIControlState.Normal)
        share.addTarget(self, action: #selector(self.share), forControlEvents: UIControlEvents.TouchUpInside)
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
            return 75 + height + 20
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
            let longitude = ud.objectForKey("longitude")as! String
            let latitude = ud.objectForKey("latitude")as! String
            let myLongitude = removeOptionWithString(longitude)
            let myLatitude = removeOptionWithString(latitude)
            let current = CLLocation.init(latitude: CLLocationDegrees(myLatitude)!, longitude: CLLocationDegrees(myLongitude)!)
            if goodsInfo.latitude != "0.0"&&goodsInfo.latitude != "" && goodsInfo.longitude != "0.0"&&goodsInfo.longitude != ""  && goodsInfo.latitude != nil&&goodsInfo.longitude != nil{
                print(goodsInfo.latitude,goodsInfo.longitude,"00000000")
                
                let before = CLLocation.init(latitude: CLLocationDegrees(self.goodsInfo.latitude!)!, longitude: CLLocationDegrees(self.goodsInfo.longitude!)!)
                let meters = current.distanceFromLocation(before)/1000
//                let meter:String = "\(meters)"
//                let array = meter.componentsSeparatedByString(".")
                let distance = String(format:"%.2f",meters)
                print(distance)
                cell.distance.text = "\(distance)km"
                
            }else{
                cell.distance.text = ""
            }
            cell.title.text = self.goodsInfo.address
            cell.title.adjustsFontSizeToFitWidth = true
            cell.selectionStyle = .None
            return cell
            
        }else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2")as!EditTableViewCell2
            cell.title.text = "我的发布"
            cell.selectionStyle = .None
            let view = UIView.init(frame: CGRectMake(0, 59, WIDTH, 1))
            view.backgroundColor = UIColor.whiteColor()
            cell.addSubview(view)
            
            return cell
        }else if (indexPath.row == 2){
            let cell = UITableViewCell()
            let view1 = UIView.init(frame: CGRectMake(0, 60, WIDTH, 10))
            view1.backgroundColor = RGREY
            view1.userInteractionEnabled = false
            cell.addSubview(view1)
            
            let labelcomment = UILabel.init(frame: CGRectMake(20, 75, 60, 40))
            labelcomment.text = "评价"
            labelcomment.userInteractionEnabled = true
            cell.addSubview(labelcomment)
            
            return cell
        }
        else{
            //            let cell = CommentListCell.init()
            //            let contenLabel = UILabel.init(frame: CGRectMake(0, cell.userImage.height, WIDTH, 100))
            //            contenLabel.text = "  位置很好，离我们单位特别近，不过就是等了一会时间，不过还好啦，因为披萨确实特别特别好吃，肉超级多..."
            //            //            contenLabel.adjustsFontSizeToFitWidth = true
            //            contenLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            //            contenLabel.numberOfLines = 0
            //            cell.addSubview(contenLabel)
            //
            //            cell.userName.text = "小小鱼"
            //
            //            let image1 = UIImageView()
            //            image1.frame = CGRectMake(5, cell.userImage.height+contenLabel.height, (WIDTH-20)/3, (WIDTH-20)/3)
            //            image1.image = UIImage(named: "01")
            //            cell.addSubview(image1)
            //            let image2 = UIImageView()
            //            image2.frame = CGRectMake(10+(WIDTH-20)/3, cell.userImage.height+contenLabel.height, (WIDTH-20)/3, (WIDTH-20)/3)
            //            image2.image = UIImage(named: "02")
            //            cell.addSubview(image2)
            //            let image3 = UIImageView()
            //            image3.frame = CGRectMake(15+2*(WIDTH-20)/3, cell.userImage.height+contenLabel.height, (WIDTH-20)/3, (WIDTH-20)/3)
            //            image3.image = UIImage(named: "03")
            //            cell.addSubview(image3)
            //            photoArr.addObject(image1.image!)
            //            photoArr.addObject(image2.image!)
            //            photoArr.addObject(image3.image!)
            //            for count in 0...photoArr.count-1 {
            //                let mybutton = UIButton()
            //                let a = CGFloat (count%3)
            //                mybutton.frame = CGRectMake( (WIDTH-20)/3*a+5*(a+1), cell.userImage.height+contenLabel.height, (WIDTH-20)/3, (WIDTH-20)/3)
            //                mybutton.tag = count
            //                mybutton.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //                cell.addSubview(mybutton)
            //
            //            }
//            if(dataSource?.count>0){
//                let cell = shopCommentTableViewCell.init(goodsInfo: dataSource![indexPath.row-3], num: indexPath.row-3)
//                return cell
//            }else{
//                let cell = UITableViewCell()
//                cell.backgroundColor = UIColor.clearColor()
//                return cell
//            }
            
            if self.dataSource?.count>0 {
                let cell = ConveniceCell.init(myinfo: self.dataSource![indexPath.row-3] )
                print(self.dataSource![indexPath.row-3].add_time)
                print(self.dataSource![indexPath.row-3].id)
                print(self.dataSource![indexPath.row-3].content)
                print(self.dataSource![indexPath.row-3].name)
                print(self.dataSource![indexPath.row-3].userid)
                print(self.dataSource![indexPath.row-3].photo)
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
        self.dataSource = self.goodsInfo.commentlist
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
        
        let scrollView = UIScrollView.init(frame:CGRectMake(0, 0, WIDTH, 200))
        scrollView.backgroundColor = UIColor.clearColor()
        //
        if goodsInfo.pic.count > 0  {
            for num in 0...goodsInfo.pic.count-1{
                let headerPhotoView = UIImageView()
                headerPhotoView.frame = CGRectMake(CGFloat(num) * WIDTH, 0, WIDTH, 200)
                headerPhotoView.setImageWithURL(NSURL.init(string:Bang_Image_Header+goodsInfo.pic[num].pictureurl!), placeholderImage: UIImage.init(named: "01"))
                scrollView.addSubview(headerPhotoView)
                
            }
            
        }else{
            let headerPhotoView1 = UIImageView()
            headerPhotoView1.frame = CGRectMake(0, 0, WIDTH, 200)
            headerPhotoView1.image = UIImage(named: "01")
            scrollView.addSubview(headerPhotoView1)
        }
        scrollView.contentSize = CGSizeMake(WIDTH * CGFloat (goodsInfo.pic.count) , 200)
        scrollView.contentOffset = CGPoint(x: 0,y: 0)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        headerView.addSubview(scrollView)
        
        
        
        //        headerView.headerImage.setImageWithURL(NSURL.init(string:Bang_Image_Header+arrayphoto[1])!, placeholderImage: UIImage.init(named: "01"))
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*360/375)
        headerView.price.text = "¥"+goodsInfo.price!
        headerView.desciption.text = goodsInfo.description
        headerView.desciption.adjustsFontSizeToFitWidth = true
        if goodsInfo.description == "" {
            headerView.desciption.removeFromSuperview()
            headerView.frame.size.height = 250
            
        }else{
            let height = calculateHeight(goodsInfo.description!, size: 15, width:WIDTH-16)
            print(height)
            headerView.desciption.frame.size.height = height+10
            headerView.frame.size.height = WIDTH*350/375
        }
        
        
        headerView.favorite.addTarget(self, action: #selector(self.favorite), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.favorite.tag = 10
        print(isFavorite)
        if loginSign == 1 {
            
            let ud = NSUserDefaults.standardUserDefaults()
            let uid = ud.objectForKey("userid")as! String
            let shoucang = ud.objectForKey(uid)
            print(shoucang)
            if shoucang == nil {
                print("sdf")
            }
            if shoucang != nil && shoucang as! Bool == true {
                headerView.favorite.setImage(UIImage(named: "ic_yishoucang"), forState: UIControlState.Normal)
                isFavorite = true
            }else{
                headerView.favorite.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
                isFavorite = false
            }
            //
        }else{
            headerView.favorite.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
            
        }
        
        
        
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
        footView?.price.text = "¥"+goodsInfo.price!
        //        myTableView.tableFooterView = footView
        //        myTableView.tableFooterView?.frame.size.height = WIDTH*50/375
        footView?.frame = CGRectMake(0, HEIGHT-WIDTH*50/375 - 64, WIDTH, WIDTH*50/375)
        self.view.addSubview(myTableView)
        self.view.addSubview(footView!)
        // Do any additional setup after loading the view.
    }
    
    func call(){
        let url1 = NSURL(string: "tel://"+goodsInfo.phone!)
        UIApplication.sharedApplication().openURL(url1!)
        
    }
    
    
    func myfabu(){
        
        let vc = MenuViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 1)
        {
            self.myfabu()
        }
    }
    
    
    //MARK:分享
    func share(){
        
        let backView = UIView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        backView.backgroundColor = UIColor.grayColor()
        backView.alpha = 0.8
        backView.tag = 100
        let shareView = UIView.init(frame: CGRectMake(0, HEIGHT-WIDTH*150/375-64-100,WIDTH , WIDTH*150/375+100))
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.tag = 101
        let margin:CGFloat = (WIDTH-CGFloat(2) * WIDTH*80/375)/(CGFloat(5)+1);
        for i in 0..<4 {
            let row:Int = i / 2;//行号
            //1/3=0,2/3=0,3/3=1;
            let loc:Int = i % 2;//列号
            let appviewx:CGFloat = margin+(margin+WIDTH/CGFloat(2))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+WIDTH*40/375+30) * CGFloat(row)
            
            let button = UIButton.init(frame: CGRectMake(appviewx+5, appviewy, WIDTH*70/375, WIDTH*70/375))
            
            button.tag = i
            button.addTarget(self, action: #selector(self.goToShare(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.setImage(UIImage(named: self.buttonImageArr[i]), forState: UIControlState.Normal)
            let title = UILabel.init(frame: CGRectMake(appviewx+5, 5+WIDTH*70/375+appviewy, WIDTH*70/375, 30))
            title.textAlignment = .Center
            title.font = UIFont.systemFontOfSize(14)
            title.text = nameArr[i]
            shareView.addSubview(button)
            shareView.addSubview(title)
        }
        let cancle = UIButton.init(frame: CGRectMake(0, WIDTH*150/375-50+100, WIDTH, 50))
        cancle.setTitle("取消", forState: UIControlState.Normal)
        cancle.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        cancle.addTarget(self, action: #selector(self.cancle), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        shareView.addSubview(cancle)
        self.view.addSubview(backView)
        self.view.addSubview(shareView)
        
    }
    
    func cancle(){
        
        let backView = self.view.viewWithTag(100)
        let shareView = self.view.viewWithTag(101)
        backView?.removeFromSuperview()
        shareView?.removeFromSuperview()
        
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
            }else if btn.tag == 2{
                let message = APMediaMessage()
                let webObj = APShareWebObject()
                //            let textObj = APShareTextObject()
                webObj.wepageUrl = "http://bang.xiaocool.net/index.php?g=portal&m=article&a=index&id=7";
                
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
                webObj.wepageUrl = "http://bang.xiaocool.net/index.php?g=portal&m=article&a=index&id=7";
                
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
        
    }
    
    
    
    //MARK:收藏
    func favorite(){
        
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            
            print("收藏商品")
            print(isFavorite)
            let ud = NSUserDefaults.standardUserDefaults()
            let uid = ud.objectForKey("userid")as! String
            print(uid)
            if isFavorite == false {
                
                shopHelper.favorite(uid, type: "3", goodsid: self.goodsInfo.id!, title: self.goodsInfo.goodsname!, desc: self.goodsInfo.description!) { (success, response) in
                    
                    print(response)
                    let button = self.view.viewWithTag(10)as! UIButton
                    button.setImage(UIImage(named: "ic_yishoucang"), forState: UIControlState.Normal)
                    isFavorite = true
                    ud.setObject(isFavorite, forKey: uid)
                }
            }else{
                
                //取消收藏
                shopHelper.cancelFavoritefunc(uid, type: "3", goodsid: self.goodsInfo.id!, handle: { (success, response) in
                    print(response)
                    let button = self.view.viewWithTag(10)as! UIButton
                    button.setImage(UIImage(named: "ic_weishoucang"), forState: UIControlState.Normal)
                    isFavorite = false
                    ud.setObject(isFavorite, forKey: uid)
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
        
        let lookPhotosImageView = UIImageView()
        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        
        let image = photoArr[sender.tag]
        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
        var myImagess = UIImage()
        myImagess = UIImage.init(data: data)!
        lookPhotosImageView.image = myImagess
        
        lookPhotosImageView.contentMode = .ScaleAspectFit
        
        let myVC = UIViewController()
        myVC.title = "查看图片"
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        myVC.tabBarController?.tabBar.hidden = true
        myVC.view.addSubview(lookPhotosImageView)
        self.navigationController?.pushViewController(myVC, animated: true)
        
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
