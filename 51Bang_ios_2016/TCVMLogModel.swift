//
//  TCVMLogModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire

typealias ResponseBlock = (success:Bool,response:AnyObject?)->Void
typealias DownMP3Block = (success:Bool,response:String)->Void
class TCVMLogModel: NSObject {
    var requestManager:AFHTTPSessionManager?
    
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    //登录
    func login(phoneNum:String,password:String,registrationID:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"applogin"
        let paramDic = ["phone":phoneNum,"password":password,"registrationID":registrationID,"devicestate":"1"]
        
        requestManager?.GET(url, parameters: paramDic, success: { (task, obj) in
            print(task.currentRequest?.URL)
            let result = TCUserInfoModel(JSONDecoder(obj!))
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.errorData)
                
            }
//            handle(success: true, response: result.data)
            
            }, failure: { (task, error) in
                print(task)
            handle(success: false, response: "请求失败")
        })
        
//        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
////            print(request)
//             let result = TCUserInfoModel(JSONDecoder(json!))
//             print(result)
//             print(result.data)
//             print(result.status)
//             if result.status == "success"{
//                print(result.data)
//                handle(success: true, response: result.data)
//             }else{
//                handle(success: false, response: result.errorData)
////                print(result.data)
//
//                
//            }
// 
//            
//        }
        
//        requestManager?.GET(url, parameters: paramDic, success: { (task, response) in
//            let result = TCUserInfoModel(JSONDecoder(response!))
//            if result.status == "success"{
//                TCUserInfo.currentInfo.phoneNumber = (result.data?.user_phone)!
//                let userid = (result.data?.id)!
//                TCUserInfo.currentInfo.userid = String(userid)
//                TCUserInfo.currentInfo.userName = (result.data?.user_name)!
//                TCUserInfo.currentInfo.address = (result.data?.addr)!
//                TCUserInfo.currentInfo.cardid = (result.data?.card_id)!
//                TCUserInfo.currentInfo.bankNo = (result.data?.bank_branch)!
//                TCUserInfo.currentInfo.banktype = (result.data?.bank_type)!
//                TCUserInfo.currentInfo.bankBranch = (result.data?.bank_no)!
//                TCUserInfo.currentInfo.bankUserName = (result.data?.bank_user_name)!
//                TCUserInfo.currentInfo.sex = (result.data?.sex)!
//                if result.data?.avatar != nil {
//                    TCUserInfo.currentInfo.avatar = (result.data?.avatar)!
//                }
//            }
//            let responseStr = result.status == "success" ? nil : result.errorData
//                handle(success: result.status == "success",response: responseStr)
//            }, failure: { (task, error) in
//                handle(success: false,response: "网络错误")
//        })
    }
    //发送验证码
    func sendMobileCodeWithPhoneNumber(phoneNumber:String){
        let url = Bang_URL_Header+"SendMobileCode"
        let paramDic = ["phone":phoneNumber]
        requestManager?.GET(url, parameters: paramDic, success: { (task, obj) in
            alert("发送成功", delegate: self)
            }, failure: { (task, error) in
        alert("发送失败，请重试", delegate: self)
        
        })
    }
    //注册
    func register(phone:String,password:String,
                  code:String,avatar:String,name:String,
                  sex:String,cardid:String,addr:String,referral:String, handle:ResponseBlock){
        let url = Bang_URL_Header+"AppRegister"
        let paramDic = ["phone":phone,"password":password,"avatar":avatar,
                        "code":code,"name":name,"devicestate":"1","sex":sex,"referral":referral
                       ]
        
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            print(json)
            let result = Http(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
//                print(result.datas)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.errorData)
                print(result.data)
            }
            
            
        }

        
