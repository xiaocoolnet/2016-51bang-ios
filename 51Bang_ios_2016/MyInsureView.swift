//
//  MyInsure.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class MyInsure: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate{
    private let Nav = UIView()
    var timer:NSTimer!
    var isPushedPhotos = Bool()
    var photoArrayOfPush:NSMutableArray = []
    var myPhotoData = NSData()
    var myPhotoCount = NSInteger()
    let photoPushButton = UIButton()
    var photoArray:NSMutableArray = []
    var isnotSHANCHU = Bool()
    var collectionV:UICollectionView?
    private let Statue = UILabel()
    private let TopView = UIView()
    private let InsureBtn = UIButton()
    private let aboutTextView = UITextView()
    private let statuFrame = UIApplication.sharedApplication().statusBarFrame
    private let imageForInsurance = UIImageView.init()
    private let scrollView = UIScrollView.init()
    private let iView = UIImageView()
    private var cameraPic = UIImage()
    let photosArrayOfBack = NSMutableArray()
    var  photoArraySecond = NSMutableArray()
    let photoNameArr = NSMutableArray()
    let mainHelper = MainHelper()
    var Tip1 = UILabel()
    
    var pickerView:UIPickerView!
    var datePicker:UIDatePicker!
    var isShow = Bool()
    let coverView = UIView()
    let formatter = NSDateFormatter()
    var expirydate = ""
    var time = String()
    var label1 = UILabel()
    var view1 = UIView()
    private let turnBao = UIButton.init(frame: CGRectMake(0, (83 / 750) * WIDTH , (354 / 83) *  ((83 / 750) * WIDTH), 20))
    private let statu = false
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        
        photoPushButton.userInteractionEnabled = true
        scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 64+50+100)
//        let userPic = NSUserDefaults.standardUserDefaults()
//        if( userPic.objectForKey("photoss") != nil )
//        {
            //            setFrameForImage()
//            InsureBtn.hidden = true
//            scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 64)
//            self.iView.hidden = true
//            self.Statue.text = "认证中"
//            //            print(userPic.objectForKey("photoss"))
//            

//            photoArraySecond = userPic.objectForKey("photoss") as! NSMutableArray
//            
//            //            let buttonCount = 0
//            
//            //            var iii : UIImage = NSKeyedUnarchiver.unarchiveObjectWithData(photoArraySecond[0] as! NSData) as! (UIImage)
//            isPushedPhotos = true
//            for count in 0...photoArraySecond.count-1 {
//                let mybutton = UIButton()
//                let a = CGFloat (count%3)
//                mybutton.frame = CGRectMake( (WIDTH-20)/3*a+5*(a+1), 170+(WIDTH-20)/3*CGFloat(Int(count/3))+5*CGFloat(count/3), (WIDTH-20)/3, (WIDTH-20)/3)
//                mybutton.tag = count
//                let myimage : UIImage = NSKeyedUnarchiver.unarchiveObjectWithData(photoArraySecond[count] as! NSData)as! (UIImage)
//                mybutton.setBackgroundImage(myimage,forState: UIControlState.Normal)
//                mybutton.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//                self.scrollView.addSubview(mybutton)
            
//            }
            
            
            //            self.photoArray = (userPic.objectForKey("photoArrayOfPush") as! [ZuberImage] )
            
