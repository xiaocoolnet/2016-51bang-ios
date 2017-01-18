 //
 //  MainHelper.swift
 //  51Bang_ios_2016
 //
 //  Created by zhang on 16/7/6.
 //  Copyright © 2016年 校酷网络科技公司. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import AFNetworking
 import AVFoundation
 class MainHelper: NSObject {
    
    var audioSession = AVAudioSession()
    var audioPlayer: AVAudioPlayer?
    
    
    func getTaskList(userid:String,beginid:String,cityName:String,longitude:String,latitude:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"getTaskListByCity"
        //                let param = [
        //                    "userid":"1",
        //                    "city":"北京",
        //                    "longitude":"110.23121",
        //                    "latitude":"12.888"
        //                ];
        let param1 = [
            
            "userid":userid,
            "city":cityName,
            "beginid":beginid,
            "longitude":longitude,
            "latitude":latitude
            
        ];
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TaskModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    print(result.datas.count)
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    //获取字典列表
    func getDicList(type:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"getDictionaryList"
        let param1 = [
            
            "type":type
            
        ];
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = DicModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    print(result.datas.count)
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    
    //检查是否需要重新登录
    func checkIslogin(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"checkLogin"
        let param1 = [
            
            "userid":userid,
            
        ];
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
//                    print(result.datas)
//                    print(result.datas.count)
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    
    //获取是否工作中
    func GetWorkingState(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetWorkingState"
        let param1 = [
            
            "userid":userid
            
        ];
        isMemberOfClass(NSNull)
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = WorkingStateModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
//                    print(result.datas)
//                    print(result.datas.count)
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    //开工接口
    func BeginWorking(userid:String,address:String,longitude:String,latitude:String,isworking:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"BeginWorking"
        let param1 = [
            
            "userid":userid,
            "address":address,
            "longitude":longitude,
            "latitude":latitude,
            "isworking":isworking
            
        ];
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = WorkingStateModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    //                    print(result.datas)
                    //                    print(result.datas.count)
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    //发布任务
    func upLoadOrder(userid:String,title:String,description:String,address:String,longitude:String,latitude:String,saddress:String,slongitude:String,slatitude:String, expirydate:String,price:String,type:String,sound:String,picurl:NSArray,soundtime:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"publishTask"
        
        let photoUrl = NSMutableString()
        for i in 0..<picurl.count {
            if i == picurl.count-1{
                photoUrl.appendString(picurl[i] as! String)
            }else{
                photoUrl.appendString(picurl[i] as! String)
                photoUrl.appendString(",")
            }
        }
        let param = [
            "userid":userid,
            "title":title,
            "description":description,
            "address":address,
            "saddress":saddress,
            "longitude":longitude,
            "latitude":latitude,
            "slongitude":slongitude,
            "slatitude":slatitude,
            "expirydate":expirydate,
            "sound":sound,
            "type":type,
            "price":price,
            "picurl":photoUrl,
            "soundtime":soundtime
        ];
        //        let param1 = [
        //
        //            "userid":userid,
        //            "title":title,
        //            "description":description,
        //            "address":address,
        //            "longitude":longitude,
        //            "latitude":latitude,
        //            "price":price
        //        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    //                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }

    
    //商品购买
    func buyGoods(userid:String,roomname:String,goodsid:String,goodnum:String,mobile:String,remark:String,money:String,delivery:String, address:String, handle:ResponseBlock){
        let url = Bang_URL_Header+"bookingshopping"
        
        let param = [
            "userid":userid,
//            "goodsname":roomname,
            "goodsid":goodsid,
            "goodnum":goodnum,
            "mobile":mobile,
            "remark":remark,
            "money":money,
            "delivery":delivery,
            "address":address
            
        ]
        //        let param1 = [
        //
        //            "userid":userid,
        //            "title":title,
        //            "description":description,
        //            "address":address,
        //            "longitude":longitude,
        //            "latitude":latitude,
        //            "price":price
        //        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    //                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
//    func downloadImage(recordName:String) ->NSData{
//        
//        let url = Bang_Image_Header+recordName
//        let destination = Alamofire.Request.suggestedDownloadDestination(
//            directory: .DocumentDirectory, domain: .UserDomainMask)
//        print(destination)
//        var b = NSData()
//        Alamofire.download(.GET, url, destination: destination)
//            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
//                let percent = totalBytesRead*100/totalBytesExpectedToRead
//                print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
//            }
//            .response { (request, response, _, error) in
//                print(response)
//                let fileManager = NSFileManager.defaultManager()
//                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
//                    inDomains: .UserDomainMask)[0]
//                let pathComponent = response!.suggestedFilename
//                let pathUrl = directoryURL.URLByAppendingPathComponent(pathComponent!)
//                
//                print(pathUrl)
//                let a = UIImage.init(contentsOfFile: pathUrl.path!)
//                 b = UIImageJPEGRepresentation(a!, 1)!
//                let userData = NSUserDefaults.standardUserDefaults()
//                userData.setObject(b, forKey: "userphoto")
//                
////                print(b)
////                do{
////                    self.audioSession = AVAudioSession.sharedInstance()
////                    try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
////                    try self.audioSession.setActive(true)
////                    self.audioPlayer = try AVAudioPlayer.init(contentsOfURL:pathUrl)
////                    self.audioPlayer!.prepareToPlay()
////                    //                    self.audioPlayer!.numberOfLoops = -1
////                    self.audioPlayer!.volume = 1;
////                    self.audioPlayer!.play()
////                }catch{
////                    print("1233444")
////                }
//        }
////        print("00000")
//        return b
//    }
//    
    
    //语音下载
    func downloadRecond(recordName:String, handles:DownMP3Block) {
        
        let url = Bang_Image_Header+recordName
        let destination = Alamofire.Request.suggestedDownloadDestination(
            directory: .DocumentDirectory, domain: .UserDomainMask)
        print(destination)
        
        let directoryURL = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        
        let fileManager = NSFileManager.defaultManager()
//        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
//                                                        inDomains: .UserDomainMask)[0]
//        let pathComponent = recordName.suggestedFilename
        
        let pathUrl = directoryURL.stringByAppendingString("/" + recordName)
        let b = NSURL.init(fileURLWithPath: pathUrl, isDirectory: true)
       

//        if fileManager.fileExistsAtPath(pathUrl) {
//            handles(success: true, response: pathUrl)
//            return
//        }
        Alamofire.download(.GET, url) {
            temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
                                                            inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            let a = directoryURL.URLByAppendingPathComponent(pathComponent!)
            print(a)
            
//            dispatch_async(dispatch_get_main_queue(), {
//                let url = NSBundle.mainBundle().URLForResource("杨宗纬 - 空白格", withExtension: ".mp3")
                
                do{
                    self.audioSession = AVAudioSession.sharedInstance()
                    try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try self.audioSession.setActive(true)
                    self.audioPlayer = try AVAudioPlayer.init(contentsOfURL:a)
                    self.audioPlayer!.prepareToPlay()
                    //                    self.audioPlayer!.numberOfLoops = -1
                    self.audioPlayer!.volume = 1;
                    self.audioPlayer!.play()
                }catch{
                   
                    print("1233444")
                }
//            })
            
            
            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        }
        
//        Alamofire.download(.GET, url, destination: destination)
//            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
//                let percent = totalBytesRead*100/totalBytesExpectedToRead
//                print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
//            }
//            .response { (request, response, _, error) in
//                print(response)
//                print(error)
//                if error != nil{
//                    handles(success: true, response: "失败")
//                    return
//                }
//                handles(success: true, response: pathUrl)
//                
//                
//                
//                       }
        
//        var pathUrl = NSURL()
        
        
//        Alamofire.download(.GET, url){ temporaryURL, response in
//            let fileManager = NSFileManager.defaultManager()
//            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
//                                                            inDomains: .UserDomainMask)[0]
//            let pathComponent = response.suggestedFilename
//            pathUrl = directoryURL.URLByAppendingPathComponent(pathComponent!)
//            return directoryURL.URLByAppendingPathComponent(pathComponent!)
//        }
//        return pathUrl
    }
    //发布便民信息
    func upLoadMessage(userid:NSString,phone:String,type:NSString,title:NSString,content:NSString,photoArray:NSArray,sound:NSString,soundtime:String,address2:String,longitude:String,latitude:String, handle:ResponseBlock){
        let url = Bang_URL_Header+"addbbsposts"
        let photoUrl = NSMutableString()
        for i in 0..<photoArray.count {
            if i == photoArray.count-1{
                photoUrl.appendString(photoArray[i] as! String)
            }else{
                photoUrl.appendString(photoArray[i] as! String)
                photoUrl.appendString(",")
            }
            //            photoUrl.appendString(photoArray[i] as! String)
            //            photoUrl.appendString(",")
            //            if i==photoArray.count-1 {
            ////                photoUrl.delete(",")
            //                photoUrl.deleteCharactersInRange(NSRange.init(location: i, length: 1))
            //            }
        }
        print(photoUrl)
        let param = [
            
            "userid":userid,
            "title":title,
            "content":content,
            "picurl":photoUrl,
            "sound":sound,
            "soundtime":soundtime,
            "phone":phone,
            "address":address2,
            "longitude":longitude,
            "latitude":latitude
        ];
        
//        Alamofire.upload(<#T##URLRequest: URLRequestConvertible##URLRequestConvertible#>, data: <#T##NSData#>)
        
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    //发布评论
    func upLoadevaluate(userid:NSString,type:NSString,id:NSString,content:NSString,photoArray:NSArray,photo:UIImage,handle:ResponseBlock){
        let url = Bang_URL_Header+"SetComment"
        let photoUrl = NSMutableString()
        for i in 0..<photoArray.count {
            if i == photoArray.count-1{
                photoUrl.appendString(photoArray[i] as! String)
            }else{
                photoUrl.appendString(photoArray[i] as! String)
                photoUrl.appendString(",")
            }
            //            photoUrl.appendString(photoArray[i] as! String)
            //            photoUrl.appendString(",")
            //            if i==photoArray.count-1 {
            ////                photoUrl.delete(",")
            //                photoUrl.deleteCharactersInRange(NSRange.init(location: i, length: 1))
            //            }
        }
        print(photoUrl)
        let param = [
            
            "userid":userid,
            "id":id,
            "content":content,
            //            "picture":photoUrl,
            "photo":photo,
            "type":type
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    //                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    //检测城市是否开通
    func checkCity(city:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"CheckCity"
        
                let param = [
            
            "city":city
                    ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }

    
    
    
    
    func postMp3(pathUrl:NSURL,handle:ResponseBlock){
        
        
        
        Alamofire.upload(.POST, Bang_URL_Header+"uploadRecord", file: pathUrl).response{
            request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TchdModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    handle(success: true, response: result.datas)
                    
                }else{
                    //                    handle(success: false, response: result.errorData)
                    
                }
            }
            
            
            
        }
        
    }
    
    
    
    func GetTchdList(type:NSString,beginid:NSString,handle:ResponseBlock){
        let ud = NSUserDefaults.standardUserDefaults()
        var cityName = String()
        
        let url = Bang_URL_Header+"getbbspostlist"
        if (ud.objectForKey("quName") != nil) {
            cityName = ud.objectForKey("quName") as! String
        }
        
        let param = [
            
            "type":type,
            "beginid":beginid,
            "city":cityName
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TchdModel(JSONDecoder(json!))
//                print("---")
//                print(result)
//                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
//                    print(result.datas)
                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    
    func GetRzbList(cityname:String,beginid:String,sort:String, type:String,isOnLine:String, handle:ResponseBlock){
        
        
        let url = Bang_URL_Header+"getAuthenticationUserList"
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        var latitude = String()
        var longitude = String()
        if userLocationCenter.objectForKey("latitude") != nil && userLocationCenter.objectForKey("longitude") != nil{
            latitude = userLocationCenter.objectForKey("latitude") as! String
            longitude = userLocationCenter.objectForKey("longitude") as! String
        }
        Alamofire.request(.GET, url, parameters: ["beginid":beginid,"cityname":cityname,"sort":sort,"type":type,"online":isOnLine,"latitude":latitude,"longitude":longitude]).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = RzbModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    
    
    func GetHomeRzbList(cityname:String,beginid:String,sort:String, type:String, handle:ResponseBlock){
        
        
        let url = Bang_URL_Header+"HomegetAuthenticationUserList"
//        let userLocationCenter = NSUserDefaults.standardUserDefaults()
////        var latitude = String()
////        var longitude = String()
//        if userLocationCenter.objectForKey("latitude") != nil && userLocationCenter.objectForKey("longitude") != nil{
//            latitude = userLocationCenter.objectForKey("latitude") as! String
//            longitude = userLocationCenter.objectForKey("longitude") as! String
//        }
        Alamofire.request(.GET, url, parameters: ["cityname":cityname]).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = RzbModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    //获取我的下级推广客户
    func GetNextGrade(userid:NSString,beginid:String, handle:ResponseBlock){
        let url = Bang_URL_Header+"getMyIntroduceList"
        let param = [
            "beginid":beginid,
            "userid":userid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = RzbModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    print(result.datas.count)
                    
                    
                    
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
        
    }

    
    
    func GetTaskList(userid:NSString,state:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"getTaskListByUserid"
        let param = [
            "userid":userid,
            "state":state
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TaskModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    print(result.datas.count)
                    
                    
                    
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
        
    }
    
    //获取发单详情
    func getFaDanDetail(taskid:String,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"getTaskInfoByTaskid"
        let paramDic = ["taskid":taskid]
        
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = fadanDetailModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    //                    print(result.datas)
                    //                    print(result.datas.count)
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    //买家获取订单详情列表
    func getDingDanDetail(userid:String,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"BuyerGetShoppingOrderList"
        let paramDic = ["userid":userid]
        
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = fadanDetailModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    //                    print(result.datas)
                    //                    print(result.datas.count)
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    func qiangDan(userid:NSString,taskid:NSString,longitude:NSString,latitude:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"ApplyTask"
        let param = [
            "userid":userid,
            "taskid":taskid,
            "longitude":longitude,
            "latitude":latitude
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    
    //获取我的接单
    func getMyGetOrder(userid:NSString,state:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"getMyApplyTaskList"
        let param = [
            "userid":userid,
            "state":state
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TaskModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.datas)
                    print(result.datas.count)
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
        
    }
    
    //获取我的订单
    func getMyOrder(userid:NSString,state:NSString,type:Bool,handle:ResponseBlock){
        var url = String()
        if !type {
            url = Bang_URL_Header+"BuyerGetShoppingOrderList"
        }else{
            url = Bang_URL_Header+"SellerGetShoppingOrderList"
        }
        
//        let url = Bang_URL_Header+"BuyerGetShoppingOrderList"
        let param = [
            "userid":userid,
            "state":state
        ];
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = MyOrderModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
//                    print(result.datas)
//                    print(result.datas.count)
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    
    //支付宝上传支付状态
    /*
     state:微信支付还是支付宝支付。1-支付宝，2－微信
     type:任务的支付还是商品的支付 1- 任务，2-商品
  */
    func upALPState(order_num:String,state:String,type:String, handle:ResponseBlock){
        
        let url = Bang_URL_Header
        
        var typeNum = String()
        if type == "1" {
            typeNum = "UpdataTaskPaySuccess"
        }else{
            typeNum = "UpdataShoppingPaySuccess"
        }
        var paytype = String()
        if state == "1" {
            paytype = "alipay"
        }else{
            paytype = "weixin"
        }
        let param = [
            "a":typeNum,
            "order_num":order_num,
            "paytype":paytype
            
        ];
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            print(error)
            print(json)
            if(1 != 1){
//                handle(success: false, response: error?.description)
            }else{
                print(JSONDecoder(json!).value)
                let result = ZHIFUfankui(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                print(result.status)
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
//                    print(result.datas)
//                    print(result.datas.count)
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }

    //发表评论
    //  static  func AddConmment(parm:Dictionary<String,String>,url:String)
    //    {
    //        let manager = AFHTTPSessionManager()
    //        manager.requestSerializer = AFHTTPRequestSerializer()
    //        manager.responseSerializer.acceptableContentTypes = NSSet.init(object: "text/html" ) as! Set<String>
    //        manager.GET(url, parameters: parm, success: { (task, response) in
    //            let result = JSONDecoder(response!).dictionary
    //            if (result!["status"]?.string == "success"){
    //                print("成功")
    //            }
    //            else{
    //                print("评论失败")
    //            }
    //            }) { (task, errpr) in
    //                print("服务器连接失败")
    //        }
    //
    //    }
    //发布评论
    /*
     orderid(订单编号),type(任务是1,商城是2),usertype(1= 》发布者，2=》购买者)
  */
    func upLoadComment(userid:NSString,id:NSString,content:NSString,type:NSString,photo:NSString,usertype:String,score:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"SetEvaluate"
        //        let photoUrl = NSMutableString()
        //        for i in 0..<photo.count {
        //            if i == photo.count-1{
        //                photoUrl.appendString(photo[i] as! String)
        //            }else{
        //                photoUrl.appendString(photo[i] as! String)
        //                photoUrl.appendString(",")
        //            }
        //
        //        }
        //        print(photoUrl)
        let param = [
            
            "userid":userid,
            "orderid":id,
            "content":content,
            "type":type,
            //            "photo":photoUrl
            "photo":photo,
            "receivetype":usertype,
            "score":score
            
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    //取消订单
    func gaiBianDingdan(ordernum:NSString,state:NSString,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"UpdataShoppingState"
        let param = [
            
            "order_num":ordernum,
            "state":state
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    
    //改变任务
    func gaiBianRenWu(userid:String,ordernum:NSString,state:NSString,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"UpdataTaskState"
        let param = [
            "userid":userid,
            "order_num":ordernum,
            "state":state
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }

    
    //获取商品详细信息
    
    func getshowshopping(id:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"showshoppinginfo"
        let paramDic = ["id":id]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = GoodsModel2(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                print(result.data)
                
            }
            
            
        }
        
        
    }

    //获取是否收藏
    func getCheckHadFavorite(userid:String,refid:String,type:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"CheckHadFavorite"
        let paramDic = ["userid":userid,
                        "refid":refid,
                        "type":type
        ]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = favoriteModel(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status!)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                print(result.data)
                
            }
            
            
        }
        
        
    }
    
    
    // mark 留言：发送聊天信息
    func sendMessage(send_uid:NSString,receive_uid:NSString,content:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"SendChatData"
       
        let param = [
            
            "send_uid":send_uid,
            "receive_uid":receive_uid,
            "content":content
        
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    //获取聊天列表
    func getChatList(uid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"xcGetChatListData"
        let paramDic = ["uid":uid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = chatListModel(JSONDecoder(json!))
            print(result)
//            print(result.datas)
//            print(result.status!)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.datas)
            }else{
//                alert(error, delegate: self)
                handle(success: false, response: result.datas)
                print(result.data)
                
            }
            
            
        }
        
        
    }

    //获取聊天信息（两个人之间的）
    func getChatMessage(send_uid:String,receive_uid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"xcGetChatData"
        let paramDic = ["send_uid":send_uid,
                        "receive_uid":receive_uid
        ]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            print(response)
//            let dictionary:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(json!)! as! NSDictionary
//            print(dictionary)
            let dogString:String = (NSString(data: json!, encoding: NSUTF8StringEncoding))! as String
            print(dogString)
            
//            let a = String.init(data: json!, encoding: NSStringEncoding)
            let result = chatModel(JSONDecoder(json!))
            print(JSONDecoder(json!).array)
            print(result)
            print(result.status!)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.datas)
            }else{
                handle(success: false, response: result.datas)
                print(result.data)
                
            }
            
            
        }
        
        
    }

    //卷码验证
    func getVerifyShoppingCode(userid:String,code:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"VerifyShoppingCode"
        let param1 = [
            
            "userid":userid,
            "code":code
            
        ];
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = JuanmaModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                if(result.status == "success"){
                
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    

    //获取我的接单接单数目
    func GetMyApplyTastTotal(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetMyApplyTastTotal"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = GetMyApplyTastTotalModel(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                print(result.data)
                
            }
            
            
        }
        
        
    }

    //获取绑定用户银行、支付宝信息
    func getUserBank(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetUserBankInfo"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = GetUserBankModel(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                print(result.data)
                
            }
            
            
        }
        
        
    }
    

     //提现申请
    func ApplyWithdraw(userid:NSString,money:NSString,banktype:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"ApplyWithdraw"
        
        let param = [
            
            "userid":userid,
            "money":money,
            "banktype":banktype
            
        ];
        
       
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }

    //提交保险认证
    func UpdateUserInsurance(userid:NSString,photoArray:NSArray,expirydate:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"UpdateUserInsurance"
        let photoUrl = NSMutableString()
        for i in 0..<photoArray.count {
            if i == photoArray.count-1{
                photoUrl.appendString(photoArray[i] as! String)
            }else{
                photoUrl.appendString(photoArray[i] as! String)
                photoUrl.appendString(",")
            }
            
        }
            let param = [
            "userid":userid,
            "expirydate":expirydate,
            "photo":photoUrl
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
            
        }
    }

    //删除发布的帖子
    func Deletebbspost(userid:NSString,id:NSString,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"deletebbspost"
        let param = [
            
            "userid":userid,
            "id":id
            
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    
    //便民圈举报
    func Report(userid:NSString,type:NSString,refid:NSString,content:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"Report"
       
        let param = [
            
            "userid":userid,
            "type":type,
            "refid":refid,
            "content":content
            
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }

}
