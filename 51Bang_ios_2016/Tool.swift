//
//  Tool.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
import UIKit

let Bang_Open_Header = "http://www.my51bang.com/"
//let Bang_Open_Header = "http://bang.xiaocool.net/"

let Bang_URL_Header = Bang_Open_Header+"index.php?g=apps&m=index&a="
let Bang_Image_Header = Bang_Open_Header+"uploads/images/"

typealias TimerHandle = (timeInterVal:Int)->Void


//计时器类
class TimeManager{
    var taskDic = Dictionary<String,TimeTask>()
    
    //两行代码创建一个单例
    static let shareManager = TimeManager()
    private init() {
    }
    func begainTimerWithKey(key:String,timeInterval:Float,process:TimerHandle,finish:TimerHandle){
        if taskDic.count > 20 {
            print("任务太多")
            return
        }
        if timeInterval>120 {
            print("不支持120秒以上后台操作")
            return
        }
        if taskDic[key] != nil{
            print("存在这个任务")
            return
        }
        let task = TimeTask().configureWithTime(key,time:timeInterval, processHandle: process, finishHandle:finish)
        taskDic[key] = task
    }
}
class TimeTask :NSObject{
    var key:String?
    var FHandle:TimerHandle?
    var PHandle:TimerHandle?
    var leftTime:Float = 0
    var totolTime:Float = 0
    var backgroundID:UIBackgroundTaskIdentifier?
    var timer:NSTimer?
    
    func configureWithTime(myKey:String,time:Float,processHandle:TimerHandle,finishHandle:TimerHandle) -> TimeTask {
        backgroundID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        key = myKey
        totolTime = time
        leftTime = totolTime
        FHandle = finishHandle
        PHandle = processHandle
        timer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(sendHandle), userInfo: nil, repeats: true)
        
        //将timer源写入runloop中被监听，commonMode-滑动不停止
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        return self
    }
    
    func sendHandle(){
        leftTime -= 1
        if leftTime > 0 {
            if PHandle != nil {
                PHandle!(timeInterVal:Int(leftTime))
            }
        }else{
            timer?.invalidate()
            TimeManager.shareManager.taskDic.removeValueForKey(key!)
            if FHandle != nil {
                FHandle!(timeInterVal: 0)
            }
        }
    }
}

//正则验证类
class RegularExpression{
    //身份证
    class func validateIdentityCard(card:String) -> Bool{
        let string = NSString(string: card)
        let length =  NSString(string: card).length
        if length != 15 && length != 18 {
            return false
        }
        var regex:String?
        if length == 15 {
            regex = "^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"
        }else{
            regex = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"
        }
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        
        return predicate.evaluateWithObject(string)
    }}


//  提示框
func alert(message:String,delegate:AnyObject){
    let alert = UIAlertView(title: "提示", message: message, delegate: delegate, cancelButtonTitle: "确定")
    alert.show()
}

//计算文字高度
func calculateHeight(string:String,size:CGFloat,width:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)
    print(boundingRect.height)
    return boundingRect.height
}

func stringToTimeStamp(stringTime:String)->String {
    
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    let date = dfmatter.dateFromString(stringTime)
    
    let dateStamp:NSTimeInterval = date!.timeIntervalSince1970
    
    let dateSt:Int = Int(dateStamp)
    print(dateSt)
    return String(dateSt)
    
}

 func timeStampToString(timeStamp:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:NSTimeInterval = string.doubleValue
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="MM月dd日 HH:mm"
    
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    print(dfmatter.stringFromDate(date))
    return dfmatter.stringFromDate(date)
}

func removeOptionWithString(str:String)->String{
//    let str = String(self.longitude)
    print(str)
    
//    let array:NSArray = str.componentsSeparatedByString("(")
//    
//    print(array)
//    //我已经修改过，此处存在Array index out of range错误
//    let str2 = array[1]as! String
//    let array2 = str2.componentsSeparatedByString(")")
//    print(array2)
//    let str3 = array2[0]
//    print(str3)
//    return str3
    return str
}