//            return
//            
//        }else{
//            InsureBtn.hidden = false
//            scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 270)
//        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        setTopView()
        setBtutton()
        setscrollView()
        setButtonOnImage()
        Checktoubao()
        view1.hidden = false
        
    }
    
    func createSaveTime(){
        view1 = UIView.init(frame: CGRectMake(0, self.collectionV!.height+WIDTH*210/375+20, WIDTH, 60))
        view1.backgroundColor = UIColor.whiteColor()
        view1.hidden = false
        self.scrollView.addSubview(view1)
        let label = UILabel.init(frame: CGRectMake(10, 10 , 80, 40))
        label.text = "有效期至:"
        view1.addSubview(label)
        label1 = UILabel.init(frame: CGRectMake(90, 10, WIDTH-90, 40))
        label1.text = "请选择认证有效时间!"
        view1.addSubview(label1)
        let button = UIButton.init(frame: CGRectMake(0, 0, WIDTH, 60))
        button.addTarget(self, action: #selector(self.chooseDate), forControlEvents: UIControlEvents.TouchUpInside)
        view1.addSubview(button)
    }
    func chooseDate(){
        if isShow == false {
            coverView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            //            let view = UIView()
            let view2 = UIView()
            view2.tag = 51
            view2.frame = CGRectMake(0, HEIGHT-290, WIDTH, 290)
            view2.backgroundColor = UIColor.whiteColor()
            let label = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 30))
            label.text = "选择有效时间"
            label.textAlignment = .Center
            //            pickerView=UIDatePicker()
            datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.tag = 101
            datePicker.minimumDate = NSDate()
            datePicker.frame = CGRectMake(0, 30, WIDTH, 180)
            //            datePicker.backgroundColor = UIColor.redColor()
            datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(self.dateChanged(_:)),
                                 forControlEvents: UIControlEvents.ValueChanged)
            
            let button1 = UIButton.init(frame: CGRectMake(0, datePicker.frame.size.height+datePicker.frame.origin.y, WIDTH/2, 50))
            let button2 = UIButton.init(frame: CGRectMake(WIDTH/2, datePicker.frame.size.height+datePicker.frame.origin.y, WIDTH/2, 50))
            button1.setTitle("取消", forState: UIControlState.Normal)
            //            button1.backgroundColor = UIColor.greenColor()
            button1.tintColor = UIColor.blackColor()
            button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button1.tag = 201
            button1.addTarget(self, action: #selector(self.click1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button2.setTitle("确定", forState: UIControlState.Normal)
            //            button2.backgroundColor = UIColor.greenColor()
            button2.tintColor = UIColor.blackColor()
            button2.addTarget(self, action: #selector(self.click1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button2.tag = 202
            view2.addSubview(label)
            view2.addSubview(datePicker)
            view2.addSubview(button1)
            view2.addSubview(button2)
            //            coverView.addSubview(view)
            
            self.view.addSubview(coverView)
            self.view.addSubview(view2)
            isShow = true
        }else{
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(51)
            view!.removeFromSuperview()
            //            coverView.frame = CGRectMake(0, 0, 0, 0)
            isShow = false
        }
        
        
    }

    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        //        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print(formatter.stringFromDate(datePicker.date))
    }

    func click1(btn:UIButton){
        
        
        if btn.tag == 201{
            print("取消")
            
            //            pickerView.removeFromSuperview()
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(51)
            view!.removeFromSuperview()
            isShow = false
        }else if btn.tag == 202{
            let datestr = formatter.stringFromDate(datePicker.date)
            //            datePicker.minimumDate = datestr
            
            //            print(datePicker.date)
            
            let formatter2 = NSDateFormatter()
            formatter2.dateFormat = "yyyyMMdd"
            let dateStr = formatter2.stringFromDate(datePicker.date)
            let date222 = formatter2.dateFromString(dateStr)
            let dates = date222!.timeIntervalSince1970
            self.time = datestr
            self.expirydate = String(dates)
            print(self.expirydate)
//            let button = self.view.viewWithTag(12)as! UIButton
//            button.setTitle(datestr, forState: UIControlState.Normal)
            
            let formatter3 = NSDateFormatter()
            formatter3.dateFormat = "yyyy年MM月dd日"
            let dateStr1 = formatter3.stringFromDate(datePicker.date)
            label1.text = dateStr1
            print("---")
            print(datestr)
            print("---")
            //            datePicker.removeFromSuperview()
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(51)
            view!.removeFromSuperview()
            isShow = false

        }
        
        
        
        
    }

    //照片多选代理实现
    //    func passPhotos(selected:[ZuberImage]){
    //
    //
    //    }
    
    func pushPhotoAction(){
        if photoArray.count != 3 {
            alert("仔细阅读图片上传要求", delegate: self)
            return
        }
        //        print(photoArray.count)
        photoPushButton.userInteractionEnabled = false
        if label1.text == "请选择认证有效时间!" {
            photoPushButton.userInteractionEnabled = true
            alert("请选择有效时间", delegate: self)
        }else{
            
        self.pushPhotos()
        }
        
    }
    
    func pushPhotos(){
        if self.photoArray.count == 0{
            self.photoPushButton.removeFromSuperview()
            let myPhotosPush = NSUserDefaults.standardUserDefaults()
            
            let photoss = NSMutableArray()
            for myimages in photoArrayOfPush {
                
                //                let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
                //                let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                //                                                         length: Int(representation.size()), error: nil)
                //                let data:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
                let image = myimages
                let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
                var myImagess = UIImage()
                myImagess = UIImage.init(data: data)!
                
                photoss.addObject(NSKeyedArchiver.archivedDataWithRootObject(myImagess))
            }
            
            myPhotosPush.setObject(photoss, forKey: "photoss")
            timer.invalidate()
            isPushedPhotos = true
            photoArray = photoArrayOfPush
            //            print(photoArray)
            self.collectionV?.reloadData()
            self.addCollectionViewPicture()
            return
        }
        myPhotoCount = 0
        
        
        //        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
        //        let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
        //                                                 length: Int(representation.size()), error: nil)
        //        let dataPhoto:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
        
        for image in self.photoArray {
            let dataPhoto:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
            var myImagess = UIImage()
            myImagess = UIImage.init(data: dataPhoto)!
            
            let data = UIImageJPEGRepresentation(myImagess, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr + String(arc4random()%1000)
            //        print(imageName)
            //        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
            
            //上传图片
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg")  { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    print(result.status)
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                self.photoNameArr.addObject(result.data!)
                                //                            self.photoArrayOfPush.addObject(self.photoArray[0])
                                //                            self.photoArray.removeObjectAtIndex(0)
                                if self.photoNameArr.count == 3{
                                    self.shangchuan()
                                }
                                
                                
                                self.collectionV?.reloadData()
                                //                            self.myPhotoCount = self.myPhotoCount + 1
                                self.addCollectionViewPicture()
                                
                            }else{
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "图片上传失败"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 1)
                            }
                        })
                    }
                })
            }

        }
