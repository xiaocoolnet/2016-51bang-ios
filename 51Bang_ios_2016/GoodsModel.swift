//
//  GoodsModel.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

//typealias ResponseBlock = (success:Bool,response:AnyObject?)->Void

class GoodsModel: JSONJoy {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<GoodsInfo>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                print(childs)
                print(SkillModel(childs))
                datas.append(GoodsInfo(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
class GoodsList: JSONJoy {
    var status:String?
    var objectlist: [GoodsInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<GoodsInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<GoodsInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(GoodsInfo(childs))
        }
    }
    
    func append(list: [GoodsInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class GoodsInfo: JSONJoy {
    
    var id:String?
    var type:String?
    var goodsname:String?
    var username:String?
    var phone:String?
    var price:String?
    var oprice:String?
    var picture:String?
    var description:String?
    var sellnumber:String?
    var address:String?
    var longitude:String?
    var latitude:String?
    var commentlist:[commentlistInfo]
    var status:String?
    var delivery: String?
    
    var pic:[PicInfos]
    init(){
        pic = Array<PicInfos>()
        commentlist = Array<commentlistInfo>()
    }
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        type = decoder["type"].string
        goodsname = decoder["goodsname"].string
        username = decoder["username"].string
        phone = decoder["phone"].string
        price = decoder["price"].string
        oprice = decoder["oprice"].string
        picture = decoder["picture"].string
        description = decoder["description"].string
        sellnumber = decoder["sellnumber"].string
        address = decoder["address"].string
        longitude = decoder["longitude"].string
        latitude = decoder["latitude"].string
        commentlist = Array<commentlistInfo>()
        status = decoder["statue"].string
        delivery = decoder["delivery"].string
        pic = Array<PicInfos>()
        if decoder["picturelist"].array != nil {
            for childs: JSONDecoder in decoder["picturelist"].array!{
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


class GoodsModel2: JSONJoy {
    var status:String?
    var data: JSONDecoder?
    //    var datas ＝ Array<GoodsList>()
    var datas = Array<GoodsInfo2>()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            for childs: JSONDecoder in decoder["data"].array!{
                print(childs)
                print(SkillModel(childs))
                datas.append(GoodsInfo2(childs))
                print(datas)
                //                    array.append(SkillModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
        
    }
    
}
class GoodsList2: JSONJoy {
    var status:String?
    var objectlist: [GoodsInfo2]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<GoodsInfo2>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<GoodsInfo2>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(GoodsInfo2(childs))
        }
    }
    
    func append(list: [GoodsInfo2]){
        self.objectlist = list + self.objectlist
    }
    
}

class GoodsInfo2: JSONJoy {
    
    var order_num:String?
    var gid:String?
    var goodsname:String?
    var picture:String?
    var id:String?
    var time:String?
    var state:String?
    var peoplename:String?
    var mobile:String?
    var number:String?
    var money:String?
    var username:String?
    var statusname:String?
    var statusend:String?
    var commentlist:[commentlistInfo]
    var status:String?
    
    init(){
        
        commentlist = Array<commentlistInfo>()
    }
    
    required init(_ decoder: JSONDecoder){
        
        order_num = decoder["order_num"].string
        gid = decoder["gid"].string
        goodsname = decoder["goodsname"].string
        picture = decoder["picture"].string
        id = decoder["id"].string
        time = decoder["time"].string
        state = decoder["state"].string
        peoplename = decoder["peoplename"].string
        mobile = decoder["mobile"].string
        number = decoder["number"].string
        money = decoder["money"].string
        username = decoder["username"].string
        statusname = decoder["statusname"].string
        statusend = decoder["statusend"].string
        commentlist = Array<commentlistInfo>()
        status = decoder["statue"].string
        if decoder["commentlist"].array != nil {
            for childs: JSONDecoder in decoder["commentlist"].array!{
                self.commentlist.append(commentlistInfo(childs))
            }
        }
        
    }
    
    func addpend(list2: [commentlistInfo]){
        self.commentlist = list2 + self.commentlist
    }
    
}












