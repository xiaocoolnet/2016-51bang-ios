//
//  chatModel.swift
//  51Bang_ios_2016
//
//  Created by 何明阳 on 16/9/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class chatModel: JSONJoy {
    var status:String?
    var data: JSONDecoder?
    var datas = Array<chatInfo>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                print(childs)
                print(SkillModel(childs))
                datas.append(chatInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }

}
class chatList: JSONJoy {
    var status:String?
    var objectlist: [chatInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<chatInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<chatInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(chatInfo(childs))
        }
    }
    
    func append(list: [chatInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class chatInfo: JSONJoy {
    
    var id:String?
    var send_uid:String?
    var receive_uid:String?
    var content:String?
    var status:String?
    var create_time:String?
    var send_face:String?
    var send_nickname:String?
    var receive_face:String?
    var receive_nickname:String?
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        send_uid = decoder["send_uid"].string
        receive_uid = decoder["receive_uid"].string
        content = decoder["content"].string
        status = decoder["status"].string
        create_time = decoder["create_time"].string
        send_face = decoder["send_face"].string
        send_nickname = decoder["send_nickname"].string
        receive_face = decoder["receive_face"].string
        receive_nickname = decoder["receive_nickname"].string
        
        
    }
    
}

class chatListModel: JSONJoy {
    var status:String?
    var data: JSONDecoder?
    var datas = Array<chatListInfo>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                print(childs)
                datas.append(chatListInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
class chatlistList: JSONJoy {
    var status:String?
    var objectlist: [chatListInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<chatListInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<chatListInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(chatListInfo(childs))
        }
    }
    
    func append(list: [chatListInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class chatListInfo: JSONJoy {
    
    var id:String?
    var uid:String?
    var chat_uid:String?
    var last_content:String?
    var status:String?
    var last_chat_id:String?
    var create_time:String?
    var my_face:String?
    var my_nickname:String?
    var other_face:String?
    var other_nickname:String?
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        uid = decoder["uid"].string
        chat_uid = decoder["chat_uid"].string
        last_content = decoder["last_content"].string
        status = decoder["status"].string
        last_chat_id = decoder["last_chat_id"].string
        create_time = decoder["create_time"].string
        my_face = decoder["my_face"].string
        my_nickname = decoder["my_nickname"].string
        other_face = decoder["other_face"].string
        other_nickname = decoder["other_nickname"].string
        
        
    }
    
}
