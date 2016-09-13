//
//  UploadContractViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/2.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class UploadContractViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    let photoArray = NSMutableArray()
    var collectionV:UICollectionView?
    let button = UIButton()
    var salary = String()
    var  price = NSString()
    var goodName = String()
    var numofGoods = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "上传合同"
        self.view.backgroundColor = RGREY
        button.frame = CGRectMake(10, 10, 100, 100)
        //        button.setTitle("上传合同", forState: UIControlState.Normal)
        button.setImage(UIImage(named: "ic_shangchuanhetong-0"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blueColor(), forState:UIControlState.Normal)
        button.addTarget(self, action: #selector(self.uploadImage), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        let button2 = UIButton.init(frame: CGRectMake(10, HEIGHT-140, WIDTH/2-20, 40))
        button2.setTitle("跳过", forState: UIControlState.Normal)
        button2.addTarget(self, action: #selector(self.tiaoguo), forControlEvents: UIControlEvents.TouchUpInside)
        let button3 = UIButton.init(frame: CGRectMake(WIDTH/2+10, HEIGHT-140, WIDTH/2-20, 40))
        button2.layer.cornerRadius = 5
        button3.layer.cornerRadius = 5
        button3.setTitle("上传", forState: UIControlState.Normal)
        button2.backgroundColor = UIColor.orangeColor()
        button3.backgroundColor = COLOR
        button3.addTarget(self, action: #selector(self.tiaoguo), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        // Do any additional setup after loading the view.
    }
    
    func tiaoguo(){
        let vc = PayViewController()
        vc.isRenwu = true
        vc.numForGoodS = self.numofGoods
        if self.salary == "" {
            vc.price = 0
        }else{
            vc.price = Double(self.salary)!
        }
        vc.price = self.price.doubleValue
        vc.body = self.goodName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func uploadImage(){
        
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let pictureAssert = UIAlertAction.init(title: "从相册选取", style: UIAlertActionStyle.Default, handler: {
            void in
            self.LocalPhoto()
            
        })
        
        let Camera = UIAlertAction.init(title: "拍照", style: UIAlertActionStyle.Default, handler: {
            void in
            
            self.upload()
            
            
        })
        let canelSelect = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(Camera)
        alertController.addAction(pictureAssert)
        alertController.addAction(canelSelect)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func LocalPhoto(){
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    //上传合同
    func upload(){
        
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage]as! UIImage
        self.photoArray.addObject(image)
        self.addCollectionViewPicture()
        //        self.button.setImage(info[UIImagePickerControllerEditedImage] as? UIImage, forState: UIControlState.Normal)
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
                            print(result.data)
                            //                            self.array.addObject(result.data!)
                            //                            self.imagenameArray.addObject(result.data!)
                            //                            self.imagename = result.data!
                            
                        }else{
                            //                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            //                            hud.mode = MBProgressHUDMode.Text;
                            //                            hud.labelText = "图片上传失败"
                            //                            hud.margin = 10.0
                            //                            hud.removeFromSuperViewOnHide = true
                            //                            hud.hide(true, afterDelay: 1)
                        }
                    })
                }
            })
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
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
        self.collectionV = UICollectionView.init(frame: CGRectMake(0, 110, WIDTH, height), collectionViewLayout: flowl)
        collectionV!.backgroundColor = UIColor.whiteColor()
        collectionV!.delegate = self
        collectionV!.dataSource = self
        //        collectionV?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        collectionV!.registerNib(UINib(nibName: "PhotoCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "photo")
        self.view.addSubview(collectionV!)
        //        self.headerView.addSubview(collectionV!)
        //        self.headerView.frame.size.height = WIDTH*200/375+WIDTH*180/375+(collectionV?.frame.size.height)!
        //        self.myTableView.tableHeaderView = self.headerView
        
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
        print(self.photoArray[indexPath.item] as? UIImage)
        cell.button.setBackgroundImage(self.photoArray[indexPath.item] as? UIImage, forState: UIControlState.Normal)
        
        let button = UIButton.init(frame: CGRectMake(cell.frame.size.width-18, 0, 20, 20))
        button.setImage(UIImage(named: "ic_shanchu-cha"), forState: UIControlState.Normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(self.deleteImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(button)
        return cell
    }
    
    //删除照片
    func deleteImage(btn:UIButton){
        print(btn.tag)
        self.photoArray.removeObjectAtIndex(btn.tag)
        //        self.collectionV?.deleteItemsAtIndexPaths([NSIndexPath.init(index: btn.tag)])
        self.collectionV?.reloadData()
        if self.photoArray.count == 0 {
            self.collectionV?.frame.size.height = 0
            self.collectionV?.removeFromSuperview()
            self.addCollectionViewPicture()
            
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
