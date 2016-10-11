//
//  FaBuBianMinViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/7.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVFoundation
import Alamofire

var type = Int()
class FaBuBianMinViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,AVAudioRecorderDelegate,UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate{
    var isRecord = Bool()
    
    var timer:NSTimer!
    var timer1:NSTimer!
    var timer2:NSTimer!
//    var phone = String()
    
    var deletebutton = UIButton()
    let boFangButton = UIButton()
    var myPhotoCount = NSInteger()
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
    var hud1 = MBProgressHUD()
    
    var sound  = NSString()
    let headerView = UIView()
    var photoArray:NSMutableArray = []
    let photoPushButton = UIButton()
    let myTableViw = UITableView()
    var collectionV:UICollectionView?
    let photoNameArr = NSMutableArray()
    let mainHelper = MainHelper()
    private let GET_ID_KEY = "record"
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    //    var audioRecorder:AVAudioRecorder!
    //    var audioPlayer:AVAudioPlayer!
    let timeButton = UIButton()
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSetting = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 2),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.High.rawValue)),//音频质量
        AVLinearPCMBitDepthKey: NSNumber(int: 2)
    ]
    
    func keyboardWillShow(note:NSNotification){
        
        let userInfo  = note.userInfo as! NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let deltaY = keyBoardBounds.size.height/2
        
        UIView.animateWithDuration(0.4, animations: {
            self.myTableViw.frame.origin.y = -deltaY
        })
        
    }
    
    func keyboardWillHide(note:NSNotification){
        
        UIView.animateWithDuration(0.4, animations: {
            self.myTableViw.frame.origin.y = 0
        })
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布便民信息"
        type = 0
        isRecord = false
        myTableViw.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableViw.delegate = self
        myTableViw.dataSource = self
        myTableViw.backgroundColor = RGREY
        myTableViw.registerNib(UINib(nibName: "LianXiDianHuaTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        //myTableViw.registerNib(UINib(nibName: "LianXiDianHuaTableViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        //myTableViw.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let view = UIView()
        self.myTableViw.tableFooterView = view
        self.myTableViw.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.view.addSubview(myTableViw)
        
        self.createTextView()
        //        time()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.fabu))
        //
        //        let audioSession = AVAudioSession.sharedInstance()
        //        do {
        //            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
        //                                                settings: recordSettings)//初始化实例
        //            audioRecorder.prepareToRecord()//准备录音
        //        } catch {
        //        }
        //        TimeManager.shareManager.taskDic[GET_ID_KEY]?.FHandle = finishHandle
        //        TimeManager.shareManager.taskDic[GET_ID_KEY]?.PHandle = processHandle
        //
        //
        ////         Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic[GET_ID_KEY]?.FHandle = nil
        TimeManager.shareManager.taskDic[GET_ID_KEY]?.PHandle = nil
    }
    
    //    func passPhotos(selected:[ZuberImage]){
    //        photoArray = selected
    //        print(selected)
    //        self.addCollectionViewPicture()
    ////        if selected.count>0 {
    ////
    ////            photoPushButton.frame = CGRectMake(WIDTH/2-40, self.collectionV!.height+WIDTH*210/375+20, 80, 40)
    ////            photoPushButton.backgroundColor = COLOR
    ////            photoPushButton.layer.masksToBounds = true
    ////            photoPushButton.layer.cornerRadius = 5
    ////            photoPushButton.setTitle("上传图片", forState: UIControlState.Normal)
    ////            photoPushButton.addTarget(self, action: #selector(self.pushPhotoAction), forControlEvents: UIControlEvents.TouchUpInside)
    ////            self.headerView.addSubview(photoPushButton)
    ////            self.headerView.height = self.collectionV!.height+WIDTH*210/375+80
    ////            self.myTableViw.tableHeaderView = self.headerView
    ////        }
    //
    //    }
    
    func directoryURL() -> NSURL? {
        //定义并构建一个url来保存音频，音频文件名为ddMMyyyyHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(recordingName)
        print(soundURL)
        return soundURL
    }
    
    
    func createTextView(){
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*220/375)
        //        headerView.backgroundColor = UIColor.greenColor()
        let textView = PlaceholderTextView.init(frame: CGRectMake(0, 0, WIDTH, WIDTH*200/375))
        textView.tag = 1
        textView.backgroundColor = UIColor.whiteColor()
        textView.delegate = self
        textView.textAlignment = .Left
        textView.editable = true
        textView.layer.cornerRadius = 4.0
        //        textView.layer.borderColor = kTextBorderColor.CGColor
        textView.layer.borderWidth = 0
        textView.placeholder = "禁止发布黄、赌，毒，违反国家法律的言论及图片"
        let button = UIButton.init(frame: CGRectMake(20, textView.frame.size.height-30, 30, 30))
        button.setImage(UIImage(named: "ic_tupian"), forState: UIControlState.Normal)
        button.layer.borderColor = UIColor.grayColor().CGColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(self.goToCamera(_:)), forControlEvents: .TouchUpInside)
        let yinPin = UIButton.init(frame: CGRectMake(80, textView.frame.size.height-30, 30, 30))
        yinPin.setImage(UIImage(named: "ic_yinpin"), forState: UIControlState.Normal)
        yinPin.layer.borderColor = UIColor.grayColor().CGColor
        yinPin.layer.borderWidth = 1.0
        yinPin.layer.cornerRadius = 15
        yinPin.layer.masksToBounds = true
        yinPin.addTarget(self, action: #selector(self.startRecord), forControlEvents: UIControlEvents.TouchUpInside)
        let shiPin = UIButton.init(frame: CGRectMake(140, textView.frame.size.height-30, 30, 30))
        shiPin.setImage(UIImage(named: "ic_shipin"), forState: UIControlState.Normal)
        
        textView.addSubview(button)
//        textView.addSubview(yinPin)//语音录制按钮
        //        textView.addSubview(shiPin)
        let line = UILabel.init(frame: CGRectMake(0, button.frame.size.height+button.frame.origin.y+10, WIDTH, 1))
        line.backgroundColor = RGREY
        //        let JINGGAOLabel = UILabel()
        //        JINGGAOLabel.frame = CGRectMake(0, WIDTH*200/375, WIDTH, 20)
        //        JINGGAOLabel.text = "禁止发布黄、赌，毒，违反国家法律的言论及图片"
        //        JINGGAOLabel.backgroundColor = GREY
        //        JINGGAOLabel.textColor = UIColor.redColor()
        //        self.headerView.addSubview(JINGGAOLabel)
        headerView.addSubview(textView)
        //        headerView.addSubview(line)
        self.myTableViw.tableHeaderView = headerView
        //        myTableViw.tableHeaderView = textView
        //        self.view.addSubview(textView)
    }
    
    //录音
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
        
        
        
        
        
        
        //        if isRecord == false {
        //             //开始录音
        //            if !audioRecorder.recording {
        //                let audioSession = AVAudioSession.sharedInstance()
        //                do {
        //
        //                    TimeManager.shareManager.begainTimerWithKey(self.GET_ID_KEY, timeInterval: 60, process: self.processHandle!, finish: self.finishHandle!)
        //                    self.view.addSubview(self.timeButton)
        //                    try audioSession.setActive(true)
        //                    audioRecorder.record()
        //                    print(audioRecorder.currentTime)
        //                    print("record!")
        //                } catch {
        //                }
        //            }
        //            isRecord = true
        //        }else if isRecord == true{
        //            //停止录音
        //            audioRecorder.stop()
        //
        //            let audioSession = AVAudioSession.sharedInstance()
        //
        //            do {
        //                try audioSession.setActive(false)
        //                print("stop!!")
        //                self.timeButton.removeFromSuperview()
        ////                TimeManager.shareManager
        //                try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
        //                print(audioPlayer.duration)
        //
        ////                let image = UIImage.init(named: "ic_yinpinbeijing-1")
        ////                self.photoArray.addObject(image!)
        //                type = 1
        //                self.addCollectionViewPicture()
        //
        //                isRecord = false
        //            } catch {
        //            }
        //
        //        }
        //
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
        //           buttonFloat = CGFloat(self.recordTime*15)
        //        }
        boFangButton.removeFromSuperview()
        boFangButton.frame = CGRectMake(20, collectionV!.height+WIDTH*210/375+20,114 , 30)
        
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
        self.headerView.height = collectionV!.height+WIDTH*210/375+70
        self.myTableViw.tableHeaderView = self.headerView
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
            
            
            if (recordUrl.absoluteString != "") {
                try self.audioPlayer = AVAudioPlayer.init(contentsOfURL: self.recordUrl)
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
    
    func time(){
        
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                
                self.timeButton.frame = CGRectMake(WIDTH/2-50, 200, 100, 100)
                self.timeButton.backgroundColor = UIColor.grayColor()
                self.timeButton.layer.cornerRadius = 50
                self.timeButton.alpha = 0.6
                print(String(timeInterVal))
                self.timeButton.setTitle(String(timeInterVal), forState: UIControlState.Normal)
                //                self.view.addSubview(self.timeButton)
                //                self.checkNumBtn.userInteractionEnabled = false
                //                let btnTitle = String(timeInterVal) + "秒后重新获取"
                //                self.checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                //                self.checkNumBtn.setTitleColor(COLOR, forState: .Normal)
                //
                //                self.checkNumBtn.setTitle(btnTitle, forState: .Normal)
                
                
                
            })
        }
        
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                
                self.timeButton.removeFromSuperview()
                self.isRecord = false
                //                self.checkNumBtn.userInteractionEnabled = true
                //                self.checkNumBtn.setTitleColor(COLOR, forState: .Normal)
                //                self.checkNumBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
                //                self.checkNumBtn.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic["forget"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["forget"]?.PHandle = processHandle
    }
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        self.photoArray.removeAllObjects()
        for imagess in photos {
            photoArray.addObject(imagess)
        }
        self.addCollectionViewPicture()
        if self.mp3FilePath.absoluteString != ""{
        boFangButton.removeFromSuperview()
        boFangButton.frame = CGRectMake(20, collectionV!.height+WIDTH*210/375+20,114 , 30)
        
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
        self.headerView.height = collectionV!.height+WIDTH*210/375+70
        self.myTableViw.tableHeaderView = self.headerView
        self.timeLabel.text = ""
        }
        
    }
    
    func goToCamera(btn:UIButton){
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 9, delegate:self)
        
        //        let VC1 =  ViewController1()
        //        VC1.photoDelegate = self
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
        
        //        print("上传图片")
        //        print(btn.tag)
        //        let imagePicker = UIImagePickerController();
        //        imagePicker.delegate = self
        //        imagePicker.allowsEditing = true
        //        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //上传图片的协议与代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //        let image = info[UIImagePickerControllerEditedImage]as! UIImage
        //        self.photoArray.addObject(image)
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
    //MARK:创建图片视图
    func addCollectionViewPicture(){
        
        let flowl = UICollectionViewFlowLayout.init()
        //设置每一个item大小
        
        flowl.itemSize = CGSizeMake((WIDTH-60)/3, (WIDTH-60)/3)
        //        flowl.sectionInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        flowl.sectionInset = UIEdgeInsetsMake(10, 10, 5, 10)
        flowl.minimumInteritemSpacing = 10
        flowl.minimumLineSpacing = 10
        print(self.photoArray.count)
        var height =  CGFloat(((self.photoArray.count-1)/3))*((WIDTH-60)/3+10)+((WIDTH-60)/3+10)+10
        if self.photoArray.count == 0 {
            height = 0
        }
        //创建集合视图
        self.collectionV?.removeFromSuperview()
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, WIDTH*210/375, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        //        collectionV?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        collectionV!.registerNib(UINib(nibName: "PhotoCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
        collectionV!.registerNib(UINib(nibName: "SoundCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "yinpin")
        self.headerView.addSubview(collectionV!)
        self.headerView.frame.size.height = WIDTH*210/375+(collectionV?.frame.size.height)!
        self.myTableViw.tableHeaderView = self.headerView
        
        
    }
    
    //    func pushPhotoAction(){
    //        print(photoArray.count)
    //
    //
    //            timer = NSTimer.scheduledTimerWithTimeInterval(1.2,
    //                                                           target:self,selector:#selector(self.pushPhotos),
    //                                                           userInfo:nil,repeats:true)
    //
    //
    //    }
    
    func pushPhotos(){
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        
        
        var isRecord = false
        
        var a = Int()
        a = 0
        if mp3FilePath.absoluteString == "" {
            isRecord = true
        }
        if mp3FilePath.absoluteString != "" {
            print(mp3FilePath.absoluteString)
            
            let data = NSData.init(contentsOfFile: self.mp3FilePath.path!)
            
//            Alamofire.upload(.POST, "http://httpbin.org/post", file: self.mp3FilePath)
            
//            Alamofire.upload(.POST, Bang_URL_Header+"uploadRecord", file: self.mp3FilePath)
            
//            Alamofire.upload(.GET, Bang_URL_Header+"uploadRecord", data: data!)
//                .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
//                    print(totalBytesWritten)
//                }
//                .responseJSON(completionHandler: { (json) in
//                    print(json)
//                    //                    print(error)
//                    
//                })
            
            
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss:SSS"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr + "record"+userid
            print(imageName)
            ConnectModel.uploadWithVideoName(imageName, imageData: data, URL: Bang_URL_Header+"uploadRecord", finish: { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    print(result.status)
                    print(result.data)
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                isRecord = true
                                self.sound = result.data!
                                if a == self.photoArray.count-1||self.photoArray.count == 0{
                                    self.fabuAction()
                                }
                                print("000000000000000000")
                                //                                self.hud1.hide(true)
                                
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
        
        
        if self.photoArray.count != 0 {
            for ima in photoArray {
                
                //                let representation =  ima.asset.defaultRepresentation()
                let image = ima
                let dataPhoto:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
                var myImagess = UIImage()
                myImagess = UIImage.init(data: dataPhoto)!
                
                let data = UIImageJPEGRepresentation(myImagess, 0.1)!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMddHHmmssSSS"
                let dateStr = dateFormatter.stringFromDate(NSDate())
                let imageName = "avatar" + dateStr + String(a) + userid + String(Int(arc4random()%10000)+1)
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
                                    print(a)
                                    print(self.photoArray.count)
                                    
                                    if a == self.photoArray.count-1 && isRecord == true{
                                        self.fabuAction()
                                    }
                                    a = a+1
                                    
                                }else{
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
        }
        
        
        
    }
    
    func fabuAction() {
        
        var adress2 = String()
        var longitude = String()
        var latitude = String()
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("subLocality") != nil && ud.objectForKey("quName") != nil && ud.objectForKey("streetName") != nil {
            adress2 = ud.objectForKey("subLocality") as! String + (ud.objectForKey("quName") as! String) + (ud.objectForKey("streetName") as! String)
        }
        
        if ud.objectForKey("longitude") != nil {
            longitude = ud.objectForKey("longitude") as! String
        }
        if ud.objectForKey("latitude") != nil {
            latitude = ud.objectForKey("latitude") as! String
        }
//        userLocationCenter.setObject(self.dingWeiStr, forKey: "subLocality")
//        userLocationCenter.setObject(result.addressDetail.district, forKey: "quName")
//        //                    print(self.dingWeiStr)
//        userLocationCenter.setObject(self.streetNameStr, forKey: "streetName")
        
        
        print("发表评论")
        
        let textView = self.view.viewWithTag(1)as! PlaceholderTextView
        print(textView.text)
        
//        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        let userPhone = ud.objectForKey("phone")as! String
        
        print(userid)
        print(self.photoNameArr)
        mainHelper.upLoadMessage(userid,phone:userPhone, type: "1", title: textView.text, content: textView.text, photoArray: self.photoNameArr,sound:self.sound,soundtime:String(self.countTime),address2:adress2,longitude:longitude,latitude:latitude) { (success, response) in
            print(response)
            if !success{
                alert("亲，请拨打4000608856申请VIP客户才能多发哦😀", delegate: self)
                
                return
            }
//            self.hud1.hide(true)
           
            //                let aletView = UIAlertView.init(title: "提示", message:"发布成功", delegate: self, cancelButtonTitle: "确定")
            //                aletView.show()
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
//        self.navigationController?.popViewControllerAnimated(true)
        
        
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
        
        cell.button.tag = indexPath.item
        cell.button.setBackgroundImage(self.photoArray[indexPath.item] as? UIImage, forState: UIControlState.Normal)
        cell.button.addTarget(self, action: #selector(self.lookPhotos(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //        cell.myImage.image = self.photoArray[indexPath.item] as? UIImage
        if type == 1 {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("yinpin", forIndexPath: indexPath)as! SoundCollectionViewCell
            //            try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
            print(audioPlayer!.duration)
            cell.myButton.setTitle(String(audioPlayer!.duration), forState: UIControlState.Normal)
            cell.myButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            cell.myButton.frame = CGRectMake(0, 0, cell.frame.size.width, 30)
            //            cell.button.frame.size.height = 30
            //            cell.myButton.backgroundColor = UIColor.redColor()
            //            cell.button.center = cell.center
            cell.frame.size.height = 35
        }
        let button = UIButton.init(frame: CGRectMake(cell.frame.size.width-20, 0, 20, 20))
        button.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(self.deleteImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(button)
        //        cell.myImage.addSubview(button)
        return cell
    }
    
    func lookPhotos(sender:UIButton)  {
        
        let lookPhotosImageView = UIImageView()
        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        
        //        let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
        //        let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
        //                                                 length: Int(representation.size()), error: nil)
        //        let data:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
        let image = self.photoArray[sender.tag]
        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
        var myImagess = UIImage()
        myImagess = UIImage.init(data: data)!
        lookPhotosImageView.image = myImagess
        lookPhotosImageView.contentMode = .ScaleAspectFit
        //        let singleTap1 = UITapGestureRecognizer()
        //        singleTap1.addTarget(self, action: #selector(self.backMyView))
        //        lookPhotosImageView.addGestureRecognizer(singleTap1)
        let myVC = UIViewController()
        myVC.title = "查看图片"
        myVC.view.addSubview(lookPhotosImageView)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myVC, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")as! LianXiDianHuaTableViewCell
//        cell.phone.delegate = self
//        cell.phone.tag = 10
//        cell.phone.keyboardType = UIKeyboardType.NumberPad
//        cell.phone.borderStyle = .None
        let ud = NSUserDefaults.standardUserDefaults()
        let userPhone = ud.objectForKey("phone")as! String
        cell.phone.text = userPhone
        
        return cell
    }
    
    //MARK:发布便民信息
    func fabu(){
//        let textfiled = self.myTableViw.viewWithTag(10)as! UITextField
//        textfiled.resignFirstResponder()
        let textView = self.view.viewWithTag(1)as! PlaceholderTextView
//        if textView.text == "" || self.phone.characters.count<4{
//            let aletView = UIAlertView.init(title: "提示", message:"请填写相关信息", delegate: self, cancelButtonTitle: "确定")
//            aletView.show()
//            return
//        }
        if textView.text == ""{
            let aletView = UIAlertView.init(title: "提示", message:"请填写相关信息", delegate: self, cancelButtonTitle: "确定")
            aletView.show()
            return
        }

//        hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud1.animationType = .Zoom
//        hud1.labelText = "正在努力加载"
        print(mp3FilePath.absoluteString)
        if (self.photoArray.count == 0) && (mp3FilePath.absoluteString == "" ){
            self.fabuAction()
        }else {
            self.pushPhotos()
        }
        
        //        mp3FilePath.absoluteString
        
        //        if self.photoArray.count != 0 {
        //            let aletView = UIAlertView.init(title: "提示", message:"请先上传图片", delegate: self, cancelButtonTitle: "确定")
        //            aletView.show()
        //            return
        //        }
        
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
            self.myTableViw.tableHeaderView = self.headerView
            //            })
            
        }
        if self.photoArray.count == 0 {
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            self.addCollectionViewPicture()
        }
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        let frame:CGRect = textView.frame
        let offset:CGFloat = frame.origin.y+70-(self.view.frame.size.height-216.0)
        UIView.animateWithDuration(0.4, animations: {
            if offset > 0{
                self.myTableViw.frame.origin.y = -offset
            }
            
        })
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.myTableViw.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
            UIView.animateWithDuration(0.4, animations: {
            if self.photoArray.count > 0 && self.photoArray.count < 4 && self.mp3FilePath.absoluteString == "" {
                self.myTableViw.frame.origin.y = -100
            }else if(self.photoArray.count > 3 && self.photoArray.count < 7 && self.mp3FilePath.absoluteString == ""){
                self.myTableViw.frame.origin.y = -100-WIDTH/3
            }else if (self.photoArray.count > 6 && self.mp3FilePath.absoluteString == ""){
                self.myTableViw.frame.origin.y = -25-(WIDTH/3)*2
            }else if(self.photoArray.count > 0 && self.photoArray.count < 4 && self.mp3FilePath.absoluteString != ""){
                self.myTableViw.frame.origin.y = -100-80
            }else if(self.photoArray.count > 3 && self.photoArray.count < 7 && self.mp3FilePath.absoluteString !=  ""){
                self.myTableViw.frame.origin.y = -180-WIDTH/3
                self.myTableViw.frame.size.height = HEIGHT+100
            }else if(self.photoArray.count > 6 && self.mp3FilePath.absoluteString != ""){
                self.myTableViw.frame.origin.y = -70-(WIDTH/3)*2
                self.myTableViw.frame.size.height = HEIGHT+100
            }else if (self.mp3FilePath.absoluteString != "" && self.photoArray.count == 0 ){
                self.myTableViw.frame.origin.y = -50
                }
            
        })
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 10 {
//            self.phone = textField.text!
        }
        self.myTableViw.frame.origin.y = 0
        self.myTableViw.frame.size.height = HEIGHT-64
        
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
