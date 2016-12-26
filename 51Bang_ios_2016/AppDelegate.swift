//
//  AppDelegate.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UINavigationControllerDelegate,BMKGeneralDelegate,TencentApiInterfaceDelegate,WXApiDelegate,TencentSessionDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?
    let mainhelper = MainHelper()
    var pointNum = Int()
    let logVM = TCVMLogModel()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let options = BugtagsOptions()
        options.trackingUserSteps = true
        options.trackingNetwork = true
        Bugtags.startWithAppKey("61aa08ab63a722f5788c5bd02f878780", invocationEvent: BTGInvocationEventNone)
        
        // Override point for customization after application launch.
       //WXApi.registerApp("wxe61df5d7fee96861")
        WXApi.registerApp("wx765b8c5e082532b4", withDescription: "a51bang")
        APOpenAPI.registerApp("2016083001821606", withDescription: "a51bang")
//        WXApi.registerApp("wx5bbd35eed5255733", withDescription: "51bang")//第二次
        TencentOAuth(appId: "1105589363", andDelegate: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkDidReceiveMessage), name:kJPFNetworkDidLoginNotification, object: nil)
       
//         WXApi.registerApp("wx765b8c5e08253264", withDescription: "51bang")
         //WXApi.registerApp("wxe61df5d7fee96861", withDescription: "51bang1")
        
//        self.window?.rootViewController?.tabBarController?.selectedIndex = 3
        //推送
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert],
                                                      categories: nil)
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
            //可以添加自定义categories
            JPUSHService.registerForRemoteNotificationTypes(userSettings.types.rawValue,
                                                            categories: nil)
        }else if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 10.0) {
            let entity  = JPUSHRegisterEntity.init()
            entity.types = 1|2|3
            JPUSHService.registerForRemoteNotificationConfig(entity, delegate: nil)
            
        }
        else {
            //categories 必须为nil
            JPUSHService.registerForRemoteNotificationTypes(userSettings.types.rawValue,
                                                            categories: nil)
        }
        
        // 启动JPushSDK
        JPUSHService.setupWithOption(launchOptions, appKey: "9d8ff2f94d6c180efb085b1a",
                                     channel: "Publish Channel", apsForProduction: true)
        
//        let defau = NSNotificationCenter.defaultCenter()
        
//        defau.addObserver(self, selector: #selector(network(_:)), name: kJPFNetworkDidLoginNotification, object: nil)
        
        if let launchOpts = launchOptions {
            
            let notification = launchOpts[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject]
            print("#$%^&*(*&^%$#")
            print(notification)
        }
        
        
        
        
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
    func tencentDidLogin(){
        
    }
    func tencentDidNotLogin(cancelled: Bool) {
        
    }
    func tencentDidNotNetWork(){
        
    }
    
    
    func networkDidReceiveMessage(){
        NSNotificationCenter.defaultCenter().postNotificationName("getRegistrationID", object: nil)
        
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            let registrationIDs = registrationID as String
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(registrationIDs, forKey: "registrationID")
            
        }
//        JPUSHService.registrationIDCompletionHandler({ (resCode, registrationID) in
            ////
