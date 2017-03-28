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
            if(result.status == "success"){
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
                if(result.status == "success"){
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




                if(result.status == "success"){


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
                if(result.status == "success"){
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
                if(result.status == "success"){
                    handle(success: true, response: result.data)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    func getslidelist_new(typeid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"getslidelist_new"
        let ud = NSUserDefaults.standardUserDefaults()
        var cityid = String()
        if ud.objectForKey("cityid") != nil {
            cityid = ud.objectForKey("cityid")as! String
        }

        let param1 = [
            "cityid":cityid,
            "typeid":typeid
            
        ];
        Alamofire.request(.GET, url, parameters: param1).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = AdvertisementModel(JSONDecoder(json!))

                if(result.status == "success"){

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
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))

               
                if(result.status == "success"){
                    
                    
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

                if(result.status == "success"){

                    handle(success: true, response: result.data)
                    
                }else{
                    //                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    

    //发布便民信息
    func upLoadMessage(userid:NSString,phone:String,type:NSString,title:NSString,content:NSString,photoArray:NSArray,sound:NSString,soundtime:String,address2:String,longitude:String,latitude:String, video:String,handle:ResponseBlock){
//        let url = Bang_URL_Header+"addbbsposts"
        let url = Bang_URL_Header+"addbbsposts_new"
        let photoUrl = NSMutableString()
        for i in 0..<photoArray.count {
            if i == photoArray.count-1{
                photoUrl.appendString(photoArray[i] as! String)
            }else{
                photoUrl.appendString(photoArray[i] as! String)
                photoUrl.appendString(",")
            }
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
            "latitude":latitude,
            "video":video
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = messageBack(JSONDecoder(json!))

                if(result.status == "success"){

                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
//    //发布便民信息
//    func GetMessagePrice(userid:NSString,handle:ResponseBlock){
//        //        let url = Bang_URL_Header+"addbbsposts"
//        let url = Bang_URL_Header+"GetMessagePrice"
//        let param = [
//            
//            "userid":userid
//        ];
//        
//        
//        
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//            print(request)
//            if(error != nil){
//                handle(success: false, response: error?.description)
//            }else{
//                let result = Http(JSONDecoder(json!))
//
//                if(result.status == "success"){
//
//                    handle(success: true, response: result.data)
//                    
//                }else{
//                    handle(success: false, response: result.errorData)
//                    
//                }
//            }
//            
//        }
//    }
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

                if(result.status == "success"){

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

                if(result.status == "success"){

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

                if(result.status == "success"){

                    handle(success: true, response: result.datas)
                    
                }else{
                    //                    handle(success: false, response: result.errorData)
                    
                }
            }
            
            
            
        }
        
    }
    //获取未读消息数
    func xcGetChatnoReadCount(userid:NSString,handle:ResponseBlock){
        
        
        
        let url = Bang_URL_Header+"xcGetChatnoReadCount"

        
        let param = [
            "uid":userid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))

                
                if(result.status == "success"){

                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    func GetTchdList(type:NSString,beginid:NSString,keyWord:String,handle:ResponseBlock){
        let ud = NSUserDefaults.standardUserDefaults()
        var cityName = String()
        
        let url = Bang_URL_Header+"getbbspostlist"
        if (ud.objectForKey("quName") != nil) {
            cityName = ud.objectForKey("quName") as! String
        }
        
        let param = [
            
            "type":type,
            "beginid":beginid,
            "city":cityName,
            "keyword":keyWord
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TchdModel(JSONDecoder(json!))

                if(result.status == "success"){

                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    //获取我的便民圈
    
    func getbbspostlist(status:NSString,beginid:NSString,userid:String,handle:ResponseBlock){
        
        
        let url = Bang_URL_Header+"getmybbspostlist"
        
        let param = [
            
            "status":status,
            "beginid":beginid,
            "userid":userid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = TchdModel(JSONDecoder(json!))

                if(result.status == "success"){

                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    //获取我的广告发布
    func getMyAdlist(status:NSString,beginid:NSString,userid:String,handle:ResponseBlock){
        
        
        let url = Bang_URL_Header+"getMyAdlist"
        
        let param = [
            
            "status":status,
            "beginid":beginid,
            "userid":userid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = ADVListdModel(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    //获取我的广告发布单价
    //type(0:便民圈单条信息，1轮播广告位1，2轮播广告位2，3轮播广告位3)
    func GetMessagePrice(type:NSString,userid:String,handle:ResponseBlock){
        
        
        let url = Bang_URL_Header+"GetMessagePrice"
        
        let param = [
            
            "type":type,
            
            "userid":userid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    
    //获取我的广告发布是否可用
    func CheckADIsCanPublish(type:NSString,userid:String,day:Array<String>, handle:ResponseBlock){
        var cityName = String()
        let ud = NSUserDefaults.standardUserDefaults()
        let url = Bang_URL_Header+"CheckADIsCanPublish"
        if (ud.objectForKey("quName") != nil) {
            cityName = ud.objectForKey("quName") as! String
        }
        var cityid = String()
        if ud.objectForKey("cityid") != nil {
            cityid = ud.objectForKey("cityid")as! String
        }
        
        var count1 = 0
        var dayStr = String()
        for str in day {
            if count1 == day.count-1{
                dayStr = dayStr+stringToTimeStampWithyyyymmdd(str)
            }else{
                dayStr = dayStr+stringToTimeStampWithyyyymmdd(str)+","
            }
           count1 = count1+1
        }
        

        let param = [
            
            "type":type,
            "city":cityName,
            "day":dayStr,
            "userid":userid,
            "cityid":cityid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = ADVresultdModel(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    
    //广告发布
    func PublishAD(type:NSString,userid:String,photo:String,urls:String,begintime:String,endtime:String,price:String,slide_name:String, handle:ResponseBlock){

        let url = Bang_URL_Header+"PublishAD"
        let ud = NSUserDefaults.standardUserDefaults()
        var cityid = String()
        if ud.objectForKey("cityid") != nil {
            cityid = ud.objectForKey("cityid")as! String
        }
        
        
        let param = [
            
            "type":type,
            "photo":photo,
            "url":urls,
            "begintime":begintime,
            "endtime":endtime,
            "price":price,
            "slide_name":slide_name,
            "userid":userid,
            "cityid":cityid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    //广告更新
    func UpdateAD(id:NSString,userid:String,photo:String,urls:String,slide_name:String, handle:ResponseBlock){
        
        let url = Bang_URL_Header+"UpdateAD"
        
        
        
        let param = [
            
            "id":id,
            "photo":photo,
            "url":urls,
            "slide_name":slide_name,
            "userid":userid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
    }
    
    
    //删除我发布的广告
    
    func DeleteMyAD(userid:String,id:String, handle:ResponseBlock){
        
        let url = Bang_URL_Header+"DeleteMyAD"
        
        
        
        let param = [
            
            
            "id":id,
            "userid":userid
        ];
        
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    handle(success: true, response: result.data)
                    
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
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
    }
    
    
    func GetHomeRzbList(cityname:String,beginid:String,sort:String, type:String, handle:ResponseBlock){
        
        
        let url = Bang_URL_Header+"HomegetAuthenticationUserList"
        Alamofire.request(.GET, url, parameters: ["cityname":cityname]).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = RzbModel(JSONDecoder(json!))
                if(result.status == "success"){
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

                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                    
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
        
        
        
    }
    
    //获取我的下级推广客户人数
    func getMyIntroduceCount(userid:NSString, handle:ResponseBlock){
        let url = Bang_URL_Header+"getMyIntroduceCount"
        let param = [
            "userid":userid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    
                    
                    
                    handle(success: true, response: result.data)
                    
                    
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
                if(result.status == "success"){
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
                if(result.status == "success"){
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
                if(result.status == "success"){
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
                if(result.status == "success"){
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
               
                
                if(result.status == "success"){
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
                if(result.status == "success"){
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
                       if(1 != 1){

            }else{
               
                let result = ZHIFUfankui(JSONDecoder(json!))
               
                if(result.status == "success"){

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
                if(result.status == "success"){
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
                if(result.status == "success"){
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
                if(result.status == "success"){
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

            if result.status == "success"{
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                
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
            if result.status == "success"{
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                
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
                
                if(result.status == "success"){
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
            if result.status == "success"{
                handle(success: true, response: result.datas)
            }else{
//                alert(error, delegate: self)
                handle(success: false, response: result.datas)
                
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
            
            let result = chatModel(JSONDecoder(json!))
            if result.status == "success"{
                
                handle(success: true, response: result.datas)
            }else{
                handle(success: false, response: result.datas)
                
                
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
            if result.status == "success"{
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                
            }
            
            
        }
        
        
    }
    
    //获取城市列表
    func GetCityList(handle:ResponseBlock){
        let url = Bang_URL_Header+"GetCityList"
        
        Alamofire.request(.GET, url, parameters: nil).response { request, response, json, error in
            print(request)
            let result = cityModel(JSONDecoder(json!))
            if result.status == "success"{
                handle(success: true, response: result.datas)
            }else{
                handle(success: false, response: result.errorData)
                
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
            if result.status == "success"{
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.data)
                
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
                if(result.status == "success"){
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
                if(result.status == "success"){
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
                if(result.status == "success"){
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
                if(result.status == "success"){
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }

}
