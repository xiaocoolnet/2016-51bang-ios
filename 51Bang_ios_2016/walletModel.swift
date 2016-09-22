//
//  walletModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class walletModel: NSObject {

    var status:String?
    var data: walletInfo?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<walletInfo>()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = walletInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }

}
class walletList: JSONJoy {
    var status:String?
    var objectlist: [walletInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<walletInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<walletInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(walletInfo(childs))
        }
    }
    
    func append(list: [walletInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



//0支出
class walletInfo: JSONJoy {
    var availablemoney:String?
    var money:String?
    var alltasks:String?
    var daytasks:String?
    var monthtasks:String?
    var allincome:String?
    var monthincome:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        availablemoney = decoder["availablemoney"].string
        alltasks = decoder["alltasks"].string
        daytasks = decoder["daytasks"].string
        monthtasks = decoder["monthtasks"].string
        allincome = decoder["allincome"].string
        monthincome = decoder["monthincome"].string
        money = decoder["money"].string
    }
    
}
