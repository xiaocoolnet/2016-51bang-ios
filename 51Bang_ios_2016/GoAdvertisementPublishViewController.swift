//
//  GoAdvertisementPublishViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class GoAdvertisementPublishViewController: UIViewController,GKImagePickerDelegate {
    
    let addImageButton = UIButton()
    let selectImageView = UIImageView()
    var icurDay = NSInteger()
    var icurMonth = NSInteger()
    var icurDYear = NSInteger()
    var sumDayOfMonth = NSInteger()
    var timeDic = NSMutableDictionary()
    var timeStampArray:Array<String> = ["","",""]
    var imagePicker = GKImagePicker()
    var selectedImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.title = "广告发布"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.creatUI()

        // Do any additional setup after loading the view.
    }
    func creatUI(){
        
        let typeLabel = UILabel.init(frame: CGRectMake(10, 30, 60, 20))
        typeLabel.text = "广告位置:"
        typeLabel.font = UIFont.systemFontOfSize(13)
        typeLabel.textColor = UIColor.blackColor()
        self.view.addSubview(typeLabel)
        
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
            self.view.addSubview(typeButton)
        }
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

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowTimeStr = dateFormatter.stringFromDate(NSDate())
        
        var timeStr1 = String()
        var timeStr2 = String()
        var timeStr3 = String()
        
        if self.icurDay<11{
            timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-10"
            timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-20"
            timeStr3 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
        }else if self.icurDay<21&&self.icurDay>10 {
            if self.icurMonth != 12{
                timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-10"
                timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
                timeStr3 = String(self.icurDYear)+"-"+String(self.icurMonth+1)+"-20"
            }else{
                timeStr1 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-10"
                timeStr2 = String(self.icurDYear)+"-"+String(self.icurMonth)+"-"+String(sumDayOfMonth)
                timeStr3 = String(self.icurDYear+1)+"-"+"01"+"-20"
            }
           
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
        }
        timeDic.setValue(timeStr1, forKey: "100")
        timeDic.setValue(timeStr2, forKey: "101")
        timeDic.setValue(timeStr3, forKey: "102")
        print(timeStr1)
        print(timeStr2)
        print(timeStr3)
        
        let timeLabel = UILabel.init(frame: CGRectMake(10, 80, 100, 20))
        timeLabel.text = "广告播放时间:"
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textColor = UIColor.blackColor()
        self.view.addSubview(timeLabel)
        for index in 0...2 {
            let timesButton = UIButton.init(frame: CGRectMake(50, CGFloat(index*50)+120, WIDTH-100, 30))
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
            timesButton.backgroundColor = UIColor.grayColor()
            timesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//            timesButton.setTitle(String(index), forState: .Normal)
            timesButton.tag = index+100
            timesButton.layer.masksToBounds = true
            timesButton.layer.cornerRadius = 5
            timesButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            timesButton.addTarget(self, action: #selector(self.timesButtonAction(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(timesButton)
        }
        
        
        
        
        self.addImageButton.setTitle("添加/更改图片", forState: .Normal)
        self.addImageButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.addImageButton.backgroundColor = COLOR
        self.addImageButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.addImageButton.frame = CGRectMake(WIDTH/2-50, 290, 120, 30)
        self.view.addSubview(self.addImageButton)
        self.addImageButton.addTarget(self, action: #selector(self.addImageButtonAction), forControlEvents: .TouchUpInside)
    }
    
    
    func creatImageUI(){
        selectImageView.frame = CGRectMake(30, addImageButton.height+addImageButton.frame.origin.y+30, WIDTH-60, WIDTH/2-30)
        selectImageView.image = self.selectedImage
        selectImageView.contentMode = .ScaleAspectFit
        if self.selectImageView.superview == nil{
            self.view.addSubview(selectImageView)
        }
        
    }
    
    func typeButtonAction(sender:UIButton){
        if !sender.selected{
            for index in 1...3 {
                if (self.view.viewWithTag(index) as? UIButton)!.selected{
                    (self.view.viewWithTag(index) as? UIButton)!.backgroundColor = UIColor.grayColor()
                    (self.view.viewWithTag(index) as? UIButton)!.selected = false
                }
            }
            sender.backgroundColor = COLOR
            sender.selected = !sender.selected
        }
    }
    func timesButtonAction(sender:UIButton){
        if !sender.selected{
            timeStampArray[sender.tag-100] = stringToTimeStampWithyyyymmdd((self.timeDic.objectForKey(String(sender.tag)) as! String))
            sender.backgroundColor = COLOR
        }else{
            timeStampArray[sender.tag-100] = ""
            
            sender.backgroundColor = UIColor.grayColor()
        }
        sender.selected = !sender.selected
    }
    
    func addImageButtonAction(){
        self.imagePicker.cropSize = CGSizeMake(WIDTH, WIDTH/2)
        self.imagePicker.delegate = self
        self.presentViewController(self.imagePicker.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePicker(imagePicker: GKImagePicker!, pickedImage image: UIImage!) {
        
        self.selectedImage = image
        self.creatImageUI()
        self.imagePicker.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
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
