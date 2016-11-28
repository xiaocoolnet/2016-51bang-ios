//
//  TchdModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/12.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage

class TchdModel: NSObject {
    
    var status:String?
    var data: JSONDecoder?
    
    var datas = Array<TCHDInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(TCHDInfo(childs))
//                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
//class TCHDList: JSONJoy {
//    var status:String?
//    var objectlist: [TCHDInfo]
//
//    var count: Int{
//        return self.objectlist.count
//    }
//    init(){
//        objectlist = Array<TCHDInfo>()
//    }
//    required init(_ decoder: JSONDecoder) {
//
//        objectlist = Array<TCHDInfo>()
//        for childs: JSONDecoder in decoder.array!{
//            objectlist.append(TCHDInfo(childs))
//        }
//    }
//
//    func append(list: [TCHDInfo]){
//        self.objectlist = list + self.objectlist
//    }
//
//}

class TCHDInfo: JSONJoy {
    
    var mid:String?
    var userid:String?
    var title:String?
    var type:String?
    var name:String?
    var create_time:String?
    var photo:String?
    var content:String?
    var record:String?
    var soundtime :String?
    var phone : String?
    
    
    var pic:[PicInfo]
    init(){
        pic = Array<PicInfo>()
    }
    required init(_ decoder: JSONDecoder){
        
        mid = decoder["mid"].string
        record = decoder["sound"].string
        name = decoder["name"].string
        userid = decoder["userid"].string
        title = decoder["title"].string
        type = decoder["type"].string
        create_time = decoder["create_time"].string
        photo = decoder["photo"].string
        content = decoder["content"].string
        soundtime = decoder["soundtime"].string
        pic = Array<PicInfo>()
        phone = decoder["phone"].string
        if decoder["pic"].array != nil {
            for childs: JSONDecoder in decoder["pic"].array!{
                self.pic.append(PicInfo(childs))
            }
        }
    }
    func addpend(list: [PicInfo]){
        self.pic = list + self.pic
    }
    
}

class PicList: JSONJoy {
    var status:String?
    var objectlist: [PicInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<PicInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<PicInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(PicInfo(childs))
        }
    }
    
    func append(list: [PicInfo]){
        self.objectlist = list + self.objectlist
    }
    
}


class PicInfo:JSONJoy{
    
    var pictureurl:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        pictureurl = decoder["pictureurl"].string
        
    }
    
}

class PicInfos:JSONJoy{
    
    var pictureurl:String!
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        pictureurl = decoder["file"].string
        
    }
    
}


class commentlistInfo:JSONJoy{
    var id :String?
    var content:String?
    var add_time:String?
    var name:String?
    var userid :String?
    var photo :String?
    var score :String?
    var username:String?
    
    
    //    var pictureurl:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        content = decoder["content"].string
        add_time = decoder["add_time"].string
        name = decoder["username"].string
        username = decoder["name"].string
        id = decoder["id"].string
        userid = decoder["userid"].string
        photo = decoder["photo"].string
        score = decoder["score"].string
        
    }
    
}

