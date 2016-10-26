//
//  Parking
//
//  Created by xiaocool on 16/5/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class TCUserInfoModel: JSONJoy{
    var status:String?
    var data:UserInfo?
    var errorData:String?
    var datastring:String?

    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = UserInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class UserInfo: JSONJoy {
    var name:String?
    var phone:String?
    var id:String?
    var address:String?
    var idcard:String?
    var sex:String?
//    var qq:String
    var time:String?
    var status:String?
    var photo:String?
//    var weixin:String
    var from:String?
    var city:String?
    var password:String?
    var xgtoken:String?
    var usertype:String?
    var myreferral:String?
    
    
    
    required init(_ decoder:JSONDecoder){
        
        
        if decoder["name"].string == nil {
            name = ""
        }else{
            name = decoder["name"].string!
        }
//        name = decoder["name"].string!
        phone = decoder["phone"].string!
        id = decoder["id"].string!
        
        if decoder["address"].string == nil {
            address = ""
        }else{
            address = decoder["address"].string!
        }
        if decoder["myreferral"].string == nil {
            myreferral = ""
        }else{
            myreferral = decoder["myreferral"].string!
        }
        
//        address = decoder["address"].string!
        
//        idcard = decoder["idcard"].string!
        if decoder["idcard"].string == nil {
            idcard = ""
        }else{
            idcard = decoder["idcard"].string!
        }
//        sex = decoder["sex"].string!
        if decoder["sex"].string == nil {
            sex = ""
        }else{
            sex = decoder["sex"].string!
        }
//        qq = decoder["qq"].string!
        
        if decoder["time"].string == nil {
            time = ""
        }else{
            time = decoder["time"].string!
        }
//        time = decoder["time"].string!
        
        if decoder["status"].string == nil {
            status = ""
        }else{
            status = decoder["status"].string!
        }
        
//        status = decoder["status"].string!
        print(decoder["photo"].string)
        if decoder["photo"].string == nil {
            photo = ""
        }else{
            photo = decoder["photo"].string!
        }
        
//        weixin = decoder["weixin"].string!
        
        if decoder["from"].string == nil {
            from = ""
        }else{
            from = decoder["from"].string!
        }

//        from = decoder["from"].string!
        
        if decoder["city"].string == nil {
            city = ""
        }else{
            city = decoder["city"].string!
        }
        
//        city = decoder["city"].string!
        password = decoder["password"].string!
        
        if decoder["xgtoken"].string == nil {
            xgtoken = ""
        }else{
            xgtoken = decoder["xgtoken"].string!
        }
//        xgtoken = decoder["xgtoken"].string!
        
        if decoder["usertype"].string == nil {
            usertype = ""
        }else{
            usertype = decoder["usertype"].string!
        }
//        usertype = decoder["usertype"].string!
    }
}

















