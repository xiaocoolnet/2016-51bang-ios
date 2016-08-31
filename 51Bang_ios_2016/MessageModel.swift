//
//  MessageModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MessageModel: NSObject {

    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<MessInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(MessInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }

    
}

class MessList: JSONJoy {
    var status:String?
    var objectlist: [MessInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MessInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MessInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MessInfo(childs))
        }
    }
    
    func append(list: [MessInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



class MessInfo: JSONJoy {
    
 
    var photo:String
    var id:String
    var title:String?
    var content:String?
    var create_time:String?
    required init(_ decoder:JSONDecoder){
       
        photo = decoder["photo"].string!
        id = decoder["id"].string!
        content = decoder["content"].string!
        create_time = decoder["create_time"].string!
        title = decoder["title"].string!
      
    }
    
    
}

