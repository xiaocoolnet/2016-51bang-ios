//
//  ShopHelper.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class ShopHelper: NSObject {
    
    func getGoodsList(beginid:String,type:String,keyword:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"getshoppinglist"
        //        let param = [
        //            "id":"0"
        //        ];
        let ud = NSUserDefaults.standardUserDefaults()
        var cityName = String()
        if (ud.objectForKey("quName") != nil) {
            cityName = ud.objectForKey("quName") as! String
        }
        
        Alamofire.request(.GET, url, parameters: ["beginid":beginid,"city":cityName,"type":type,"keyword":keyword]).response { request, response, json, error in
            print(request)
            let result = GoodsModel(JSONDecoder(json!))
            if(error != nil){
                handle(success: false, response: result.errorData)
            }else{
                
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
    
    //
    
    //发布特卖
    func upLoadTeMaiMessage(userid:NSString,type:NSString,goodsname:NSString,oprice:NSString,price:NSString,desc:NSString,photoArray:NSArray,unit:NSString,longitude:NSString,latitude:NSString,address:NSString,delivery:String, handle:ResponseBlock){
        //        print(goodsname)
        //        print(photoArray)
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        var UserLatitude = String()
        var UserLongitude = String()
        var UserLocation = String()
        if userLocationCenter.objectForKey("latitude") != nil {
            UserLatitude = userLocationCenter.objectForKey("latitude") as! String
        }
        if userLocationCenter.objectForKey("longitude") != nil {
            UserLongitude = userLocationCenter.objectForKey("longitude") as! String
        }
        if userLocationCenter.objectForKey("UserLocation") != nil {
            UserLocation = userLocationCenter.objectForKey("UserLocation") as! String
        }
        let url = Bang_URL_Header+"PublishGoods"
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
            "type":type,
            "goodsname":goodsname,
            "oprice":oprice,
            "price":price,
            "picturelist":photoUrl,
            "description":desc,
            "unit":unit,
            "latitude":latitude,
            "longitude":longitude,
            "address":address,
            "delivery":delivery,
            "UserLatitude":UserLatitude,
            "UserLongitude":UserLongitude,
            "UserLocation":UserLocation
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
    
    //更新我的发布
    func reLoadTeMaiMessage(userid:NSString,type:NSString,goodsname:NSString,oprice:NSString,price:NSString,desc:NSString,unit:NSString,longitude:NSString,latitude:NSString,address:NSString,delivery:String, handle:ResponseBlock){
        let userLocationCenter = NSUserDefaults.standardUserDefaults()
        var UserLatitude = String()
        var UserLongitude = String()
        var UserLocation = String()
        if userLocationCenter.objectForKey("latitude") != nil {
            UserLatitude = userLocationCenter.objectForKey("latitude") as! String
        }
        if userLocationCenter.objectForKey("longitude") != nil {
            UserLongitude = userLocationCenter.objectForKey("longitude") as! String
        }
        if userLocationCenter.objectForKey("UserLocation") != nil {
            UserLocation = userLocationCenter.objectForKey("UserLocation") as! String
        }
        print(goodsname)
        let url = Bang_URL_Header+"UpdateGoodsInfo"
        
        let param = [
            
            "userid":userid,
            "type":type,
            "goodsname":goodsname,
            "oprice":oprice,
            "price":price,
            "description":desc,
            "unit":unit,
            "latitude":latitude,
            "longitude":longitude,
            "address":address,
            "delivery":delivery,
            "UserLatitude":UserLatitude,
            "UserLongitude":UserLongitude,
            "UserLocation":UserLocation
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
    
    
    
    //微信支付订单生成
    func getWeixinDingdan(appid:String,mch_id:String,device_info:String,nonce_str:String,sign:String,body:String,detail:String,attach:String,out_trade_no:String,fee_type:String,total_fee:Int,spbill_create_ip:String,time_start:String,time_expire:String,goods_tag:String,notify_url:String,trade_type:String,limit_pay:String, handle:ResponseBlock){
        
        let url = "https://api.mch.weixin.qq.com/pay/unifiedorder"
        
        let param = [
            
            "appid":appid,
            "mch_id":mch_id,
            "device_info":device_info,
            "nonce_str":nonce_str,
            "sign":sign,
            "body":body,
            "detail":detail,
            "attach":attach,
            "out_trade_no":out_trade_no,
            "fee_type":fee_type,
            "total_fee":total_fee,
            "spbill_create_ip":spbill_create_ip,
            "time_start":time_start,
            "time_expire":time_expire,
            "goods_tag":goods_tag,
            "notify_url":notify_url,
            "trade_type":trade_type,
            "limit_pay":limit_pay
        ];
        let xmlData = XMLHelper()
        
        let  aa = xmlData.genPackage(NSMutableDictionary(dictionary: param))
        
        let data = xmlData.httpSend(url, method: "POST", data: aa)
        xmlData.startParse(data)
        let datas = xmlData.getDict()
        print(datas)
        
        Alamofire.request(.POST, url, parameters: param as? [String : AnyObject]).response { request, response, json, error in
            print(request)
            print(json)
            
            let xmlData = XMLHelper()
            xmlData.startParse(json)
            let data = xmlData.getDict()
            
            print(data["return_msg"]?.UTF8String)
            
            do{
                let data11 = try NSJSONSerialization.JSONObjectWithData(json!, options:NSJSONReadingOptions.MutableLeaves)
                print(data11)
            }catch{
                
            }
            
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                print("---")
                print(result.data)
                print(result.errorData)
                print(result.status)
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
    
    //收藏商品
    
    func favorite(userid:NSString,type:NSString,goodsid:NSString,title:NSString,desc:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"addfavorite"
        let param = [
            
            "userid":userid,
            "goodsid":goodsid,
            "type":type,
            "title":title,
            "description":desc,
            
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
    
    func cancelFavoritefunc(userid:NSString,type:NSString,goodsid:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"cancelfavorite"
        let param = [
            
            "userid":userid,
            "goodsid":goodsid,
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
    
    //获取我的发布
    
    func getMyFaBu(userid:NSString,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"getMyshoppinglist"
        let param = [
            
            "userid":userid
            
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = GoodsModel(JSONDecoder(json!))
                print("---")
                print(result)
                print("---")
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
    
    //下架
    func XiaJia(id:NSString,isShangjia:String,handle:ResponseBlock){
        var url = String()
        
        if isShangjia == "1" {
            url = Bang_URL_Header+"Shangjia"
        }else{
            url = Bang_URL_Header+"Xiajia"
        }
        let param = [
            
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
    //删除
    func deleteOrder(id:NSString,handle:ResponseBlock){
        var url = String()
        url = Bang_URL_Header+"DeleteGoods"
        
        let param = [
            
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
    
    
    
    
}