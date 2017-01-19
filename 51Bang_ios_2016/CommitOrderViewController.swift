//
//  CommitOrderViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/1.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class CommitOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,BMKGeoCodeSearchDelegate,skillProrocol,TZImagePickerControllerDelegate,AVAudioRecorderDelegate {
    
    var infosss = Array<ClistInfo>()
    
    
    var timer1:NSTimer!
    var timer2:NSTimer!
    var deletebutton = UIButton()
    let boFangButton = UIButton()
    let backMHView = UIView()
    var LuYinButton = UIButton()
    var recordUrl = NSURL()
    var mp3FilePath = NSURL()
    var audioFileSavePath = NSURL()
    var audioSession = AVAudioSession()
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var recordTime = Int()
    var countTime = Int()
    
    var timeLabel = UILabel()
    
    let recordSetting = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 2),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.High.rawValue)),//音频质量
//        AVLinearPCMBitDepthKey: NSNumber(int: 2)
    ]

    
    var hud1 = MBProgressHUD()
    let formatter = NSDateFormatter()
    var timer:NSTimer!
    var myPhotoCount = NSInteger()
    let photoPushButton = UIButton()
    let mainHelper = MainHelper()
    let skillHelper = RushHelper()
    var dataSource = Array<SkillModel>()
    var myLongitude = CLLocationDegrees()
    var myLatitude = CLLocationDegrees()
    //定位管理者
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var cityName = String()
    var ViewTag = Int()
    //var tempLongtide
    var longitude = ""
    var latitude =  ""
    var slongitude = ""
    var slatitude =  ""
    var address = ""
    var saddress =  ""
    var price =  ""
    var expirydate = ""
    var type = ""
    var sound = ""
    var isShow = Bool()
    let coverView = UIView()
    let myTableView = TPKeyboardAvoidingTableView()
    var pickerView:UIPickerView!
    var datePicker:UIDatePicker!
    let totalloc:Int = 4
    var taskTitle = String()
    var taskDescription = String()
    var salar = String()
    var time = String()
    var photoArray:NSMutableArray = []
    var collectionV:UICollectionView?
    let photoNameArr = NSMutableArray()
    let jiNengID = NSMutableArray()
    let array = ["跑腿","维修","家政","车辆","兼职","代办","宠物","丽人","婚恋","其他"]
    let array1 = ["按小时计费","按天计费","按月计费","按趟计费","按件计费","按重量计费"]
//    var address = String()
    let headerView = UIView()
    var shangMenLocation = String()
    var FuWuLocation = String()
    var phone = UITextField()
    var salary = UITextField()
    var shangmen = UITextView()
    var location = UITextView()
    var selectArr = NSMutableArray()
    var sign = Int()
    var mysalary:String = ""
    //code by zcq :ServiceDistance
    var distance:String = ""
    var mypaotui:String = ""
    var label = UILabel()
    var distanceLabel = UILabel()
    var skillNum = Int()
    var selectedIndex = Int()
    var a = Int()
    var isRecord = false
    
    
    
    var keyBordHeight:CGFloat = 0
    var willShowLocationCell = LocationTableViewCell()
    var willShowLocationCell1 = LocationTableViewCell()
    var markCell = UITableViewCell.init()
    static var FirstLocation = CLLocation.init()
    static var SecondLocation = CLLocation.init()
    static var firstString = MainViewController.BMKname
    static var secondstring = MainViewController.BMKname
    var searcher = BMKGeoCodeSearch.init()
    var geoCodeSearchOption = BMKGeoCodeSearchOption.init()
    var useGeoTag = 1
    var BMKdistance = CLLocationDistance.init()
    var reloadTag = 0
    static var ReturnTagForView = 0
    var firstTag = 0
    var secondTag = 0
    let textView = PlaceholderTextView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "帮我"
        self.view.backgroundColor = RGREY
        print(self.cityName)
        print(self.latitude)
        print(self.longitude)
        self.GetData()
        self.createTableView()
        self.createTableViewHeaderView()
        location.delegate = self
        shangmen.delegate = self
        distanceLabel.text = "距离 " + "0.1Km"
        distanceLabel.textAlignment = NSTextAlignment.Center
        shangmen.text = MainViewController.BMKname
        location.text = MainViewController.BMKname
        
    }
    
    
    func setback()
    {
        
        //let leftitem  = UINavigationItem.init()
        let barbuttonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = barbuttonItem
    }
    
    func backAction()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    
    override func viewWillAppear(animated: Bool) {
        
        print(CommitOrderViewController.firstString)
        print(CommitOrderViewController.FirstLocation)
        
        if self.ViewTag == 1 {
            self.address = CommitOrderViewController.firstString
            self.latitude = String(CommitOrderViewController.FirstLocation.coordinate.latitude)
            self.longitude = String(CommitOrderViewController.FirstLocation.coordinate.longitude)
        }else{
            self.saddress = CommitOrderViewController.secondstring
            self.slatitude = String(CommitOrderViewController.SecondLocation.coordinate.latitude)
            self.slongitude = String(CommitOrderViewController.SecondLocation.coordinate.longitude)
        }
        
        print(CommitOrderViewController.SecondLocation)
        print(CommitOrderViewController.secondstring)
        
        print(self.ViewTag)
        myTableView.reloadData()
        super.viewWillAppear(true)
        searcher.delegate = self
        
        firstTag = 0
        secondTag = 0
        self.tabBarController?.tabBar.hidden = true
        setback()
        if self.latitude as String == "0" || self.longitude as String == "0" || self.slatitude as String == "0" || self.slongitude as String == "0" || self.latitude as String == "" || self.longitude as String == "" || self.slatitude as String == "" || self.slongitude as String == ""{
            
        }else{
            let dic = ["latitude":self.latitude,"longitude":self.longitude,"slatitude":self.slatitude,"slongitude":self.slongitude]
            print(dic)
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.calculDistence(_:)), name: UIKeyboardDidHideNotification, object: dic)
            calculDistence(dic)
        }
        
//             calculDistence(notification:NSNotification)
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = false
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        firstTag = 0
        secondTag = 0
        searcher.delegate = nil
        self.audioPlayer = nil
//        self.audioSession = nil
        self.audioRecorder = nil
    }
    
    //照片多选代理实现
