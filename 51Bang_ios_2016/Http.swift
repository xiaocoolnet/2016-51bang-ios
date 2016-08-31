//
//  Httpresult.swift
//  yunzhuyangche_shop
//
//  Created by LCB on 15/8/21.
//  Copyright (c) 2015年 lcb. All rights reserved.
//

import Foundation

class Http: JSONJoy{
    var status:String?
    var data:String?
    var errorData:String?
  
    init(){
    }
    required init(_ decoder:JSONDecoder){

        status = decoder["status"].string
        if status == "success"{
            data = decoder["data"].string
        }else{
            errorData = decoder["data"].string
        }

        
    }
}
