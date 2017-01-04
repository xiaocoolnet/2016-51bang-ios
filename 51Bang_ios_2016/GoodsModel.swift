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
    var racking:String?
    var commentcount:String?
    
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
        racking = decoder["racking"].string
        commentcount = decoder["commentcount"].string
        
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
    //    var datas ＝ Array<GoodsList>()
//    var datas = Array<GoodsInfo2>()
    var data = GoodsInfo2()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success"{
            data = GoodsInfo2(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
    
    
    }
    
}
//class GoodsList2: JSONJoy {
//    var status:String?
//    var objectlist: [GoodsInfo2]
//    
//    var count: Int{
//        return self.objectlist.count
//    }
//    init(){
//        objectlist = Array<GoodsInfo2>()
//    }
//    required init(_ decoder: JSONDecoder) {
//        
//        objectlist = Array<GoodsInfo2>()
//        for childs: JSONDecoder in decoder.array!{
//            objectlist.append(GoodsInfo2(childs))
//        }
//    }
//    
//    func append(list: [GoodsInfo2]){
//        self.objectlist = list + self.objectlist
//    }
//    
//}

class GoodsInfo2: JSONJoy {
    var id:String!
    var userid:String!
    var goodsname:String!
    var type:String!
    var price:String!
    var oprice:String!
    var unit:String!
    var description:String!
    var picture:String!
    var sound:String!
    var showid:String!
    var address:String!
    var longitude:String!
    var latitude:String!
    var status:String!
    var racking:String!
    var delivery:String!
    var time:String!
    var sellnumber:String!
    var name:String!
    var phone:String!
    var pic:[PicInfos]
    var commentlist:[commentlistInfo]
    
    
    init(){
        pic = Array<PicInfos>()
        commentlist = Array<commentlistInfo>()
    }
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string
        userid = decoder["userid"].string
        goodsname = decoder["goodsname"].string
        type = decoder["type"].string
        price = decoder["price"].string
        oprice = decoder["oprice"].string
        unit = decoder["unit"].string
        description = decoder["description"].string
        picture = decoder["picture"].string
        sound = decoder["sound"].string
        showid = decoder["showid"].string
        address = decoder["address"].string
        longitude = decoder["longitude"].string
        latitude = decoder["latitude"].string
        commentlist = Array<commentlistInfo>()
        status = decoder["statue"].string
        racking = decoder["racking"].string
        delivery = decoder["delivery"].string
        time = decoder["time"].string
        sellnumber = decoder["sellnumber"].string
        name = decoder["name"].string
        phone = decoder["phone"].string
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
    
    func addpend(list2: [commentlistInfo]){
        self.commentlist = list2 + self.commentlist
    }
    
}


class favoriteModel: JSONJoy {
    var status:String?
    var data :String?
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



class GetMyApplyTastTotalModel: JSONJoy {
    var status:String?
    var data = GetMyApplyTastTotalInfo()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success"{
            data = GetMyApplyTastTotalInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
        
    }
    
}


class GetMyApplyTastTotalInfo: JSONJoy {
    var allcount:String!
    var daycount:String!
    var monthcount:String!
    
    init(){
        
    }

    required init(_ decoder: JSONDecoder){
        
        allcount = decoder["allcount"].string
        daycount = decoder["daycount"].string
        monthcount = decoder["monthcount"].string
        
   }

}

//提现 绑定判断
class GetUserBankModel: JSONJoy {
    var status:String?
    var data = GetUserBankInfo()
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success"{
            data = GetUserBankInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
        
    }
    
}


class GetUserBankInfo: JSONJoy {
    var alipay:String!
    var bank:String!
    var bankno:String!
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        
        alipay = decoder["alipay"].string
        bank = decoder["bank"].string
        bankno = decoder["bankno"].string
        
    }
    
}






