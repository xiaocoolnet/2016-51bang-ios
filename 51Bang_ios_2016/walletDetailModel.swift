//
//  walletDetailModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class walletDetailModel: NSObject {

    
    var status:String?
    var data: walletDetailInfo?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<walletDetailInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(walletDetailInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }

        }else{
            errorData = decoder["data"].string
        }
        
    }

}
class walletDetailList: JSONJoy {
    var status:String?
    var objectlist: [walletDetailInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<walletDetailInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<walletDetailInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(walletDetailInfo(childs))
        }
    }
    
    func append(list: [walletDetailInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



//0支出
class walletDetailInfo: JSONJoy {
    var id:String?
    var userid:String?
    var money:String?
    var balance:String?
    var type:String?
    var time:String?
    var info:String?
    
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        userid = decoder["userid"].string
        money = decoder["money"].string
        balance = decoder["balance"].string
        type = decoder["type"].string
        time = decoder["time"].string
        info = decoder["info"].string
    }
    
}
