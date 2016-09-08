//
//  Parking
//
//  Created by xiaocool on 16/5/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class TCUserInfoModel: JSONJoy{
    var status:String?
    var data:UserInfo?
    var errorData:String?
    var datastring:String?

    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = UserInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
    }
}
class UserInfo: JSONJoy {
    var name:String?
    var phone:String?
    var id:String?
    var address:String?
    var idcard:String?
    var sex:String?
//    var qq:String
    var time:String?
    var status:String?
    var photo:String?
//    var weixin:String
    var from:String?
    var city:String?
    var password:String?
    var xgtoken:String?
    var usertype:String?
    
    required init(_ decoder:JSONDecoder){
        name = decoder["name"].string!
        phone = decoder["phone"].string!
        id = decoder["id"].string!
        address = decoder["address"].string!
        idcard = decoder["idcard"].string!
        
        sex = decoder["sex"].string!
//        qq = decoder["qq"].string!
        time = decoder["time"].string!
        
        status = decoder["status"].string!
        print(decoder["photo"].string)
        if decoder["photo"].string == nil {
            photo = ""
        }else{
            photo = decoder["photo"].string!
        }
        
//        weixin = decoder["weixin"].string!
        from = decoder["from"].string!
        city = decoder["city"].string!
        password = decoder["password"].string!
        xgtoken = decoder["xgtoken"].string!
        usertype = decoder["usertype"].string!
    }
}

