////                    })
//
//            }
//            
//            
//        
//    })
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        
        application.applicationIconBadgeNumber = 0
        pointNum = 0
        application.cancelAllLocalNotifications()
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        print(userInfo["sound"])
        //增加IOS 7的支持
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
        print("545645465")
        print(userInfo)
        pointNum = pointNum+1
        application.applicationIconBadgeNumber = pointNum
    //所在城市有新任务
        if userInfo["key"] != nil {
            if  userInfo["key"] as! String == "newTask" {
                NSNotificationCenter.defaultCenter().postNotificationName("newTasksss", object: nil)
//                let vc = WoBangPageViewController()
//                pointNum = pointNum+1
//                application.applicationIconBadgeNumber = pointNum
            }else if userInfo["v"] != nil && userInfo["key"] as! String == "newMessage" {
                let dic = ["name":userInfo["v"]! as! String];
                NSNotificationCenter.defaultCenter().postNotificationName("newMessage", object: dic)
//                pointNum = pointNum+1
//                application.applicationIconBadgeNumber = pointNum
            }else
            if userInfo["key"] as! String == "sendTaskType" {
                let dic = ["name":userInfo["v"]! as! String];
                NSNotificationCenter.defaultCenter().postNotificationName("sendTaskType", object: dic)
                
            }else
            if userInfo["key"] as! String == "acceptTaskType" {
                let dic = ["name":userInfo["v"]! as! String];
                NSNotificationCenter.defaultCenter().postNotificationName("acceptTaskType", object: dic)
            }else
            if userInfo["key"] as! String == "buyOrderType" {
                let dic = ["name":userInfo["v"]! as! String];
                NSNotificationCenter.defaultCenter().postNotificationName("buyOrderType", object: dic)
            }else
            if userInfo["key"] as! String == "businessOrderType" {
                let dic = ["name":userInfo["v"]! as! String];
                NSNotificationCenter.defaultCenter().postNotificationName("businessOrderType", object: dic)
            }else
            if userInfo["key"] as! String == "loginFromOther" {
//                let dic = ["name":userInfo["v"]! as! String];
                let ud = NSUserDefaults.standardUserDefaults()
                if ud.objectForKey("registrationIDs") != nil {
                    let registrationIDs = ud.objectForKey("registrationIDs") as! String
                    let dic = userInfo["v"]! as! String
                    if dic !=  registrationIDs {
                         NSNotificationCenter.defaultCenter().postNotificationName("loginFromOther", object: nil)
                    }else{
                        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - 1
                    }
                   
                }
                
                
            }else
            if userInfo["key"] as! String == "certificationType" {
                let dic = ["name":userInfo["v"]! as! String];
                NSNotificationCenter.defaultCenter().postNotificationName("certificationType", object: dic)
            }else
                if userInfo["key"] as! String == "WithdrawSuccess" {
//                    let dic = ["name":userInfo["v"]! as! String];
                   alert("您的提现申请已成功打款，请查收", delegate: self)
                }
            
            
            else
                if userInfo["key"] as! String == "prohibitVisit" || userInfo["key"] as! String == "deleteUser" {
                    if userInfo["aps"] != nil {
                        let strr = userInfo["aps"] as! NSDictionary
                        if strr["alert"] != nil {
//                            alert(strr["alert"] as! String, delegate: self)
                            let dic = ["name":strr["alert"] as! String]
                            NSNotificationCenter.defaultCenter().postNotificationName("prohibitVisit", object: dic)
                        }
                    }

                   
                }
            
            else{
                    
                let dic = ["name":userInfo["key"]! as! String]
                NSNotificationCenter.defaultCenter().postNotificationName("CustomPushType", object: dic)
//                alert(userInfo["key"] as! String, delegate: self)
            }

        }else{
            if userInfo["aps"] != nil {
                let strr = userInfo["aps"] as! NSDictionary
                if strr["alert"] != nil {
                    if !strr["alert"]!.isKindOfClass(NSString) {
                        alert(strr["alert"]!["body"] as! String, delegate: self)
                        return
                    }else{
                        alert(strr["alert"] as! String, delegate: self)
                    }
                    
                }
            }
            
//            print(strr["alert"])
            
            
        }
        
        
        //userinfo表示可以选择的type类型
        
        completionHandler(UIBackgroundFetchResult.NewData)
        
    }
    
    
    func application(application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //可选
        NSLog("did Fail To Register For Remote Notifications With Error: \(error)")
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        WXApi.handleOpenURL(url, delegate: self)
        if url.host == "safepay"{
        
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDict:[NSObject : AnyObject]!) in
                print(resultDict)
//                let vc = OrderDetailViewController()
                
            })
