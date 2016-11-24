//
//  OrderCommentViewController.swift
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//


import UIKit
import MBProgressHUD
import AVFoundation

class OrderCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate{
    
    
    var deletebutton = UIButton()
    let boFangButton = UIButton()
    var myPhotoCount = NSInteger()
    let backMHView = UIView()
    var order_num = String()
    let dafenButton1 = UIButton()
    let dafenButton2 = UIButton()
    let dafenButton3 = UIButton()
    let dafenButton4 = UIButton()
    let dafenButton5 = UIButton()
    var gradeNum = String()
    let backView = UIView()//打分view
    var hud1 = MBProgressHUD()
    let headerView = UIView()
    var photoArray:NSMutableArray = []
    let photoPushButton = UIButton()
    let myTableViw = UITableView()
    var collectionV:UICollectionView?
    let photoNameArr = NSMutableArray()
    let mainHelper = MainHelper()
    var WEIXUAN = "ic_yellow_bian"
    var XUANZHONG = "ic_yellowstar_quan"
    var usertype = String()
    var types = String()
    
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    var idStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发表评价"
        self.tabBarController?.tabBar.hidden = true
        type = 0
        self.gradeNum = "1"
        myTableViw.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        myTableViw.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 64)
        myTableViw.delegate = self
        myTableViw.dataSource = self
        myTableViw.backgroundColor = RGREY
        myTableViw.separatorStyle = UITableViewCellSeparatorStyle.None
        myTableViw.registerNib(UINib(nibName: "LianXiDianHuaTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        //myTableViw.registerNib(UINib(nibName: "LianXiDianHuaTableViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        //myTableViw.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let view = UIView()
        self.myTableViw.tableFooterView = view
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
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    
    
    func createTextView(){
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*220/375 + 300)
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
        textView.placeholder = "禁止发布黄、赌，毒，违反国家法律的言论"
        let button = UIButton.init(frame: CGRectMake(20, textView.frame.size.height-30, 30, 30))
        button.setImage(UIImage(named: "ic_tupian"), forState: UIControlState.Normal)
        button.layer.borderColor = UIColor.grayColor().CGColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(self.goToCamera(_:)), forControlEvents: .TouchUpInside)
        
        //        textView.addSubview(button)
        //        textView.addSubview(shiPin)
        let line = UILabel.init(frame: CGRectMake(0, button.frame.size.height+button.frame.origin.y+10, WIDTH, 1))
        line.backgroundColor = RGREY
        
        //添加五角星打分
        
        gradeView()
        
       
        headerView.addSubview(textView)
        headerView.addSubview(backView)
        self.myTableViw.tableHeaderView = headerView
        
    }
    
    
    func gradeView(){
        
        backView.frame = CGRectMake(0, WIDTH*200/375+40, WIDTH, 50)
        backView.backgroundColor = RGREY
        
        let dafenLabel = UILabel.init(frame: CGRectMake(20, 0, 60, 50))
        dafenLabel.backgroundColor = RGREY
        dafenLabel.text = "请打分"
        dafenLabel.textAlignment = .Center
        dafenLabel.textColor = COLOR
        self.backView.addSubview(dafenLabel)
        
        self.dafenButton1.frame = CGRectMake(100, 13, 24, 24)
        self.dafenButton1.backgroundColor = RGREY
        self.dafenButton1.setImage(UIImage(named: XUANZHONG), forState: UIControlState.Normal)
//        self.dafenButton1.setImage(UIImage(named: "ic_kongjianF"), forState: UIControlState.Selected)
        self.dafenButton1.addTarget(self, action: #selector(self.dafenButton1Action), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.dafenButton2.frame = CGRectMake(100+35, 13, 24, 24)
        self.dafenButton2.backgroundColor = RGREY
        self.dafenButton2.setImage(UIImage(named: WEIXUAN), forState: UIControlState.Normal)
        self.dafenButton2.setImage(UIImage(named: XUANZHONG), forState: UIControlState.Selected)
        self.dafenButton2.addTarget(self, action: #selector(self.dafenButton2Action), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.dafenButton3.frame = CGRectMake(100+70, 13, 24, 24)
        self.dafenButton3.backgroundColor = RGREY
        self.dafenButton3.setImage(UIImage(named: WEIXUAN), forState: UIControlState.Normal)
        self.dafenButton3.setImage(UIImage(named: XUANZHONG), forState: UIControlState.Selected)
        self.dafenButton3.addTarget(self, action: #selector(self.dafenButton3Action), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.dafenButton4.frame = CGRectMake(100+105, 13, 24, 24)
        self.dafenButton4.backgroundColor = RGREY
        self.dafenButton4.setImage(UIImage(named: WEIXUAN), forState: UIControlState.Normal)
        self.dafenButton4.setImage(UIImage(named: XUANZHONG), forState: UIControlState.Selected)
        self.dafenButton4.addTarget(self, action: #selector(self.dafenButton4Action), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.dafenButton5.frame = CGRectMake(100+140, 13, 24, 24)
        self.dafenButton5.backgroundColor = RGREY
        self.dafenButton5.setImage(UIImage(named: WEIXUAN), forState: UIControlState.Normal)
        self.dafenButton5.setImage(UIImage(named: XUANZHONG), forState: UIControlState.Selected)
        self.dafenButton5.addTarget(self, action: #selector(self.dafenButton5Action), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.backView.addSubview(self.dafenButton1)
        self.backView.addSubview(self.dafenButton2)
        self.backView.addSubview(self.dafenButton3)
        self.backView.addSubview(self.dafenButton4)
        self.backView.addSubview(self.dafenButton5)
        
        
        
    }
    
    
    func dafenButton1Action(){
        self.dafenButton3.selected = false
        self.dafenButton4.selected = false
        self.dafenButton5.selected = false
        
        self.dafenButton2.selected = false
        self.gradeNum = "1"
    }
    func dafenButton2Action(){
        
            self.dafenButton3.selected = false
            self.dafenButton4.selected = false
            self.dafenButton5.selected = false
        
            self.dafenButton2.selected = true
        self.gradeNum = "2"
    

    }
    func dafenButton3Action(){
        
            self.dafenButton4.selected = false
            self.dafenButton5.selected = false
            self.dafenButton2.selected = true
//            self.dafenButton.selected = true
        
            self.dafenButton3.selected = true
        self.gradeNum = "3"
    }
    func dafenButton4Action(){
        
            self.dafenButton3.selected = true
            self.dafenButton5.selected = false
            self.dafenButton2.selected = true
        
            self.dafenButton4.selected = true
        self.gradeNum = "4"
    }
    func dafenButton5Action(){
        self.dafenButton3.selected = true
        self.dafenButton5.selected = true
        self.dafenButton2.selected = true
        
        self.dafenButton4.selected = true
        self.gradeNum = "5"
    }
    
    
    
    
    
    
    
    
    
    
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        self.photoArray.removeAllObjects()
        self.photoNameArr.removeAllObjects()
        for imagess in photos {
            photoArray.addObject(imagess)
        }
        self.addCollectionViewPicture()
        
    }
    
    func goToCamera(btn:UIButton){
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 9, delegate:self)
        
        
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
        
        
    }
    //上传图片的协议与代理方法
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        self.addCollectionViewPicture()
//        let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyyMMddHHmmss"
//        let dateStr = dateFormatter.stringFromDate(NSDate())
//        let imageName = "avatar" + dateStr
//        
//        //上传图片
//        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                let result = Http(JSONDecoder(data))
//                if result.status != nil {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if result.status! == "success"{
//                            print("....................\(result.data)")
//                            self.photoNameArr.addObject(result.data!)
//                            
//                        }else{
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.labelText = "图片上传失败"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 1)
//                        }
//                    })
//                }
//            })
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
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
        self.headerView.addSubview(collectionV!)
        self.headerView.frame.size.height = WIDTH*210/375+(collectionV?.frame.size.height)!
        self.myTableViw.tableHeaderView = self.headerView
        
        
    }
    
    
    func pushPhotos(){
        var a = Int()
        a = 0
        
        if self.photoArray.count != 0 {
            for ima in photoArray {
                
                //                let representation =  ima.asset.defaultRepresentation()
                let image = ima
                let dataPhoto:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
                var myImagess = UIImage()
                myImagess = UIImage.init(data: dataPhoto)!
                
                let data = UIImageJPEGRepresentation(myImagess, 0.1)!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss:SSS"
                let dateStr = dateFormatter.stringFromDate(NSDate())
                let imageName = "avatar" + dateStr + String(a)
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
                                    
                                    if a == self.photoArray.count-1{
                                        self.fabuAction()
                                    }
                                    a = a+1
                                    
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
        
        
        
    }
    
    func fabuAction() {
        
        print("发表评论")
        
        let textView = self.view.viewWithTag(1)as! PlaceholderTextView
        print(textView.text)
        
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        print(userid)
        print(self.photoNameArr)
        if photoNameArr.count > 0{
            mainHelper.upLoadComment(userid, id: idStr, content: textView.text, type:types,photo:photoNameArr[0] as! NSString,usertype:usertype,score:gradeNum) { (success, response) in
                print(response)
                if !success{
                    alert("数据加载出错请重试", delegate: self)
                    return
                }
                self.hud1.hide(true)
//                self.mainHelper.gaiBianDingdan(self.order_num, state: "10", handle: { (success, response) in
//                    if !success{
//                        alert("数据加载出错请重试", delegate: self)
//                        return
//                    }
//                })
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            
            
        }else{
            mainHelper.upLoadComment(userid, id: idStr, content: textView.text, type: types,photo:"01.png",usertype:usertype,score:gradeNum) { (success, response) in
                
                if !success{
                    alert("数据加载出错请重试", delegate: self)
                    return
                }
                self.hud1.hide(true)
//                self.mainHelper.gaiBianDingdan(self.order_num, state: "10", handle: { (success, response) in
//                    if !success{
//                        alert("数据加载出错请重试", delegate: self)
//                        return
//                    }
//                })

                self.navigationController?.popViewControllerAnimated(true)
                
            }
            
        }
        
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
            
            let button = UIButton.init(frame: CGRectMake(cell.frame.size.width-20, 0, 20, 20))
            button.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(self.deleteImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.addSubview(button)
        }
        //        cell.myImage.addSubview(button)
        return cell
    }
    
    func lookPhotos(sender:UIButton)  {
        
        let lookPhotosImageView = UIImageView()
        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        
        let image = self.photoArray[sender.tag]
        let data:NSData = UIImageJPEGRepresentation(image as! UIImage, 1.0)!
        var myImagess = UIImage()
        myImagess = UIImage.init(data: data)!
        lookPhotosImageView.image = myImagess
        lookPhotosImageView.contentMode = .ScaleAspectFit
        
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
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    //MARK:发表评论
    func fabu(){
        let textView = self.view.viewWithTag(1)as! PlaceholderTextView
        if textView.text == "" {
            let aletView = UIAlertView.init(title: "提示", message:"请填写相关信息", delegate: self, cancelButtonTitle: "确定")
            aletView.show()
            return
        }
        hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud1.animationType = .Zoom
        hud1.labelText = "正在努力加载"
        
        if (self.photoArray.count == 0){
            self.fabuAction()
        }else {
            self.pushPhotos()
        }
        
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
            if self.photoArray.count > 0 && self.photoArray.count < 4  {
                self.myTableViw.frame.origin.y = -100
            }else if(self.photoArray.count > 3 && self.photoArray.count < 7 ){
                self.myTableViw.frame.origin.y = -100-WIDTH/3
            }else if (self.photoArray.count > 6 ){
                self.myTableViw.frame.origin.y = -25-(WIDTH/3)*2
            }else if(self.photoArray.count > 0 && self.photoArray.count < 4 ){
                self.myTableViw.frame.origin.y = -100-80
            }else if(self.photoArray.count > 3 && self.photoArray.count < 7 ){
                self.myTableViw.frame.origin.y = -180-WIDTH/3
                self.myTableViw.frame.size.height = HEIGHT+100
            }else if(self.photoArray.count > 6 ){
                self.myTableViw.frame.origin.y = -70-(WIDTH/3)*2
                self.myTableViw.frame.size.height = HEIGHT+100
            }else if (self.photoArray.count == 0 ){
                self.myTableViw.frame.origin.y = -50
            }
            
        })
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.myTableViw.frame.origin.y = 0
        self.myTableViw.frame.size.height = HEIGHT-64
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
