//
//  MyAddressModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MyAddressModel: NSObject {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<addressInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(addressInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
class addressList: JSONJoy {
    var status:String?
    var objectlist: [addressInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<addressInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<addressInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(addressInfo(childs))
        }
    }
    
    func append(list: [addressInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



//0支出
class addressInfo: JSONJoy {
    var id:String?
    var userid:String?
    var address:String?
    var longitude:String?
    var latitude:String?
    var mydefault:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        userid = decoder["userid"].string
        address = decoder["address"].string
        longitude = decoder["longitude"].string
        latitude = decoder["latitude"].string
        mydefault = decoder["default"].string
    }
    
}