//
          
        }
        
        
        
        if APOpenAPI.handleOpenURL(url, delegate: nil) {
            
        }
        QQApiInterface .handleOpenURL(url, delegate: nil)
        
        if TencentApiInterface.canOpenURL(url, delegate: self){
            TencentApiInterface.handleOpenURL(url, delegate: self)
        }
        
        TencentOAuth.HandleOpenURL(url)
        
        return true
    }
    
    
    
   
    
    
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        WXApi.handleOpenURL(url, delegate: self)
        if TencentApiInterface.canOpenURL(url, delegate: self) {
            TencentApiInterface.handleOpenURL(url, delegate: self)
        }
        return true
    }
    
    func onResp(resp:BaseResp){
//        print(resp)
//        
//        print(resp.type)
//        print(resp.errCode)
//        print(resp.errStr)
        if resp.errCode == 0 {
            NSNotificationCenter.defaultCenter().postNotificationName("backForPAy", object: "success", userInfo: nil)
        }
        
        
    }
    
    
    
    
    //ios9以后使用
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        WXApi.handleOpenURL(url, delegate: self)
        if url.host == "safepay"{
            
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic:[NSObject : AnyObject]!) in
                print(resultDic)
                print("reslut = \(resultDic)");
                if let Alipayjson = resultDic as? NSDictionary{
                    let resultStatus = Alipayjson.valueForKey("resultStatus") as! String
                    if resultStatus == "9000"{
                        
                        print("OK")
//                        NSNotificationCenter.defaultCenter().postNotificationName("payBack", object: nil)
//                        let vc = OrderDetailViewController()
//                        NSNotificationCenter.defaultCenter().postNotificationName("payResult", object: "success", userInfo: nil)
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
//    
//    func payback(notification:NSNotification){
//        let isRenwu = notification.object?.valueForKey("isRenwu") as? Bool
//        let numForGoodS = notification.object?.valueForKey("numForGoodS") as? String
//            }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

//    func applicationWillEnterForeground(application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        print(application)
        let ud = NSUserDefaults.standardUserDefaults()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if ud.objectForKey("comeFromWechat") != nil {
            if ud.objectForKey("comeFromWechat") as! String == "bookDan" {
               NSNotificationCenter.defaultCenter().postNotificationName("goOrderList", object: nil)
                ud.removeObjectForKey("comeFromWechat")
            }else{
                NSNotificationCenter.defaultCenter().postNotificationName("goRenwuList", object: nil)
                ud.removeObjectForKey("comeFromWechat")
            }
        }
        //这里是检测是否需要再次登陆的地方，走接口发送设备吗到后台进行验证，客户需求暂时关闭
//        if (JPUSHService.registrationID() != nil) {
////            print(JPUSHService.registrationID())
//            
//            if (ud.objectForKey("userid") != nil) {
//                var userids = String()
//                if ud.objectForKey("userid") != nil{
//                    userids = ud.objectForKey("userid")as! String
//                }
////                let userids = ud.objectForKey("userid") as! String
//                mainhelper.checkIslogin(userids, handle: { (success, response) in
//                    dispatch_async(dispatch_get_main_queue(), {
//                    if !success{
//                        let userDatas = NSUserDefaults.standardUserDefaults()
//                        //                    print(userDatas.objectForKey("userid"))
//                        userDatas.removeObjectForKey("userid")
//                        if userDatas.objectForKey("name") != nil {
//                            userDatas.removeObjectForKey("name")
//                        }
//                        
//                        if userDatas.objectForKey("photo") != nil {
//                            userDatas.removeObjectForKey("photo")
//                        }
//                        if userDatas.objectForKey("sex") != nil {
//                            userDatas.removeObjectForKey("sex")
//                        }
//                        
//                        if userDatas.objectForKey("pwd") != nil {
//                            userDatas.removeObjectForKey("pwd")
//                        }
//                        if userDatas.objectForKey("userphoto") != nil {
//                            userDatas.removeObjectForKey("userphoto")
//                        }
//                        
//                        if userDatas.objectForKey("ss") != nil {
//                            userDatas.removeObjectForKey("ss")
//                        }
//                        JPUSHService.setTags(nil, aliasInbackground: "99999999")
//                        loginSign = 0
//                        self.window?.rootViewController?.tabBarController?.selectedIndex = 3
//                        NSNotificationCenter.defaultCenter().postNotificationName("getRegistrationID", object: nil)
////                        UIApplication.sharedApplication().registerForRemoteNotifications()
//                                            self.window?.rootViewController!.tabBarController?.selectedIndex = 3
//                        if self.window?.rootViewController?.tabBarController?.selectedIndex == 3{
//                            self.window?.rootViewController?.tabBarController?.selectedIndex = 0
//                        }
//                    }
//                    else{
//                        let ud = NSUserDefaults.standardUserDefaults()
//                        if ud.objectForKey("registrationID") != nil{
//                            let registrationID = response as! String
//                            if (ud.objectForKey("registrationID") as! String) != registrationID{
//                                print(registrationID)
//                                let userDatas = NSUserDefaults.standardUserDefaults()
//                                //                    print(userDatas.objectForKey("userid"))
//                                userDatas.removeObjectForKey("userid")
//                                if userDatas.objectForKey("name") != nil {
//                                    userDatas.removeObjectForKey("name")
//                                }
//                                
//                                if userDatas.objectForKey("photo") != nil {
//                                    userDatas.removeObjectForKey("photo")
//                                }
//                                if userDatas.objectForKey("sex") != nil {
//                                    userDatas.removeObjectForKey("sex")
//                                }
//                                
//                                if userDatas.objectForKey("pwd") != nil {
//                                    userDatas.removeObjectForKey("pwd")
//                                }
//                                if userDatas.objectForKey("userphoto") != nil {
//                                    userDatas.removeObjectForKey("userphoto")
//                                }
//                                
//                                if userDatas.objectForKey("ss") != nil {
//                                    userDatas.removeObjectForKey("ss")
//                                }
//                                JPUSHService.setTags(nil, aliasInbackground: "99999999")
//                                loginSign = 0
//                                NSNotificationCenter.defaultCenter().postNotificationName("getRegistrationID", object: nil)
//                                self.window?.rootViewController?.tabBarController?.selectedIndex = 3
//                                if self.window?.rootViewController?.tabBarController?.selectedIndex == 3{
//                                    self.window?.rootViewController?.tabBarController?.selectedIndex = 0
//                                }
//                            }
//                        }
//                        
//                    }
//                    })
//                })
//            }
//
//        }
        
        
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
    
    //MARK:------JPUSHRegisterDelegate
    


}

