//
//  MineGetModel.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
class MineGetModel: JSONJoy{
    var status:String?
    var data:UserData?
    var errorData:String?
    var datastring:String?
    //var uid:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = UserData(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class UserData: JSONJoy {
    var id:String?
    var name:String?
    var phone:String?
    var city:String?
    var qq:String?
    var weixin:String?
    var idcard:String?
    var address:String?
    var photo:String?
    var sex:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string
        name = decoder["name"].string
        phone = decoder["phone"].string
        city = decoder["city"].string
        qq = decoder["qq"].string
        weixin = decoder["weixin"].string
        idcard = decoder["idcard"].string
        address = decoder["address"].string
        photo = decoder["photo"].string
        sex = decoder["sex"].string
        
    }
}

