//
//  GoAdvertisementPublishViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class GoAdvertisementPublishViewController: UIViewController,GKImagePickerDelegate ,UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ALiImageReshapeDelegate,UIActionSheetDelegate{
    
    let mainScrollView = UIScrollView()
    let addImageButton = UIButton()
    let selectImageView = UIImageView()
    var icurDay = NSInteger()
    var icurMonth = NSInteger()
    var icurDYear = NSInteger()
    var sumDayOfMonth = NSInteger()
    var timeDic = NSMutableDictionary()
    var begintimeStampArray:String?
    var endtimeStampArray:String?
    var imagePicker = GKImagePicker()
    var selectedImage : UIImage?
    var selectedImageStr = String()
    var urlTextFiled = UITextField()
    var advMainTextFiled = UITextField()
    var keyBoardHide = Bool()
    let mainHelp = MainHelper()
    var type = "1"
    var price = String()
    let moneyLabel = UILabel()
    var money = String()
    var resultArray:Array<Array<String>> = []
    
    var timeStr1 = String()
    var timeStr2 = String()
    var timeStr3 = String()
    
    var timeday1 = NSInteger()
    var timeday2 = NSInteger()
    var timeday3 = NSInteger()
    
    var nowTimeStr = String()
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        self.title = "广告发布"
        self.view.backgroundColor = UIColor.whiteColor()
        selectImageView.contentMode = .ScaleAspectFit
        let rightButton = UIButton.init(frame: CGRectMake(0, 0, 40, 30))
        rightButton.setTitle("发布", forState: .Normal)
        rightButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightButton.addTarget(self, action: #selector(self.rightButtonAction), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        
        self.creatTimeStr()
        self.creatUI()
        self.getData()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func getData(){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        
        mainHelp.GetMessagePrice(type, userid: userid) { (success, response) in
            if success{
                self.price = response as! String
                self.mainHelp.CheckADIsCanPublish(self.type, userid: userid,  day: [self.timeStr1,self.timeStr2,self.timeStr3], handle: { (success, response) in
                    hud.hide(true)
                    if success{
                        self.resultArray = response as! Array<Array<String>>
                        self.money = "0.00"
                        self.moneyLabel.text = "总价："+self.money+"元"
                        self.begintimeStampArray = nil
                        self.endtimeStampArray = nil
                        for index in 0...2{
                            (self.mainScrollView.viewWithTag(100+index) as! UIButton).selected = false
                            
                            if self.resultArray[index][1] == "1"{
                                (self.mainScrollView.viewWithTag(100+index) as! UIButton).backgroundColor = UIColor.lightGrayColor()
                                (self.mainScrollView.viewWithTag(100+index) as! UIButton).userInteractionEnabled = true
                            }else{
                                (self.mainScrollView.viewWithTag(100+index) as! UIButton).backgroundColor = UIColor.darkGrayColor()
                                (self.mainScrollView.viewWithTag(100+index) as! UIButton).userInteractionEnabled = false
                            }
                        }
                        
                    }
                })
            }else{
                hud.hide(true)
                alert("网络错误，请重试", delegate: self)
            }
        }
    }
    
    func creatTimeStr(){
        //获取当前月份的天数
        let calendar = NSCalendar.currentCalendar()
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: NSDate())
        print(range.length)
        sumDayOfMonth = range.length
        //获取当前是几号
        self.icurDay = calendar.component(.Day, fromDate: NSDate())
        self.icurMonth = calendar.component(.Month, fromDate: NSDate())
        self.icurDYear = calendar.component(.Year, fromDate: NSDate())
        //        print(self.icurMonth)
        //        print(self.icurDYear)
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nowTimeStr = dateFormatter.stringFromDate(NSDate())
        
        
        
        if self.icurDay<11{
            timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-10"
            timeday1 = 11-self.icurDay
            timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-20"
            timeday2 = 10
            timeStr3 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
            timeday3 = sumDayOfMonth-20
        }else if self.icurDay<21&&self.icurDay>10 {
            if self.icurMonth != 12{
                timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-20"
                
                timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
                
                timeStr3 = String(self.icurDYear)+"-"+String(self.icurMonth+1)+"-10"
                
            }else{
                timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-20"
                
                timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
               
                timeStr3 = String(self.icurDYear+1)+"-"+"01"+"-10"
                
            }
            timeday1 = 21-self.icurDay
            timeday2 = sumDayOfMonth-20
            timeday3 = 10
        }else{
            if self.icurMonth != 12{
                timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth+1)+"-10"
                timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
                timeStr3 = String(self.icurDYear)+"-"+String(self.icurMonth+1)+"-20"
            }else{
                timeStr2 = String(self.icurDYear+1)+"-"+"01"+"-10"
                timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
                timeStr3 = String(self.icurDYear+1)+"-"+"01"+"-20"
            }
            timeday1 = sumDayOfMonth-self.icurDay
            timeday2 = 10
            timeday3 = 10
        }
        timeDic.setValue(timeStr1, forKey: "100")
        timeDic.setValue(timeStr2, forKey: "101")
        timeDic.setValue(timeStr3, forKey: "102")
    }
    
    func creatUI(){
        mainScrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        mainScrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mainScrollView)
        
        
        let typeLabel = UILabel.init(frame: CGRectMake(10, 30, 60, 20))
        typeLabel.text = "广告位置:"
        typeLabel.font = UIFont.systemFontOfSize(13)
        typeLabel.textColor = UIColor.blackColor()
        mainScrollView.addSubview(typeLabel)
        
        for index in 1...3 {
            let typeButton = UIButton.init(frame: CGRectMake(90+CGFloat(index*40), 30, 30, 20))
            if index == 1{
                typeButton.selected = true
                typeButton.backgroundColor = COLOR
            }else{
                typeButton.backgroundColor = UIColor.grayColor()
            }
            typeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            typeButton.setTitle(String(index), forState: .Normal)
            typeButton.tag = index
            typeButton.addTarget(self, action: #selector(self.typeButtonAction(_:)), forControlEvents: .TouchUpInside)
            mainScrollView.addSubview(typeButton)
        }
       
        
        let timeLabel = UILabel.init(frame: CGRectMake(10, 80, 100, 20))
        timeLabel.text = "广告播放时间:"
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textColor = UIColor.blackColor()
        mainScrollView.addSubview(timeLabel)
        for index in 0...2 {
            let timesButton = UIButton.init(frame: CGRectMake(50, CGFloat(index*50)+120, WIDTH-100, 30))
            
            timesButton.backgroundColor = UIColor.darkGrayColor()
            timesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            timesButton.userInteractionEnabled = false
//            timesButton.setTitle(String(index), forState: .Normal)
            timesButton.tag = index+100
            timesButton.layer.masksToBounds = true
            timesButton.layer.cornerRadius = 5
            timesButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            timesButton.addTarget(self, action: #selector(self.timesButtonAction(_:)), forControlEvents: .TouchUpInside)
            if index == 0{
                
                timesButton.setTitle(nowTimeStr+"至"+timeStr1, forState: .Normal)
                
            }else if index == 1{
                
                
                let date =  dateFormatter.dateFromString(timeStr1)
                let str1 = dateFormatter.stringFromDate(DateSection(date!,selectDays:1))
                //                print(DateSection(date!,selectDays:1))
                
                timesButton.setTitle(str1+"至"+timeStr2, forState: .Normal)
            }else{
                let date =  dateFormatter.dateFromString(timeStr2)
                let str2 = dateFormatter.stringFromDate(DateSection(date!,selectDays:1))
                timesButton.setTitle(str2+"至"+timeStr3, forState: .Normal)
            }
            
//            if self.resultArray[index][1] == "1"{
//                timesButton.backgroundColor = UIColor.lightGrayColor()
//                timesButton.userInteractionEnabled = true
//            }
            
            
           mainScrollView.addSubview(timesButton)
        }
        
        self.moneyLabel.frame = CGRectMake(0, 255, WIDTH, 30)
        self.moneyLabel.font = UIFont.systemFontOfSize(14)
        self.moneyLabel.textColor = UIColor.blackColor()
        self.moneyLabel.textAlignment = .Center
        self.moneyLabel.text = "总价："+self.money
        self.mainScrollView.addSubview(self.moneyLabel)
        
        
        self.addImageButton.setTitle("添加/更改图片", forState: .Normal)
        self.addImageButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addImageButton.backgroundColor = COLOR
        self.addImageButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.addImageButton.frame = CGRectMake(WIDTH/2-50, 290, 120, 30)
        mainScrollView.addSubview(self.addImageButton)
        self.addImageButton.addTarget(self, action: #selector(self.addImageButtonAction), forControlEvents: .TouchUpInside)
    }
    
    
    func creatImageUI(){
        
        selectImageView.image = self.selectedImage
        
        if self.selectImageView.superview == nil{
            selectImageView.frame = CGRectMake(30, addImageButton.height+addImageButton.frame.origin.y+30, WIDTH-60, WIDTH/2-30)
            selectImageView.contentMode = .ScaleAspectFit
            mainScrollView.addSubview(selectImageView)
        }
        if self.urlTextFiled.superview == nil{
            self.urlTextFiled.frame = CGRectMake(30, selectImageView.height+selectImageView.frame.origin.y+10, WIDTH-60, 35)
            self.urlTextFiled.leftViewMode = .Always
            let leftLabel1 = UILabel.init(frame: CGRectMake(0, 0, 60, 35))
            leftLabel1.text = "  http://"
            leftLabel1.textColor = UIColor.blackColor()
            leftLabel1.font = UIFont.systemFontOfSize(14)
            self.urlTextFiled.leftView = leftLabel1
            self.urlTextFiled.layer.masksToBounds = true
            self.urlTextFiled.layer.cornerRadius = 5
            self.urlTextFiled.layer.borderColor = UIColor.brownColor().CGColor
            self.urlTextFiled.layer.borderWidth = 1
            self.urlTextFiled.delegate = self
            self.urlTextFiled.placeholder = "请填写您的跳转网址"
            self.urlTextFiled.setValue(UIFont.systemFontOfSize(13), forKeyPath: "_placeholderLabel.font")
            
            mainScrollView.addSubview(self.urlTextFiled)
        }
        if self.advMainTextFiled.superview == nil{
            self.advMainTextFiled.frame = CGRectMake(30, urlTextFiled.height+urlTextFiled.frame.origin.y+10, WIDTH-60, 35)
            self.advMainTextFiled.leftViewMode = .Always
            let leftLabel1 = UILabel.init(frame: CGRectMake(0, 0, 60, 35))
            leftLabel1.text = "  主题："
            leftLabel1.textColor = UIColor.blackColor()
            leftLabel1.font = UIFont.systemFontOfSize(14)
            self.advMainTextFiled.leftView = leftLabel1
            self.advMainTextFiled.layer.masksToBounds = true
            self.advMainTextFiled.layer.cornerRadius = 5
            self.advMainTextFiled.layer.borderColor = UIColor.brownColor().CGColor
            self.advMainTextFiled.layer.borderWidth = 1
            self.advMainTextFiled.delegate = self
            self.advMainTextFiled.placeholder = "请填写您的广告主题（10字之内）"
            self.advMainTextFiled.setValue(UIFont.systemFontOfSize(13), forKeyPath: "_placeholderLabel.font")
            
            mainScrollView.addSubview(self.advMainTextFiled)
        }
        
        mainScrollView.contentSize = CGSizeMake(WIDTH, self.advMainTextFiled.height+self.advMainTextFiled.frame.origin.y)
        
    }
    //MARK:ACTION
    func typeButtonAction(sender:UIButton){
        if !sender.selected{
            type = String(sender.tag)
            for index in 1...3 {
                if (self.view.viewWithTag(index) as? UIButton)!.selected{
                    (self.view.viewWithTag(index) as? UIButton)!.backgroundColor = UIColor.grayColor()
                    (self.view.viewWithTag(index) as? UIButton)!.selected = false
                }
            }
            sender.backgroundColor = COLOR
            sender.selected = !sender.selected
            self.getData()
        }
    }
    func timesButtonAction(sender:UIButton){
        if !sender.selected{
            endtimeStampArray = stringToTimeStampWithyyyymmdd((self.timeDic.objectForKey(String(sender.tag)) as! String))
            sender.backgroundColor = COLOR
            sender.selected = !sender.selected
            
            let prices = Double(self.price)
            if prices != nil{
                switch sender.tag {
                case 100:
                    self.money = String(format: "%.2f",Double(timeday1)*prices!)
                    self.moneyLabel.text = "总价："+self.money+"元"
                    begintimeStampArray = stringToTimeStampWithyyyymmdd(nowTimeStr)
                    break
                case 101:
                    self.money = String(format: "%.2f",Double(timeday2)*prices!)
                    self.moneyLabel.text = "总价："+self.money+"元"
                    let date =  dateFormatter.dateFromString(timeStr1)
                    let str1 = dateFormatter.stringFromDate(DateSection(date!,selectDays:1))
                    begintimeStampArray = stringToTimeStampWithyyyymmdd(str1)
                    break
                case 102:
                    self.money = String(format: "%.2f",Double(timeday3)*prices!)
                    self.moneyLabel.text = "总价："+self.money+"元"
                    let date =  dateFormatter.dateFromString(timeStr2)
                    let str1 = dateFormatter.stringFromDate(DateSection(date!,selectDays:1))
                    begintimeStampArray = stringToTimeStampWithyyyymmdd(str1)
                    break
                default:
                    break
                }
                
            }
            
            for index in 0...2 {
                if index != sender.tag-100{
                    
                    if (self.mainScrollView.viewWithTag(index+100) as! UIButton).selected == true{
                        (self.mainScrollView.viewWithTag(index+100) as! UIButton).selected = false
                        (self.mainScrollView.viewWithTag(index+100) as! UIButton).backgroundColor = UIColor.lightGrayColor()
                    }
                }
            }
        }
        
    }
    
    func addImageButtonAction(){
//        self.imagePicker.cropSize = CGSizeMake(WIDTH, WIDTH/2)
//        self.imagePicker.delegate = self
//        self.presentViewController(self.imagePicker.imagePickerController, animated: true, completion: nil)
        
        let sheet = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","从相册选择图片")
        sheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1{
            self.takePhoto()
        }else if buttonIndex == 2{
            self.chooseImageFromLibary()
        }else{
            
        }
    }
    
    func takePhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func chooseImageFromLibary(){
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    //MARK:ALiImageReshapeDelegate
    func imageReshaperController(reshaper: AliImageReshapeController!, didFinishPickingMediaWithInfo image: UIImage!) {
        self.selectedImage = image
        self.creatImageUI()
        reshaper.dismissViewControllerAnimated(true, completion: nil)
    }
    func imageReshaperControllerDidCancel(reshaper: AliImageReshapeController!) {
        reshaper.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        if picker.allowsEditing{
//            let image = editingInfo!["UIImagePickerControllerEditedImage"] as! UIImage
            self.selectedImage = image
            self.creatImageUI()
            picker.dismissViewControllerAnimated(true, completion: nil)
        }else{
//            let image = editingInfo!["UIImagePickerControllerOriginalImage"] as! UIImage
//            self.selectedImage = image
//            self.creatImageUI()
            let vc = AliImageReshapeController()
            vc.sourceImage = image
            vc.reshapeScale = 2
            vc.delegate = self
            picker.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func rightButtonAction(){
        
        if selectedImage == nil{
            alert("请选择图片", delegate: self)
            return
        }
//        if self.urlTextFiled.text == nil||self.urlTextFiled.text == ""{
//            alert("请填写网址", delegate: self)
//            return
//        }
        if self.endtimeStampArray == nil||self.begintimeStampArray == nil{
            alert("请选择广告时间段", delegate: self)
            return
        }
        
        
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
            let data = UIImageJPEGRepresentation(self.selectedImage!, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "guanggao" + dateStr + userid + String(arc4random())
            
            
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    if result.status != nil {
                        if result.status! == "success"{
                            self.selectedImageStr = result.data!
                            
                            self.goPay()
                        }
                        
                    }
                })
            }
        }
        
    }
    
    
    func goPay(){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid")as! String
        }
        mainHelp.PublishAD(type, userid: userid, photo: self.selectedImageStr, urls: stringIsNotNil(self.urlTextFiled.text) as! String, begintime: self.begintimeStampArray!, endtime: self.endtimeStampArray!,price:self.money,slide_name:self.advMainTextFiled.text != nil ? self.advMainTextFiled.text!:"") { (success, response) in
            if success{
                let vc = PayViewController()
                let ud = NSUserDefaults.standardUserDefaults()
                var userid = String()
                if ud.objectForKey("userid") != nil {
                    userid = ud.objectForKey("userid") as! String
                }
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "ddHHmmss"
                let dateStr = dateFormatter.stringFromDate(NSDate())
                let numForGoodS =  dateStr + userid  + "_A" + (response as! String)
                vc.numForGoodS = numForGoodS
                vc.isGuanggao = true
                let price1 = Double(self.money)
                if price1 != nil{
                    vc.price = 0.01
                }
                vc.subject = "广告发布购买"
                
                vc.body = "广告发布购买"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    //MARK:GKImagePickerDelegate
    func imagePicker(imagePicker: GKImagePicker!, pickedImage image: UIImage!) {
        
        self.selectedImage = image
        self.creatImageUI()
        self.imagePicker.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    //UItextFiledDeleggate
    func textFieldDidBeginEditing(textField: UITextField) {
        mainScrollView.contentSize = CGSizeMake(WIDTH, HEIGHT)
        mainScrollView.contentOffset = CGPointMake(0,260)
        mainScrollView.delegate = self
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.urlTextFiled.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if mainScrollView.contentOffset != CGPointMake(0,0){
            self.urlTextFiled.resignFirstResponder()
            self.advMainTextFiled.resignFirstResponder()
            mainScrollView.contentSize = CGSizeMake(WIDTH, self.advMainTextFiled.height+self.advMainTextFiled.frame.origin.y)
            mainScrollView.delegate = nil
//        }
        
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
