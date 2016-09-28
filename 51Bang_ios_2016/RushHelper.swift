//
//  RushHelper.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class RushHelper: NSObject {

    func getSkillList(handle:ResponseBlock){
        let url = Bang_URL_Header+"getTaskTypeList"
        let param = [
            "id":"0"
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = SkillListModel(JSONDecoder(json!))
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                     print(result.datas)
                     handle(success: true, response: result.datas)
                    
                }else{
                    handle(success: false, response: result.errorData)

                }
            }
            
        }
     }
    
    //获取用户技能
    func getSkillListByUserId(userid:String, handle:ResponseBlock){
        
        let url = Bang_URL_Header+"getSkillListByUserId"
        let param = [
            "userid":userid
        ];
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = XGSkillListModel(JSONDecoder(json!))
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
//                    print(result.datas)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    //修改用户技能
    func UpdataUserSkill(userid:String,type:String, handle:ResponseBlock){
        
        let url = Bang_URL_Header+"UpdataUserSkill"
        let param = [
            "userid":userid,
            "type":type
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    func getAuthenticationInfoByUserId(userid:String, handle:ResponseBlock){
        let url = Bang_URL_Header+"getAuthenticationInfoByUserId"
        let param = [
            "userid":userid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = RZBAAModel(JSONDecoder(json!))
                //let status = SkillListModel(JSONDecoder(json!))
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    }
    
    
    
    //身份认证
    func identityAffirm(userid:String,city:String,realname:String,idcard:String,contactperson:String,contactphone:String,positive_pic:String,opposite_pic:String,driver_pic:String,types:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"Authentication"
        let param = [
            "userid":userid,
            "city":city,
            "realname":realname,
            "idcard":idcard,
            "contactperson":contactperson,
            "contactphone":contactphone,
            "positive_pic":positive_pic,
            "opposite_pic":opposite_pic,
            "driver_pic":driver_pic,
            "type":types
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                
                if(result.status == "success"){
                    print(result.data)
                    handle(success: true, response: result.data)
                    
                }else{
                    print(result)
                    print(result.status)
                    print(result.data)
                    print(result.errorData)
                    handle(success: false, response: result.errorData)
                    
                }
            }
            
        }
    
    }
    
}