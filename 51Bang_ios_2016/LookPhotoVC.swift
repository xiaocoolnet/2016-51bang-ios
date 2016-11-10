//
//  LookPhotoVC.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/8/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LookPhotoVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {
    
    var myPhotoArray = NSArray()
    var count  =  Int()
    var mycollection : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return myPhotoArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        
        
//        let cell = UICollectionViewCell.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        
        let lookPhotosImageView = UIImageView()
        lookPhotosImageView.backgroundColor = UIColor.whiteColor()
        lookPhotosImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        
        
        if myPhotoArray[indexPath.item].isKindOfClass(UIImageView){
            lookPhotosImageView.image = (myPhotoArray[indexPath.item] as? UIImageView)?.image
        }else{
            lookPhotosImageView.image = myPhotoArray[indexPath.item] as? UIImage
        }
        
        lookPhotosImageView.contentMode = .ScaleAspectFit
        cell.addSubview(lookPhotosImageView)
        return cell
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
