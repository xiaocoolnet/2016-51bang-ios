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
    
    
    func getTaskList(userid:String,cityName:String,longitude:String,latitude:String,handle:ResponseBlock){
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
            "picurl":photoUrl
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
    
    
    func downloadRecond(recordName:String)->NSURL {
        
        let url = Bang_Image_Header+recordName
        let destination = Alamofire.Request.suggestedDownloadDestination(
            directory: .DocumentDirectory, domain: .UserDomainMask)
        print(destination)
        
        Alamofire.download(.GET, url, destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                let percent = totalBytesRead*100/totalBytesExpectedToRead
                print("已下载：\(totalBytesRead)  当前进度：\(percent)%")
            }
            .response { (request, response, _, error) in
                print(response)
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
                    inDomains: .UserDomainMask)[0]
                let pathComponent = response!.suggestedFilename
                let pathUrl = directoryURL.URLByAppendingPathComponent(pathComponent!)
                print(pathUrl)
                do{
                    self.audioSession = AVAudioSession.sharedInstance()
                    try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try self.audioSession.setActive(true)
                    self.audioPlayer = try AVAudioPlayer.init(contentsOfURL:pathUrl)
                    self.audioPlayer!.prepareToPlay()
                    //                    self.audioPlayer!.numberOfLoops = -1
                    self.audioPlayer!.volume = 1;
                    self.audioPlayer!.play()
                }catch{
                    print("1233444")
                }
        }
        
        var pathUrl = NSURL()
        
        
        Alamofire.download(.GET, url){ temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
                                                            inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            pathUrl = directoryURL.URLByAppendingPathComponent(pathComponent!)
            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        }
        return pathUrl
    }
    //发布便民信息
    func upLoadMessage(userid:NSString,type:NSString,title:NSString,content:NSString,photoArray:NSArray,sound:NSString,soundtime:String,phone:String, handle:ResponseBlock){
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
            "phone":phone
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
    //发布评论
    func upLoadevaluate(userid:NSString,type:NSString,id:NSString,content:NSString,photoArray:NSArray,photo:UIImage,handle:ResponseBlock){
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
        
        
        
        Alamofire.upload(.POST, "http://bang.xiaocool.net/index.php?g=apps&m=index&a=uploadRecord", file: pathUrl).response{
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
        let url = Bang_URL_Header+"getbbspostlist"
        let param = [
            
            "type":type,
            "beginid":beginid
        ];
        
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
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
    
    
    func GetRzbList(handle:ResponseBlock){
        
        // url	String	"http://bang.xiaocool.net/index.php?g=apps&m=index&a=getAuthenticationUserList"
        let url = Bang_URL_Header+"getAuthenticationUserList"
        
        Alamofire.request(.GET, url, parameters: nil).response { request, response, json, error in
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
    func getMyOrder(userid:NSString,state:NSString,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"BuyerGetShoppingOrderList"
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
                    print(result.datas)
                    print(result.datas.count)
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
    func upLoadComment(userid:NSString,id:NSString,content:NSString,type:NSString,photo:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"SetComment"
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
            "id":id,
            "content":content,
            "type":type,
            //            "photo":photoUrl
            "photo":photo
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
    
 }
