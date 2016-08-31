//
//  TaskModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class TaskModel: NSObject {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<TaskInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
//                print(childs)
//                print(SkillModel(childs))
                datas.append(TaskInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
}

class DicModel: NSObject {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<DicInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(DicInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
}


class TaskList: JSONJoy {
    var status:String?
    var objectlist: [TaskInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<TaskInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<TaskInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(TaskInfo(childs))
        }
    }
    
    func append(list: [TaskInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class TaskInfo: JSONJoy {
    
    var id:String?
    var userid:String?
    var title:String?
    var price:String?
    var type:String?
    var description:String?
    var time:String?
    var longitude:String?
    var latitude:String?
    var expirydate:String?
    var address:String?
    var saddress:String?
    var slongitude:String?
    var slatitude:String?
    var order_num:String?
    var status:String?
    var phone:String?
    var name:String?
    var apply:applyModel?
    var pic:[PicInfos]?
    var record:String?
    var soundtime:String?
    
    init(){
        pic = Array<PicInfos>()
    }
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        record = decoder["sound"].string
        price = decoder["price"].string
        description = decoder["description"].string
        userid = decoder["userid"].string
        title = decoder["title"].string
        type = decoder["type"].string
        time = decoder["time"].string
        longitude = decoder["longitude"].string
        latitude = decoder["latitude"].string
        slongitude = decoder["slongitude"].string
        slatitude = decoder["slatitude"].string
        expirydate = decoder["expirydate"].string
        address = decoder["address"].string
        saddress = decoder["saddress"].string
        order_num = decoder["order_num"].string
        status = decoder["status"].string
        phone = decoder["phone"].string
        name = decoder["name"].string
        soundtime = decoder["soundtime"].string
        apply = decoder["apply"] as? applyModel
        pic = Array<PicInfos>()
        if decoder["files"].array != nil {
            for childs: JSONDecoder in decoder["files"].array!{
                self.pic?.append(PicInfos(childs))
            }
        }
    }
    
    
}
class DicInfo: JSONJoy {
    
    var id:String?
    var name:String?
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        name = decoder["name"].string
    }
    
    
}

