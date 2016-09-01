//
//  AppDelegate.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UINavigationControllerDelegate,BMKGeneralDelegate,TencentApiInterfaceDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
       //WXApi.registerApp("wxe61df5d7fee96861")
        WXApi.registerApp("wx765b8c5e082532b4", withDescription: "51bang")
        APOpenAPI.registerApp("2016083001821606", withDescription: "51bang")
//        WXApi.registerApp("wx5bbd35eed5255733", withDescription: "51bang")//第二次
        TencentOAuth(appId: "1105589363", andDelegate: nil)
//         WXApi.registerApp("wx765b8c5e08253264", withDescription: "51bang")
         //WXApi.registerApp("wxe61df5d7fee96861", withDescription: "51bang1")
        
        //分享
        ShareSDK.registerApp("13be4c6c247e0", activePlatforms:
            
            [SSDKPlatformType.TypeQQ.rawValue,SSDKPlatformType.TypeWechat.rawValue], onImport: { (platform : SSDKPlatformType) -> Void in
                
                switch platform{
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                default:
                    break
                }
                
        }) { (platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
            switch platform {
                //            case  SSDKPlatformType.TypeQQ:
                //                appInfo.SSDKSetupQQByAppId("1105281857", appKey: "bysMNvzaiLTMsXjQ", authType: "qq分享")
            //                break
            case SSDKPlatformType.TypeWechat:
                //设置微信应用信息
                appInfo.SSDKSetupWeChatByAppId("wxe61df5d7fee96861", appSecret: "0dbfa83f68bfca4d3b60412e581301e2")
                break
            default:
                break
            }
        }

        
        
        
        
        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        NSThread.sleepForTimeInterval(2.0)
        
        UITabBar.appearance().tintColor = COLOR
        UINavigationBar.appearance().barTintColor = COLOR
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        if let barFont = UIFont(name: "ChalkboardSE-Bold", size: 18){
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName:UIColor.whiteColor(),
                NSFontAttributeName : barFont
            ]
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: UIBarMetrics.Default)
        if( NSUserDefaults.standardUserDefaults().objectForKey("userid") != nil)
        {
            loginSign = 1
        }
        
        
        /***********************百度地图********************************/
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("SdD0fiLvsqqWuoAUZWhDmF3BuU4ovmHA", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        

        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.host == "safepay"{
        
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDict:[NSObject : AnyObject]!) in
                print(resultDict)
//                let vc = OrderDetailViewController()
                
            })
//
          
        }
        
        
        
        if APOpenAPI.handleOpenURL(url, delegate: nil) {
            
        }
        if TencentApiInterface.canOpenURL(url, delegate: self){
            TencentApiInterface.handleOpenURL(url, delegate: self)
        }
        
        
        
        return true
    }
    
    
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if TencentApiInterface.canOpenURL(url, delegate: self) {
            TencentApiInterface.handleOpenURL(url, delegate: self)
        }
        return true
    }
    
    
    
    
    
    
    //ios9以后使用
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if url.host == "safepay"{
            
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic:[NSObject : AnyObject]!) in
                print(resultDic)
                print("reslut = \(resultDic)");
                if let Alipayjson = resultDic as? NSDictionary{
                    let resultStatus = Alipayjson.valueForKey("resultStatus") as! String
                    if resultStatus == "9000"{
                        print("OK")
//                        let vc = OrderDetailViewController()
                        NSNotificationCenter.defaultCenter().postNotificationName("payResult", object: "success", userInfo: nil)
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if resultStatus == "8000" {
                        print("正在处理中")
//                        self.navigationController?.popViewControllerAnimated(true)
                    }else if resultStatus == "4000" {
                        print("订单支付失败");
//                        self.navigationController?.popViewControllerAnimated(true)
                    }else if resultStatus == "6001" {
                        print("用户中途取消")
//                        self.navigationController?.popViewControllerAnimated(true)
                    }else if resultStatus == "6002" {
                        print("网络连接出错")
//                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }

            })
            
        }
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
        
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }

}

