//
//  applyModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class applyModel: NSObject {

    var servicecount:String?
    var userid:String?
    var status:String?
    var phone:String?
    var name:String?
    var photo:String?
    var idcard:String?
    override init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        servicecount = decoder["servicecount"].string
        userid = decoder["userid"].string
        status = decoder["status"].string
        phone = decoder["phone"].string
        name = decoder["name"].string
        photo = decoder["photo"].string
        idcard = decoder["idcard"].string
    }

}
