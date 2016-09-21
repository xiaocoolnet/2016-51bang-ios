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
    private let statuFrame = UIApplication.sharedApplication().statusBarFrame
    private let imageForInsurance = UIImageView.init()
    private let scrollView = UIScrollView.init()
    private let iView = UIImageView()
    private var cameraPic = UIImage()
    let photosArrayOfBack = NSMutableArray()
    var  photoArraySecond = NSMutableArray()
    let photoNameArr = NSMutableArray()
    private let turnBao = UIButton.init(frame: CGRectMake(0, (83 / 750) * WIDTH , (354 / 83) *  ((83 / 750) * WIDTH), 20))
    private let statu = false
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = true
        let userPic = NSUserDefaults.standardUserDefaults()
        if( userPic.objectForKey("photoss") != nil )
        {
            //            setFrameForImage()
            InsureBtn.hidden = true
            scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 64)
            self.iView.hidden = true
            self.Statue.text = "认证中"
            //            print(userPic.objectForKey("photoss"))
            
            photoArraySecond = userPic.objectForKey("photoss") as! NSMutableArray
            
            //            let buttonCount = 0
            
            //            var iii : UIImage = NSKeyedUnarchiver.unarchiveObjectWithData(photoArraySecond[0] as! NSData) as! (UIImage)
            isPushedPhotos = true
            for count in 0...photoArraySecond.count-1 {
                let mybutton = UIButton()
                let a = CGFloat (count%3)
                mybutton.frame = CGRectMake( (WIDTH-20)/3*a+5*(a+1), 170+(WIDTH-20)/3*CGFloat(Int(count/3))+5*CGFloat(count/3), (WIDTH-20)/3, (WIDTH-20)/3)
                mybutton.tag = count
                let myimage : UIImage = NSKeyedUnarchiver.unarchiveObjectWithData(photoArraySecond[count] as! NSData)as! (UIImage)
                mybutton.setBackgroundImage(myimage,forState: UIControlState.Normal)
                mybutton.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.scrollView.addSubview(mybutton)
                
            }
            
            
            //            self.photoArray = (userPic.objectForKey("photoArrayOfPush") as! [ZuberImage] )
            
            return
            
        }else{
            InsureBtn.hidden = false
            scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 270)
        }
        
        Checktoubao()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        setTopView()
        setBtutton()
        setscrollView()
        setButtonOnImage()
        
    }
    
    
    //照片多选代理实现
    //    func passPhotos(selected:[ZuberImage]){
    //
    //
    //    }
    
    func pushPhotoAction(){
        //        print(photoArray.count)
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.1,
                                                       target:self,selector:#selector(self.pushPhotos),
                                                       userInfo:nil,repeats:true)
        
        
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
        let image = self.photoArray[myPhotoCount]
        let dataPhoto:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
        var myImagess = UIImage()
        myImagess = UIImage.init(data: dataPhoto)!
        
        let data = UIImageJPEGRepresentation(myImagess, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr
        //        print(imageName)
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        
        //上传图片
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "http://www.my51bang.com/index.php?g=apps&m=index&a=UpdateUserInsurance&\(id)&a=uploadimg")  { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                
                let result = Http(JSONDecoder(data))
                print(result.status)
                if result.status != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.status! == "success"{
                            self.photoNameArr.addObject(result.data!)
                            self.photoArrayOfPush.addObject(self.photoArray[0])
                            self.photoArray.removeObjectAtIndex(0)
                            
                            self.collectionV?.reloadData()
                            self.myPhotoCount = self.myPhotoCount + 1
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
                
                print("已经认证")
                self.InsureBtn.hidden = true
                self.scrollView.contentSize = CGSizeMake(WIDTH,HEIGHT -  self.statuFrame.height + 10 + 40 + 90)
                self.TopView.backgroundColor = COLOR
                self.Statue.text = "已投保"
            }else{
                
                print("未进行认证")
                
            }
            
        }
        
    }
    
    
    func setscrollView()
    {
        iView.frame = CGRectMake(0, 170 - (statuFrame.height   + 40) + 70, WIDTH, WIDTH * 3068 / 750)
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
        
        
        
        let BackButton = UIButton.init(frame: CGRectMake(5, statuFrame.height + 10, 20,20 ))
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
        Tip.frame = CGRectMake(WIDTH / 2 - 40,20, 80, 30 )
        //+ 70 + 10
        Tip.text = "今日保障状态"
        Tip.textColor = UIColor.whiteColor()
        Tip.adjustsFontSizeToFitWidth  = true
        Tip.textAlignment = NSTextAlignment.Center
        Tip.font = UIFont.systemFontOfSize(15)
        TopView.addSubview(Tip)
        
        
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
        scrollView.addSubview(InsureBtn)
    }
    
    func InsureAction()
    {
        InsureBtn.backgroundColor = UIColor.grayColor()
        TopView.backgroundColor = UIColor.grayColor()
        InsureBtn.hidden = true
        
        scrollView.contentSize = CGSizeMake(WIDTH,HEIGHT -  statuFrame.height + 10 + 40)
        
        cameraAction()
        
    }
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        self.photoArray.removeAllObjects()
        for imagess in photos {
            photoArray.addObject(imagess)
        }
        
        if photoArray.count != 0 {
            self.Statue.text = "准备上传"
            self.InsureBtn.userInteractionEnabled = false
        }
        //        self.setFrameForImage()
        InsureBtn.hidden = true
        scrollView.contentSize = CGSizeMake(WIDTH, iView.frame.size.height + statuFrame.height + 64)
        self.iView.hidden = true
        self.addCollectionViewPicture()
        if photoArray.count>0 {
            
            photoPushButton.frame = CGRectMake(WIDTH/2-40, self.collectionV!.height+WIDTH*210/375+20, 80, 40)
            photoPushButton.backgroundColor = COLOR
            photoPushButton.layer.masksToBounds = true
            photoPushButton.layer.cornerRadius = 5
            photoPushButton.hidden = false
            photoPushButton.setTitle("上传图片", forState: UIControlState.Normal)
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
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 9, delegate:self)
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
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "http://www.my51bang.com/index.php?g=apps&m=index&a=UpdateUserInsurance&\(id)&a=uploadimg") { [unowned self] (data) in
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
