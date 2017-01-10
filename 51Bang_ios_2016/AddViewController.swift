//
//  AddViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVProgressHUD
import AssetsLibrary

class AddViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AVAudioRecorderDelegate,TZImagePickerControllerDelegate {
    
    
    
    
    var hud1 = MBProgressHUD()
    var timer1:NSTimer!
    var timer2:NSTimer!
    var address1 = NSString()
    var deletebutton = UIButton()
    let boFangButton = UIButton()
    let backMHView11 = UIView()
    var LuYinButton = UIButton()
    var recordUrl = NSURL()
    var mp3FilePath = NSURL()
    var audioFileSavePath = NSURL()
    var audioSession = AVAudioSession()
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var recordTime = Int()
    var timeLabel = UILabel()
    let recordSetting = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 2),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.High.rawValue)),//音频质量
        AVLinearPCMBitDepthKey: NSNumber(int: 2)
    ]
    
    
    
    let myPickerView = UIPickerView()//底部选择器
    let pickerArray = ["同城自取","送货上门","凭劵消费"]//选择数据
    let pickerViewFromDownBackView = UIView()
    let backMHView = UIView()
    var ishaveNext = Bool()
    var myLiction = CLLocationCoordinate2D.init()
    var timer:NSTimer!
    var myPhotoCount = NSInteger()
    let photoPushButton = UIButton()
    
    let dingWeiImageView = UIButton()
    let clearButtonOfBack = UIButton()
    
    var mainHelper = MainHelper()
    var myDatas : Array<GoodsInfo>?
    var isEdit = Bool()
    var isEditsss = Bool()
    var isSecordEdit = Bool()
    var isTypeEdit = Bool()
    var isAdressEdit = Bool()
    var isLeftTableViewHiden = Bool()
    let button = UIButton()//分类选择leftTableView返回按钮
    let headerView = UIView()
    let mytableView = UITableView()
    let leftTableView = UITableView()
    let rightTableView = UITableView()
    let mytextView = UITextField()//商品名称
    var isShow = Bool()
    let coverView = UIView()
    var photoArray:NSMutableArray = []
    var collectionV:UICollectionView?
     let btn = UIButton()
    let photoNameArr = NSMutableArray()
    let shopHelper = ShopHelper()
    var myPhone = NSString()
    var myLabel1 = UILabel()//商品分类显示label
    var myLabel2 = UILabel()//配送方式显示label
    var valueLabelStr = String()//商品分类cell处的label的String
    var typeLabelStr = String()//商品配送方式
    
    let leftArr = ["全部分类","餐饮美食","休闲娱乐","个护化妆","按摩","养生","健身"]
    var rightArr = ["全部","足疗按摩","运动健身","KTV","其他养生保健","游乐园","其他游乐活动"]
    var rightArr0 = ["全部","足疗按摩","运动健身","KTV","其他养生保健","游乐园","其他游乐活动"]
    let rightArr1 = ["油压按摩","足底按摩","泰式按摩","养生","保健","治疗","美容"]
    let rightArr2 = ["八仙粉","辣子鸡","糖霜花生","武汉热干面","串串香","菌子汤","豌豆黄"]
    let rightArr3 = ["体育类","旅游类","游戏类","喝茶","聊天","上网","健身"]
    let rightArr4 = ["影视化妆","平面化妆","现代人物","经典化妆","普通化妆","化妆学习","化妆招聘"]
    let rightArr5 = ["饮食养生","调息养生","运动养生","保健养生","道家养生","大众养生","中医养生"]
    let rightArr6 = ["全部","足疗按摩","运动健身","KTV","其他养生保健","游乐园","其他游乐活动"]
    var array : Array<DicInfo> = []
    var type1 = String()
    var rightKind:Array<[String]>?
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        let myindexPaths = NSIndexPath.init(forRow: 3, inSection: 0)
        mytableView.reloadRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Fade)
        if address == "" {
            alert("请打开定位服务",delegate:self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightKind = [rightArr0,rightArr2,rightArr,rightArr4,rightArr1,rightArr5,rightArr6]
        self.title = "特卖发布"
        mytextView.delegate = self
        mainHelper.getDicList("3",handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                print(response)
                
                self.array.removeAll()
                self.array = response as? Array<DicInfo> ?? []
//                for name in self.array{
//                    print(name.id)
//                    print(name.name)
//                }
                self.leftTableView.reloadData()
//                print(self.myDic![0].id)
//                
//                print(self.myDic?.count)
                
                //                }
            })
            })
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        mytableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        mytableView.backgroundColor = RGREY
        mytableView.dataSource = self
        mytableView.delegate = self
        mytableView.tag = 0
        mytableView.registerNib(UINib(nibName: "FabuTableViewCell4",bundle: nil), forCellReuseIdentifier: "cell4")
        mytableView.registerNib(UINib(nibName: "FabuTableViewCell1",bundle: nil), forCellReuseIdentifier: "cell1")
        
        mytableView.registerNib(UINib(nibName: "FabuTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell2")
        
        mytableView.registerNib(UINib(nibName: "FabuTableViewCell3",bundle: nil), forCellReuseIdentifier: "cell3")
        mytableView.registerNib(UINib(nibName: "ShopPhoneTableViewCell",bundle: nil), forCellReuseIdentifier: "phone")
        mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        self.view.addSubview(mytextView)
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 120))
        btn.frame = CGRectMake(15, 30, WIDTH-30, 50)
        btn.layer.cornerRadius = 8
        btn.setTitle("发布", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        //btn.addTarget(self, action: #selector(self.fabu), forControlEvents: <#T##UIControlEvents#>)
        btn.addTarget(self, action: #selector(self.fabu), forControlEvents: .TouchUpInside)
        bottom.addSubview(btn)
        mytableView.tableFooterView = bottom
        self.view.addSubview(mytableView)
        self.createTextView()
        
        pickerViewFromDownBackView.backgroundColor = UIColor.whiteColor()
        pickerViewFromDownBackView.frame = CGRectMake(0, self.view.bounds.size.height+20, WIDTH, 240)
        self.myPickerView.frame = CGRectMake(0, 40, WIDTH, 130)
        self.myPickerView.dataSource = self
        self.myPickerView.delegate = self
        pickerViewFromDownBackView.addSubview(myPickerView)
        self.view.addSubview(pickerViewFromDownBackView)
        let confirmButton = UIButton()
        confirmButton.backgroundColor = COLOR
        confirmButton.frame = CGRectMake(WIDTH-50-50, 140+40, 70, 40)
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.masksToBounds = true
        confirmButton.addTarget(self, action: #selector(self.confirmButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        confirmButton.setTitle("确定", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        pickerViewFromDownBackView.addSubview(confirmButton)
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = COLOR
        cancelButton.frame = CGRectMake(50, 140+40, 70, 40)
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        pickerViewFromDownBackView.addSubview(cancelButton)
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = COLOR
        titleLabel.text = "配送方式选择"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.frame = CGRectMake(0, 0, WIDTH, 40)
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 5
        
        pickerViewFromDownBackView.addSubview(titleLabel)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //照片多选代理实现
    //    func passPhotos(selected:[ZuberImage]){
    //        photoArray = selected
    //        print(selected)
    //        self.addCollectionViewPicture()
    ////        if selected.count>0 {
    ////
    ////            photoPushButton.frame = CGRectMake(WIDTH/2-40, self.collectionV!.height+250+20, 80, 40)
    ////            photoPushButton.backgroundColor = COLOR
    ////            photoPushButton.layer.masksToBounds = true
    ////            photoPushButton.layer.cornerRadius = 5
    ////            photoPushButton.setTitle("上传图片", forState: UIControlState.Normal)
    ////            photoPushButton.addTarget(self, action: #selector(self.pushPhotoAction), forControlEvents: UIControlEvents.TouchUpInside)
    ////            self.headerView.addSubview(photoPushButton)
    ////            self.headerView.height = self.collectionV!.height+250+80
    ////            self.mytableView.tableHeaderView = self.headerView
    ////        }
    //
    //
    //    }
    //    func pushPhotoAction(){
    //        print(photoArray.count)
    //
    //
    //        timer = NSTimer.scheduledTimerWithTimeInterval(1.2,
    //                                                       target:self,selector:#selector(self.pushPhotos),
    //                                                       userInfo:nil,repeats:true)
    //
    //
    //    }
    
    func pushPhotos(){
        if self.photoArray.count == 0{
            self.photoPushButton.removeFromSuperview()
            timer.invalidate()
            return
        }
        myPhotoCount = 0
        
    }
    
    
    
    //确认按钮点击事件
    func confirmButtonAction() {
        self.backMHView.removeFromSuperview()
        typeLabelStr = pickerArray[self.myPickerView.selectedRowInComponent(0)]
        let myindexPaths = NSIndexPath.init(forRow: 4, inSection: 0)
        mytableView.reloadRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Middle)
        isLeftTableViewHiden = true
        UIView.animateWithDuration(0.2, animations: {
            self.pickerViewFromDownBackView.frame = CGRectMake(0, self.view.bounds.size.height, WIDTH, 240)
        })
    }
    
    func cancelButtonAction() {
        self.backMHView.removeFromSuperview()
        UIView.animateWithDuration(0.2, animations: {
            self.pickerViewFromDownBackView.frame = CGRectMake(0, self.view.bounds.size.height, WIDTH, 240)
        })
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        return WIDTH
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 35
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return self.pickerArray[row]
    }
    
    
    func keyboardWillShow(note:NSNotification){
        
        let userInfo  = note.userInfo as! NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let deltaY = keyBoardBounds.size.height/2
        
        UIView.animateWithDuration(0.4, animations: {
            self.mytableView.frame.origin.y = -deltaY
        })
        
    }
    
    func keyboardWillHide(note:NSNotification){
        
        UIView.animateWithDuration(0.4, animations: {
            self.mytableView.frame.origin.y = 0
        })
        
    }
    
    
    
    func fabu(){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        self.btn.enabled = false
        hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud1.animationType = .Zoom
        hud1.labelText = "正在努力加载"
        if self.photoArray.count == 0 {
            self.fabuAction()
            return
        }
        var isRecord = false
        if mp3FilePath.absoluteString == "" {
            isRecord = true
        }
        
        var a = Int()
        a = 0
        
        if mp3FilePath.absoluteString != "" {
            print(mp3FilePath.absoluteString)
            
            let data = NSData.init(contentsOfFile: self.mp3FilePath.path!)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss:SSS"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr + "record" + String(arc4random() % 10000) + userid
            print(imageName)
            ConnectModel.uploadWithVideoName(imageName, imageData: data, URL: Bang_URL_Header+"uploadRecord",url:self.mp3FilePath, finish: { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    print(result.status)
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                isRecord = true
                                if a == self.photoArray.count-1||self.photoArray.count == 0{
                                    self.fabuAction()
                                }
                                print("000000000000000000")
                                
                            }else{
                                self.btn.enabled = true
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
        
        
        for ima in photoArray{
            
            let dataPhoto:NSData = UIImageJPEGRepresentation(ima as! UIImage, 1.0)!
            var myImagess = UIImage()
            myImagess = UIImage.init(data: dataPhoto)!
            
            let data = UIImageJPEGRepresentation(myImagess, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss.SSS"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "shopavatar" + dateStr + String(a) + String(arc4random() % 10000) + userid
            print(imageName)
            
            //上传图片
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    print(result.status)
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                
                                self.photoNameArr.addObject(result.data!)
                                if self.photoNameArr.count > 9{
                                    self.photoNameArr.removeLastObject()
                                }
                                
                                if a == self.photoArray.count-1 && isRecord == true{
                                    self.fabuAction()
                                }
                                a = a+1
                                
                            }else{
                                self.btn.enabled = true
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "图片上传失败"
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
        
        
        //        if loginSign == 0 {//未登陆
        //
        //            self.tabBarController?.selectedIndex = 3
        //
        //        }else{
        //已登陆
        
        
        
        //        }
        
    }
    
    func fabuAction(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        //        let longitude = ud.objectForKey("longitude")as! String
        //        let latitude = ud.objectForKey("latitude")as! String
        
        let myLongitude = String(self.myLiction.longitude)
        let myLatitude = String(self.myLiction.latitude)
        //        let myLongitude = removeOptionWithString(longitude)
        //
        //        let myLatitude = removeOptionWithString(latitude)
        
        print(myLongitude)
        print(myLatitude)
        if self.mytextView.text!.isEmpty{
            alert("请填写商品名称", delegate: self)
            self.hud1.hidden = true
            self.btn.enabled = true
            return
        }
        print(self.mytextView.text!.characters.count)
        if self.mytextView.text!.characters.count > 35{
            alert("商品名称不超过35个字", delegate: self)
            self.hud1.hidden = true
            self.btn.enabled = true
            return
        }
        
       
        
        print(address)
        let textView = self.view.viewWithTag(1)as! PlaceholderTextView
        let price = self.view.viewWithTag(5)as! UITextField
        let oprice = self.view.viewWithTag(6)as!UITextField
        //            print(oprice)
        //            print(mytextView.text!)
        //            print(textView.text)
        //            print(price.text!)
        //            print(self.photoNameArr)
        //        print("---")
        //        let myPhone = ud.objectForKey("phone")as!String
        //        print(myPhone)
//        if oprice.text!.isEmpty{
//            alert("请填写商品名称", delegate: self)
//        }
        
        if textView.text!.isEmpty{
            alert("请填写商品描述", delegate: self)
            self.hud1.hidden = true
            self.btn.enabled = true
            return
        }
        
        if price.text!.isEmpty{
            alert("请填写商品价格", delegate: self)
            self.hud1.hidden = true
            self.btn.enabled = true
            return
        }
        if (address1 as String).isEmpty{
            alert("请填写商户地址", delegate: self)
            self.hud1.hidden = true
            self.btn.enabled = true
            return
        }
        if (typeLabelStr as String).isEmpty{
            alert("请填写配送方式", delegate: self)
            self.hud1.hidden = true
            self.btn.enabled = true
            return
        }
        let a = Double(oprice.text!)
        
        let b = Double(price.text!)
        
        if !oprice.text!.isEmpty{
            if a==nil {
                alert("请填写正确格式的价格", delegate: self)
                self.hud1.hidden = true
                self.btn.enabled = true
                return
            }
            
        }
        if !price.text!.isEmpty{
            if b==nil {
                alert("请填写正确格式的价格", delegate: self)
                self.hud1.hidden = true
                self.btn.enabled = true
                return
            }
            
        }
        if self.photoNameArr.count > 0{
            for index in 0...self.photoNameArr.count-1 {
                if index>8 {
                    self.photoNameArr.removeObjectAtIndex(index)
                }
            }
        }
        
        
        if (self.myDatas?.count>0&&isEditsss == true){
            shopHelper.reLoadTeMaiMessage(userid, type: type1, goodsname:self.mytextView.text!, oprice: oprice.text! as String, price: price.text! as String, desc: textView.text, unit: "",longitude:myLongitude,latitude:myLatitude,address:address1,delivery:typeLabelStr) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                print(response)
                self.hud1.hidden = true
                self.navigationController?.popViewControllerAnimated(true)
                alert("发布成功", delegate: self)
                
                self.btn.enabled = true
                })
            }

        }else{
            print(type1)
            shopHelper.upLoadTeMaiMessage(userid, type: type1, goodsname:self.mytextView.text!, oprice: oprice.text! , price: price.text!, desc: textView.text, photoArray: self.photoNameArr, unit: "",longitude:myLongitude,latitude:myLatitude,address:address1,delivery:typeLabelStr) { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                print(response)
                
                
                
                self.hud1.hide(true)
                self.navigationController?.popViewControllerAnimated(true)
                alert("发布成功", delegate: self)
                
                self.btn.enabled = true
                })
            }

        }
        
        
    }
    
    func createTextView(){
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*240/375+10)
        //                headerView.backgroundColor = UIColor.greenColor()
        
        mytextView.frame = CGRectMake(10, 0, WIDTH, WIDTH*60/375)
        mytextView.placeholder = "  特卖商品名称"
        mytextView.backgroundColor = UIColor.whiteColor()
        let myheadView = UIView.init(frame: CGRectMake(0, 0, 10, mytextView.height))
        myheadView.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(myheadView)
        //        let JINGGAOLabel = UILabel()
        //        JINGGAOLabel.frame = CGRectMake(0, 250, WIDTH, 20)
        //        JINGGAOLabel.text = "禁止发布黄、赌，毒，违反国家法律的言论及图片"
        //        JINGGAOLabel.backgroundColor = GREY
        //        JINGGAOLabel.textColor = UIColor.redColor()
        //        self.headerView.addSubview(JINGGAOLabel)
        if self.myDatas?.count>0{
            mytextView.text = self.myDatas![0].goodsname
        }
        
        let textView = PlaceholderTextView.init(frame: CGRectMake(0, 65, WIDTH, WIDTH*180/375))
        textView.tag = 1
        textView.backgroundColor = UIColor.whiteColor()
        textView.delegate = self
        textView.textAlignment = .Left
        textView.editable = true
        textView.layer.cornerRadius = 4.0
        //        textView.layer.borderColor = kTextBorderColor.CGColor
        textView.layer.borderWidth = 0
        textView.placeholder = "  说说您的商品描述吧...（禁止发布二维码）"
        if self.myDatas?.count>0{
            textView.text = self.myDatas![0].description
        }
        let button = UIButton.init(frame: CGRectMake(20, textView.frame.size.height-30, 30, 30))
        button.setImage(UIImage(named: "ic_tupian"), forState: UIControlState.Normal)
        button.layer.borderColor = UIColor.grayColor().CGColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(self.goToCamera1(_:)), forControlEvents: .TouchUpInside)
        let yinPin = UIButton.init(frame: CGRectMake(80, textView.frame.size.height-30, 30, 30))
        yinPin.setImage(UIImage(named: "ic_yinpin"), forState: UIControlState.Normal)
        yinPin.layer.borderColor = UIColor.grayColor().CGColor
        yinPin.layer.borderWidth = 1.0
        yinPin.layer.cornerRadius = 15
        yinPin.layer.masksToBounds = true
        yinPin.addTarget(self, action: #selector(self.startRecord), forControlEvents: UIControlEvents.TouchUpInside)
        //        yinPin.addTarget(self, action: #selector(self.startRecord), forControlEvents: UIControlEvents.TouchUpInside)
        let shiPin = UIButton.init(frame: CGRectMake(140, textView.frame.size.height-30, 30, 30))
        shiPin.setImage(UIImage(named: "ic_shipin"), forState: UIControlState.Normal)
        
        textView.addSubview(button)
        //        textView.addSubview(yinPin)
        //        textView.addSubview(shiPin)
        let line = UILabel.init(frame: CGRectMake(0, button.frame.size.height+button.frame.origin.y+10, WIDTH, 1))
        line.backgroundColor = RGREY
        headerView.addSubview(line)
        headerView.addSubview(mytextView)
        headerView.addSubview(textView)
        textView.addSubview(line)
        self.mytableView.tableHeaderView = headerView
        //        myTableViw.tableHeaderView = textView
        //        self.view.addSubview(textView)
    }
    
    
    
    //录音
    func startRecord(){
        
        self.backMHView11.frame = CGRectMake(0, 0, WIDTH, self.view.bounds.height+64)
        self.backMHView11.backgroundColor = UIColor.grayColor()
        self.backMHView11.alpha = 0.8
        
        LuYinButton = UIButton.init(type: UIButtonType.RoundedRect)
        LuYinButton.frame = CGRectMake((WIDTH-80)/2, (HEIGHT-80)/2, 80, 80)
        LuYinButton.layer.masksToBounds = true
        LuYinButton.layer.cornerRadius = 40
        //        LuYinButton.setImage(UIImage(named: "ic_luyin"), forState: UIControlState.Normal)
        LuYinButton.backgroundColor = UIColor.whiteColor()
        LuYinButton.setBackgroundImage(UIImage(named: "ic_luyin"), forState: UIControlState.Normal)
        //        LuYinButton.userInteractionEnabled = false
        //        LuYinButton.addTarget(self, action: #selector(self.overRecord), forControlEvents: UIControlEvents.TouchUpInside)
        backMHView11.addSubview(LuYinButton)
        
        let longPressGR = UILongPressGestureRecognizer()
        longPressGR.addTarget(self, action: #selector(self.startRecordAndGetIn(_:)))
        longPressGR.minimumPressDuration = 0
        LuYinButton.addGestureRecognizer(longPressGR)
        timeLabel.frame = CGRectMake((WIDTH-150)/2, 200, 150, 30)
        timeLabel.backgroundColor = UIColor.whiteColor()
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 10
        timeLabel.textAlignment = .Center
        //        timeLabel.layer.borderColor = UIColor.blackColor().CGColor
        //        timeLabel.layer.borderWidth = 1
        timeLabel.textColor = COLOR
        timeLabel.text = "长按录音"
        self.backMHView11.addSubview(timeLabel)
        
        self.view.addSubview(self.backMHView11)
        
        self.addCollectionViewPicture()
        
        
    }
    func overRecord(){
        
        mp3FilePath = NSURL.init(string: NSTemporaryDirectory().stringByAppendingString("myselfRecord.mp3"))!
        print(mp3FilePath)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.mp3FilePath = NSURL.init(string: AudioWrapper.audioPCMtoMP3(self.recordUrl.absoluteString, self.mp3FilePath.absoluteString))!
            
        }
        
        
        audioFileSavePath = mp3FilePath;
        //        let alert2 = UIAlertView.init(title: "mp3转化成功！", message: nil, delegate: self, cancelButtonTitle: "确定")
        //        alert2.show()
        self.backMHView11.removeFromSuperview()
        
        //        var buttonFloat = CGFloat()
        //        if self.recordTime<7 {
        //            buttonFloat = 90
        //        }else if(self.recordTime>Int(WIDTH-80)/15){
        //            buttonFloat = WIDTH-80
        //        }else{
        //            buttonFloat = CGFloat(self.recordTime*15)
        //        }
        boFangButton.removeFromSuperview()
        boFangButton.frame = CGRectMake(20, collectionV!.height+250+20,114, 30)
        
        boFangButton.backgroundColor = UIColor.clearColor()
        boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
        boFangButton.setBackgroundImage(UIImage(named: "ic_yinpinbeijing"), forState: UIControlState.Normal)
        boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        boFangButton.addTarget(self, action: #selector(self.boFangButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
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
        self.headerView.height = collectionV!.height+250+70
        self.mytableView.tableHeaderView = self.headerView
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
                //                print(recordUrl)
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
            if self.recordTime <= 0{
                let alert2 = UIAlertView.init(title: "录音时间太短", message: nil, delegate: self, cancelButtonTitle: "确定")
                alert2.show()
                timer1.invalidate()
                return
            }else{
                do{
                    if audioRecorder?.recording == true{
                        audioRecorder!.stop()
                    }else{
                        audioPlayer?.stop()
                    }
                    
                    try audioSession.setActive(false)
                    
                }catch{
                    
                }
                timer1.invalidate()
                self.overRecord()
                print(recordUrl)
                
                
            }
            
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
                
                
                
                let filepath = NSBundle.mainBundle().pathForResource("myselfRecord", ofType: "mp3")
                print(filepath)
                
            }
            
            if (recordUrl.absoluteString != "") {
                try self.audioPlayer = AVAudioPlayer.init(contentsOfURL: self.recordUrl)
                print(self.audioPlayer)
            }
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
            recordTime = 0
        }
        boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
    }
    
    func recordTimeTick(){
        recordTime += 1
        boFangButton.setTitle(String(self.recordTime)+"\"", forState: UIControlState.Normal)
        
        timeLabel.text = "已经录制"+String(recordTime)+"秒"
        
        
    }
    
    
    
    func viewTap(sender: UITapGestureRecognizer) {
        print("clicked...")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return 6
        }else if tableView.tag == 1{
            
            return self.array.count
        }else{
            
            return rightArr.count
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 40
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == mytableView {
            if indexPath.row == 0{
                
                let cell = mytableView.dequeueReusableCellWithIdentifier("cell1")as! FabuTableViewCell1
                
                myLabel1.removeFromSuperview()
               
                cell.title.text = "分类"
                myLabel1 = UILabel.init(frame: CGRectMake(108, 8, 200, 30))
                if (self.myDatas?.count>0&&isEdit == true && isSecordEdit == false){
                    if self.myDatas![0].type! as NSString as String == ""{
                        myLabel1.text = ""
                        isSecordEdit = true
                    }else{
                        for name in array {
                            if name.id == self.myDatas![0].type{
                                myLabel1.text = name.name
                                isSecordEdit = true
                            }
                        }
                        
                        
                    }
                    self.isEdit = false
                }
                
                myLabel1.textColor = UIColor.blackColor()
                myLabel1.font = UIFont.systemFontOfSize(13)
                cell.addSubview(myLabel1)
                myLabel1.text = valueLabelStr
                cell.selectionStyle = .None
                tableView.separatorStyle = .None
                //cell.button.addTarget(self, action: #selector(self.goToCamera(_:)), forControlEvents: .TouchUpInside)
                cell.button.addTarget(self, action: #selector(self.onClick), forControlEvents: .TouchUpInside)
                //            cell.accessoryType = .DisclosureIndicator
                return cell
            }else if indexPath.row == 1{
                dingWeiImageView.removeFromSuperview()
                clearButtonOfBack.removeFromSuperview()
                let cell = mytableView.dequeueReusableCellWithIdentifier("cell2")as! FabuTableViewCell2
                cell.title.text = "价格"
                cell.textField.tag = 5
//                cell.textField.keyboardType = UIKeyboardType.NumberPad
                cell.textField.delegate = self
                cell.selectionStyle = .None
                cell.textField.borderStyle = .None
                cell.textField.placeholder = "请输入价格"
                cell.textField.text = ""
                if (self.myDatas?.count>0&&isEdit == true && self.myDatas![0].price != nil){
                    cell.textField.text = self.myDatas![0].price
                }
                tableView.separatorStyle = .None
                return cell
            }else if indexPath.row == 2{
                dingWeiImageView.removeFromSuperview()
                clearButtonOfBack.removeFromSuperview()
                let cell = mytableView.dequeueReusableCellWithIdentifier("cell2")as! FabuTableViewCell2
                cell.title.text = "原价"
                cell.textField.tag = 6
//                cell.textField.keyboardType = UIKeyboardType.NumberPad
                if (self.myDatas?.count>0&&isEdit == true && self.myDatas![0].oprice != nil){
                    cell.textField.text = self.myDatas![0].oprice
                }
                cell.textField.text = ""
                cell.textField.placeholder = "请输入价格"
                cell.textField.delegate = self
                cell.selectionStyle = .None
                cell.textField.borderStyle = .None
                tableView.separatorStyle = .None
                return cell
                
                
            }else if indexPath.row == 3{
                dingWeiImageView.removeFromSuperview()
                clearButtonOfBack.removeFromSuperview()
                let cell = mytableView.dequeueReusableCellWithIdentifier("cell2")as! FabuTableViewCell2
                cell.title.text = "位置"
                if !self.ishaveNext{
                    cell.textField.text = MainViewController.BMKname
                    address1 = MainViewController.BMKname
                    print(MainViewController.userLocationForChange)
                    self.myLiction = MainViewController.userLocationForChange.coordinate
                    print(self.myLiction)
                }else{
                    cell.textField.text = LocationViewController.myAddressOfpoint
                    address1 = LocationViewController.myAddressOfpoint
                    self.myLiction = LocationViewController.pointOfSelected
                }
                
                //                cell.textField.text = MainViewController.BMKname
                cell.textField.borderStyle = .None
                cell.textField.delegate = self
                cell.textField.tag = 7
                if (self.myDatas?.count>0&&isEdit == true && self.myDatas![0].address != nil && isAdressEdit == false){
                    cell.textField.text = self.myDatas![0].address
                    address1 = self.myDatas![0].address!
                    isAdressEdit = true
                }
                print(address)
                if self.ishaveNext {
                    //SVProgressHUD.showSuccessWithStatus("登录成功")
                    
                }else{
                    cell.textField.text = address
                    address1 = address
                }
                
                dingWeiImageView.frame = CGRectMake(WIDTH-30, (cell.frame.height-20)/2, 18, 20)
                dingWeiImageView.setBackgroundImage(UIImage(named: "ic_wodeweizhi"), forState: UIControlState.Normal)
                
                clearButtonOfBack.backgroundColor = UIColor.clearColor()
                clearButtonOfBack.frame = CGRectMake(0, 0, WIDTH, cell.frame.height)
                
                clearButtonOfBack.addTarget(self, action: #selector(self.dingWeiAction), forControlEvents: UIControlEvents.TouchUpInside)
                dingWeiImageView.addTarget(self, action: #selector(self.dingWeiAction), forControlEvents: UIControlEvents.TouchUpInside)
                cell.addSubview(dingWeiImageView)
                
                
                
                cell.textField.placeholder = ""
                cell.selectionStyle = .None
                tableView.separatorStyle = .None
                cell.addSubview(clearButtonOfBack)
                //            cell.accessoryType = .DisclosureIndicator
                return cell
                
            }else if indexPath.row == 4{
                
                let cell = mytableView.dequeueReusableCellWithIdentifier("cell1")as! FabuTableViewCell1
                
                myLabel2.removeFromSuperview()
                cell.title.text = "配送方式"
                myLabel2 = UILabel.init(frame: CGRectMake(108, 8, 200, 30))
                cell.button.userInteractionEnabled = false
                myLabel2.textColor = UIColor.blackColor()
                myLabel2.font = UIFont.systemFontOfSize(13)
                myLabel2.text = typeLabelStr
                cell.addSubview(myLabel2)
                cell.selectionStyle = .None
                tableView.separatorStyle = .None
                if (self.myDatas?.count>0&&isEdit == true && self.myDatas![0].delivery != nil && isTypeEdit == false){
                    myLabel2.text = self.myDatas![0].delivery
                    isTypeEdit = true
                }
                //cell.button.addTarget(self, action: #selector(self.goToCamera(_:)), forControlEvents: .TouchUpInside)
//                cell.button.addTarget(self, action: #selector(self.onClick), forControlEvents: .TouchUpInside)
//                cell.accessoryType = .DisclosureIndicator
                return cell
                
                
               
            }else {
                let cell = mytableView.dequeueReusableCellWithIdentifier("phone")as!ShopPhoneTableViewCell
                let ud = NSUserDefaults.standardUserDefaults()
//                var userid = String()
                if ud.objectForKey("phone") != nil {
                    self.myPhone = ud.objectForKey("phone")as! String
                }
                
                cell.phone.text = self.myPhone as String
                return cell
                            }
//            else{
//                let cell = mytableView.dequeueReusableCellWithIdentifier("cell1")as! FabuTableViewCell1
//                myLabel2.removeFromSuperview()
//                cell.title.text = "配送方式"
//                myLabel2 = UILabel.init(frame: CGRectMake(108, 8, 200, 30))
//                myLabel2.textColor = UIColor.blackColor()
//                myLabel2.font = UIFont.systemFontOfSize(13)
//                myLabel2.text = typeLabelStr
//                cell.addSubview(myLabel2)
//                cell.selectionStyle = .None
//                tableView.separatorStyle = .None
//               
//                cell.button.addTarget(self, action: #selector(self.onClick), forControlEvents: .TouchUpInside)
//                return cell
//            }
           
            
        }else if tableView == leftTableView {
            //            tableView.separatorStyle = .None
            let cell = tableView.dequeueReusableCellWithIdentifier("leftTableView")
            cell?.textLabel?.text = array[indexPath.row].name
            //            cell!.accessoryType = .DisclosureIndicator
            cell?.selectedBackgroundView = UIView.init(frame: (cell?.frame)!)
            cell?.backgroundColor = RGREY
            cell?.selectedBackgroundView?.backgroundColor = UIColor.whiteColor()
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell!
        }else{
            tableView.separatorStyle = .None
            let cell = tableView.dequeueReusableCellWithIdentifier("rightTableView")
            cell?.textLabel?.text = rightArr[indexPath.row]
            cell?.backgroundColor = RGREY
            cell?.selectionStyle = .None
            return cell!
        }
        
        
    }
    
    
    func dingWeiAction()  {
        self.ishaveNext = true;
        let vc = LocationViewController()
        vc.isWobangPush = true
        vc.latitudeStr = String(self.myLiction.latitude)
        vc.longitudeStr = String(self.myLiction.longitude)
        vc.addressPoint = self.address1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 2 {
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            rightTableView.removeFromSuperview()
        }else if tableView == mytableView{
            
            if indexPath.row == 0 {
                (self.view.viewWithTag(5)as! UITextField).resignFirstResponder()
                (self.view.viewWithTag(6)as!UITextField).resignFirstResponder()
                self.mytextView.resignFirstResponder()
                (self.view.viewWithTag(1)as! PlaceholderTextView).resignFirstResponder()
                self.onClick()
                isLeftTableViewHiden = true
                self.leftTableView.hidden = false
            }else if indexPath.row == 4 {
                
                (self.view.viewWithTag(5)as! UITextField).resignFirstResponder()
                (self.view.viewWithTag(6)as!UITextField).resignFirstResponder()
                self.mytextView.resignFirstResponder()
                (self.view.viewWithTag(1)as! PlaceholderTextView).resignFirstResponder()
                
                self.backMHView.frame = CGRectMake(0, 0, WIDTH, self.view.bounds.height-240+64)
                self.backMHView.backgroundColor = UIColor.grayColor()
                self.backMHView.alpha = 0.5
                UIApplication.sharedApplication().keyWindow!.addSubview(self.backMHView)
                UIView.animateWithDuration(0.2, animations: {
                    self.pickerViewFromDownBackView.frame = CGRectMake(0, self.view.bounds.size.height-240, WIDTH, 240)
                })
                self.leftTableView.hidden = true
                
            }
//            print(indexPath.row)
        }else if tableView == leftTableView {
            let myindexPaths = NSIndexPath.init(forRow: 0, inSection: 0)
            print(valueLabelStr)
            valueLabelStr = array[indexPath.row].name!
            type1 = array[indexPath.row].id!
            print(valueLabelStr)
            mytableView.reloadRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Middle)
            isLeftTableViewHiden = true
            self.hidenLeftTableView()
        }else{
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            
//            type1 = array[indexPath.row].id!
            self.tabBarController?.tabBar.hidden = true
            
        }
        
        
    }
    
    
    func onClick(){
        coverView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-48)
        coverView.backgroundColor = UIColor.grayColor()
        coverView.alpha = 0.8
        leftTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        leftTableView.tag = 1
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = .None
        leftTableView.backgroundColor = RGREY
        leftTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "leftTableView")
        //        view.addSubview(leftTableView)
        
        rightTableView.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, leftTableView.frame.size.height)
        rightTableView.backgroundColor = UIColor.grayColor()
        rightTableView.tag = 2
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "rightTableView")
        self.view.addSubview(leftTableView)
        self.view.addSubview(rightTableView)
        self.view.addSubview(coverView)
        self.view.bringSubviewToFront(leftTableView)
        //        self.view.bringSubviewToFront(rightTableView)
        
        button.frame = CGRectMake(0, 0, 20, 20)
        //        button.backgroundColor = UIColor.redColor()
        button.backgroundColor = UIColor.clearColor()
        button.setImage(UIImage(named: "ic_fanhui-left"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.hidenLeftTableView), forControlEvents: UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView:button)
        self.navigationItem.leftBarButtonItem = item
        
    }
    func hidenLeftTableView() {
        if isLeftTableViewHiden == false {
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            rightTableView.removeFromSuperview()
        }
        isLeftTableViewHiden = false
    }
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        self.photoArray.removeAllObjects()
        self.photoNameArr.removeAllObjects()
        for imagess in photos {
            photoArray.addObject(imagess)
        }
        self.addCollectionViewPicture()
        
        
    }
    
    
    
    func goToCamera1(btn:UIButton){
        
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 9, delegate:self)
        
        
        
        //
        //        let VC1 = SGImagePickerController()
        //        VC1.maxCount = 9
        ////        self.navigationController?.pushViewController(VC1, animated: true)
        //        VC1.didFinishSelectThumbnails = {
        //            ( images ) in
        //            //photoArray = images
        //
        //            self.photoArray.removeAllObjects()
        //            for image in images
        //            {
        //                self.photoArray.addObject(image)
        //            }
        //            self.addCollectionViewPicture()
        //
        //
        //
        //        }
        print(photoArray.count)
        print("上传图片")
        print(btn.tag)
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 250, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        //        collectionV?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        collectionV!.registerNib(UINib(nibName: "PhotoCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
        //        collectionV?.backgroundColor = UIColor.redColor()//测试用
        self.headerView.addSubview(collectionV!)
        self.headerView.frame.size.height = 250+(collectionV?.frame.size.height)!
        self.mytableView.tableHeaderView = self.headerView
        
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
        
        let image = self.photoArray[indexPath.item]
        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
        var myImagess = UIImage()
        myImagess = UIImage.init(data: data)!
        
        cell.button.setBackgroundImage(myImagess, forState: UIControlState.Normal)
        cell.button.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //            (self.photoArray[indexPath.item].asset.aspectRatioThumbnail().takeUnretainedValue(), forState: UIControlState.Normal)
        
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
       
        myVC.myPhotoArray =  self.photoArray
        
        myVC.title = "查看图片"
        myVC.count = sender.tag
        print(sender.tag)
        
        self.navigationController?.pushViewController(myVC, animated: true)
         myVC.hidesBottomBarWhenPushed = false
        
