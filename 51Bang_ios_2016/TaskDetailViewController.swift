//
//  TaskDetailViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AVFoundation

class TaskDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate {
    let myTableView = UITableView()
    var myPhotoArray = NSMutableArray()
    var collectionV:UICollectionView?
    var taskInfo = TaskInfo()
    var dataSource : Array<commentlistInfo>?//评价
    var dataSource3 : Array<chatInfo>?
    let mainHelper = MainHelper()
    var soundName = NSURL()
    var btn = UIButton()
    var qiangdanBut=Bool()
    
    var player = AVPlayer()
    
    var imageView = UIImageView()
    
    var timer1 = NSTimer()
    
    var timesCount = Int()
    
    var audioSession = AVAudioSession()
    

    
    override func viewWillAppear(animated: Bool) {
        audioSession = AVAudioSession.sharedInstance()
        do{
            //            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
            try audioSession.setActive(true)
        }catch{
            
        }
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(taskInfo)
        let vc = MineViewController()
        vc.Checktoubao()
        
       
        
        self.dataSource = self.taskInfo.commentlist
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "TaskDetailTableViewCell1",bundle: nil), forCellReuseIdentifier: "cell1")
        myTableView.registerNib(UINib(nibName: "TaskDetailTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell2")
        btn = UIButton(frame: CGRectMake(0, 0, WIDTH, 40))
        btn.layer.cornerRadius = 8
        btn.setTitle("立即抢单", forState: .Normal)
        btn.addTarget(self, action: #selector(self.qiangdan), forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        if qiangdanBut{
            btn.hidden = true
        }else {
            btn.hidden = true//隐藏掉，过期的单子还是会被抢
        }
        if self.taskInfo.state != "1" {
            btn.hidden = true
        }

//        btn.addTarget(self, action: #selector(self.nextToView), forControlEvent
        let view = UIView()
        myTableView.tableFooterView = view
        self.myTableView.tableFooterView = btn
        self.view.addSubview(myTableView)
//        soundName =  mainHelper.downloadRecond(self.taskInfo.record!)
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.dataSource?.count > 0 {
            return 8 + (self.dataSource?.count)!
        }else{
            return 7
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row > 7 {
            let str = dataSource![indexPath.row-8].content
            let height = calculateHeight( str!, size: 15, width: WIDTH - 10 )
            return 75 + height + 20
        }
        
        
        
        if indexPath.row == 0 {
            return 80
        }else if indexPath.row == 3{
            print(taskInfo.sound)
            print(taskInfo.pic?.count)
            if taskInfo.sound == "" || taskInfo.sound == nil {
                
                let a = CGFloat(Int((taskInfo.pic!.count+2)/3)) * ((WIDTH-5) / 3 + 10)
                print(a)
                return a
                
            }else{
                let a = (60 + CGFloat(Int((taskInfo.pic!.count+2)/3)) * (WIDTH-5)/3)
                print(a)
//                var a = CGFloat()
                
                return a
            }
            
        }else{
            return 50
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1") as! TaskDetailTableViewCell1
            cell.call.addTarget(self, action: #selector(self.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
            cell.message.addTarget(self, action: #selector(self.messageSend), forControlEvents: UIControlEvents.TouchUpInside)
            cell.selectionStyle = .None
            cell.username.text = self.taskInfo.name
            cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
            cell.icon.clipsToBounds = true
            
            if taskInfo.photo == nil {
                cell.icon.image = UIImage(named:"ic_moren")
            }else{
                let photoUrl:String = Bang_Open_Header+"uploads/images/"+taskInfo.photo!
                print(photoUrl)
                cell.icon.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! TaskDetailTableViewCell2
            cell.title.text = "任务号"
            cell.selectionStyle = .None
            cell.desc.text = self.taskInfo.order_num
            return cell
            
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! TaskDetailTableViewCell2
            cell.title.text = "任务"
            cell.selectionStyle = .None
            cell.desc.text = self.taskInfo.title
            return cell
            
        }else if indexPath.row == 3{
            
            let cell = UITableViewCell()
            let imshow = UIView()
            cell.selectionStyle = .None
            var imcount = 0
            for ima in self.taskInfo.pic!
            {
                let imview = UIImageView()
                
                imview.tag = imcount+100
                
                let url = Bang_Image_Header+self.taskInfo.pic![imcount].pictureurl!
                
                print(url)
                
                
                imview.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "1.png"))
                
                switch imcount / 3 {
                case 0:
                    imview.frame = CGRectMake( CGFloat( imcount ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3, (WIDTH) / 3 - 5 , WIDTH / 3 )
                case 1:
                    imview.frame = CGRectMake( CGFloat( imcount-3) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 5, (WIDTH) / 3 - 5 , WIDTH / 3 )
                case 2:
                    imview.frame = CGRectMake( CGFloat( imcount-6 ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 10, (WIDTH) / 3 - 5 , WIDTH / 3 )
                default: break
                    
                }
                let backButton = UIButton()
                backButton.frame = imview.frame
//                backButton.frame.origin.y = imview.frame.origin.y + 98
                backButton.backgroundColor = UIColor.clearColor()
                backButton.tag = imcount
                
                backButton .addTarget(self, action:#selector(self.lookImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                
                imshow.addSubview(imview)
                imcount += 1
                imshow.addSubview(backButton)
                myPhotoArray.addObject(imview)
            }
            var picHeight:CGFloat = 0
            switch (self.taskInfo.pic!.count+2) / 3 {
                
            case 0:
                picHeight = 0
            case 1:
                picHeight = WIDTH / 3
            case 2:
                picHeight = WIDTH / 3 * 2
            default:
                picHeight = WIDTH
            }
            var boFangButton = UIButton()
            if self.taskInfo.sound != nil && self.taskInfo.sound != "" {
                print(self.taskInfo.sound)
                
                if self.taskInfo.pic!.count>0 {
                    boFangButton = UIButton.init(frame: CGRectMake(20,
                        5 + picHeight+20,114, 30))
                }else{
                    boFangButton = UIButton.init(frame: CGRectMake(20,
                        20 + 5,114, 30))
                }
                
                boFangButton.backgroundColor = UIColor.clearColor()
                
                if taskInfo.soundtime != nil{
                    boFangButton.setTitle((taskInfo.soundtime! as String + "\""), forState: UIControlState.Normal)
                }else{
                    boFangButton.setTitle("0" + "\"", forState: UIControlState.Normal)
                }
                boFangButton.addTarget(self, action: #selector(self.boFangButtonActions(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                boFangButton.setBackgroundImage(UIImage(named: "ic_yuyino3"), forState: UIControlState.Normal)
                boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                boFangButton.layer.masksToBounds = true
                //        boFangButton.layer.borderWidth = 1
                //        boFangButton.layer.borderColor = GREY.CGColor
                boFangButton.layer.cornerRadius = 10
                boFangButton.layer.shadowColor = UIColor.blackColor().CGColor
                boFangButton.layer.shadowOffset = CGSizeMake(20.0, 20.0)
                boFangButton.layer.shadowOpacity = 0.7
                imshow.addSubview(boFangButton)
                imshow.frame = CGRectMake(0, 5 , WIDTH, picHeight+80)
                
            }else{
                imshow.frame = CGRectMake(0, 5,  WIDTH, picHeight)
            }

            
            
            cell.addSubview(imshow)
            
            
            
            
            
//            let cell = UITableViewCell()
//            cell.userInteractionEnabled = false
//            let flowl = UICollectionViewFlowLayout.init()
//            //设置每一个item大小
//            flowl.itemSize = CGSizeMake((WIDTH-60)/3, (WIDTH-60)/3)
//            flowl.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
//            flowl.minimumInteritemSpacing = 10
//            flowl.minimumLineSpacing = 10
//            print(self.taskInfo.pic!.count)
//            var height =  CGFloat(((self.taskInfo.pic!.count-1)/3))*((WIDTH-60)/3+10)+((WIDTH-60)/3+10)
//            if self.taskInfo.pic!.count == 0 {
//                height = 0
//            }
//            //创建集合视图
//            
//            self.collectionV = UICollectionView.init(frame: CGRectMake(0, 0, WIDTH, height), collectionViewLayout: flowl)
//            collectionV!.backgroundColor = UIColor.whiteColor()
//            collectionV!.delegate = self
//            collectionV!.dataSource = self
//            //        collectionV?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
//            collectionV!.registerNib(UINib(nibName: "PhotoCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
//            if self.taskInfo.record == "" || self.taskInfo.record == nil{
//                
//            }else{
//                let boFangButton = UIButton.init(frame: CGRectMake(20, collectionV!.height+20,114, 30))
//                boFangButton.backgroundColor = UIColor.clearColor()
//                boFangButton.setTitle(" 点击播放", forState: UIControlState.Normal)
//                boFangButton.setBackgroundImage(UIImage(named: "ic_yinpinbeijing"), forState: UIControlState.Normal)
//                boFangButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//                boFangButton.addTarget(self, action: #selector(self.boFangButtonActions), forControlEvents: UIControlEvents.TouchUpInside)
//                boFangButton.layer.masksToBounds = true
//                //        boFangButton.layer.borderWidth = 1
//                //        boFangButton.layer.borderColor = GREY.CGColor
//                boFangButton.layer.cornerRadius = 10
//                boFangButton.layer.shadowColor = UIColor.blackColor().CGColor
//                boFangButton.layer.shadowOffset = CGSizeMake(20.0, 20.0)
//                boFangButton.layer.shadowOpacity = 0.7
//                cell.addSubview(boFangButton)
//                
//            }
//            
//            cell.addSubview(collectionV!)
            return cell
            
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! TaskDetailTableViewCell2
            cell.title.text = "服务费"
            cell.selectionStyle = .None
            cell.desc.text = self.taskInfo.price
            return cell
            
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! TaskDetailTableViewCell2
            cell.title.text = "上门地址"
            cell.selectionStyle = .None
            cell.desc.text = self.taskInfo.address
            return cell
            
        }else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! TaskDetailTableViewCell2
            cell.title.text = "有效期"
            cell.selectionStyle = .None
            let time = timeStampToString(self.taskInfo.expirydate!)
            cell.desc.text = time
            tableView.separatorStyle = .None
            return cell
        }else if indexPath.row == 7{
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
        }else{
            if self.dataSource?.count>0 {
                let cell = ConveniceCell.init(myinfo: self.dataSource![indexPath.row-8] )
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
    
    
    func boFangButtonActions(sender:UIButton){
        
        
        timer1.invalidate()
        if taskInfo.soundtime != nil && taskInfo.soundtime != ""{
            timesCount =  Int(taskInfo.soundtime!)! + 1
        }else{
            timesCount =  1
        }
        
        
        
        imageView.removeFromSuperview()
        //        player.
        
        imageView = UIImageView.init(frame: CGRectMake(0, 0, sender.width, sender.height))
        imageView.animationImages =  [UIImage(named:"ic_yuyino1")!,UIImage(named:"ic_yuyino2")!,UIImage(named:"ic_yuyino3")!]
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.userInteractionEnabled = false
        imageView.backgroundColor = UIColor.clearColor()
        sender.addSubview(imageView)
        imageView.startAnimating()
        
        let item = AVPlayerItem.init(URL:NSURL.init(string: Bang_Image_Header + (taskInfo.sound!))!)
        
        player = AVPlayer.init(playerItem: item)
        player.volume = 1
        player.allowsExternalPlayback = true
        player.play()
        
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1,
                                                        target:self,selector:#selector(self.recordTimeTick),
                                                        userInfo:nil,repeats:true)
        
//        mainHelper.downloadRecond(self.taskInfo.record!){ (success, response) in
//            if !success{
//                alert("加载语音失败", delegate: self)
//                return
//            }
//            let str = response
//            print(str)
//        }

        
//        print("0000")
//        do{
//            let audioPlayer = try AVAudioPlayer.init(contentsOfURL:soundName)
//            audioPlayer.prepareToPlay()
//            audioPlayer.volume = 1;
//            audioPlayer.play()
//        }catch{
//            
//        }
        
        
    }
    
    func recordTimeTick(){
        timesCount = timesCount - 1
        if timesCount < 0{
            imageView.removeFromSuperview()
            timer1.invalidate()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.taskInfo.pic!.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let myVC = LookPhotoVC()
        myVC.hidesBottomBarWhenPushed = true
        myVC.myPhotoArray =  myPhotoArray
        myVC.pic = self.taskInfo.pic!
        myVC.count = indexPath.item
        myVC.title = "查看图片"
        self.navigationController?.pushViewController(myVC, animated: true)
        myVC.hidesBottomBarWhenPushed = false
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = CollectionViewCell()
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photo", forIndexPath: indexPath)as! PhotoCollectionViewCell
//        //        print(self.photoArray[indexPath.item] as? UIImage)
//        cell.button.tag = indexPath.item
//        cell.button.backgroundColor = UIColor.redColor()
//        cell.button.hidden = true
//        cell.myImage.hidden = true
        
        var imcount = 0
        for ima in self.taskInfo.pic! {
            let imageurl = Bang_Image_Header + self.taskInfo.pic![indexPath.item].pictureurl!
            let imview = UIImageView()
            print(imageurl)
            imview.sd_setImageWithURL(NSURL(string:imageurl), placeholderImage: UIImage(named: "1.png"), completed: { (myImage, error, sdimageType, url) in
                self.myPhotoArray.addObject(myImage)
                
                
            })
//            imview.sd_setImageWithURL(NSURL(string:imageurl), placeholderImage: UIImage(named: "1.png"))
            switch imcount / 3 {
            case 0:
                imview.frame = CGRectMake( CGFloat( imcount ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3, (WIDTH) / 3 - 5 , WIDTH / 3 )
            case 1:
                imview.frame = CGRectMake( CGFloat( imcount-3) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 5, (WIDTH) / 3 - 5 , WIDTH / 3 )
            case 2:
                imview.frame = CGRectMake( CGFloat( imcount-6 ) * (WIDTH-5) / 3 + 5  , ( CGFloat (imcount / 3) ) * (WIDTH-5) / 3 + 10, (WIDTH) / 3 - 5 , WIDTH / 3 )
            default: break
//                imview.frame = CGRectMake(0, 0, 0, 0)
            }
            cell.addSubview(imview)

            /////添加tapGuestureRecognizer手势
//            let tapGR = UITapGestureRecognizer(target: self, action:#selector(self.lookImage(_:)))
//            tapGR.numberOfTapsRequired = imcount
//            imview.addGestureRecognizer(tapGR)
            let backButton = UIButton()
            backButton.frame = imview.frame
            backButton.frame.origin.y = imview.frame.origin.y + 98
            backButton.backgroundColor = UIColor.redColor()
            backButton.tag = imcount
//
            backButton.addTarget(self, action:#selector(self.lookImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//
            cell.addSubview(backButton)
            imcount += 1
            
            
            
        }
        
        
        
        
        
        return cell
    }
        
        
        
    func lookImage(sender:UIButton) {
        let myVC = LookPhotoVC()
        myVC.hidesBottomBarWhenPushed = true
        myVC.myPhotoArray =  myPhotoArray
        myVC.pic = self.taskInfo.pic!
        myVC.count = sender.tag
        myVC.title = "查看图片"
        self.navigationController?.pushViewController(myVC, animated: true)
        myVC.hidesBottomBarWhenPushed = false
        }
        
    
    func qiangdan(){
        
        var userid = String()
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        //         = ud.objectForKey("userid")as! String
        if userid == taskInfo.userid {
            alert("不能抢自己的单", delegate: self)
            return
        }
        
        
        if(ud.objectForKey("ss") != nil){
            if(ud.objectForKey("ss") as! String == "no"){
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "是否去实名认证？", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .Default,
                                             handler: { action in
                                                let vc = CertificationViewController()
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
                
            }else{
                if (ud.objectForKey("baoxiangrenzheng") != nil && ud.objectForKey("baoxiangrenzheng") as! String == "no") {
                    
                    let alertController = UIAlertController(title: "系统提示",
                                                            message: "请先投保在抢单，是否去投保？", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                    let okAction = UIAlertAction(title: "确定", style: .Default,
                                                 handler: { action in
                                                    
                                                    print(ud.objectForKey("baoxiangrenzheng") as! String)
                                                    let vc2 = MyInsure()
                                                    self.navigationController?.pushViewController(vc2, animated: true)
                                                    
                                                    
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
            }
        }
        
        
       
//        let ud = NSUserDefaults.standardUserDefaults()
//        if (ud.objectForKey("baoxiangrenzheng") != nil && ud.objectForKey("baoxiangrenzheng") as! String == "no") {
//            
//            let alertController = UIAlertController(title: "系统提示",
//                                                    message: "请先投保在抢单，是否去投保？", preferredStyle: .Alert)
//            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//            let okAction = UIAlertAction(title: "确定", style: .Default,
//                                         handler: { action in
//                                            
//                                            print(ud.objectForKey("baoxiangrenzheng") as! String)
//                                            let vc2 = MyInsure()
//                                            self.navigationController?.pushViewController(vc2, animated: true)
//                                            
//                                            
//            })
//            alertController.addAction(cancelAction)
//            alertController.addAction(okAction)
//            self.presentViewController(alertController, animated: true, completion: nil)
//            return
//        }
        
        btn.enabled = false
        print("抢单")
//        let ud = NSUserDefaults.standardUserDefaults()
//        let userid = ud.objectForKey("userid")as! String
        var longitude = String()
        var latitude = String()
        //        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("longitude") != nil && ud.objectForKey("latitude") != nil {
            longitude = ud.objectForKey("longitude")as! String
            latitude = ud.objectForKey("latitude")as! String
        }
        print(longitude)
        
        print(latitude)
        
        let str = String(longitude)
        let array:NSArray = str.componentsSeparatedByString("(")
        let str2 = array[0]as! String
        let array2 = str2.componentsSeparatedByString(")")
        let str3 = array2[0]
        print(str3)
        
        let str4 = String(latitude)
        let array3:NSArray = str4.componentsSeparatedByString("(")
        let str5 = array3[0]as! String
        let array4 = str5.componentsSeparatedByString(")")
        let str6 = array4[0]
        print(str6)
        
        mainHelper.qiangDan(userid, taskid: taskInfo.id!, longitude: str3, latitude: str6) { (success, response) in
            print(response)
            if !success {
                alert("抢单失败！", delegate: self)
                self.btn.enabled = true
                return
            }
//            let ud = NSUserDefaults.standardUserDefaults()
//            let userid = ud.objectForKey("userid")as! String
//            self.mainHelper.gaiBianRenWu(userid,ordernum: self.taskInfo.order_num! as String, state: "2") { (success, response) in
//                if !success {
//                    return
//                }
//                
//            }
            
            
            let vc = MyTaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }

        
            }
    
    func callPhone(){
        
        print(self.taskInfo.phone!)
//        let phone = removeOptionWithString(self.taskInfo.phone!)
//        print(phone)
        let alertController = UIAlertController(title: "系统提示",
                                                message: "是否要拨打电话？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        
                                        UIApplication.sharedApplication().openURL(NSURL(string :"tel://"+"\(self.taskInfo.phone!)")!)
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
//        UIApplication.sharedApplication().openURL(NSURL(string :"tel://15974462468")!)
    }
    
    func messageSend(){
        let vc = ChetViewController()
        vc.receive_uid = taskInfo.id
        vc.titleTop = taskInfo.name
        //        vc.datasource2 = NSMutableArray()
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        if userid == taskInfo.userid{
            alert("请不要和自己说话", delegate: self)
        }else{
            mainHelper.getChatMessage(userid, receive_uid: taskInfo.userid!) { (success, response) in
                
                if !success {
                    alert("加载错误", delegate: self)
                    return
                }
                let dat = NSMutableArray()
                self.dataSource3 = response as? Array<chatInfo> ?? []
                print(self.dataSource3)
                if self.dataSource3?.count != 0{
                    for num in 0...self.dataSource3!.count-1{
                        let dic = NSMutableDictionary()
                        dic.setObject(self.dataSource3![num].id!, forKey: "id")
                        dic.setObject(self.dataSource3![num].send_uid!, forKey: "send_uid")
                        dic.setObject(self.dataSource3![num].receive_uid!, forKey: "receive_uid")
                        dic.setObject(self.dataSource3![num].content!, forKey: "content")
                        dic.setObject(self.dataSource3![num].status!, forKey: "status")
                        dic.setObject(self.dataSource3![num].create_time!, forKey: "create_time")
                        if self.dataSource3![num].send_face != nil{
                            dic.setObject(self.dataSource3![num].send_face!, forKey: "send_face")
                        }
                        
                        if self.dataSource3![num].send_nickname != nil{
                            dic.setObject(self.dataSource3![num].send_nickname!, forKey: "send_nickname")
                        }
                        
                        if self.dataSource3![num].receive_face != nil{
                            dic.setObject(self.dataSource3![num].receive_face!, forKey: "receive_face")
                        }
                        
                        if self.dataSource3![num].receive_nickname != nil{
                            dic.setObject(self.dataSource3![num].receive_nickname!, forKey: "receive_nickname")
                        }
                        
                        
                        dat.addObject(dic)
                        
                        //                vc.datasource2.addObject(dic)
                        
                    }
                    
                    print(dat)
                    vc.datasource2 = NSArray.init(array: dat) as Array
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }
           
        }

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