//    func passPhotos(selected:[ZuberImage]){
//        photoArray = selected
//        print(selected)
//        self.addCollectionViewPicture()
//        photoArray = selected
//        print(selected)
//        self.addCollectionViewPicture()
//        if selected.count>0 {
//            
//            photoPushButton.frame = CGRectMake(WIDTH/2-40, self.collectionV!.height+350+20, 80, 40)
//            photoPushButton.backgroundColor = COLOR
//            photoPushButton.layer.masksToBounds = true
//            photoPushButton.layer.cornerRadius = 5
//            photoPushButton.setTitle("上传图片", forState: UIControlState.Normal)
//            photoPushButton.addTarget(self, action: #selector(self.pushPhotoAction), forControlEvents: UIControlEvents.TouchUpInside)
//            self.headerView.addSubview(photoPushButton)
//            self.headerView.height = self.collectionV!.height+350+80
//            self.myTableView.tableHeaderView = self.headerView
//        }
//
//    }
    
    func pushPhotoAction(){
        print(photoArray.count)
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.2,
                                                       target:self,selector:#selector(self.pushPhotos),
                                                       userInfo:nil,repeats:true)
        
        
    }
    
    func pushPhotos(){
        if self.photoArray.count == 0{
            self.photoPushButton.removeFromSuperview()
            timer.invalidate()
            return
        }
        myPhotoCount = 0
        
//        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
//        let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
//                                                 length: Int(representation.size()), error: nil)
//        let dataPhoto:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
        
    }

    
    
    func textViewDidEndEditing(textView: UITextView) {
        self.taskTitle = textView.text!
        
        UIView.animateWithDuration(0.4, animations: {
            self.myTableView.frame.origin.y = 0
            print("编辑完成")
            if(textView.tag == 1)
            {
                self.firstTag = 1
            }else if( textView.tag == 2 ){
            
                self.secondTag = 1
            
            }
            
        })
    }
    
    
       //Return 键盘关闭
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        phone.resignFirstResponder()
        salary.resignFirstResponder()
        
        return true
    }
    
    
    
    //MARK:请求数据
    func GetData(){
        
        let hud = MBProgressHUD.showHUDAddedTo(self.myTableView, animated: true)
        hud.animationType = .Zoom

        hud.labelText = "正在努力加载"

        skillHelper.getSkillList({[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                hud.hide(true)
//                print(response)
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
                //                print(self.dataSource)
//                print(self.dataSource.count)
                self.createTableViewHeaderView()

            })
            })
    }
    
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        myTableView.backgroundColor = RGREY
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textField")
        myTableView.registerNib(UINib(nibName: "IdentityTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName: "PhoneTableViewCell",bundle: nil), forCellReuseIdentifier: "phone")
        myTableView.registerNib(UINib(nibName: "LocationTableViewCell",bundle: nil), forCellReuseIdentifier: "location")
        myTableView.registerNib(UINib(nibName: "SalaryTableViewCell",bundle: nil), forCellReuseIdentifier: "salary")
        myTableView.registerNib(UINib(nibName: "DeadlineTableViewCell",bundle: nil), forCellReuseIdentifier: "data")
//        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, <#T##height: CGFloat##CGFloat#>))
        
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 150))
        distanceLabel.frame = CGRectMake(0, 0, WIDTH, 40)
        bottom.addSubview(distanceLabel)
        
        self.label.frame = CGRectMake(0, 50,WIDTH, 50)
        label.tag == 56
//        //计算距离
//        if self.myLongitude != 0 && self.myLatitude != 0 {
//            let currentLocation = CLLocation(latitude: myLatitude, longitude: myLongitude)
//            let targetLocation = CLLocation(latitude: 52.105526, longitude: 51.141151)
//            let distance:CLLocationDistance = currentLocation.distanceFromLocation(targetLocation)
//            label.text = "服务距离："+String(distance);
//        }
        if self.mysalary != ""{
            let salary = Int(self.mysalary)!
            label.text = "服务费"+"￥"+String(salary)
            setAttributText(label.text!, Lable: label)

        }else{
            //label.text = "服务费"
            setAttributText("服务费", Lable: label)
        }
        
        
        
        
        
        label.textAlignment = .Center
//        bottom.backgroundColor = UIColor.redColor()
        let btn = UIButton(frame: CGRectMake(15, 100, WIDTH-30, 50))
        btn.layer.cornerRadius = 8
        btn.setTitle("提交订单", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        bottom.addSubview(label)
        bottom.addSubview(btn)
        myTableView.tableFooterView = bottom
        
        self.view.addSubview(myTableView)
        
        self.view.addSubview(myTableView)
    }

    
    func setAttributText(Text:String,Lable:UILabel)
    {
        let str = NSMutableAttributedString.init(string: Text)
        str.addAttribute(NSForegroundColorAttributeName, value: COLOR, range: NSRange.init(location: 0, length: 3))
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSRange.init(location: 3, length: str.length - 3 ))
        Lable.attributedText = str
    }
    //MARK:提交订单
    func nextToView(){
        
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
//        let userid = ud.objectForKey("userid") as! String
    
        if(willShowLocationCell.textView.text.characters.count == 0 || willShowLocationCell1.textView.text.characters.count == 0||self.price == ""||self.price == "0")
        {
            let alertController = UIAlertController.init(title: "请填充完整内容", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: {
                void in
            })
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: { Void in
            })
            return
            
        }
        hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud1.animationType = .Zoom
        hud1.labelText = "正在努力加载"
        
        if Double(self.price) == nil{
            alert("请填写正确格式的价格", delegate: self)
            self.hud1.hide(true)
            return
        }
        if self.photoArray.count == 0 &&  mp3FilePath.absoluteString == ""{
            self.fabuAction()
            return
        }
        isRecord = false
        if mp3FilePath.absoluteString == "" {
            isRecord = true
        }
        
        
       
        a = 0
        
        if mp3FilePath.absoluteString != "" {

            
            let data = NSData.init(contentsOfFile: self.mp3FilePath.path!)

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "record" + dateStr + userid

            ConnectModel.uploadWithVideoName(imageName, imageData: data, URL: Bang_URL_Header+"uploadRecord", url:self.mp3FilePath,finish: { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    print(result.status)
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                self.isRecord = true
                                self.sound = result.data!
                                if self.a == self.photoArray.count||self.photoArray.count == 0{
                                    self.fabuAction()
                                }
                                
                            }else{
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "上传语音失败"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 1)
                                self.hud1.hide(true)
                            }
                        })
                    }
                })
                })
        }
        
        self.upImage()
        
        
