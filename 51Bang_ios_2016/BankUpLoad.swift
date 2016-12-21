//
//  BankUpLoad.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class BankUpLoad {
    
    func requestMessage( phone: String)
    {
        let urlForPhone = Bang_URL_Header + "SendMobileCode"
        
        let paramDic = ["phone":phone]
        Alamofire.request(.GET, urlForPhone, parameters: paramDic).response { request, response, json, error in
            print("手机验证码请求是",request)
            let result = Http(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print("发送验证码成功")
            }else{
                
                print("发送验证码失败")
            }
            
            
        }

        
    }
    
    
    func bankMessageUpload(name:String,idCard:String,bankName:String,bankNum:String,Phone:String,Code:String,Target:UIViewController,pushVc:UIViewController )
    {
        let urlForBank = Bang_URL_Header + "UpdateUserBank"
        var id = String()
        if( NSUserDefaults.standardUserDefaults().objectForKey("userid") != nil){
            id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        }
        

        let param = ["userid":id,"realname":name,"idcard":idCard,"bank":bankName,"bankno":bankNum,"phone":Phone,"code":Code]
        //let hud = MBProgressHUD.showHUDAddedTo(Target.view, animated: true)
        Alamofire.request(.GET, urlForBank, parameters: param).response{
        
            request, response , json , error in
            
            
            let result = Http(JSONDecoder(json!))
            print("json是",json)
            if( result.status == "success" )
            {
                print("上传银行卡资料成功")
                Target.navigationController?.popViewControllerAnimated(true)
            }else{
            
               
//                hud.mode = MBProgressHUDMode.Text
//                hud.labelText = "修改昵称失败"
//                hud.color = UIColor.grayColor()
//                hud.alpha = 0.7
//                hud.labelColor = UIColor.whiteColor()
//                hud.xOffset = 0
//                hud.yOffset = 0
//                hud.hide(true, afterDelay: 2)

                print("银行卡资料上传失败")
            }
                
            
            
        
        
        }
        
    }
    
    
    func CheckRenzheng()
    {
        
        let checkUrl = Bang_URL_Header + "CheckHadAuthentication"
        if( NSUserDefaults.standardUserDefaults().objectForKey("userid") == nil)
        {
            return
        }
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        let param = ["userid":id]
        Alamofire.request(.GET, checkUrl, parameters: param ).response{
        
            request, response , json , error in
        
            let ud = NSUserDefaults.standardUserDefaults()
            
            
            let result = Http(JSONDecoder(json!))
            if result.status == "success"{
                print("已经认证")
                ud .setObject("yes", forKey: "ss")
                MainViewController.renZhengStatue = 1
                
                
            }else{
                ud .setObject("no", forKey: "ss")
                print("未进行认证")
                MainViewController.renZhengStatue = 0
            }

        
        
        }
        
    }
    
    
    
    
    
    func baoMessageRequest(userid:String,name:String,card:String,alipay:String,phone:String,code:String,Targert:UIViewController,pushVc:UIViewController)
    {
        
        let urlMessage = Bang_URL_Header+"UpdateUserAlipay&"
        
        let param = ["userid":userid,"realname":name,"idcard":card,"alipay":alipay,"phone":phone,"code":code]
        
        Alamofire.request(.GET, urlMessage,parameters: param).response
            {
                Request,response,json,error in
                
                let result = Http(JSONDecoder(json!))
                print("JSON是",json)
                print(Request)
                if result.status == "success"{
                    print("支付宝资料上传成功")
                    Targert.navigationController?.popViewControllerAnimated(true)
//                    Targert.tabBarController?.selectedIndex = 0
//                     Targert.navigationController?.pushViewController(pushVc, animated: true)
                }else{
                    print("支付宝资料上传失败")
                }
        }
    }

    
}
