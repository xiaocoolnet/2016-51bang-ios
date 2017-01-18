//
//  RzbModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RzbModel: JSONJoy {

    var status:String?
    var data: JSONDecoder?
    var datas = Array<RzbInfo>()
    var errorData:String?
     init(){
    }
    required init(_ decoder:JSONDecoder){
   
        status = decoder["status"].string
        if status == "success" {
            print(decoder["data"])
            
            for childs: JSONDecoder in decoder["data"].array!{
                datas.append(RzbInfo(childs))
                print(datas)
                
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class RzbList: JSONJoy {
    var status:String?
    var objectlist: [RzbInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<RzbInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<RzbInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(RzbInfo(childs))
        }
    }
    
    func append(list: [RzbInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



class RzbInfo: JSONJoy {
    
    var name:String
    var phone:String
    var id:String
    var address:String
    var idcard:String
    //    var sex:String
    //    var qq:String
    var time:String
    var status:String
    var longitude:String
    var latitude:String
    var orderNum:String
    var serviceCount:String
    var Ranking:String
    
    
    //    var photo:String
    //    var weixin:String
    var from:String
    var city:String
    var password:String
    var xgtoken:String
    var usertype:String
    var photo:String
    var isworking :String
    var skilllist :[SkilllistModel]
    var commentlist:[commentlistInfo]
    
//    init(){
////        pic = Array<PicInfos>()
//        commentlist = Array<commentlistInfo>()
//    }
    
    required init(_ decoder:JSONDecoder){
        name = decoder["name"].string ?? ""
        phone = decoder["phone"].string ?? ""
        id = decoder["id"].string ?? ""
        address = decoder["address"].string ?? ""
        idcard = decoder["idcard"].string ?? ""
        //        sex = decoder["sex"].string!
        //        qq = decoder["qq"].string!
        time = decoder["time"].string ?? ""
        status = decoder["status"].string ?? ""
        //        photo = decoder["photo"].string!
        //        weixin = decoder["weixin"].string!
        from = decoder["from"].string ?? ""
        city = decoder["city"].string ?? ""
        password = decoder["password"].string ?? ""
        xgtoken = decoder["xgtoken"].string ?? ""
        usertype = decoder["usertype"].string ?? ""
        photo = decoder["photo"].string ?? ""
        isworking = decoder["isworking"].string ?? ""
        longitude = decoder["longitude"].string ?? ""
        latitude = decoder["latitude"].string ?? ""
        orderNum = decoder["orderNum"].string ?? ""
        serviceCount = decoder["serviceCount"].string ?? ""
        Ranking = decoder["Ranking"].string ?? ""
        skilllist = Array<SkilllistModel>()
        commentlist = Array<commentlistInfo>()
        if decoder["skilllist"].array != nil{
            for childs: JSONDecoder in decoder["skilllist"].array!{
                //            print(childs)
                print(SkilllistModel(childs))
                skilllist.append(SkilllistModel(childs))
                //            print(skilllist)
                //                                array.append(SkillModel(childs))
            }
        }
        
        if decoder["commentlist"].array != nil {
//            print(childs)
            for childs: JSONDecoder in decoder["commentlist"].array!{
                self.commentlist.append(commentlistInfo(childs))
            }
        }
    }
    
    
}














