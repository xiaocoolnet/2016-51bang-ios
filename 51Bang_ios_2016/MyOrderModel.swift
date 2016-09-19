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

class ZHIFUfankui: NSObject {
    var status:String?
    var data: String?
    //    var datas ＝ Array<GoodsList>()
    var datas = String()
    var errorData:String?
    override init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = decoder["data"].string
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}

class MyOrderInfo: JSONJoy {
    var order_num:String?
    var gid:String?
    var goodsname:String?
    var id:String?
    var time:String?
    var state:String?
    var peoplename:String?
    var mobile:String?
    var price:String?
    var number:String?
    var money:String?
    var remarks:String?
    var username:String?
    var statusname:String?
    var statusend:String?
    var delivery:String?
    var address:String?
    var commentlist:[commentlistInfo]
    var pic:[PicInfos]
    var tracking:String?
    
    //    var apply:applyModel?
    init(){
        pic = Array<PicInfos>()
        commentlist = Array<commentlistInfo>()
    }
    required init(_ decoder: JSONDecoder){
        
        order_num = decoder["order_num"].string
        gid = decoder["gid"].string
        goodsname = decoder["goodsname"].string
        id = decoder["id"].string
        time = decoder["time"].string
        state = decoder["state"].string
        peoplename = decoder["peaplename"].string
        mobile = decoder["mobile"].string
        price = decoder["price"].string
        number = decoder["number"].string
        money = decoder["money"].string
        remarks = decoder["remarks"].string
        username = decoder["username"].string
        statusname = decoder["statusname"].string
        statusend = decoder["statusend"].string
        delivery = decoder["delivery"].string
        address = decoder["address"].string
        tracking = decoder["tracking"].string
        commentlist = Array<commentlistInfo>()
        pic = Array<PicInfos>()
        
        if decoder["picture"].array != nil {
            for childs: JSONDecoder in decoder["picture"].array!{
                self.pic.append(PicInfos(childs))
            }
        }

        if decoder["commentlist"].array != nil {
            for childs: JSONDecoder in decoder["commentlist"].array!{
                self.commentlist.append(commentlistInfo(childs))
            }
        }

    }
    
    func addpend(list: [PicInfos]){
        self.pic = list + self.pic
    }
    
    func addpend(list1: [commentlistInfo]){
        self.commentlist = list1 + self.commentlist
    }

}