//        requestManager?.GET(url, parameters: paramDic, success: { (task, response) in
//            
//            let result = Http(JSONDecoder(response!))
//            let responseStr = result.status == "success" ? nil : result.errorData
//            handle(success: result.status == "success",response: responseStr)
//            }, failure: { (task, error) in
//                handle(success: false,response: "网络错误")
//        })
    }
    //忘记密码
    func forgetPassword(phone:String,code:String,password:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"forgetpwd"
        let paramDic = ["phone":phone,"code":code,"password":password]
        requestManager?.GET(url, parameters: paramDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? "成功" : result.errorData
            if responseStr != nil {
                handle(success: result.status == "success",response: responseStr)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //验证手机是否已经注册
    func comfirmPhoneHasRegister(phoneNum:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"checkphone"
        let paraDic = ["phone":phoneNum]
        requestManager?.GET(url, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
               handle(success: false,response: "网络错误") 
        })
    }
    
    func getCollectionList(uid:NSString,handle:ResponseBlock){
    //http://bang.xiaocool.net/index.php?g=apps&m=index&a=getfavoritelist&userid=578
        
        let url = Bang_URL_Header+"getfavoritelist"
        let paramDic = ["userid":uid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = CollectionModel(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.datas)
                handle(success: true, response: result.datas)
            }else{
                
                print(result.data)
            }
            
            
        }
    
    }
    
    
    
    
    func ChangePhone(userid:NSString,phone:NSString,code:NSString,handle:ResponseBlock){
        let url = Bang_URL_Header+"UpdateUserPhone"
        let paramDic = ["userid":userid,"phone":phone,"code":code]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(response!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.data)
                handle(success: true, response: result.data)
            }else{
                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }
    }

    //判断是否签到
    func isSign(userid:String,day:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetMySignLog"
        let paramDic = ["userid":userid,"day":day]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(json!))
            print(result)
            print(result.data)
            print(result.status)
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.status)
            }else{
                handle(success: false, response: result.status)
//                alert(result.data!, delegate: self)
                print(result.status)
            }
            
            
        }

    
    }
    
    //签到
    func sign(userid:String,day:String,handle:ResponseBlock){
    
        let url = Bang_URL_Header+"SignDay"
        let paramDic = ["userid":userid,"day":day]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.status)
            }else{
                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }
    }
    //获取系统消息
    func getMessage(userid:String,handle:ResponseBlock){
        //http://bang.xiaocool.net/index.php?g=apps&m=index&a=getsystemmessage&userid=1
        let url = Bang_URL_Header+"getsystemmessage"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = MessageModel(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.datas)
                handle(success: true, response: result.datas)
            }else{
//                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }

    
    }
    
   //取消订单
    func cancleOrder(ownerid:String,taskid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"OwnerCancelTask"
        let paramDic = ["ownerid":ownerid,"taskid":taskid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.data)
            }else{
                handle(success: false, response: result.errorData)
//                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }

    }
    
    
    //钱包  http://bang.xiaocool.net/index.php?g=apps&m=index&a=GetMyWallet&userid=127
    func getQianBaoData(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetMyWallet"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = walletModel(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.data)
            }else{
//                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }

    
    }
    
    //收支记录
    func getShouZhi(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetMyWalletLog"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = walletDetailModel(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.datas)
            }else{
                //                alert(result.data!, delegate: self)
                print(result.data)
                handle(success: false, response: result.errorData)
            }
            
            
        }
        
        
    }

    //提现记录
    func getTiXian(userid:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"GetMyWithdrawLog"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = walletDetail2Model(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.datas)
            }else{
                handle(success: false, response: result.datas)
                print(result.data)
            }
            
            
        }
    }
    
    //获取我的地址
    //http://bang.xiaocool.net/index.php?g=apps&m=index&a=GetMyAddressList&userid=127
    func  getMyAddress(userid:String,handle:ResponseBlock){
    
        let url = Bang_URL_Header+"GetMyAddressList"
        let paramDic = ["userid":userid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = MyAddressModel(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.datas)
            }else{
                handle(success: false, response: result.datas)
                //                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }

    
    }
    
    //删除地址
    func deleteAddress(userid:String,addressid:String,handle:ResponseBlock){
        
        let url = Bang_URL_Header+"DeleteAddress"
        let paramDic = ["userid":userid,"addressid":addressid]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.data)
            }else{
                //                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }

    
    }
    
    //添加地址
    func addAddress(userid:String,address:String,longitude:String,latitude:String,isdefault:String,handle:ResponseBlock){
        let url = Bang_URL_Header+"AddAddress"
        let paramDic = ["userid":userid,"address":address,"longitude":longitude,"latitude":latitude,"isdefault":isdefault]
        Alamofire.request(.GET, url, parameters: paramDic).response { request, response, json, error in
            print(request)
            let result = Http(JSONDecoder(json!))
            print("++++")
            print(result)
            print(result.data)
            print(result.status)
            print("++++")
            if result.status == "success"{
                print(result.status)
                handle(success: true, response: result.data)
            }else{
                //                alert(result.data!, delegate: self)
                print(result.data)
            }
            
            
        }
    
    }
    
    
    
    
}