//        let lookPhotosImageView = UIImageView()
//        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
//        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
//        
//        let image = self.photoArray[sender.tag]
//        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
//        
//        //        let representation =  self.photoArray[sender.tag].asset.defaultRepresentation()
//        //        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
//        //        let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
//        //                                                 length: Int(representation.size()), error: nil)
//        //        let data:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
//        
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
            self.mytableView.tableHeaderView = self.headerView
            //            })
            
        }
        if self.photoArray.count == 0 {
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            self.addCollectionViewPicture()
        }
        
    }
    
    //    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    //
    //              return true
    //    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let frame:CGRect = textView.frame
        let offset:CGFloat = frame.origin.y+70-(self.view.frame.size.height-216.0)
        UIView.animateWithDuration(0.4, animations: {
            if offset > 0{
                self.mytableView.frame.origin.y = -offset
            }
            
        })
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.mytableView.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print(textField.tag)
        let frame:CGRect = textField.frame
        print(self.view.frame.size.height-216.0)
        print(frame.origin.y)
        let height = textField.tag*50-100
        let offset:CGFloat = WIDTH*240/375+frame.origin.y+70-(self.view.frame.size.height-216.0)+CGFloat(height)
        print(offset)
        UIView.animateWithDuration(0.4, animations: {
            if offset > 0{
                self.mytableView.frame.origin.y = -offset
            }
            
        })
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.mytableView.frame.origin.y = 0
//        print(self.mytextView.text!.characters.count)
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
