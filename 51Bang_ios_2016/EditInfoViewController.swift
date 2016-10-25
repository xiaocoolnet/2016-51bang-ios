//
//  EditInfoViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SDWebImage
class EditInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MineDelegate{
    var sexcell = EditTableViewCell1()
    let sexVc = sexView()
    let nicVc = NickNameView()
    let getData = TCMoreInfoHelper()
    var headerView = EditHeaderViewCell()
    let myTableView = UITableView()
    var myActionSheet:UIAlertController?
    var myDelegate:MineDelegate?
    var nickCell = EditTableViewCell()
    var index = NSIndexPath.init(forRow: 1, inSection: 0)
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = true
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        self.view.backgroundColor = RGREY
        myTableView.frame = CGRectMake(0, -20, WIDTH, HEIGHT)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = RGREY
        myTableView.registerNib(UINib(nibName: "EditTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName: "EditTableViewCell1",bundle: nil), forCellReuseIdentifier: "cell1")
        myTableView.registerNib(UINib(nibName: "EditTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell2")
        headerView = (NSBundle.mainBundle().loadNibNamed("EditHeaderViewCell", owner: nil, options: nil).first as? EditHeaderViewCell)!
        headerView.iconImage.addTarget(self, action: #selector(self.uploadImage), forControlEvents: UIControlEvents.TouchUpInside)
//bug:我已经修改过，此处注释过
//**********************************************************************
        
        
        
        let image = UIImage.init(data: NSUserDefaults.standardUserDefaults().objectForKey("userphoto") as! NSData )
        
        
        //sd_imageWithData(NSUserDefaults.standardUserDefaults().objectForKey("userphoto") as! NSData )
        
        headerView.iconImage.setImage(image, forState: UIControlState.Normal)
        headerView.iconImage.setImage(image, forState: UIControlState.Selected)
//**********************************************************************
        headerView.iconImage.layer.cornerRadius = 55 / 2
        headerView.iconImage.layer.masksToBounds = true
        
        
        headerView.backgroundColor = COLOR
        headerView.back.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        self.myTableView.tableHeaderView = headerView
        let view = UIView()
        self.myTableView.tableFooterView = view
        self.view.addSubview(myTableView)
        
        myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        myActionSheet?.addAction(UIAlertAction(title: "拍照", style: .Default, handler: {[unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.takePhoto()
            })
            }))
        
        myActionSheet?.addAction(UIAlertAction(title: "从相册获取", style: .Default, handler: { [unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.LocalPhoto()
            })
            }))
        
        myActionSheet?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
        
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: -- MineDelegate
    func handerNickName()
    {
        
        myTableView.reloadRowsAtIndexPaths([index], withRowAnimation:  UITableViewRowAnimation.None)
    }
    
    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //MARK: -- UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    
        self.headerView.iconImage.setImage(info[UIImagePickerControllerEditedImage] as? UIImage, forState: UIControlState.Selected)
        
        
        //上传图片
        
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
                            dispatch_async(dispatch_get_main_queue(), {
                            let imageName = result.data
                            let ud = NSUserDefaults.standardUserDefaults()
                            let userid = ud.objectForKey("userid")as! String
                            self.getData.uploadIconImage(userid, str:imageName!, handle: { (success, response) in
                                print(result.data)
                                
                                
                                
                                //图片上传后进行修改图像
                        
                                picker.dismissViewControllerAnimated(true, completion: nil)
                                self.headerView.iconImage.setImage(info[UIImagePickerControllerEditedImage] as? UIImage, forState: UIControlState.Normal)
                                self.headerView.iconImage.setImage(info[UIImagePickerControllerEditedImage] as? UIImage, forState: UIControlState.Selected)
                                
                                //选择后图片形状
                                self.headerView.iconImage.layer.cornerRadius = 55/2
                                self.headerView.iconImage.layer.masksToBounds = true
                                
                                let imageData = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 1)
                                ud.setObject(imageData, forKey: "photo")
                                ud.synchronize()
                                self.myDelegate?.editePictureInMain()
                                
                                })
                            })
                            
                            
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
    
    func uploadImage(){
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pictureAssert = UIAlertAction.init(title: "从相册选取", style: UIAlertActionStyle.Default, handler: {
            void in
            self.LocalPhoto()
            
        })
        
        let Camera = UIAlertAction.init(title: "拍照", style: UIAlertActionStyle.Default, handler: {
            void in
            
            self.takePhoto()
            
            
        })
        let canelSelect = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(Camera)
        alertController.addAction(pictureAssert)
        alertController.addAction(canelSelect)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func back(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.frame = CGRectMake(0, 0, WIDTH, 10)
            view.backgroundColor = RGREY
            return view
        }else{
            
            return nil
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 2
        
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)  -> UITableViewCell {
        
        
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("cell")
                cell!.selectionStyle = .None
                return cell!
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCellWithIdentifier("cell")as!EditTableViewCell
                cell.title.text = "昵称"
                cell.dirImageview.hidden = false
                cell.label.text = NSUserDefaults.standardUserDefaults().objectForKey("name") as? String
                cell.selectionStyle = .None
                nickCell = cell
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("cell1") as! EditTableViewCell1
                if((NSUserDefaults.standardUserDefaults().objectForKey("sex") as! String) == "1")
                {
                    cell.MenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Normal)
                    cell.MenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Selected)
                    cell.womenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Selected)
                    cell.womenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
                    
                }else{
                
                   cell.MenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
                    cell.MenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Selected)
                    cell.womenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Selected)
                   cell.womenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Normal)
                
                
                }
                sexcell = cell
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2")as! EditTableViewCell2
            if indexPath.row == 0 {
                
                cell.title.text = "修改密码"
                cell.selectionStyle = .None
                
            }else{
                
                cell.title.text = "修改手机"
                cell.selectionStyle = .None
                
            }
            return cell
        }
        
    }
    
    func phone(){
        let vc = ChangePhoneController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pwd(){
        
        let vc = ChangePwdViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        }else{
            return 2
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return 50
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 10
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section==0)
        {
            switch indexPath.row {
            case 1:
                self.navigationController?.navigationBar.hidden = false
                self.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(nicVc, animated: true)
                nicVc.myDelegate = self
                self.hidesBottomBarWhenPushed = false
            case 2:
                self.navigationController?.navigationBar.hidden = false
                self.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(sexVc, animated: true)
                sexVc.myDelegate = self
                self.hidesBottomBarWhenPushed = false
            default:
                print("不可选")
            }
        }
        if(indexPath.section==1)
        {
            if(indexPath.row==0)
            {
                self.pwd()
            
            }else
            {
                phone()
            }
        }
        
    }
    
    //MARK: - MineDelegate
    func editePictureInMain() {
        
    }
    
    func updateName(name:String) {
        nickCell.label.text = name
        myTableView.reloadData()
    }
   
    func updateSex(flag: Int) {
        
     
        if(flag==0)
        {
        sexcell.MenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Normal)
        sexcell.MenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Selected)
        sexcell.womenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Selected)
        sexcell.womenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
        
        }else{
        sexcell.MenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Normal)
        sexcell.MenImage.setImage(UIImage.init(named: "ic_weixuanze"), forState: UIControlState.Selected)
        sexcell.womenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Selected)
        sexcell.womenImage.setImage(UIImage.init(named: "ic_tongyixuanzhong"), forState: UIControlState.Normal)
        }
        
        
        
    }
    
    
}
