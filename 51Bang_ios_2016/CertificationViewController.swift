//
//  CertificationViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AssetsLibrary
import MBProgressHUD
import SVProgressHUD

class CertificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate ,TZImagePickerControllerDelegate,UIScrollViewDelegate{
    
    //@IBOutlet weak var myTableView: UITableView!
    var myTableView = UITableView.init()
    var tagOfButton = Int()
    var imageOfRenzheng:NSMutableArray = []
    
    var array = NSMutableDictionary()
    var cellIndexpath = Int()
    var imagenameArray = NSMutableArray()
    var butTag = 2
    var buttonfirm1 = UIButton()
    var buttonfirm2 = UIButton()
    var labelfirm1 = UILabel()
    var labelfirm2 = UILabel()
    var wayImagebao:UIButton?
    var wayImagebank:UIButton?
    let nameTextField = UITextField()
    let certifyField = UITextField()
    let baoNumber = UITextField()
    let phoneVerify = UITextField()
    let bankSelect = UIButton()
    var haomalabel = UILabel()
    var textShow = UIView()
    var cityName = ""
    var longitude = ""
    var latitude = ""
    var address = ""
    var ViewTag = 1
    var Finish = UIButton()
    var timer = NSTimer.init()
    var getPhoneVerityBtn = UIButton()
    var timeCount = 30
    let scrollView = TPKeyboardAvoidingScrollView()
    override func viewWillAppear(animated: Bool) {
        myTableView.reloadData()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        //        scrollView.hidden = true
        if( BankSelectVc.banName != "")
        {
            bankSelect.setTitle( BankSelectVc.banName , forState: UIControlState.Normal )
        }
        func viewWillDisappear(animated: Bool) {
            
            BankSelectVc.banName = ""
            
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = RGREY
        
        self.title = "身份认证"
        myTableView.hidden = false
        scrollView.hidden = true
        
        setScrolView()
        setPayWay()
        setTextField()
        setlabel()
        setButton()
        setFooter()
        
        firmWay()
        myTableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT-49), style: UITableViewStyle.Grouped)
        self.view.addSubview(myTableView)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "IdentityTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Indentity")
        myTableView.registerNib(UINib(nibName: "IdentityPicTableViewCell",bundle: nil), forCellReuseIdentifier: "picture")
        myTableView.registerNib(UINib(nibName: "IdentityPicTableViewCell",bundle: nil), forCellReuseIdentifier: "Driving")
        myTableView.separatorStyle = .None
        
        let header = UIView(frame: CGRectMake(0, 0, WIDTH, 5))
        myTableView.tableHeaderView = header
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 120))
        let btn = UIButton(frame: CGRectMake(15, 30, WIDTH-30, 50))
        btn.layer.cornerRadius = 8
        btn.setTitle("下一步", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        bottom.addSubview(btn)
        myTableView.tableFooterView = bottom
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 6
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return WIDTH*40/375
            }else if indexPath.row == 2 {
                return WIDTH*40/375
            }else if indexPath.row == 4 {
                return WIDTH*40/375
            }else if indexPath.row == 1 {
                return WIDTH*125/375
            }else{
                return WIDTH*135/375
            }
        }else{
            return WIDTH*135/375
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }else{
            return 10
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!IdentityTableViewCell
            cell.city.userInteractionEnabled = true
            //建立手势识别器
            let gesture = UITapGestureRecognizer(target: self, action: #selector(CertificationViewController.viewTap(_:)))
            //附加识别器到视图
            cell.addGestureRecognizer(gesture)
            cell.selectionStyle = .None
            let city = NSUserDefaults.standardUserDefaults()
            
            let cityName = city.objectForKey("city")
            if cityName==nil {
                
            }else{
                let string = cityName as? String
                //               let array:NSArray = (string?.componentsSeparatedByString("-"))!
                cell.city.text = string
                city.removeObjectForKey("city")
            }
            
            cell.cityChoose.addTarget(self, action: #selector(self.choseCity), forControlEvents:UIControlEvents.TouchUpInside)
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Indentity", forIndexPath: indexPath)
                cell.selectionStyle = .None
                cell.textLabel?.font = UIFont.systemFontOfSize(12)
                cell.textLabel?.textColor = UIColor(red: 1, green: 59/255.0, blue: 0, alpha: 1.0)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "＊手持身份证正面照，靠近镜头正面拍摄胸部以上，保证身份证上面文字清晰可见"
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath)as!IdentityPicTableViewCell
                cell.selectionStyle = .None
                cell.Driving.setBackgroundImage(UIImage(named: "手持身份证"), forState: .Normal)
                cell.aaaa.hidden = true
                cell.bbbb.hidden = true
                if self.tagOfButton == indexPath.row && self.imageOfRenzheng.count != 0 {
                    cell.Camera.setBackgroundImage(self.imageOfRenzheng[0] as? UIImage, forState: .Normal)
                }else{
                    
                }
                
                cell.Camera.tag = indexPath.row
                cell.Camera.addTarget(self, action: #selector(self.goToCamera(_:)), forControlEvents: .TouchUpInside)
                return cell
            } else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCellWithIdentifier("Indentity", forIndexPath: indexPath)
                cell.selectionStyle = .None
                cell.textLabel?.font = UIFont.systemFontOfSize(12)
                cell.textLabel?.textColor = UIColor(red: 1, green: 59/255.0, blue: 0, alpha: 1.0)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "＊特卖商户请上传营业执照"
                return cell
            }else if indexPath.row == 3{
                let cell = tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath)as!IdentityPicTableViewCell
                cell.selectionStyle = .None
                if self.tagOfButton == indexPath.row && self.imageOfRenzheng.count != 0 {
                    cell.Camera.setBackgroundImage(self.imageOfRenzheng[0] as? UIImage, forState: .Normal)
                }else{
                    
                }
                cell.Driving.setBackgroundImage(UIImage(named: "身份证正面"), forState: .Normal)
                
                
                cell.Camera.tag = indexPath.row
                cell.Camera.addTarget(self, action: #selector(CertificationViewController.goToCamera(_:)), forControlEvents: .TouchUpInside)
                return cell
            }else if indexPath.row == 4{
                let cell = tableView.dequeueReusableCellWithIdentifier("Indentity", forIndexPath: indexPath)
                cell.selectionStyle = .None
                cell.textLabel?.font = UIFont.systemFontOfSize(12)
                cell.textLabel?.textColor = UIColor(red: 1, green: 59/255.0, blue: 0, alpha: 1.0)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "＊有技能证书者请上传技能证书"
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath)as!IdentityPicTableViewCell
                cell.selectionStyle = .None
                if self.tagOfButton == indexPath.row && self.imageOfRenzheng.count != 0 {
                    cell.Camera.setBackgroundImage(self.imageOfRenzheng[0] as? UIImage, forState: .Normal)
                }else{
                    
                }
                cell.Driving.setBackgroundImage(UIImage(named: "驾照"), forState: .Normal)
                cell.aaaa.hidden = true
                cell.bbbb.text = "技能证书"
                
                cell.Camera.tag = indexPath.row
                cell.Camera.addTarget(self, action: #selector(self.goToCamera(_:)), forControlEvents: .TouchUpInside)
                return cell
            }
        }
        
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == 0 && indexPath.section == 0{
//            
//        }
//    }
    
    func viewTap(sender: UITapGestureRecognizer) {
        self.choseCity()
    }
    
    
    func choseCity(){
        
        let vc = ChoseCityViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func imagePickerController(picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [AnyObject]!, isSelectOriginalPhoto: Bool, infos: [[NSObject : AnyObject]]!) {
        let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud1.animationType = .Zoom
        hud1.labelText = "正在努力加载"
        if self.tagOfButton == 1 {
            let data:NSData = UIImageJPEGRepresentation(photos[0] , 1.0)!
//            let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                self.array.setValue(result.data!, forKey: "positive_pic")
                                hud1.hide(true)
                                //                            self.imagenameArray.addObject(result.data!)
                                //                            self.imagename = result.data!
                                
                            }else{
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "图片上传失败"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 1)
                                hud1.hide(true)
                            }
                        })
                    }
                })
            }
            
        }else if self.tagOfButton == 3{
            let data:NSData = UIImageJPEGRepresentation(photos[0] , 1.0)!
            //            let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                self.array.setValue(result.data!, forKey: "opposite_pic")
                                hud1.hide(true)
                                //                            self.imagenameArray.addObject(result.data!)
                                //                            self.imagename = result.data!
                                
                            }else{
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "图片上传失败"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 1)
                                hud1.hide(true)
                            }
                        })
                    }
                })
            }

        }else{
            let data:NSData = UIImageJPEGRepresentation(photos[0] , 1.0)!
            //            let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let result = Http(JSONDecoder(data))
                    if result.status != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            if result.status! == "success"{
                                self.array.setValue(result.data!, forKey: "driver_pic")
                                hud1.hide(true)
                                //                            self.imagenameArray.addObject(result.data!)
                                //                            self.imagename = result.data!
                                
                            }else{
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "图片上传失败"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 1)
                                hud1.hide(true)
                            }
                        })
                    }
                })
            }

            
        }
        
        imageOfRenzheng.removeAllObjects()
        imageOfRenzheng.addObjectsFromArray(photos)
        self.myTableView.reloadData()
        
        
        
    }
    
    
    func goToCamera(btn:UIButton) {
        self.tagOfButton = btn.tag
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 1, delegate:self)
        self.presentViewController(imagePickerVc, animated: true, completion: nil)
        
        //        print(btn.tag)
        //        self.cellIndexpath = btn.tag
        //
        //        let imagePicker = UIImagePickerController();
        //        imagePicker.delegate = self
        //        imagePicker.allowsEditing = true
        //        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        //        self.presentViewController(imagePicker, animated: true, completion: nil)
        //        print("打开相机")
        //        //                调用相机
        //        dispatch_async(dispatch_get_main_queue(),{
        //        if UIImagePickerController.isSourceTypeAvailable(.Camera){
        //            //创建图片控制器
        //            let picker = UIImagePickerController()
        //            //设置代理
        //            picker.delegate = self
        //            //设置来源
        //            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //            //允许编辑
        //                    picker.allowsEditing = true
        //            //打开相机
        ////            if Float(UIDevice.currentDevice().systemVersion)>=8.0{
        //               // self.modalPresentationStyle = .CurrentContext
        ////            }
        //
        //            self.presentViewController(picker, animated: true, completion: nil)
        //
        ////            self.presentViewController(picker, animated: true, completion: { () -> Void in
        ////                //如果有前置摄像头则调用前置摄像头
        ////                //                        if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front){
        ////                //                            picker.cameraDevice = UIImagePickerControllerCameraDevice.Front
        ////                //                        }
        ////                //开启闪光灯
        ////                //picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
        ////            })
        //        }else{
        //            print("找不到相机")
        //        }
        //    });
        
    }
    
    //代理方法
    func nextToView() {
        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.removeObjectForKey("infomation")
        print("下一步")
        let city = self.view.viewWithTag(10) as? UILabel
        let name = self.view.viewWithTag(11) as? UITextField
        let presonId = self.view.viewWithTag(12) as? UITextField
        let emergency = self.view.viewWithTag(13) as? UITextField
        let emergencyPhone = self.view.viewWithTag(14) as? UITextField
        let view1 = self.view.viewWithTag(15) as? UIImageView
        let view2 = self.view.viewWithTag(16) as? UIImageView
        let view3 = self.view.viewWithTag(17) as? UIImageView
        
        print(city?.text)
        print(name?.text)
        print(presonId?.text)
        print(emergency?.text)
        print(emergencyPhone?.text)
        print(view1)
        //        view2?.image
        //        if name?.text==""||presonId?.text==""||emergency?.text==""||emergencyPhone?.text=="" {
        //            print("请完善信息")
        //        }else{
        if name?.text != "" && name?.text != nil {
            array.setValue(name?.text, forKey: "name")
        }
        
        if city?.text != "" && city?.text != nil {
            array.setValue(city?.text, forKey: "city")
        }
        if city?.text != "" && city?.text != nil {
            array.setValue((presonId?.text)!, forKey: "idcard")
        }
        if emergency?.text != "" && emergency?.text != nil {
            array.setValue((emergency?.text)!, forKey: "contactperson")

            
        }
        if emergencyPhone?.text != "" && emergencyPhone?.text != nil {
            array.setValue((emergencyPhone?.text)!, forKey: "contactphone")
        }
        
        
        
        
        print(array)
//        array.addObject((name?.text)!)
//        array.addObject((presonId?.text)!)
//        array.addObject((emergency?.text)!)
//        array.addObject((emergencyPhone?.text)!)
        //        array.addObject(data1)
        //        array.addObject(data2)
        //        array.addObject(data3)
//        let userdefault = NSUserDefaults.standardUserDefaults()
        userdefault.setObject(array, forKey: "infomation")
        //        let vc = SkillViewController()
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if array.count<5 {
            alert("请填写完整信息", delegate: self)
            return
        }
        
        var regex:String?
        regex = "^[xX0-9]{15,18}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        let flags = predicate.evaluateWithObject(presonId!.text! as NSString)
        if !flags{
            SVProgressHUD.showErrorWithStatus("请输入15位或18位身份证号!")
            return
        }
        
        var regex1:String?
        regex1 = "^[0-9]{7,15}$"
        let predicate1 = NSPredicate.init(format: "SELF MATCHES %@",regex1!)
        let flags1 = predicate1.evaluateWithObject(emergencyPhone!.text! as NSString)
        if !flags1{
            SVProgressHUD.showErrorWithStatus("请输入正确手机号!")
            return
        }
        
        userdefault.setObject("no", forKey: "isxiugai")
//        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SkillView")
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = SkillselectViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.title = "技能选择"

        
        
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        let city = self.view.viewWithTag(10) as? UILabel
        let name = self.view.viewWithTag(11) as? UITextField
        let presonId = self.view.viewWithTag(12) as? UITextField
        let emergency = self.view.viewWithTag(13) as? UITextField
        let emergencyPhone = self.view.viewWithTag(14) as? UITextField
        city?.resignFirstResponder()
        name?.resignFirstResponder()
        presonId?.resignFirstResponder()
        emergency?.resignFirstResponder()
        emergencyPhone?.resignFirstResponder()
        nameTextField.resignFirstResponder()
        certifyField.resignFirstResponder()
        baoNumber.resignFirstResponder()
        phoneVerify.resignFirstResponder()
        
    }
    
    func setScrolView()
    {
        scrollView.frame = CGRectMake(0, 48, WIDTH, self.view.frame.size.height )
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.directionalLockEnabled = false
        scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT + 150)
        scrollView.scrollsToTop = true
        scrollView.backgroundColor = UIColor.whiteColor()
        
        
        self.view.addSubview(scrollView)
        
    }
    
    func setPayWay()
    {
        let baoView = UIButton.init(frame: CGRectMake(0, 20, WIDTH / 2, 40))
        baoView.tag = 0
        baoView.addTarget(self, action: #selector(self.selectWayAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let baoBtnTip = UIButton.init(frame: CGRectMake( 15, 7.5, 15, 15) )
        wayImagebao = baoBtnTip
        baoBtnTip.layer.masksToBounds = true
        baoBtnTip.layer.cornerRadius = 7.5
        baoBtnTip.layer.borderWidth = 1
        baoBtnTip.layer.borderColor = UIColor.grayColor().CGColor
        baoBtnTip.setImage(UIImage.init(named: "ic_xuanzetuoguan"), forState: UIControlState.Normal)
        baoBtnTip.addTarget(self, action: #selector(self.selectWayAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        baoBtnTip.tag = 0
        let baoBtnImage = UIImageView.init(frame: CGRectMake(baoBtnTip.frame.origin.x + 30, 0, 30, 30))
        baoBtnImage.layer.masksToBounds = true
        baoBtnImage.layer.cornerRadius = 15
        baoBtnImage.image = UIImage.init(named: "ic_zhifubao")
        baoView.addSubview(baoBtnImage)
        let baoLabel = UILabel.init(frame: CGRectMake(baoBtnImage.frame.origin.x + 35, 0, 40, 30))
        baoLabel.adjustsFontSizeToFitWidth = true
        baoLabel.text = "支付宝"
        baoView.addSubview(baoLabel)
        baoView.addSubview(baoBtnTip)
        scrollView.addSubview(baoView)
        
        
        
        let bankView = UIButton.init(frame: CGRectMake(WIDTH / 2, 20, WIDTH / 2, 40))
        bankView.tag = 1
        bankView.addTarget(self, action: #selector(self.selectWayAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let bankBtnTip = UIButton.init(frame: CGRectMake( WIDTH / 2 - 15 - 45 - 35 - 25, 7.5, 15, 15) )
        bankBtnTip.addTarget(self, action: #selector(self.selectWayAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        bankBtnTip.tag = 1
        wayImagebank = bankBtnTip
        
        bankBtnTip.layer.masksToBounds = true
        bankBtnTip.layer.cornerRadius = 7.5
        bankBtnTip.layer.borderWidth = 1
        bankBtnTip.layer.borderColor = UIColor.grayColor().CGColor
        let bankBtnImage = UIImageView.init(frame: CGRectMake(bankBtnTip.frame.origin.x + 30, 0, 30, 30))
        bankBtnImage.layer.masksToBounds = true
        bankBtnImage.layer.cornerRadius = 15
        bankBtnImage.image = UIImage.init(named: "yinhangka")
        bankView.addSubview(bankBtnImage)
        let bakLabel = UILabel.init(frame: CGRectMake(bankBtnImage.frame.origin.x + 35, 0, 40, 30))
        bakLabel.adjustsFontSizeToFitWidth = true
        bakLabel.text = "银行卡"
        bankView.addSubview(bakLabel)
        bankView.addSubview(bankBtnTip)
        scrollView.addSubview(bankView)
        
        
        
        
        
    }
    //60
    func selectWayAction(btn:UIButton)
    {
        timer.invalidate()
        timeCount = 30
        getPhoneVerityBtn.userInteractionEnabled = true
        getPhoneVerityBtn.setTitle("获取短信验证码", forState: UIControlState.Normal)
        getPhoneVerityBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        
        print("点击")
        switch btn.tag {
        case 0:
            wayImagebao?.imageView?.hidden = false
            wayImagebao!.setImage(UIImage.init(named: "ic_xuanzetuoguan"), forState: UIControlState.Normal)
            wayImagebank?.imageView?.hidden = true
            baoChange()
            ViewTag = 1
            
        default:
            
            wayImagebank?.imageView?.hidden = false
            wayImagebank!.setImage(UIImage.init(named: "ic_xuanzetuoguan"), forState: UIControlState.Normal)
            wayImagebao?.imageView?.hidden = true
            bankChange()
            ViewTag = 2
        }
        
    }
    
    func setTextField()
    {
        nameTextField.frame = CGRectMake(15, 80, WIDTH - 30, 35)
        nameTextField.layer.masksToBounds = true
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        nameTextField.layer.borderWidth = 1
        sethoder(nameTextField, size: 13, str: "   请输入您的姓名")
        scrollView.addSubview(nameTextField)
        
        
        
        certifyField.frame = CGRectMake(15, nameTextField.frame.origin.y + 35 + 15, WIDTH - 30, 35)
        certifyField.layer.masksToBounds = true
        certifyField.layer.cornerRadius = 10
//        certifyField.keyboardType = .NumberPad
        certifyField.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        certifyField.layer.borderWidth = 1
        sethoder(certifyField, size: 13, str: "   请输入身份证号码")
        scrollView.addSubview(certifyField)
        
        baoNumber.frame = CGRectMake(15, certifyField.frame.origin.y + 35 + 15, WIDTH - 30, 35)
        baoNumber.layer.masksToBounds = true
        baoNumber.layer.cornerRadius = 10
        baoNumber.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        baoNumber.layer.borderWidth = 1
        sethoder(baoNumber, size: 13, str: "   请输入支付宝账号")
        scrollView.addSubview(baoNumber)
        
        phoneVerify.frame = CGRectMake(15, baoNumber.frame.origin.y + 35 + 20 + 35 + 10 , WIDTH - 30, 35)
        phoneVerify.layer.masksToBounds = true
        phoneVerify.layer.cornerRadius = 10
        phoneVerify.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        phoneVerify.layer.borderWidth = 1
        phoneVerify.keyboardType = .NumberPad
        sethoder(phoneVerify, size: 13, str: "   请输入短信验证码")
        scrollView.addSubview(phoneVerify)
        
        getPhoneVerityBtn.userInteractionEnabled = true
        getPhoneVerityBtn = UIButton.init(frame: CGRectMake(phoneVerify.frame.size.width - 100, 0,100, 35))
        getPhoneVerityBtn.setTitle("获取短信验证码", forState: UIControlState.Normal)
        getPhoneVerityBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        getPhoneVerityBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        getPhoneVerityBtn.addTarget(self, action: #selector(self.getPhoneVerifyAction), forControlEvents: UIControlEvents.TouchUpInside)
        getPhoneVerityBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
        
        
        let decorlabel = UILabel.init(frame: CGRectMake(getPhoneVerityBtn.frame.origin.x - 1, 0, 1, 35))
        decorlabel.backgroundColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0)
        phoneVerify.addSubview(decorlabel)
        phoneVerify.addSubview(getPhoneVerityBtn)
        
    }
    
    func timego(){
        
        if(timeCount != -1)
        {
            getPhoneVerityBtn.userInteractionEnabled = false
            getPhoneVerityBtn.setTitle("\(timeCount)后重新获取", forState: UIControlState.Normal)
            getPhoneVerityBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            timeCount -= 1
            
        }else
            
        {
            
            timer.invalidate()
            timeCount = 30
            getPhoneVerityBtn.userInteractionEnabled = true
            getPhoneVerityBtn.setTitle("获取短信验证码", forState: UIControlState.Normal)
            getPhoneVerityBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
            
        }
    }
    func setlabel()
    {
        haomalabel = UILabel.init(frame: CGRectMake(0, baoNumber.frame.origin.y + 35 + 20, WIDTH, 35))
        haomalabel.font = UIFont.systemFontOfSize(13)
        haomalabel.text = phoneNumberCal()
        haomalabel.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(haomalabel)
        
        
    }
    
    
    func phoneNumberCal() ->String
    {
        
        let userData = NSUserDefaults.standardUserDefaults()
        var phoneNum = String()
        if userData.objectForKey("phone") != nil {
            phoneNum = userData.objectForKey("phone")as! String
        }
//        let phoneNum = userData.objectForKey("phone") as! String
        let temp1 = (phoneNum as NSString).substringWithRange(NSMakeRange(0, 4))
        let temp2 = (phoneNum as NSString).substringWithRange(NSMakeRange(7, 4))
        return "您当前绑定的手机号码：" + temp1 + "****" + temp2
    }
    
    
    func sethoder(field:UITextField,size:CGFloat,str:String)
    {
        var attributes:[String:AnyObject] = [:]
        attributes[NSFontAttributeName] = UIFont.systemFontOfSize(size)
        let atrholder = NSMutableAttributedString.init(string: str, attributes: attributes)
        field.attributedPlaceholder = atrholder
    }
    
    func setButton()
    {
        Finish = UIButton.init(frame: CGRectMake(15, phoneVerify.frame.origin.y + 100, WIDTH - 30, 35))
        Finish.backgroundColor = COLOR
        Finish.setTitle("完成认证并绑定", forState: UIControlState.Normal)
        Finish.layer.masksToBounds = true
        Finish.layer.cornerRadius  = 10
        Finish.addTarget(self, action: #selector(self.action), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(Finish)
        
    }
    
    
    func setFooter()
    {
        textShow = UIView.init(frame: CGRectMake(0,Finish.frame.origin.y + 35 + 10 , WIDTH, 100))
        
        let lin1 = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 25))
        setText(lin1, size: 12)
        lin1.text = "*此次认证与提现认证一致，且只认证一次，"
        
        let lin2 = UILabel.init(frame: CGRectMake(0, 30, WIDTH, 25))
        setText(lin2, size: 12)
        lin2.text = "请输入正确的身份证号码和姓名且收款账户必须与姓"
        
        let lin3 = UILabel.init(frame: CGRectMake(0, 60, WIDTH, 25))
        setText(lin3, size: 12)
        lin3.text = "名一致，否则无法认证与提现"
        
        scrollView.addSubview(textShow)
        textShow.addSubview(lin1)
        textShow.addSubview(lin2)
        textShow.addSubview(lin3)
        
    }
    
    func setText(label:UILabel,size:CGFloat)
    {
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(size)
        
    }
    
    func action()
    {
        let userData = NSUserDefaults.standardUserDefaults()
        var phoneNum = String()
        if userData.objectForKey("phone") != nil {
            phoneNum = userData.objectForKey("phone")as! String
        }
//        let phoneNum = userData.objectForKey("phone") as! String
        let vc = CommitOrderViewController()
        vc.cityName = self.cityName
        vc.longitude =   self.longitude
        vc.latitude =   self.latitude
        vc.address = address
        
        let uploadFunction = BankUpLoad()
        if( ViewTag == 1)
        {
            
            uploadFunction.baoMessageRequest( userData.objectForKey("userid") as! String , name: nameTextField.text!, card:certifyField.text! , alipay: baoNumber.text!, phone: phoneNum, code: phoneVerify.text!, Targert: self, pushVc: vc)
            
        }else{
            uploadFunction.bankMessageUpload( nameTextField.text! , idCard: certifyField.text! , bankName: BankSelectVc.banName , bankNum: baoNumber.text!, Phone: phoneNum, Code: phoneVerify.text! , Target: self,pushVc: vc )
            
            
            
        }
        
    }
    
    func getPhoneVerifyAction()
    {
        getPhoneVerityBtn.userInteractionEnabled = false
        print("开始发送")
        let userData = NSUserDefaults.standardUserDefaults()
        var phoneNum = String()
        if userData.objectForKey("phone") != nil {
            phoneNum = userData.objectForKey("phone")as! String
        }
//        let phoneNum = userData.objectForKey("phone") as! String
        let getphoneMessage = BankUpLoad()
        getphoneMessage.requestMessage(phoneNum)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.timego), userInfo: nil, repeats: true)
    }
    
    
    
    func bankChange()
    {
        self.title = "银行卡认证"
        sethoder(baoNumber, size: 13, str: "   请输入银行卡号")
        
        bankSelect.frame = CGRectMake(15, baoNumber.frame.origin.y + 35 + 15, WIDTH - 30, 35)
        bankSelect.layer.masksToBounds = true
        bankSelect.layer.cornerRadius = 10
        bankSelect.hidden = false
        bankSelect.layer.borderColor = UIColor(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1.0).CGColor
        bankSelect.layer.borderWidth = 1
        bankSelect.setTitleColor(UIColor.blackColor(), forState:  UIControlState.Normal )
        bankSelect.setTitle("请选择开户行", forState: UIControlState.Normal)
        bankSelect.addTarget(self, action: #selector(self.banselectAction), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(bankSelect)
        haomalabel.frame = CGRectMake(15, bankSelect.frame.origin.y + 35 + 20 , WIDTH - 30, 35)
        phoneVerify.frame = CGRectMake(15, bankSelect.frame.origin.y + 35 + 20 + 35 + 10 , WIDTH - 30, 35)
        Finish.frame = CGRectMake(15, phoneVerify.frame.origin.y + 100, WIDTH - 30, 35)
        textShow.frame = CGRectMake(0,Finish.frame.origin.y + 35 + 10 , WIDTH, 100)
    }
    
    func banselectAction()
    {
        let vc = BankSelectVc()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //self.hidesBottomBarWhenPushed = false
    }
    
    func baoChange()
    {
        self.title = "支付宝认证"
        sethoder(baoNumber, size: 13, str: "   请输入支付宝账号")
        bankSelect.hidden = true
        haomalabel.frame = CGRectMake(0, baoNumber.frame.origin.y + 35 + 20, WIDTH, 35)
        phoneVerify.frame = CGRectMake(15, baoNumber.frame.origin.y + 35 + 20 + 35 + 10 , WIDTH - 30, 35)
        Finish.frame =  CGRectMake(15, phoneVerify.frame.origin.y + 100, WIDTH - 30, 35)
        textShow.frame = CGRectMake(0,Finish.frame.origin.y + 35 + 10 , WIDTH, 100)
    }
    
    
    
    
    
    
}


extension CertificationViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let indexPath = NSIndexPath.init(forRow: self.cellIndexpath, inSection: 1)
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! IdentityPicTableViewCell
        let imageView = UIImageView()
        imageView.tag = 14+self.cellIndexpath
        imageView.frame = CGRectMake(0, 0, cell.Driving.frame.size.width, cell.Driving.frame.size.height)
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.view.addSubview(imageView)
        cell.Driving.addSubview(imageView)
        let data = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: Bang_URL_Header+"uploadimg") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.status! == "success"{
//                            self.array.addObject(result.data!)
                            //                            self.imagenameArray.addObject(result.data!)
                            //                            self.imagename = result.data!
                            
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
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //    func imagePickerControllerDidCancel(picker: UIImagePickerController){
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //
    //
    //    }
    
    
}