//        let image = self.photoArray[0]
        
    }
    
    
    func shangchuan(){
        let user = NSUserDefaults.standardUserDefaults()
        let userid = user.objectForKey("userid") as! String
        
        print(expirydate)
        mainHelper.UpdateUserInsurance(userid, photoArray: self.photoNameArr, expirydate: expirydate) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success{
                alert("上传失败", delegate: self)
                return
            }
            alert("上传成功,等待认证", delegate: self)
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            self.Statue.text = "认证中"
            self.TopView.backgroundColor = COLOR
            self.photoPushButton.hidden = true
            self.view1.hidden = true
            })
        }
    }
    
    func addCollectionViewPicture(){
        
        let flowl = UICollectionViewFlowLayout.init()
        //设置每一个item大小
        flowl.itemSize = CGSizeMake((WIDTH-60)/3, (WIDTH-60)/3)
        flowl.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        flowl.minimumInteritemSpacing = 10
        flowl.minimumLineSpacing = 10
        //        print(self.photoArray.count)
        var height =  CGFloat(((self.photoArray.count-1)/3))*((WIDTH-60)/3+10)+((WIDTH-60)/3+10)
        if self.photoArray.count == 0 {
            height = 0
        }
        //创建集合视图
        self.collectionV?.removeFromSuperview()
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 200, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        //        collectionV?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        collectionV!.registerNib(UINib(nibName: "PhotoCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
        //        collectionV?.backgroundColor = UIColor.redColor()//测试用
        self.scrollView.addSubview(collectionV!)
        
        //        let myButton = UIButton()
        //        myButton.frame = CGRectMake(WIDTH/2-80, collectionV!.height*1.5+(collectionV?.centerY)!+20, 160, 40)
        //        myButton.layer.masksToBounds = true
        //        myButton.layer.cornerRadius = 8
        //        myButton.setTitle("确认提交", forState: UIControlState.Normal)
        //        myButton.backgroundColor = COLOR
        //        self.scrollView.addSubview(myButton)
        //        myButton.addTarget(self, action: #selector(self.pushPhotos), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    //    func pushPhotos()  {
    //        self.isnotSHANCHU = true
    //        self.collectionV?.reloadData()
    //        for myImages in photoArray {
    //            let data = UIImageJPEGRepresentation(UIImage(CGImage:myImages.asset.aspectRatioThumbnail().takeUnretainedValue()), 0.1)!
    //            let dateFormatter = NSDateFormatter()
    //            dateFormatter.dateFormat = "yyyyMMddHHmmss"
    //            let dateStr = dateFormatter.stringFromDate(NSDate())
    //            let imageName = "avatar" + dateStr
    //            let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
    //            //上传图片
    //            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "http://www.my51bang.com/index.php?g=apps&m=index&a=UpdateUserInsurance&\(id)&a=uploadimg") { [unowned self] (data) in
    //                dispatch_async(dispatch_get_main_queue(), {
    //
    //                    let result = Http(JSONDecoder(data))
    //                    if result.status != nil {
    //                        dispatch_async(dispatch_get_main_queue(), {
    //                            if result.status! == "success"{
    //                                    print("图片上传成功")
    //                                self.photoNameArr.addObject(result.data!)
    //                                self.photosArrayOfBack.addObject(UIImage(CGImage:myImages.asset.aspectRatioThumbnail().takeUnretainedValue()))
    //
    //                                let photoData = NSUserDefaults.standardUserDefaults()
    //
    //                                    photoData.setObject(self.photosArrayOfBack, forKey: "baophotos")
    //
    //
    //                            }else{
    //                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    //                                hud.mode = MBProgressHUDMode.Text;
    //                                hud.labelText = "图片上传失败"
    //                                hud.margin = 10.0
    //                                hud.removeFromSuperViewOnHide = true
    //                                hud.hide(true, afterDelay: 1)
    //                            }
    //                        })
    //                    }
    //                })
    //            }
    //
    //        }
    //
    //    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.photoArray.count)
        if self.photoArray.count == 0 {
            return 0
        }else{
            
            return photoArray.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath)as! PhotoCollectionViewCell
        //        print(self.photoArray[indexPath.item] as? UIImage)
        cell.button.tag = indexPath.item
        cell.button.setBackgroundImage (self.photoArray[indexPath.item] as! UIImage, forState: UIControlState.Normal)
        cell.button.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //            (self.photoArray[indexPath.item].asset.aspectRatioThumbnail().takeUnretainedValue(), forState: UIControlState.Normal)
        
        let button = UIButton.init(frame: CGRectMake(cell.frame.size.width-18, 0, 20, 20))
        button.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(self.deleteImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        if isPushedPhotos {
            
        }else{
            cell.addSubview(button)
        }
        
        
        return cell
    }
    
    func deleteImage(btn:UIButton){
        print(btn.tag)
        photoPushButton.userInteractionEnabled = true
        self.photoArray.removeObjectAtIndex(btn.tag)
        self.collectionV?.reloadData()
        if self.photoArray.count%3 == 0&&self.photoArray.count>1  {
            //            UIView.animateWithDuration(0.2, animations: {
            self.collectionV?.height = (self.collectionV?.height)! - (WIDTH-60)/3
            
        }
        if self.photoArray.count == 0 {
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            //            self.addCollectionViewPicture()
            self.InsureBtn.hidden = false
            self.InsureBtn.backgroundColor = COLOR
            self.InsureBtn.userInteractionEnabled = true
            self.photoPushButton.hidden = true
            self.view1.hidden = true
            self.aboutTextView.hidden = false
        }
        
    }
    
    func lookPhotos(sender:UIButton)  {
        
        let lookPhotosImageView = UIImageView()
        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        if isPushedPhotos{
            
            let myimage : UIImage = NSKeyedUnarchiver.unarchiveObjectWithData(photoArraySecond[sender.tag] as! NSData)as! (UIImage)
            lookPhotosImageView.image = myimage
        }else{
            
            //            let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
            //            let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
            //                                                     length: Int(representation.size()), error: nil)
            //            let data:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
            let image = photoArray[sender.tag]
            let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
            var myImagess = UIImage()
            myImagess = UIImage.init(data: data)!
            lookPhotosImageView.image = myImagess
        }
        
        
        lookPhotosImageView.contentMode = .ScaleAspectFit
        //        let singleTap1 = UITapGestureRecognizer()
        //        singleTap1.addTarget(self, action: #selector(self.backMyView))
        //        lookPhotosImageView.addGestureRecognizer(singleTap1)
        let myVC = UIViewController()
        myVC.title = "查看图片"
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        myVC.tabBarController?.tabBar.hidden = true
        myVC.view.addSubview(lookPhotosImageView)
        self.navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    func Checktoubao()
    {
        
        let checkUrl = Bang_URL_Header + "CheckInsurance"
        if( NSUserDefaults.standardUserDefaults().objectForKey("userid") == nil)
        {
            return
        }
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        let param = ["userid":id]
        
        Alamofire.request(.GET, checkUrl, parameters: param ).response{
            request, response , json , error in
            
            let result = Http(JSONDecoder(json!))
            
            if result.status == "success"{
                if result.data == "0"{
                    self.Statue.text = "未认证或认证失败"
                    self.Statue.adjustsFontSizeToFitWidth = true
                    self.TopView.backgroundColor = UIColor.grayColor()
                    self.Tip1.hidden = false
                    self.InsureBtn.hidden = false
                    self.InsureBtn.backgroundColor = COLOR
                    self.scrollView.contentSize = CGSizeMake(WIDTH, self.iView.frame.size.height + self.statuFrame.height + 270+50+100)
                    self.scrollView.hidden = false
                    self.aboutTextView.hidden = false
                }else if result.data == "-1"{
                    self.InsureBtn.hidden = true
                    self.TopView.backgroundColor = COLOR
                    self.Statue.text = "认证中"
                    self.Tip1.hidden = true
                    self.iView.hidden = true
                    self.scrollView.contentSize = CGSizeMake(WIDTH,HEIGHT -  self.statuFrame.height + 10 + 40 + 90+100)
                    self.InsureBtn.hidden = true
                    self.aboutTextView.hidden = true
                }else{
                    self.Statue.text = "已投保"
                    self.TopView.backgroundColor = COLOR
                    self.Tip1.hidden = true
                    self.iView.hidden = true
                    self.scrollView.contentSize = CGSizeMake(WIDTH,HEIGHT -  self.statuFrame.height + 10 + 40 + 90+100)
                    self.InsureBtn.hidden = true
                    self.aboutTextView.hidden = true
                }
              
            }else{
                
                self.Statue.text = "未认证或认证失败"
                self.Statue.adjustsFontSizeToFitWidth = true
                self.TopView.backgroundColor = UIColor.grayColor()
                self.Tip1.hidden = false
                self.InsureBtn.hidden = false
                self.InsureBtn.backgroundColor = COLOR
                self.scrollView.contentSize = CGSizeMake(WIDTH, self.iView.frame.size.height + self.statuFrame.height + 270+50+100)
                self.scrollView.hidden = false
                
            }
            
        }
        
    }
    
    
    func setscrollView()
    {
        iView.frame = CGRectMake(0, 170 - (statuFrame.height   + 40) + 70+100, WIDTH, WIDTH * 3068 / 750)
        iView.image = UIImage.init(named: "weitoubao")
        scrollView.addSubview(iView)
        scrollView.frame = CGRectMake(0, statuFrame.height + 40, WIDTH, HEIGHT - (statuFrame.height + 40 ) )
        scrollView.backgroundColor = RGREY
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.directionalLockEnabled = false
        
        scrollView.scrollsToTop = true
        scrollView.backgroundColor = UIColor(red: 247 / 255.0, green: 247 / 255.0, blue: 249 / 255.0, alpha: 1.0)
        
        self.view.addSubview(scrollView)
        
        
        Nav.frame = CGRectMake(0, 0, WIDTH, statuFrame.height + 40)
        self.view.addSubview(Nav)
        Nav.backgroundColor = COLOR
        
        
        
        let TitileLabel = UILabel()
        TitileLabel.text = "服务保障"
        TitileLabel.frame = CGRectMake(WIDTH / 2 - 50, statuFrame.height + 10 , 100, 30)
        TitileLabel.textColor = UIColor.whiteColor()
        TitileLabel.adjustsFontSizeToFitWidth = true
        TitileLabel.textAlignment = NSTextAlignment.Center
        Nav.addSubview(TitileLabel)
        
    }
    
    
    
    func setTopView()
    {
        
        TopView.frame = CGRectMake(0, -statuFrame.height, WIDTH, 170 - 40 )
        TopView.backgroundColor = UIColor.grayColor()
        scrollView.addSubview(TopView)
        
        
        
        let BackButton = UIButton.init(frame: CGRectMake(5, statuFrame.height + 10, 40,40 ))
        BackButton.setImage(UIImage.init(named: "ic_fanhui-left"), forState: UIControlState.Normal)
        BackButton.setImage(UIImage.init(named: "ic_fanhui-left"), forState: UIControlState.Selected)
        BackButton.addTarget(self, action: #selector(self.backAction), forControlEvents: UIControlEvents.TouchUpInside)
        Nav.addSubview(BackButton)
        
        
        
        
        Statue.frame = CGRectMake( WIDTH / 2 - 70 , 60, 140, 60)
        Statue.text = "未投保"
        Statue.textColor = UIColor.whiteColor()
        Statue.textAlignment = NSTextAlignment.Center
        Statue.font = UIFont.systemFontOfSize(32)
        TopView.addSubview(Statue)
        
        
        let Tip = UILabel()
        Tip.frame = CGRectMake(WIDTH / 2 - 40,30, 80, 30 )
        //+ 70 + 10
        Tip.text = "今日保障状态"
        Tip.textColor = UIColor.whiteColor()
        Tip.adjustsFontSizeToFitWidth  = true
        Tip.textAlignment = NSTextAlignment.Center
        Tip.font = UIFont.systemFontOfSize(15)
        TopView.addSubview(Tip)
        
        Tip1 = UILabel()
        Tip1.frame = CGRectMake(WIDTH / 2 - 40,10, 80, 30 )
        Tip1.text = "先投保后抢单"
        Tip1.hidden = false
        Tip1.textColor = UIColor.whiteColor()
        Tip1.adjustsFontSizeToFitWidth  = true
        Tip1.textAlignment = NSTextAlignment.Center
        Tip1.font = UIFont.systemFontOfSize(15)
        TopView.addSubview(Tip1)
        
    }
    
    
    func backAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setBtutton()
    {
        InsureBtn.frame = CGRectMake(10, 170 - (statuFrame.height   + 40) + 10, WIDTH - 20, 40)
        InsureBtn.setTitle("支付宝投保凭证或已有投保凭证图片上传", forState: UIControlState.Normal)
        InsureBtn.backgroundColor = COLOR
        InsureBtn.hidden = false
        InsureBtn.setTitleShadowColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        InsureBtn.addTarget(self, action: #selector(self.InsureAction), forControlEvents: UIControlEvents.TouchUpInside)
        InsureBtn.layer.masksToBounds = true
        InsureBtn.layer.cornerRadius = 10
        
        aboutTextView.frame = CGRectMake(10, 170 - (statuFrame.height   + 40) + 10+self.InsureBtn.frame.height+10, WIDTH - 20, 80)
        aboutTextView.backgroundColor = RGREY
        aboutTextView.textAlignment = .Center
        aboutTextView.text = "***请上传包括手持身份证，身份证正面，投保凭证3张图片，谢谢合作！"
        aboutTextView.layer.masksToBounds = true
        aboutTextView.layer.cornerRadius = 10
        aboutTextView.font = UIFont.systemFontOfSize(16)
        aboutTextView.userInteractionEnabled = false
        aboutTextView.textColor = UIColor.redColor()
//        aboutTextView.
        
        scrollView.addSubview(aboutTextView)
        scrollView.addSubview(InsureBtn)
    }
    
    func InsureAction()
    {
//        InsureBtn.backgroundColor = UIColor.grayColor()
        TopView.backgroundColor = UIColor.grayColor()
//        InsureBtn.hidden = true
        
        scrollView.contentSize = CGSizeMake(WIDTH,HEIGHT -  statuFrame.height + 10 + 40+100)
        
        cameraAction()
        
    }
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        self.photoNameArr.removeAllObjects()
        self.photoArray.removeAllObjects()
        for imagess in photos {
            photoArray.addObject(imagess)
        }
        
        if photoArray.count == 3 {
            self.Statue.text = "准备上传"
            self.InsureBtn.userInteractionEnabled = false
            self.aboutTextView.hidden = true
        }else{
            alert("仔细阅读图片上传要求", delegate: self)
            return
        }
        //        self.setFrameForImage()
//        InsureBtn.hidden = true
        scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 64+100)
        self.iView.hidden = true
        self.addCollectionViewPicture()
        if photoArray.count>0 {
            self.createSaveTime()
            photoPushButton.frame = CGRectMake(WIDTH/2-40, self.collectionV!.height+WIDTH*210/375+20+150, 80, 40)
            photoPushButton.backgroundColor = COLOR
            photoPushButton.layer.masksToBounds = true
            photoPushButton.layer.cornerRadius = 5
            photoPushButton.hidden = false
            photoPushButton.setTitle("上传", forState: UIControlState.Normal)
            photoPushButton.addTarget(self, action: #selector(self.pushPhotoAction), forControlEvents: UIControlEvents.TouchUpInside)
            //            self.headerView.addSubview(photoPushButton)
            //            self.headerView.height = self.collectionV!.height+WIDTH*210/375+80
            //            self.myTableViw.tableHeaderView = self.headerView
            self.scrollView.addSubview(photoPushButton)
        }
        
        self.addCollectionViewPicture()
        
        
    }
    
    
    func cameraAction()
    {
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 3, delegate:self)
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
        //        let VC1 = ViewController1()
        ////        self.tabBarController?.tabBar.hidden = true
        //        VC1.photoDelegate = self
        //        self.presentViewController(VC1, animated: true, completion: nil)
        ////        self.tabBarController?.tabBar.hidden = false
        ////        let picker = UIImagePickerController()
        ////        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        ////        picker.delegate = self
        ////        picker.allowsEditing = true
        ////        presentViewController(picker, animated: true, completion: nil)
    }
    
    func setButtonOnImage()
    {
        
        turnBao.addTarget(self, action: #selector(self.turnBaoAction), forControlEvents: UIControlEvents.TouchUpInside)
        iView.userInteractionEnabled = true
        iView.addSubview(turnBao)
    }
    //354/83
    func turnBaoAction()
    {
        let urlScheme = "alipay://"
        let customUrl = NSURL.init(string: urlScheme)
//        UIApplication.sharedApplication().openURL(customUrl!)
        if(UIApplication.sharedApplication().canOpenURL(customUrl!))
        {
            UIApplication.sharedApplication().openURL(customUrl!)
        }else{
            UIApplication.sharedApplication().openURL(NSURL.init(string:"http://www.alipay.com")!)
//            alert("未安装支付宝", delegate: self)
        }
    }
    
    
    
    
    //MARK: -- UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        cameraPic = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        //        self.photoArray.addObject(cameraPic)
        let cameraData = NSUserDefaults.standardUserDefaults()
        
        
        let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr
        
        cameraData.setObject(data, forKey: "baophoto" )
        cameraData.synchronize()
        iView.image = cameraPic
        
        setFrameForImage()
        picker.dismissViewControllerAnimated(true, completion: nil)
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        
        //        上传图片
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_Open_Header+"index.php?g=apps&m=index&a=UpdateUserInsurance&\(id)&a=uploadimg") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.status! == "success"{
                            self.photoNameArr.addObject(result.data!)
                            print("图片上传成功")
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "图片上传失败"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                    })
                }
            })
            
        }
    }
    
    
    
    func setFrameForImage()
    {
        turnBao.hidden = true
        iView.frame = CGRectMake( 40, InsureBtn.frame.origin.y, WIDTH-80, WIDTH - 80)
        
    }
    
    
}
