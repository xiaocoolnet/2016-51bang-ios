//
//  fadanDetailModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class fadanDetailModel: NSObject {
    var status:String?
    var data: fadanDetaiInfo?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<fadanDetaiInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = fadanDetaiInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }

}
class fadanDetaiList: JSONJoy {
    var status:String?
    var objectlist: [fadanDetaiInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<fadanDetaiInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<fadanDetaiInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(fadanDetaiInfo(childs))
        }
    }
    
    func append(list: [fadanDetaiInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class fadanDetaiInfo: JSONJoy {
    
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
    var evaluate:String?
    var phone:String?
    var name:String?
    var unit:String?
    var saddress:String?
    var slatitude:String?
    var slongitude:String?
    var paytype:String?
    var paytime:String?
    var paystatus:String?
    var state:String?
    var hot:String?
    //files  数组，里面什么数据不知道，暂时用string代替
    var files:String?
    var apply:applyModel?
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
        evaluate = decoder["evaluate"].string
        phone = decoder["phone"].string
        name = decoder["name"].string
        unit = decoder["unit"].string
        saddress = decoder["saddress"].string
        slatitude = decoder["slatitude"].string
        slongitude = decoder["slongitude"].string
        paytype = decoder["paytype"].string
        paystatus = decoder["paystatus"].string
        paytime = decoder["paytime"].string
        state = decoder["state"].string
        hot = decoder["hot"].string
        files = decoder["files"].string
        apply =  applyModel(decoder["apply"])
       
    }
    
}
