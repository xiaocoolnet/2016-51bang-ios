//
//  walletDetail2Model.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class walletDetail2Model: NSObject {
    
    var status:String?
    var data: walletDetailInfo?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<tiXianInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                //                print(childs)
                //                print(SkillModel(childs))
                datas.append(tiXianInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
            
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
class tiXianList: JSONJoy {
    var status:String?
    var objectlist: [tiXianInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<tiXianInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<tiXianInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(tiXianInfo(childs))
        }
    }
    
    func append(list: [tiXianInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



//0支出
class tiXianInfo: JSONJoy {
    var id:String?
    var userid:String?
    var money:String?
    var balance:String?
    var state:String?
    var time:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        userid = decoder["userid"].string
        money = decoder["money"].string
        balance = decoder["balance"].string
        state = decoder["state"].string
        time = decoder["time"].string
        
    }
    
}
