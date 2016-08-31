//
//  ViewController.swift
//  swiftPickMore
//
//  Created by duzhe on 15/10/15.
//  Copyright © 2015年 duzhe. All rights reserved.
//

import UIKit
import AssetsLibrary

protocol PassPhotosDelegate{
    func passPhotos(selected:[ZuberImage])
}

class ViewController1: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate{

//    var collectionView:UICollectionView!
    var collectionView:UICollectionView?
    
    var cancelBtnItem  = UIButton()
    var confirmBtnItem = UIButton()
    
    
    var photoDelegate:PassPhotosDelegate?
    var assetsLibrary:ALAssetsLibrary!
    var currentAlbum:ALAssetsGroup?
    var tempZuber:ZuberImage!
    var count:Int = 0;
    var selectedImage:[ZuberImage] = []
    
    
    var imageArray:[ZuberImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.hidden = true
        self.title = "请选择图片"
        initCollectionView()
        getGroupList()
        
        
        self.confirmBtnItem.enabled = false
    }

    func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        let itemWidth = WIDTH/4 - 6
        let itemHeight:CGFloat = 100.0
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 2 //上下间隔
        flowLayout.minimumInteritemSpacing = 2 //左右间隔
//        self.collectionView = CollectionView.init（frame:CGRectMake(0, 0, WIDTH, HEIGHT)
        
//        self.collectionView.collectionViewLayout = flowLayout
        collectionView = UICollectionView.init(frame:CGRectMake(0, 50, WIDTH, HEIGHT-120), collectionViewLayout: flowLayout)
        collectionView!.backgroundColor = UIColor.grayColor()
        //注册
        collectionView!.registerClass(ZuberImageCell.self,forCellWithReuseIdentifier:"cell")
        //设置代理
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.view.addSubview(collectionView!)
        
        let backView = UIView()
        backView.backgroundColor = UIColor.whiteColor()
        backView.frame = CGRectMake(0, HEIGHT-70, WIDTH, 70)
        
        
        self.confirmBtnItem.frame = CGRectMake(30, 10, 70, 40)
        self.confirmBtnItem.backgroundColor = COLOR
        self.confirmBtnItem.setTitle("确定", forState: UIControlState.Normal)
        self.confirmBtnItem.addTarget(self, action: #selector(self.confirmClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmBtnItem.layer.masksToBounds = true
        self.confirmBtnItem.layer.cornerRadius = 5
        
        self.cancelBtnItem.frame = CGRectMake(WIDTH-100, 10, 70, 40)
        self.cancelBtnItem.backgroundColor = COLOR
        self.cancelBtnItem.setTitle("取消", forState: UIControlState.Normal)
        self.cancelBtnItem.addTarget(self, action: #selector(self.cancelClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.cancelBtnItem.layer.masksToBounds = true
        self.cancelBtnItem.layer.cornerRadius = 5
        
        backView.addSubview(self.confirmBtnItem)
        backView.addSubview(self.cancelBtnItem)
        self.view.addSubview(backView)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageArray.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ZuberImageCell;
        print(indexPath.row)
        print(imageArray.count)
        cell.update(imageArray[indexPath.row])
        cell.handleSelect={
            if cell.isSelect{
                if self.count > 0{
                   self.count -= 1
                }
                self.imageArray[indexPath.row].isSelect = false
                
            }else{
                self.count += 1
                self.imageArray[indexPath.row].isSelect = true
            }
            
            if(self.count > 0){
                self.title = "已选择\(self.count)张图片"
                self.confirmBtnItem.enabled = true
            }else{
                self.title = "请选择图片"
                self.confirmBtnItem.enabled = false
            }
            if self.count>9 {
                let alert = UIAlertView(title: "提示", message: "数量不能超过9张", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                cell.selectImageView.removeFromSuperview()
                cell.selectView.removeFromSuperview()
                self.imageArray[indexPath.item].isSelect = false
                return
            }
        }
        
        return cell;
        
    }
    
     func cancelClick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    
    func confirmClick(sender: UIBarButtonItem) {
        selectedImage=[]
        for  item in imageArray{
            if item.isSelect {
                selectedImage.append(item)
            }
        }
        photoDelegate?.passPhotos(selectedImage)
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    
}


extension ViewController1{
    
    func getGroupList(){
        
        let listGroupBlock:ALAssetsLibraryGroupsEnumerationResultsBlock = {(group,stop)->Void in
            
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()  //获取所有图
            if let group=group{
                
                group.setAssetsFilter(onlyPhotosFilter)
                
                if group.numberOfAssets() > 0{
                
                    self.showOhoto(group)
                    
                }else{
                    
                    
                }
            }
        }
        getAssetsLibrary().enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: listGroupBlock, failureBlock: nil)
    }
    
    
    func getAssetsLibrary()->ALAssetsLibrary{
        
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:ALAssetsLibrary?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=ALAssetsLibrary()
        })
        return Singleton.single!
        
    }
    
    func showOhoto(photos:ALAssetsGroup){
        
        if (currentAlbum == nil || currentAlbum?.valueForProperty(ALAssetsGroupPropertyName).isEqualToString(photos.valueForProperty(ALAssetsGroupPropertyName) as! String) != nil){
            
            self.currentAlbum = photos
            imageArray = []
            
            let assetsEnumerationBlock:ALAssetsGroupEnumerationResultsBlock = { (result,index,stop) in
                
                if (result != nil) {
                    self.tempZuber = ZuberImage()
                    self.tempZuber.asset = result
                    self.tempZuber.isSelect = false
                    self.imageArray.append(self.tempZuber)
                    self.collectionView!.reloadData()
                    self.assetsLibrary = nil
                    self.currentAlbum = nil
                }else{
                    
                }
            }
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()
            self.currentAlbum?.setAssetsFilter(onlyPhotosFilter)
            self.currentAlbum?.enumerateAssetsUsingBlock(assetsEnumerationBlock)
        }
        
    }

    
}

