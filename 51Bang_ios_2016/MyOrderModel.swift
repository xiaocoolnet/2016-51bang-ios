//
//  MyOrderModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyOrderModel: NSObject {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<MyOrderInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(MyOrderInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}


class MyOrderList: JSONJoy {
    var status:String?
    var objectlist: [MyOrderInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MyOrderInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MyOrderInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MyOrderInfo(childs))
        }
    }
    
    func append(list: [MyOrderInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class MyOrderInfo: JSONJoy {
    
    var id:String?
 

    var price:String?
    var number:String?
    var picture:String?
    var mobile:String?
    var order_num:String?
    var gid:String?
    var money:String?
    var goodsname:String?
    //    var apply:applyModel?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        price = decoder["price"].string
        order_num = decoder["order_num"].string
        number = decoder["number"].string
        mobile = decoder["mobile"].string
        money = decoder["money"].string
        goodsname = decoder["goodsname"].string
        picture = decoder["picture"].string
        gid = decoder["gid"].string
        //        apply = decoder["apply"] as? applyModel
    }
    
}


