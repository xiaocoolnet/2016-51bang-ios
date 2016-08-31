//
//  MyGetModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyGetModel: NSObject {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<MyGetOrderInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(MyGetOrderInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class MyGetOrderList: JSONJoy {
    var status:String?
    var objectlist: [MyGetOrderInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MyGetOrderInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MyGetOrderInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MyGetOrderInfo(childs))
        }
    }
    
    func append(list: [MyGetOrderInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class MyGetOrderInfo: JSONJoy {
    
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
    var order_num:String?
    var status:String?
    var phone:String?
    var name:String?
//    var apply:applyModel?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        price = decoder["price"].string
        description = decoder["description"].string
        userid = decoder["userid"].string
        title = decoder["title"].string
        type = decoder["type"].string
        time = decoder["time"].string
        longitude = decoder["longitude"].string
        latitude = decoder["latitude"].string
        expirydate = decoder["expirydate"].string
        address = decoder["address"].string
        order_num = decoder["order_num"].string
        status = decoder["status"].string
        phone = decoder["phone"].string
        name = decoder["name"].string
//        apply = decoder["apply"] as? applyModel
    }
    
}