//        for ima in photoArray {
//            
//            let image = ima
//            let dataPhoto:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
//            
//            var myImagess = UIImage()
//            myImagess = UIImage.init(data: dataPhoto)!
//            
//            let data = UIImageJPEGRepresentation(myImagess, 0.1)!
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyyMMddHHmmss"
//            let dateStr = dateFormatter.stringFromDate(NSDate())
//            let imageName = "taskavatar" + dateStr + userid + String(arc4random())
//            print(imageName)
//            self.photoNameArr.addObject(imageName+".png")
//            //上传图片
//            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    let result = Http(JSONDecoder(data))
//                    print(result.status)
//                    if result.status != nil {
//                        dispatch_async(dispatch_get_main_queue(), {
//                            if result.status! == "success"{
////                                self.photoNameArr.addObject(result.data!)
////                                print(a)
//                                print(self.photoArray.count)
//                                 a = a+1
//                                if a == self.photoArray.count && isRecord == true{
//                                    self.fabuAction()
//                                }
//                               
//
//                            }else{
//                                self.photoNameArr.removeLastObject()
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                                hud.mode = MBProgressHUDMode.Text;
//                                //                            hud.labelText = "图片上传失败"
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
//                                hud.hide(true, afterDelay: 1)
//                                self.hud1.hide(true)
//                            }
//                        })
//                    }
//                })
//            }
//        }
        
        


        
        
        //需要登录
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
                print(self.time)
            let address = ud.objectForKey("shangMenLocation")as!String
            print(address)
            
            
           
        }
   
    }
    
    func upImage(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
        userid = ud.objectForKey("userid")as! String
        
        let dataPhoto:NSData = UIImageJPEGRepresentation(self.photoArray[a] as! UIImage, 1.0)!
        
        var myImagess = UIImage()
        myImagess = UIImage.init(data: dataPhoto)!
        
        let data = UIImageJPEGRepresentation(myImagess, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "taskavatar" + dateStr + userid + String(arc4random())
        print(imageName)
//        self.photoNameArr.addObject(imageName+".png")
        //上传图片
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                
                let result = Http(JSONDecoder(data))
                print(result.status)
                if result.status != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.status! == "success"{
                            self.photoNameArr.addObject(result.data!)
                            //                                print(a)
                            print(self.photoArray.count)
                            self.a = self.a+1
                            if self.a == self.photoArray.count && self.isRecord == true{
                                self.fabuAction()
                            }else{
                                self.upImage()
                            }
                            
                            
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            //                            hud.labelText = "图片上传失败"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                            self.hud1.hide(true)
                        }
                    })
                }
            })
        }
    }
    }
    
    
    
    //上传任务
    func fabuAction(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        let strrr = NSMutableString()
        print(self.jiNengID)
        for i in 0..<self.jiNengID.count{
            if i == jiNengID.count-1{
                strrr.appendString(jiNengID[i] as! String)
            }else{
                strrr.appendString(jiNengID[i] as! String)
                strrr.appendString(",")
            }
        }
        self.type = strrr as String
        
        
//        let userid = ud.objectForKey("userid") as! String
        if self.expirydate == "" {
            alert("请填写有效期", delegate: self)
            self.hud1.hide(true)
            return
        }
        if self.type == "" {
            alert("请选择服务类型", delegate: self)
            self.hud1.hide(true)
            return

        }
        
        
        if self.photoNameArr.count > 0{
            for index in 0...self.photoNameArr.count-1 {
                if index>8 {
                    self.photoNameArr.removeObjectAtIndex(index)
                }
            }
        }

        
        
        mainHelper.upLoadOrder(userid, title: self.taskTitle, description: self.taskDescription, address:address , longitude: longitude, latitude: latitude, saddress:saddress,slongitude: slongitude, slatitude: slatitude, expirydate: expirydate, price: price, type: type, sound: self.sound, picurl: self.photoNameArr,soundtime:String(self.countTime), handle: { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if !success{
                self.hud1.hide(true)
                alert("任务提交失败", delegate: self)
                return
            }
            print(response!)
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(response!, forKey: "ordernumber")
//            print("上传合同")
            self.hud1.hide(true)
            
            let vc = PayViewController()
            vc.isRenwu = true
            vc.numForGoodS = response! as! String
//            if self.salary == "" {
//                vc.price = 0
//            }else{
//                vc.price = Double(self.salary)!
//            }
            vc.price = Double(self.price)!
            vc.body = self.taskDescription
            self.navigationController?.pushViewController(vc, animated: true)
            
////            let vc = UploadContractViewController()
//            vc.numofGoods = response! as! String
//            vc.price = self.price
//            vc.goodName = self.taskTitle
//            self.navigationController?.pushViewController(vc, animated: true)
            })
        })

        
    }
    
    
    
    //MARK: 创建头视图
    func createTableViewHeaderView(){
        print(self.dataSource.count)
        let startMargin = (WIDTH - 4 * (WIDTH*80/375) ) / 5
            
         headerView.frame = CGRectMake(0, 0, WIDTH, 250)
//        view.backgroundColor = UIColor.grayColor()
        let myTableViwWidth = self.myTableView.frame.size.width
        let margin:CGFloat = (myTableViwWidth-CGFloat(self.totalloc) * WIDTH*95/375)/(CGFloat(self.totalloc)+1);
        print(margin)
        for i in 0..<self.dataSource.count{
            let row:Int = i / totalloc;//行号
            //1/3=0,2/3=0,3/3=1;
            let loc:Int = i % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+myTableViwWidth/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+WIDTH*40/375) * CGFloat(row)
            let btn = UIButton()
            btn.tag = i+500
            btn.addTarget(self, action: #selector(self.onCLick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            btn.backgroundColor = UIColor.redColor()
            
            btn.frame = CGRectMake(appviewx + startMargin, appviewy+10, WIDTH*80/375, WIDTH*30/375)
            btn.layer.cornerRadius = WIDTH*10/375
            btn.layer.borderWidth = 1
            btn.layer.borderColor = COLOR.CGColor
            btn.setTitleColor(COLOR, forState: UIControlState.Normal)
            
            let label = UILabel.init(frame: CGRectMake(0, 0, btn.frame.width, btn.frame.height))
            let model = self.dataSource[i]
            label.text = model.name
//            label.text = array[i]
            label.textColor = COLOR
            label.textAlignment = .Center
            btn.addSubview(label)
            headerView.addSubview(btn)
            
        }
        textView.frame = CGRectMake(0, WIDTH*165/375, WIDTH, 180)
        textView.tag = 45
        textView.backgroundColor = UIColor.whiteColor()
        textView.delegate = self
        textView.textAlignment = .Left
        textView.editable = true
        textView.layer.cornerRadius = 4.0
        //        textView.layer.borderColor = kTextBorderColor.CGColor
        textView.layer.borderWidth = 0
        textView.placeholder = "禁止发布二维码、黄、赌、毒，违反国家法律的言论及图片，所有信息均用户提供，真假需自辩"
        let button = UIButton.init(frame: CGRectMake(20, textView.frame.size.height-40, 30, 30))
        button.layer.borderColor = UIColor.grayColor().CGColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setImage(UIImage(named: "ic_tupian"), forState: UIControlState.Normal)
        let yinPin = UIButton.init(frame: CGRectMake(80, textView.frame.size.height-40, 30, 30))
        yinPin.setImage(UIImage(named: "ic_yinpin"), forState: UIControlState.Normal)
        
        let shiPin = UIButton.init(frame: CGRectMake(140, textView.frame.size.height-40, 30, 30))
        yinPin.layer.borderColor = UIColor.grayColor().CGColor
        yinPin.layer.borderWidth = 1.0
        yinPin.layer.cornerRadius = 15
        yinPin.layer.masksToBounds = true
        shiPin.setImage(UIImage(named: "ic_shipin"), forState: UIControlState.Normal)
        //        let gesture = UITapGestureRecognizer(target: self, action: "viewTap:")
        //附加识别器到视图
        //        button.addGestureRecognizer(gesture)
        button.addTarget(self, action: #selector(self.goToCamera1(_:)), forControlEvents: .TouchUpInside)
        textView.addSubview(button)
        textView.addSubview(yinPin)//语音录制按钮
        yinPin.addTarget(self, action: #selector(self.startRecord), forControlEvents: .TouchUpInside)
//        textView.addSubview(shiPin)
        let bottomView = UIView.init(frame: CGRectMake(0, textView.frame.size.height+textView.frame.origin.y, WIDTH, 10))
        bottomView.backgroundColor = RGREY
        
        headerView.addSubview(textView)
        headerView.addSubview(bottomView)
        headerView.frame.size.height = WIDTH*180/375+WIDTH*180/375+10
        
//        view.backgroundColor = UIColor.redColor()
        self.myTableView.tableHeaderView = headerView
       
    }
    
    func startRecord(){
        
        self.backMHView.frame = CGRectMake(0, 0, WIDTH, self.view.bounds.height+64)
        self.backMHView.backgroundColor = UIColor.grayColor()
        self.backMHView.alpha = 0.8
        
        LuYinButton = UIButton.init(type: UIButtonType.RoundedRect)
        LuYinButton.frame = CGRectMake((WIDTH-80)/2, (HEIGHT-80)/2, 80, 80)
        LuYinButton.layer.masksToBounds = true
        LuYinButton.layer.cornerRadius = 40
        //        LuYinButton.setImage(UIImage(named: "ic_luyin"), forState: UIControlState.Normal)
        LuYinButton.backgroundColor = UIColor.whiteColor()
        LuYinButton.setBackgroundImage(UIImage(named: "ic_luyin"), forState: UIControlState.Normal)
//        LuYinButton.addTarget(self, action: #selector(self.overRecord), forControlEvents: UIControlEvents.TouchUpInside)
        backMHView.addSubview(LuYinButton)
        
        let longPressGR = UILongPressGestureRecognizer()
        longPressGR.addTarget(self, action: #selector(self.startRecordAndGetIn(_:)))
        longPressGR.minimumPressDuration = 0.3
        LuYinButton.addGestureRecognizer(longPressGR)
        timeLabel.frame = CGRectMake((WIDTH-150)/2, 200, 150, 30)
        timeLabel.backgroundColor = UIColor.whiteColor()
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 10
        timeLabel.textAlignment = .Center
        timeLabel.text = "长按录音"
//        timeLabel.layer.borderColor = UIColor.blackColor().CGColor
//        timeLabel.layer.borderWidth = 1
        timeLabel.textColor = COLOR
        self.backMHView.addSubview(timeLabel)
        
        self.view.addSubview(self.backMHView)
        
        self.addCollectionViewPicture()
        
        
    }
    func overRecord(){
        
        mp3FilePath = NSURL.init(string: NSTemporaryDirectory().stringByAppendingString("myselfRecord.mp3"))!
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.mp3FilePath = NSURL.init(string: AudioWrapper.audioPCMtoMP3(self.recordUrl.absoluteString, self.mp3FilePath.absoluteString))!
            
        }
        audioFileSavePath = mp3FilePath;
        //        let alert2 = UIAlertView.init(title: "mp3转化成功！", message: nil, delegate: self, cancelButtonTitle: "确定")
        //        alert2.show()
        self.backMHView.removeFromSuperview()
        
//        var buttonFloat = CGFloat()
//        if self.recordTime<7 {
//            buttonFloat = 90
//        }else if(self.recordTime>Int(WIDTH-80)/15){
//            buttonFloat = WIDTH-80
//        }else{
//            buttonFloat = CGFloat(self.recordTime*15)
//        }
        boFangButton.removeFromSuperview()
        boFangButton.frame = CGRectMake(20, collectionV!.height+350+20,114 , 30)
        
        boFangButton.backgroundColor = UIColor.clearColor()
        boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
        boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        boFangButton.addTarget(self, action: #selector(self.boFangButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        boFangButton.setBackgroundImage(UIImage(named: "ic_yinpinbeijing"), forState: UIControlState.Normal)
        boFangButton.layer.masksToBounds = true
//        boFangButton.layer.borderWidth = 1
//        boFangButton.layer.borderColor = GREY.CGColor
        boFangButton.layer.cornerRadius = 10
        boFangButton.layer.shadowColor = UIColor.blackColor().CGColor
        boFangButton.layer.shadowOffset = CGSizeMake(20.0, 20.0)
        boFangButton.layer.shadowOpacity = 0.7
        deletebutton = UIButton.init(frame: CGRectMake(boFangButton.frame.size.width-20, 0, 20, 20))
        deletebutton.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
        deletebutton.addTarget(self, action: #selector(self.deleteTimeButton), forControlEvents: UIControlEvents.TouchUpInside)
        boFangButton.addSubview(deletebutton)
        self.headerView.addSubview(boFangButton)
        self.headerView.height = collectionV!.height+350+70
        self.myTableView.tableHeaderView = self.headerView
        self.timeLabel.text = ""
        
        
    }
    
    func deleteTimeButton(){
        self.boFangButton.removeFromSuperview()
        self.mp3FilePath = NSURL.init(string: "")!
        self.addCollectionViewPicture()
    }
    
    
    func startRecordAndGetIn(gestureRecognizer:UILongPressGestureRecognizer){
        audioSession = AVAudioSession.sharedInstance()
        if gestureRecognizer.state == .Began {
            
            do{
                recordUrl = NSURL.init(string: NSTemporaryDirectory().stringByAppendingString("selfRecord.caf"))!
                try audioRecorder = AVAudioRecorder.init(URL: recordUrl, settings: recordSetting)
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioSession.setActive(true)
                audioRecorder!.prepareToRecord()
                audioRecorder!.peakPowerForChannel(0)
                audioRecorder!.record()
            }catch{
                
            }
            audioRecorder!.meteringEnabled = true
            audioRecorder!.delegate = self
            recordTime = 0
            self.recordTimeStart()
        }else if(gestureRecognizer.state == .Ended){
            if self.recordTime<=0{
                let alert2 = UIAlertView.init(title: "录音时间太短", message: nil, delegate: self, cancelButtonTitle: "确定")
                alert2.show()
                timer1.invalidate()
                return
            }
            
            do{
                if audioRecorder?.recording == true{
                    audioRecorder!.stop()
                }else{
                    audioPlayer?.stop()
                }
                
                try audioSession.setActive(false)
                
            }catch{
                
            }
            self.countTime = self.recordTime
            timer1.invalidate()
            self.overRecord()
        }
        
        
        
    }
    
    func boFangButtonAction(){
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1,
                                                        target:self,selector:#selector(self.boFangButtonActionrecordTimeTick),
                                                        userInfo:nil,repeats:true)
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
            if (mp3FilePath.absoluteString != "") {
                try self.audioPlayer = AVAudioPlayer.init(contentsOfURL: self.mp3FilePath)
            }
            
//            if (recordUrl.absoluteString != "") {
//                try self.audioPlayer = AVAudioPlayer.init(contentsOfURL: self.recordUrl)
//            }
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 1;
            audioPlayer!.play()
        }catch{
            
        }
        
    }
    
    func recordTimeStart(){
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1,
                                                        target:self,selector:#selector(self.recordTimeTick),
                                                        userInfo:nil,repeats:true)
    }
    
    func boFangButtonActionrecordTimeTick(){
        recordTime -= 1
        if recordTime<0{
            timer2.invalidate()
            recordTime = self.countTime
        }
        
        boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
        
    }
    
    func recordTimeTick(){
        recordTime += 1
        boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
        
        timeLabel.text = "已经录制"+String(recordTime)+"秒"
        
        
    }

    
    
    //MARK:点击头视图  跳转分项页
    func onCLick(btn:UIButton){
//        
//        if selectArr.count == 0{
////            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
//            btn.backgroundColor = COLOR
////            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//            let label =  btn.subviews[0]as! UILabel
//            label.textColor = UIColor.whiteColor()
//            selectArr.addObject(btn)
//            //            self.payMode = cell.title.text!
//            print(selectArr)
//        }else{
//            print(selectArr.count)
//            if !selectArr.containsObject(btn){
//                btn.backgroundColor = COLOR
////                btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//                let label =  btn.subviews[0]as! UILabel
//                label.textColor = UIColor.whiteColor()
////                btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
//                selectArr.addObject(btn)
//                //                    self.payMode = cell.title.text!
//                print(selectArr)
//            }else{
////                btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
//                btn.backgroundColor = RGREY
////                btn.setTitleColor(COLOR, forState: UIControlState.Normal)
//                let label =  btn.subviews[0]as! UILabel
//                label.textColor = COLOR
//                selectArr.removeObject(btn)
//                print(selectArr)
//            }
//        }

        let vc = SkillSubitemViewController()
        vc.isBangwo = true
        let model = self.dataSource[btn.tag-500]
        infosss = model.clist
        vc.jinengID = self.jiNengID
        print(model.name)
        vc.mytitle = model.name
        vc.info = infosss
        vc.index = btn.tag-500
        vc.delegate = self
        self.selectedIndex = btn.tag
        self.presentViewController(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        self.photoArray.removeAllObjects()
        self.photoNameArr.removeAllObjects()
        for imagess in photos {
            photoArray.addObject(imagess)
        }
        self.addCollectionViewPicture()
        
        if self.mp3FilePath.absoluteString != ""{
            boFangButton.removeFromSuperview()
            boFangButton.frame = CGRectMake(20, collectionV!.height+350+20,114 , 30)
            
            boFangButton.backgroundColor = UIColor.clearColor()
            boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
            boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            boFangButton.addTarget(self, action: #selector(self.boFangButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            boFangButton.setBackgroundImage(UIImage(named: "ic_yinpinbeijing"), forState: UIControlState.Normal)
            boFangButton.layer.masksToBounds = true
            //        boFangButton.layer.borderWidth = 1
            //        boFangButton.layer.borderColor = GREY.CGColor
            boFangButton.layer.cornerRadius = 10
            boFangButton.layer.shadowColor = UIColor.blackColor().CGColor
            boFangButton.layer.shadowOffset = CGSizeMake(20.0, 20.0)
            boFangButton.layer.shadowOpacity = 0.7
            deletebutton = UIButton.init(frame: CGRectMake(boFangButton.frame.size.width-20, 0, 20, 20))
            deletebutton.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
            deletebutton.addTarget(self, action: #selector(self.deleteTimeButton), forControlEvents: UIControlEvents.TouchUpInside)
            boFangButton.addSubview(deletebutton)
            self.headerView.addSubview(boFangButton)
            self.headerView.height = collectionV!.height+350+70
            self.myTableView.tableHeaderView = self.headerView
            self.timeLabel.text = ""
        }
        
        
    }

    
    //MARK:打开相机
    func goToCamera1(btn:UIButton){
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 9, delegate:self)
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
//        let VC1 =  ViewController1()
//        VC1.photoDelegate = self
//        self.presentViewController(VC1, animated: true, completion: nil)
//        print("上传图片")
//        print(btn.tag)
//        let imagePicker = UIImagePickerController();
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
////        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //上传图片的协议与代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        let image = info[UIImagePickerControllerEditedImage]as! UIImage
//        self.photoArray.addObject(image)
        print(self.photoArray)
        self.addCollectionViewPicture()
        let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr
        
        //上传图片
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.status! == "success"{
                            self.photoNameArr.addObject(result.data!)
                            
                        }else{
                        }
                    })
                }
            })
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK:创建CollectionView
    func addCollectionViewPicture(){
        
        let flowl = UICollectionViewFlowLayout.init()
        //设置每一个item大小
        flowl.itemSize = CGSizeMake((WIDTH-60)/3, (WIDTH-60)/3)
        flowl.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        flowl.minimumInteritemSpacing = 10
        flowl.minimumLineSpacing = 10
        print(self.photoArray.count)
        var height =  CGFloat(((self.photoArray.count-1)/3))*((WIDTH-60)/3+10)+((WIDTH-60)/3+10)
        if self.photoArray.count == 0 {
            height = 0
        }
        //创建集合视图
        print(headerView.frame.size.height+headerView.frame.origin.y)
        self.collectionV?.removeFromSuperview()
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 350, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        //        collectionV?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        collectionV!.registerNib(UINib(nibName: "PhotoCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
        //        collectionV?.backgroundColor = UIColor.redColor()//测试用
        self.headerView.addSubview(collectionV!)
        self.headerView.frame.size.height = 350+(collectionV?.frame.size.height)!
        self.myTableView.tableHeaderView = self.headerView
        
    }
    
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
        cell.button.setBackgroundImage(self.photoArray[indexPath.item] as? UIImage, forState: UIControlState.Normal)
        cell.button.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let button = UIButton.init(frame: CGRectMake(cell.frame.size.width-18, 0, 20, 20))
        button.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(self.deleteImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(button)
        return cell
    }
    
    
    func lookPhotos(sender:UIButton)  {
        
        
        let myVC = LookPhotoVC()
        myVC.hidesBottomBarWhenPushed = true
        myVC.myPhotoArray =  photoArray
//        print(myPhotoArray)
        myVC.title = "查看图片"
        myVC.count = sender.tag
        self.navigationController?.pushViewController(myVC, animated: true)
        myVC.hidesBottomBarWhenPushed = false
        
        
//        let lookPhotosImageView = UIImageView()
//        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
//        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
//        
////        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
////        let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
////                                                 length: Int(representation.size()), error: nil)
////        let data:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
//        let image = photoArray[sender.tag]
//        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
//        var myImagess = UIImage()
//        myImagess = UIImage.init(data: data)!
//        lookPhotosImageView.image = myImagess
//        
//        lookPhotosImageView.contentMode = .ScaleAspectFit
//        //        let singleTap1 = UITapGestureRecognizer()
//        //        singleTap1.addTarget(self, action: #selector(self.backMyView))
//        //        lookPhotosImageView.addGestureRecognizer(singleTap1)
//        let myVC = UIViewController()
//        myVC.title = "查看图片"
//        myVC.view.addSubview(lookPhotosImageView)
//        self.navigationController?.pushViewController(myVC, animated: true)
        
    }

    
    //删除照片
    func deleteImage(btn:UIButton){
        print(btn.tag)
        self.photoArray.removeObjectAtIndex(btn.tag)
        self.collectionV?.reloadData()
        if self.photoArray.count%3 == 0&&self.photoArray.count>1  {
            //            UIView.animateWithDuration(0.2, animations: {
            self.collectionV?.height = (self.collectionV?.height)! - (WIDTH-60)/3
            self.headerView.frame = CGRectMake(0, 0, WIDTH, (self.headerView.height - (WIDTH-60)/3))
            self.myTableView.tableHeaderView = self.headerView
            //            })
            
        }
        if self.photoArray.count == 0 {
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            self.addCollectionViewPicture()
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorStyle = .None
        let ud = NSUserDefaults.standardUserDefaults()
        var phone = String()
        if ud.objectForKey("phone") != nil {
            phone = ud.objectForKey("phone")as! String
        }
//        let phone = ud.objectForKey("phone")as!String
        print(phone)
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("phone", forIndexPath: indexPath)as! PhoneTableViewCell
            cell.selectionStyle = .None
//            cell.phone.borderStyle = .None
            cell.phone.tag = 100
//            cell.phone.delegate = self
            cell.phone.text = phone
//            self.phone = phone
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("location",forIndexPath: indexPath)as! LocationTableViewCell
            let fugaiButton = UIButton.init(frame: CGRectMake(0, 0, tableView.width-30, 60))
            fugaiButton.tag=0
            cell.addSubview(fugaiButton)
            fugaiButton.addTarget(self, action: #selector(self.dingwei(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            if ud.objectForKey("updataAddress") == nil{
                print(self.address)
            
                self.shangMenLocation = self.address
            willShowLocationCell = cell
            
//            }else{
//                cell.textView.text = ud.objectForKey("updataAddress")as!String
//                self.shangMenLocation = ud.objectForKey("updataAddress")as!String
//            }
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(self.address, forKey: "shangMenLocation")
            
//            cell.textView.borderStyle = .None
            cell.textView.tag = 97
            self.shangmen = cell.textView
            cell.textView.delegate = self
            cell.locationButton.tag = 0
//            cell.desc.text = self.address
            cell.locationButton.addTarget(self, action: #selector(self.dingwei(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.selectionStyle = .None
            cell.textView.tag = 1
//            if(CommitOrderViewController.firstString != cell.textView.text )
//            {
//            print("不同")
//            
//            }else if( CommitOrderViewController.firstString != "" )
//            {
//                cell.textView.text = CommitOrderViewController.firstString
//            }else
//            {
//                
//            cell.textView.text = cell.textView.text
//                
//            }
//            if( CommitOrderViewController.ReturnTag != 2  )
//            {
//                
//                
//            if( CommitOrderViewController.firstString != cell.textView.text && cell.textView.text != MainViewController.BMKname && cell.textView.text.characters.count != 0)
//            {
//                cell.textView.text = cell.textView.text
//            }else{
//            
//                cell.textView.text = MainViewController.BMKname
//            }
//            }else{
//            
//                
//                
//               cell.textView.text = CommitOrderViewController.firstString
//                CommitOrderViewController.ReturnTag = 0
//            
//            }
            
            if( CommitOrderViewController.ReturnTagForView == 0)
            {
                
                cell.textView.text = MainViewController.BMKname
                self.address = MainViewController.BMKname
                self.latitude = String(MainViewController.userLocationForChange.coordinate.latitude)
                self.longitude = String(MainViewController.userLocationForChange.coordinate.longitude)
                
            }else {
                
                if( CommitOrderViewController.ReturnTagForView == 1 && firstTag == 0)
                {
                
                    cell.textView.text = CommitOrderViewController.firstString
                    
                
                }else{
                
                print(cell.textView.text)
                cell.textView.text = cell.textView.text
                    self.address = cell.textView.text
                self.latitude = String(MainViewController.userLocationForChange.coordinate.latitude)
                self.longitude = String(MainViewController.userLocationForChange.coordinate.longitude)
                
                }
                
                
                
                
            }
           
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("location",forIndexPath: indexPath)as! LocationTableViewCell
            cell.title.text = "服务地点"
            let fugaiButton2 = UIButton.init(frame: CGRectMake(0, 0, tableView.width-30, 60))
            fugaiButton2.tag = 1
            cell.addSubview(fugaiButton2)
            fugaiButton2.addTarget(self, action: #selector(self.dingwei(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(self.address, forKey: "FuWuLocation")
           
            self.location = cell.textView
            self.FuWuLocation = MainViewController.BMKname
            cell.textView.delegate = self
//            cell.textField.borderStyle = .None
            cell.textView.tag = 98
//            cell.desc.text = self.address
//            if(CommitOrderViewController.secondstring != cell.textView.text )
//            {}else if( CommitOrderViewController.secondstring != "" )
//            {
//                cell.textView.text = CommitOrderViewController.secondstring
//            }else
//            {
//                cell.textView.text = MainViewController.BMKname
//            }
//            if( CommitOrderViewController.ReturnTag == 0)
//            {
//            if( CommitOrderViewController.secondstring != cell.textView.text && cell.textView.text != MainViewController.BMKname && cell.textView.text.characters.count != 0  )
//            {
//                cell.textView.text = cell.textView.text
//            }else{
//                
//                cell.textView.text = MainViewController.BMKname
//                }}else{
//            
//            
//            
//            
//              cell.textView.text = CommitOrderViewController.secondstring
//                CommitOrderViewController.ReturnTag  = 0
//            
//            }
            cell.textView.tag = 2
            
            if( CommitOrderViewController.ReturnTagForView == 0)
            {
                
                CommitOrderViewController.ReturnTagForView = 2
            
                cell.textView.text = MainViewController.BMKname
                
                self.saddress = MainViewController.BMKname
                self.slatitude = String(MainViewController.userLocationForChange.coordinate.latitude)
                self.slongitude = String(MainViewController.userLocationForChange.coordinate.longitude)
            }else{
            
            
                if( CommitOrderViewController.ReturnTagForView == 1 && secondTag == 0)
                {
                     cell.textView.text = CommitOrderViewController.secondstring
                    
                    
                    
                }else{
                    
                    print(cell.textView.text)
                    
                    cell.textView.text = cell.textView.text
                    self.saddress = cell.textView.text
                    self.slatitude = String(MainViewController.userLocationForChange.coordinate.latitude)
                    self.slongitude = String(MainViewController.userLocationForChange.coordinate.longitude)
                    
                }
                

            
            
            
            }
            cell.locationButton.tag = 1
            cell.locationButton.addTarget(self, action: #selector(self.dingwei(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.icon.image = UIImage(named: "ic_fuwudidian")
            cell.selectionStyle = .None
            willShowLocationCell1 = cell
            return cell
        }else if indexPath.row == 3{
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("salary",forIndexPath: indexPath)as! SalaryTableViewCell
            cell.selectionStyle = .None
            cell.button.addTarget(self, action: #selector(self.chooseMothed), forControlEvents: UIControlEvents.TouchUpInside)
            //建立手势识别器
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.myTap(_:)))
            //附加识别器到视图
            cell.mothed.addGestureRecognizer(gesture)
            self.salary = cell.salary
            cell.mothed.userInteractionEnabled = true
            cell.mothed.tag = 10
            cell.salary.tag = 99
            cell.salary.delegate = self
            self.salar = cell.salary.text!
//            cell.salary.keyboardType = UIKeyboardType.NumberPad
            self.mysalary = cell.salary.text!
            
            cell.selectionStyle = .None
            markCell = cell
            return cell
        }else if indexPath.row == 4{
          
            let cell = tableView.dequeueReusableCellWithIdentifier("data",forIndexPath: indexPath)as! DeadlineTableViewCell
            cell.selectionStyle = .None
            
            cell.timeButton.addTarget(self, action: #selector(self.chooseDate), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.button.addTarget(self, action: #selector(self.chooseDate), forControlEvents: UIControlEvents.TouchUpInside)
            cell.timeButton.tag = 12
            //            cell.time.borderStyle = .None
            self.time = cell.timeButton.currentTitle!
            //            cell.accessoryType = .DisclosureIndicator
            return cell
            
        }else {
           let cell = tableView.dequeueReusableCellWithIdentifier("data",forIndexPath: indexPath)as! DeadlineTableViewCell
            cell.selectionStyle = .None
            return cell
        
        }
    }
    
    
    func pushToNext()
    {
    
    }
    
    //根据用户输入的上门地址和服务地址确定经纬度
    func getAddressWithString(str:String){
        
        
        
        
        
//        let ud = NSUserDefaults.standardUserDefaults()
//        let userid = ud.objectForKey("userid") as! String
//        self.mainHelper.upLoadOrder(userid, title: self.taskTitle, description: self.taskDescription, address: self.cityName, longitude: String(self.myLongitude), latitude: String(self.myLatitude),expirydate:self.time,price:self.salar)
//        { (success, response) in
//            if !success{
//                return
//            }
//            print(response!)
//            let userDefault = NSUserDefaults.standardUserDefaults()
//            userDefault.setObject(response!, forKey: "ordernumber")
//            print("上传合同")
//            let vc = UploadContractViewController()
//            vc.salary = self.mysalary
//            self.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//            self.hidesBottomBarWhenPushed = false
//
//        
//        
//        
//        
//        print(str)
//        self.geocoder.geocodeAddressString(str) { (placemarks,error) in
//            
//            if(placemarks == nil)
//            {
//                return
//                
//            }
//            if (placemarks!.count == 0 || error != nil) {
//                return ;
//            }
//            
//            let placemark = placemarks?.first
//            print(placemark)
//            self.myLongitude = (placemark?.location?.coordinate.longitude)!
//            self.myLatitude = (placemark?.location?.coordinate.latitude)!
//            
//            if self.myLongitude == 0 || self.myLatitude == 0 {
//                return
//            }
//            
//                       }
//            self.createAnnotation(self.myLongitude, longitude: self.myLongitudec)
//        }
        
    }
    

    
    
    
    func viewTap(sender: UITapGestureRecognizer) {
        self.chooseDate()
    }
    func myTap(sender: UITapGestureRecognizer) {
        self.chooseMothed()
    }
    
    func textFieldEditChanged(textField:UITextField)
    
    {
        
//        self.taskTitle = textField.text!
//        self.taskDescription = textField.text!
        //print("textfield text %@",textField.text);
        if textField.tag == 55{
        
            print(textField.text)
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(textField.text, forKey: "paotui")
            
        }else if textField.tag == 99 {
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(textField.text, forKey: "mysalary")
        }
    
    }
    

    
    
//    func textViewDidChange(textView: UITextView) {
//        <#code#>
//    }
//   
    
    func textFieldDidEndEditing(textField: UITextField) {
//        self.taskTitle = textField.text!
//        self.taskDescription = textField.text!
        print(textField.text);
        
        
        
        
        
        
        
        UIView.animateWithDuration(0.4, animations: {
            self.myTableView.frame.origin.y = 0
        })
        if textField.tag == 97 {
            self.shangMenLocation = textField.text!
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(self.shangMenLocation, forKey: "shangMenLocation")
            ud.synchronize()
            print(self.shangMenLocation)
            
        }else if textField.tag == 98{
        
            self.FuWuLocation = textField.text!
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(self.FuWuLocation, forKey: "FuWuLocation")
            ud.synchronize()
            print(self.FuWuLocation)
        }else if textField.tag == 99{
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(textField.text!, forKey: "mysalary")
            print(textField.text!)
            if textField.text! != ""{
                self.label.text = "服务费 "+"￥"+textField.text!
                self.price = textField.text!
                setAttributText(self.label.text!, Lable: self.label)
            }
        }else if textField.tag == 55{

            let ud = NSUserDefaults.standardUserDefaults()
            let mysalary = ud.objectForKey("mysalary")as! String
            print(mysalary)
            if textField.text! == "" && mysalary != "" {
                  self.label.text = "服务费 "+"￥"+mysalary
                setAttributText(self.label.text!, Lable: self.label)
            }else if textField.text! != "" && mysalary != ""{
                let salary = Int(mysalary)!+Int(textField.text!)!
                self.label.text = "服务费 "+"￥"+String(salary)
                setAttributText(self.label.text!, Lable: self.label)
                
            }else{
            
                self.label.text = "服务费"
                setAttributText(self.label.text!, Lable: self.label)
            }

        }
        
    }
    
    //MARK:选择时间
    func chooseDate(){
    
        let phone = self.view.viewWithTag(100)
        let textField = self.view.viewWithTag(99)
        let location = self.view.viewWithTag(98)
        let shangmen = self.view.viewWithTag(97)
        let paotui = self.view.viewWithTag(55)
        let textView = self.view.viewWithTag(45)
        textField?.resignFirstResponder()
        location?.resignFirstResponder()
        phone?.resignFirstResponder()
        shangmen?.resignFirstResponder()
        paotui?.resignFirstResponder()
        textView?.resignFirstResponder()
        
        if isShow == false {
            coverView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
//            let view = UIView()
            let view2 = UIView()
            view2.tag = 51
            view2.frame = CGRectMake(0, HEIGHT-340, WIDTH, 290)
            view2.backgroundColor = UIColor.whiteColor()
            let label = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 30))
            label.text = "选择服务时间"
            label.textAlignment = .Center
//            pickerView=UIDatePicker()
            datePicker = UIDatePicker()
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
    
    //MARK:选择方式
    func chooseMothed(){
        
        let phone = self.view.viewWithTag(100)
        let textField = self.view.viewWithTag(99)
        let location = self.view.viewWithTag(98)
        let shangmen = self.view.viewWithTag(97)
        let textView = self.view.viewWithTag(45)
        textView?.resignFirstResponder()
        shangmen?.resignFirstResponder()
        textField?.resignFirstResponder()
        location?.resignFirstResponder()
        phone?.resignFirstResponder()
        
        if isShow == false {
            coverView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            let view1 = UIView()
            view1.tag = 50
            view1.frame = CGRectMake(0, HEIGHT-400, WIDTH, 350)
            view1.backgroundColor = UIColor.whiteColor()
            let label = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 30))
            label.text = "选择计费方式"
            label.textAlignment = .Center
            let line = UILabel.init(frame: CGRectMake(0, 30, WIDTH, 1))
            line.backgroundColor = UIColor.blueColor()
            pickerView=UIPickerView()
            pickerView.tag = 100
            pickerView.frame = CGRectMake(50, 30, 200, 200)
//            pickerView.backgroundColor = UIColor.redColor()
            //将dataSource设置成自己
            pickerView.dataSource=self
            //将delegate设置成自己
            pickerView.delegate=self
            let button1 = UIButton.init(frame: CGRectMake(0, pickerView.frame.size.height+pickerView.frame.origin.y, WIDTH/2, 50))
            let button2 = UIButton.init(frame: CGRectMake(WIDTH/2, pickerView.frame.size.height+pickerView.frame.origin.y, WIDTH/2, 50))
            button1.setTitle("取消", forState: UIControlState.Normal)
            button1.tag = 1
            button1.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button1.titleLabel?.textColor = UIColor.blackColor()
            button2.setTitle("确定", forState: UIControlState.Normal)
//            button2.titleLabel?.textColor = UIColor.blackColor()
            button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button2.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button2.tag = 2
            let line1 = UILabel.init(frame: CGRectMake(0, button1.frame.origin.y, WIDTH, 1))
            line1.backgroundColor = UIColor.blueColor()
            
            view1.addSubview(label)
            view1.addSubview(line)
            view1.addSubview(pickerView)
            view1.addSubview(button1)
            view1.addSubview(button2)
            view1.addSubview(line1)
            self.view.addSubview(coverView)
            self.view.addSubview(view1)
            isShow = true
        }else{
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(50)
            view!.removeFromSuperview()
            //            coverView.frame = CGRectMake(0, 0, 0, 0)
            isShow = false
        }
    
    }
    
    func click(btn:UIButton){
        
        if btn.tag == 1 {
            print("取消")
            
//            pickerView.removeFromSuperview()
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(50)
            view!.removeFromSuperview()
            isShow = false
        }else{
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(50)
            view!.removeFromSuperview()
            isShow = false
            let label = self.view.viewWithTag(10)as! UILabel
            let index = pickerView.selectedRowInComponent(0)
            label.text = array1[index]
        }
        
    }
    //时间
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
            formatter2.dateFormat = "yyyyMMddHHmm"
            let dateStr = formatter2.stringFromDate(datePicker.date)
            let date222 = formatter2.dateFromString(dateStr)
            let dates = date222!.timeIntervalSince1970
            self.time = datestr
            self.expirydate = String(dates)
            print(self.expirydate)
            let button = self.view.viewWithTag(12)as! UIButton
            button.setTitle(datestr, forState: UIControlState.Normal)
            //            textField.text = datestr
            print("---")
            print(datestr)
            print("---")
            //            datePicker.removeFromSuperview()
            coverView.removeFromSuperview()
            let view = self.view.viewWithTag(51)
            view!.removeFromSuperview()
            isShow = false
            //            let label = self.view.viewWithTag(10)as! UILabel
            //            let index = pickerView.selectedRowInComponent(0)
            //            label.text = array1[index]
        }
        
        
    
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
            if pickerView.tag == 100 {
                 return array1[row]
            }else{
            
                return nil
            }
           
    }
    
    //设置列宽
    func pickerView(pickerView: UIPickerView,widthForComponent component: Int) -> CGFloat{
//        if(0 == component){
//            //第一列变宽
//            return 100
//        }else{
//            //第二、三列变窄
            return 200
//        }
    }
    
    //设置行高
    func pickerView(pickerView: UIPickerView,rowHeightForComponent component: Int) -> CGFloat{
        return 50
    }
    
    //设置选择框的列数为1列,继承于UIPickerViewDataSource协议
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        if pickerView.tag == 100 {
            return 1
        }else{
            return 3
        }
        
    }
    //设置选择框的行数为3行，继承于UIPickerViewDataSource协议
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        if pickerView.tag == 100 {
            return self.array1.count
        }else{
           return 3
        }
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //将在滑动停止后触发，并打印出选中列和行索引
        print(component)
        print(row)
        
        
    }
    
    func dingwei(btn:UIButton){
    
        let vc = LocationViewController()
       
        
        if btn.tag == 0 {
            
            vc.ViewTag = 1
            self.ViewTag = 1
            
        }else if btn.tag == 1{
            
            vc.ViewTag = 2
            self.ViewTag = 2
           
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    //MARK:代理方法
    func changeWithString(str: NSString, sign: Int) {
        if sign == 0 {
            let indexPath = NSIndexPath.init(forRow: sign+1, inSection: 0)
            let cell = myTableView.cellForRowAtIndexPath(indexPath)as!LocationTableViewCell
            cell.textView.text = str as String
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(cell.textView.text, forKey: "shangMenLocation")
//            self.address = str as String
//            self.myTableView.reloadData()
        }else{
            let indexPath = NSIndexPath.init(forRow: sign+1, inSection: 0)
            let cell = myTableView.cellForRowAtIndexPath(indexPath)as!LocationTableViewCell
            cell.textView.text = str as String
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(cell.textView.text, forKey: "FuWuLocation")
//            self.myTableView.reloadData()
        }
    }
    
    //MARK:skill协议方法
    func sendMessage(arr:NSArray){
        print(arr)
        if arr.count>0 {
            self.jiNengID.removeAllObjects()
            for i in 0..<self.dataSource.count{
                let button1 = self.view.viewWithTag(i+500)as! UIButton
                button1.backgroundColor = RGREY
                let label1 =  button1.subviews[0]as! UILabel
                label1.textColor = COLOR
            }
        }
        
        
        
        
        
        let button = self.view.viewWithTag(self.selectedIndex)as! UIButton
        
        if arr.count == 0  {
            button.backgroundColor = RGREY
            let label =  button.subviews[0]as! UILabel
            label.textColor = COLOR
        }
        
        for ids in self.infosss {
            if  self.jiNengID.containsObject(ids.id!) {
                self.jiNengID.removeObject(ids.id!)
            }
        }
    
        if arr.count != 0 {
            print(self.selectedIndex)
            
//             let strrr = NSMutableString()
            
            
            for i in 0..<arr.count{
                self.jiNengID.addObject(self.infosss[(arr[i]as! UIButton).tag].id!)
                
                
            }
            
            print(self.jiNengID)
                //            for str in arr {
//               
//                strrr = strrr + self.infosss[(str  as! UIButton).tag].name!
//                
//            }
            self.taskDescription = self.dataSource[self.selectedIndex-500].name!
//            self.taskTitle = 
//            print(strrr)
            
//            print(self.type )
//            self.type = (button.titleLabel?.text)!
            button.backgroundColor = COLOR
            let label =  button.subviews[0]as! UILabel
            label.textColor = UIColor.whiteColor()
        }
    
    }
    


}
