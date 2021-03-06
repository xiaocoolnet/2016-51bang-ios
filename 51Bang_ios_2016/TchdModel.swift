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



class ADVListdModel: NSObject {
    
    var status:String?
    var data: JSONDecoder?
    
    var datas = Array<AdVlistInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                
                datas.append(AdVlistInfo(childs))
                
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}

class ADVresultdModel: NSObject {
    
    var status:String?
    var data: JSONDecoder?
    
    var datas = Array<Array<String>>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        var counts = 0
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                datas.append([])
                
                for childs2: JSONDecoder in childs.array!{
                   datas[counts].append(childs2.string!)
                }
                
               counts = counts+1
                
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
    var isOpen :Bool?
    var video:String?
    
    
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
        video = decoder["video"].string
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


class AdVlistInfo:JSONJoy{
    var slide_id :String?
    var content:String?
    var create_time:String?
    var name:String?
    var userid :String?
    var photo :String?
    var score :String?
    var realname:String?
    var begintime:String?
    var endtime:String?
    var slide_status:String?
    var price:String?
    var slide_pic:String?
    var slide_url:String?
    var order_num:String?
    var slide_name:String?
    
    
    //    var pictureurl:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        content = decoder["content"].string
        create_time = decoder["create_time"].string
        name = decoder["username"].string
        realname = decoder["realname"].string
        slide_id = decoder["slide_id"].string
        userid = decoder["userid"].string
        photo = decoder["photo"].string
        score = decoder["score"].string
        begintime = decoder["begintime"].string
        endtime = decoder["endtime"].string
        slide_status = decoder["slide_status"].string
        price = decoder["price"].string
        slide_pic = decoder["slide_pic"].string
        slide_url = decoder["slide_url"].string
        order_num = decoder["order_num"].string
        slide_name = decoder["slide_name"].string
    }
    
}

