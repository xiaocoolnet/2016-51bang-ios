//
//  LookPhotoVC.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/8/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LookPhotoVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate  {
    
    var lookPhotosImageView = UIImageView()
    var myPhotoArray = NSArray()
    var count  =  Int()
    var mycollection : UICollectionView?
    var lastScaleFactor : CGFloat! = 1  //放大、缩小
    
    var pic:[PicInfos] = []
    var pic1:[PicInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(myPhotoArray.count)
        ConvenientPeople.isFresh = true
        let flowl = UICollectionViewFlowLayout.init()
        //设置每一个item大小
        flowl.itemSize = CGSizeMake(WIDTH, HEIGHT-64)
        flowl.minimumInteritemSpacing = 0
        flowl.minimumLineSpacing = 0
//        flowl.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        flowl.scrollDirection = UICollectionViewScrollDirection.Horizontal
        mycollection = UICollectionView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT),collectionViewLayout: flowl)
        //        mycollection.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        mycollection!.backgroundColor = UIColor.whiteColor()
        mycollection!.delegate = self
        mycollection!.dataSource = self
        mycollection!.pagingEnabled = true
        print(count)
//        mycollection.contentOffset =
        
        
        mycollection!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(mycollection!)
        
        mycollection!.bouncesZoom = false
        print(mycollection!.contentOffset)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = true
    }
    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
        mycollection!.contentOffset = CGPointMake(WIDTH*CGFloat(count),0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.pic.count != 0 || self.pic1.count != 0{
            return 1
        }else{
            return self.myPhotoArray.count
        }
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        if self.pic.count != 0 || self.pic1.count != 0{
            let browser = SDPhotoBrowser()
            browser.currentImageIndex = count
            browser.sourceImagesContainerView = self.mycollection
            browser.imageCount = self.myPhotoArray.count
            browser.delegate = self
            browser.vc = self
            browser.show()
        }else{
            
            let cell = UICollectionViewCell.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
            
            lookPhotosImageView = UIImageView()
            lookPhotosImageView.backgroundColor = UIColor.whiteColor()
            lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
            lookPhotosImageView.tag = indexPath.item
            lookPhotosImageView.userInteractionEnabled = true
            if myPhotoArray[indexPath.item].isKindOfClass(UIImageView){
                lookPhotosImageView.image = ((myPhotoArray[indexPath.item] as? UIImageView)?.image)!
            }else{
                lookPhotosImageView.image = (myPhotoArray[indexPath.item] as? UIImage)!
            }

            
            
            lookPhotosImageView.contentMode = .ScaleAspectFit
            cell.addSubview(lookPhotosImageView)

        }
        
        
        
        return cell
    }
    
    func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
        var imageView =  UIImage()
        if myPhotoArray[index].isKindOfClass(UIImageView){
            imageView = ((myPhotoArray[index] as? UIImageView)?.image)!
        }else{
            imageView = (myPhotoArray[index] as? UIImage)!
        }
        
        
        return imageView;
    }
    
    func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
        
        var imageName = String()
        if  self.pic.count == 0 {
            imageName = self.pic1[index].pictureurl! as String
        }else{
            imageName = self.pic[index].pictureurl! as String
        }
        
        let url = NSURL(string:  Bang_Image_Header + imageName)
        
        return url
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.navigationController?.navigationBar.hidden == true {
            UIView.animateWithDuration(0.3) {
                self.navigationController?.navigationBar.hidden = false
        }
        
        }else{
            UIView.animateWithDuration(0.3) {
                self.navigationController?.navigationBar.hidden = true
            }
        }
        
//        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender: UIPinchGestureRecognizer){
        if sender.state == .Began {
            self.mycollection?.scrollEnabled = false
        }else if sender.state == .Ended{
            self.mycollection?.scrollEnabled = true
        }
        
        let factor = sender.scale
        if factor > 1{
            //图片放大
            lookPhotosImageView.transform = CGAffineTransformMakeScale(lastScaleFactor+factor-1, lastScaleFactor+factor-1)
        }else{
            //缩小
            if lookPhotosImageView.transform.d<1 {
                return
            }
            lookPhotosImageView.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor)
            
        }
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.Ended{
            if factor > 1{
                lastScaleFactor = lastScaleFactor + factor - 1
            }else{
                lastScaleFactor = lastScaleFactor * factor
            }
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        lookPhotosImageView.transform = CGAffineTransformIdentity
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
