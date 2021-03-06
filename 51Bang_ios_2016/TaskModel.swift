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


class WorkingStateModel: NSObject {
    var status:String?
    var data: String?
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = decoder["data"].string
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class AdvertisementModel: NSObject {
    var status:String?
    var data: Array<AdvertiselistModel> = []
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                data.append(AdvertiselistModel(childs))
            }
            
            
        }else{
            errorData = decoder["data"].string
        }
        
    }
}

class AdvertiselistModel: NSObject {
    var slide_id:String?
    var slide_cid:String?
    var slide_name:String?
    var slide_pic:String?
    var slide_url:String?
    var slide_des:String?
    var slide_content:String?
    var slide_status:String?
    var listorder:String?
    
    override init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        
        slide_id = decoder["slide_id"].string
        slide_cid = decoder["slide_cid"].string
        slide_name = decoder["slide_name"].string
        slide_pic = decoder["slide_pic"].string
        slide_url = decoder["slide_url"].string
        slide_des = decoder["slide_des"].string
        slide_content = decoder["slide_content"].string
        slide_status = decoder["slide_status"].string
        listorder = decoder["listorder"].string
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
            }
            
        }else{
            errorData = decoder["data"].string
        }
        
    }
}

class JuanmaModel: NSObject {
    var status:String?
    var data: String?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<DicInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
//            for childs: JSONDecoder in decoder["data"].array!{
//                //                print(childs)
//                //                print(SkillModel(childs))
//                datas.append(DicInfo(childs))
//                print(datas)
//                //                    array.append(SkillModel(childs))
//            }
            data = decoder["data"].string
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

class messageBackInfo: JSONJoy {
    
    var status:String?
    var id : String?
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        status = decoder["status"].string
    }
    
}


class TaskInfo: JSONJoy {
    
    var id:String?
    var taskid:String?
    var order_num:String?
    var userid:String?
    var title:String?
    var sound:String?
    var soundtime:String?
    var type:String?
    var price:String?
    var unit:String?
    var description:String?
    var address:String?
    var longitude:String?
    var latitude:String?
    var saddress:String?
    var slongitude:String?
    var slatitude:String?
    var expirydate:String?
    var paytype:String?
    var paytime:String?
    var paystatus:String?
    var time:String?
    var hot:String?
    var name:String?
    var phone:String?
    var status:String?
    var photo:String?
    var idcard:String?
    var files:String?
    var evaluate:String?
    var commentlist:[commentlistInfo]
    var apply:applyModel?
    var pic:[PicInfos]?
    var record:String?
    var state :String?
    var type_parentname:String?
    var ishire:String?
   
    
    init(){
        pic = Array<PicInfos>()
//        pic = Array<PicInfos>()
        commentlist = Array<commentlistInfo>()
    }
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        taskid = decoder["taskid"].string
        order_num = decoder["order_num"].string
        userid = decoder["userid"].string
        title = decoder["title"].string
        title = decoder["title"].string
        sound = decoder["sound"].string
        soundtime = decoder["soundtime"].string
        type = decoder["type"].string
        price = decoder["price"].string
        unit = decoder["unit"].string
        description = decoder["description"].string
        address = decoder["address"].string
        longitude = decoder["longitude"].string
        latitude = decoder["latitude"].string
        saddress = decoder["saddress"].string
        slongitude = decoder["slongitude"].string
        slatitude = decoder["slatitude"].string
        expirydate = decoder["expirydate"].string
        paytype = decoder["paytype"].string
        paytime = decoder["paytime"].string
        paystatus = decoder["paystatus"].string
        time = decoder["time"].string
        hot = decoder["hot"].string
        name = decoder["name"].string
        phone = decoder["phone"].string
        status = decoder["status"].string
        state = decoder["state"].string
        photo = decoder["photo"].string
        idcard = decoder["idcard"].string
        files = decoder["files"].string
        evaluate = decoder["evaluate"].string
        ishire = decoder["ishire"].string
        type_parentname = decoder["type_parentname"].string
        commentlist = Array<commentlistInfo>()


        apply = applyModel()
        let applyyy : JSONDecoder? = decoder["apply"]
        
        apply = applyModel(applyyy!)
        
//        if decoder["files"].dictionary != nil {
////            apply = decoder["files"].dictionary
//        }
        if decoder["evaluate"].array != nil {
            for childs: JSONDecoder in decoder["evaluate"].array!{
                self.commentlist.append(commentlistInfo(childs))
            }
        }
        
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

