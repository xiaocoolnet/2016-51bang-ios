//
//  Httpresult.swift
//  yunzhuyangche_shop
//
//  Created by LCB on 15/8/21.
//  Copyright (c) 2015年 lcb. All rights reserved.
//

//import Foundation
//class Httpresult: JSONJoy{
//    var status:String?
//    var data:UserInfo?
//    var errorData:String?
//    var datastring:String?
//    //var uid:String?
//    init(){
//    }
//    required init(_ decoder:JSONDecoder){
//        status = decoder["status"].string
//        if status == "success"{
//            data = UserInfo(decoder["data"])
//        }else{
//            errorData = decoder["data"].string
//        }
//        
//    }
//}
//class UserInfo: JSONJoy {
//    var id:String?
//    var schoolid:String?
//    var classid:String?
//    init(){
//    }
//    required init(_ decoder:JSONDecoder){
//        id = decoder["id"].string
//        classid = decoder["classid"].string
//        schoolid = decoder["schoolid"].string
//    }
//}