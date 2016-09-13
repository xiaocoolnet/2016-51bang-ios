//
//  TCMoreInfoHelper.swift
//  Parking
//
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD
class TCMoreInfoHelper: NSObject {
    var myDelegate:MineDelegate?
    var requestManager:AFHTTPSessionManager?
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    //修改手机号码
    func changePhoneNumber(phoneNum:String,code:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"updatephone"
        let paraDic = ["userid":TCUserInfo.currentInfo.userid,
                       "phone":phoneNum,"code":"1234"]
        requestManager?.GET(url, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //修改头像
    func changeAvatar(handle:ResponseBlock){
        let paraDic = ["a":"updateavatar","userid":TCUserInfo.currentInfo.userid,
                       "avatar":TCUserInfo.currentInfo.avatar]
        requestManager?.GET(Bang_URL_Header, parameters: paraDic, success: { (task, response) in
             let result = Http(JSONDecoder(response!))
             let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }

    //修改密码
    func changePwdWithNewPwd(pwd:String,handle:ResponseBlock){
    let paraDic = ["a":"UpdatePass","phone":TCUserInfo.currentInfo.phoneNumber,"password":pwd]
        requestManager?.GET(Bang_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
             handle(success: false,response: "网络错误")
        })
    }
    //资料编辑
    func editPersonalInfoWithUserName(name:String,sex:String,cardid:String,
                                      addr:String,handle:ResponseBlock){
        let paraDic = ["a":"updatemember","userid":TCUserInfo.currentInfo.userid,
                       "name":name,"addr":addr,"cardid":cardid,"sex":sex]
        requestManager?.GET(Bang_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
               handle(success: false,response: "网络错误")
        })
    }

    /**
     
     *获取用户数据
     @cell     所要加载数据的cell
     
    */
    
    func getUserData(cell:AnyObject)
    {
        let urlHeader = Bang_URL_Header+"getuserinfo&"
        let id = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        
        let param = ["userid":id]
        
        Alamofire.request(.GET, urlHeader, parameters: param).response
            {
                request, response, json, error in
                
                let result = MineGetModel(JSONDecoder(json!))
                print("状态")
                print(result.status)
                print(request)
                if(result.status == "success")
                {
                    var name = result.data?.name
                    if name == nil && cell.isKindOfClass(EditTableViewCell)
                    {
                        name = ""
                    }else if (name != nil && cell.isKindOfClass(EditTableViewCell))
                    {
                        (cell as! EditTableViewCell).label.text = name
                    }
                    
                }else{
                
                if(cell.isKindOfClass(EditTableViewCell))
                {
                    (cell as! EditTableViewCell).label.text = ""
                    
                }
                
                }
                
                
                
                
        }

       
    }
    
    //修改头像
    func uploadIconImage(userid:NSString,str:NSString,handle:ResponseBlock){
    //http://nurse.xiaocool.net/index.php?g=apps&m=index&a=UpdateUserName&userid=578&avatar=2939393.jpg
    
        let url = Bang_URL_Header+"UpdateUserAvatar"
        let paramDic = ["userid":userid,"avatar":str]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                
                print(result.data)
            }
            
            
        }
        
    }
 
    //修改姓名
    func updateName(name:String,target: UIViewController )
    {
        let urlHeader = Bang_URL_Header + "UpdateUserName"
        let userData = NSUserDefaults.standardUserDefaults()
        let param = ["userid":userData.objectForKey("userid")!,"nicename":name]
        
    
        Alamofire.request(.GET, urlHeader, parameters: param).response
    {
        request, response, json, error in
    
        let result = MineGetModel(JSONDecoder(json!))
        if(result.status == "success")
        {
            print("修改姓名成功")
            
            userData.setObject(name, forKey: "name")
            userData.synchronize()
            target.navigationController?.popViewControllerAnimated(true)
            self.myDelegate?.updateName(name)
            
           
        }else
        {
            let hud = MBProgressHUD.showHUDAddedTo(target.view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "修改昵称失败"
            hud.color = UIColor.grayColor()
            hud.alpha = 0.7
            hud.labelColor = UIColor.whiteColor()
            hud.xOffset = 0
            hud.yOffset = 0
            hud.hide(true, afterDelay: 2)

            print("修改姓名失败")
            
        }
    
    
    }
        
        
        
    }
    
    
    
}
