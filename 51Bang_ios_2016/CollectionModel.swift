//
//  CollectionModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class CollectionModel: JSONJoy {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<CollectionInfo>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                print(childs)
                print(SkillModel(childs))
                datas.append(CollectionInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }

}

class CollectionList: JSONJoy {
    var status:String?
    var objectlist: [CollectionInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<CollectionInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<CollectionInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(CollectionInfo(childs))
        }
    }
    
    func append(list: [CollectionInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class CollectionInfo: JSONJoy {
    
    var id:String?
    var userid:String?
    var title:String?
    var price:String?
    var createtime:String?
    var description:String?
    var object_id:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        userid = decoder["userid"].string
        title = decoder["title"].string
        price = decoder["price"].string
        description = decoder["description"].string
        createtime = decoder["createtime"].string
        object_id = decoder["object_id"].string
    }
    
}
