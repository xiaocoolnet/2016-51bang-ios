//
//  PayViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class PayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    var selectArr = NSMutableArray()
    var payMode = NSString()
    var isAgree = Bool()
    var price = Double()
    var subject = NSString()
    var body = NSString()
    var xiaofei = String()
    let shopHelper = ShopHelper()
    var numForGoodS = String()//订单号（由服务器返回）
    var mydata = NSMutableDictionary()
    var isRenwu = Bool()
    let mainhelper = MainHelper()
    
    var isMessage = Bool()
    var isGuanggao = Bool()
    
    /**
     *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
     */
    let WXAppId = "wx765b8c5e082532b4";
    
    /**
     *  申请微信支付成功后，发给你的邮件里的微信支付商户号
     */
    let WXPartnerId = "1364047302";
    
    /** API密钥 去微信商户平台设置--->账户设置--->API安全， 参与签名使用 */
    //risF2owP8yAdmZgfVYnmqZoElIpD5Bz1
    //risF2owP8yAdmZgfVYnmqZoElIpD5Bz1
    let WXAPIKey = "risF2owP8yAdmZgfVYnmqZoElIpD5Bz1";
    
    /** 获取prePayId的url, 这是官方给的接口 */
    let getPrePayIdUrl = "https://api.mch.weixin.qq.com/pay/unifiedorder";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.price)
        print(self.subject)
        print(self.body)
        
        self.navigationItem.hidesBackButton = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.goOrderList), name:"goOrderList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.goRenwuList), name:"goRenwuList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.gomessage), name:"gomessage", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.guanggao), name:"guanggao", object: nil)
        
        isAgree = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.nextView),
                                                         name: "payResult", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.backpayForweixin),
                                                         name: "backForPAy", object: nil)
        self.title = "订单支付"
        self.createTableView()
        // Do any additional setup after loading the view.
    }
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "PayMethodTableViewCell",bundle: nil), forCellReuseIdentifier: "paycell")
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 220))
        let label = UILabel.init(frame: CGRectMake(0, 10, 160, 22))
        label.text = "我同意《用户者服务协议》"
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(14)
        let button = UIButton.init(frame: CGRectMake(WIDTH-160, 10, 160, 50))
        button.addSubview(label)
        button.addTarget(self, action: #selector(self.xieyi(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let selectBtn = UIButton.init(frame: CGRectMake(WIDTH-185, 20, 17, 17))
        selectBtn.tag = 15
        selectBtn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
        selectBtn.addTarget(self, action: #selector(self.agreePro), forControlEvents: UIControlEvents.TouchUpInside)
        //        imageView.image = UIImage(named: "ic_weixuanze")
        let btn = UIButton(frame: CGRectMake(15, 80, WIDTH-30, 50))
        btn.layer.cornerRadius = 8
        btn.setTitle("立即支付", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        btn.addTarget(self, action: #selector(self.pay), forControlEvents: .TouchUpInside)
        //        bottom.addSubview(button)
        //        bottom.addSubview(selectBtn)
        bottom.addSubview(btn)
        let btnCanel = UIButton(frame: CGRectMake(15, 150, WIDTH-30, 50))
        btnCanel.layer.cornerRadius = 8
        btnCanel.setTitle("取消支付", forState: .Normal)
        btnCanel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnCanel.backgroundColor = COLOR
        btnCanel.addTarget(self, action: #selector(self.canelPay), forControlEvents: .TouchUpInside)
        //        bottom.addSubview(button)
        //        bottom.addSubview(selectBtn)
        bottom.addSubview(btnCanel)
        
        if self.isMessage{
            bottom.frame = CGRectMake(0, 0, WIDTH, 350)
            let worningButton = UIButton.init(frame: CGRectMake(0, 250, WIDTH, 30))
            worningButton.setTitle("如果需要办理套餐请拨打:4000608856", forState: .Normal)
            worningButton.setTitleColor(COLOR, forState: .Normal)
            worningButton.titleLabel?.font = UIFont.systemFontOfSize(13)
            worningButton.backgroundColor = UIColor.clearColor()
            worningButton.addTarget(self, action: #selector(self.worningButtonAction), forControlEvents: .TouchUpInside)
            bottom.addSubview(worningButton)
            
        }
        
        let headerView =  NSBundle.mainBundle().loadNibNamed("PayHeaderCell", owner: nil, options: nil).first as? PayHeaderCell
        print(self.xiaofei)
        if self.xiaofei == "" {
            headerView?.price.text = "¥ "+String(self.price)
        }else{
            self.price = self.price + Double(self.xiaofei)!
            headerView?.price.text = "¥ "+String(self.price)
        }
        
        headerView?.frame = CGRectMake(0, 0, WIDTH, 100)
        view.backgroundColor = RGREY
        myTableView.tableHeaderView = headerView
        myTableView.tableFooterView = bottom
        self.view.addSubview(myTableView)
        //        self.view.addSubview(bottom)
    }
    
    func goOrderList(){
        let bookVC = MyBookDan()
        let array = [self.navigationController!.viewControllers[0],bookVC]
        
        
        self.navigationController?.setViewControllers(array, animated: true)
    }
    func goRenwuList(){
        
        let bookVC = MyFaDan()
        let array = [self.navigationController!.viewControllers[0],bookVC]
        self.navigationController?.setViewControllers(array, animated: true)
        
    }
    func gomessage(){
        
        let bookVC = ConvenientPeople()
        bookVC.headerRefresh()
        let array = [self.navigationController!.viewControllers[0],bookVC]
        self.navigationController?.setViewControllers(array, animated: true)

    }
    func guanggao(){
        let bookVC = MyAdvertisementPublishViewController()
        bookVC.counts = 1
        let array = [self.navigationController!.viewControllers[0],bookVC]
        self.navigationController?.setViewControllers(array, animated: true)
    }
    
    
    func xieyi(btn:UIButton){
        
        let vc = JiaoChengViewController()
        vc.sign = 3
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func worningButtonAction(){
        let alertController = UIAlertController(title: "系统提示",
                                                message: "是否要拨打电话4000608856？", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .Default,
                                     handler: { action in
                                        
                                        let url1 = NSURL(string: "tel://4000608856")
                                        UIApplication.sharedApplication().openURL(url1!)
                                        
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func canelPay(){
        if isRenwu{
            let bookVC = MyFaDan()
            let array = [self.navigationController!.viewControllers[0],bookVC]
            self.navigationController?.setViewControllers(array, animated: true)
        }else{
            if isMessage{
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: false)
            }else{
                if isGuanggao{
                    let bookVC = MyAdvertisementPublishViewController()
                    let array = [self.navigationController!.viewControllers[0],bookVC]
                    self.navigationController?.setViewControllers(array, animated: true)

                }else{
                    let bookVC = MyBookDan()
                    let array = [self.navigationController!.viewControllers[0],bookVC]
                    
                    
                    self.navigationController?.setViewControllers(array, animated: true)
                }
            }
        }
    }
    
    
    //支付方法
    func pay(){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        var orderNum = String()
        orderNum = String(arc4random()%1000) + dateStr + "_" + numForGoodS
        
        print(self.payMode)
        if price == 0{
            alert("金额不能为0", delegate: self)
            return
        }
        if self.payMode.isEqualToString("") {
            alert("请选择支付方式", delegate: self)
            print("请选择支付方式")
            return
        }else if self.payMode == "支付宝"{
            //支付宝支付
            //            let userDufault = NSUserDefaults.standardUserDefaults()
            
            //            if (userDufault.objectForKey("ordernumber") == nil) {
            //                print("0000000000")
            //            let dateFormatter = NSDateFormatter()
            //            dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
            //            let dateStr = dateFormatter.stringFromDate(NSDate())
            if  self.numForGoodS.characters.count < 0{
                alert("订单错误", delegate: self)
                return
            }
            //            orderNum  = self.numForGoodS
            
            
            //            }else{
            //                orderNum = userDufault.objectForKey("ordernumber") as! String
            //            }
            
            print("支付宝账号为：\(orderNum)")
            //            let partner = "2088002084967422";
            let partner = "2088502912356032";
            //            let seller = "aqian2001@163.com";
            let seller = "743564391@qq.com";
            
            //私钥

            
            let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM2arVc/DULOrVn5VVdkALDETOa1sznxviFaDD/+bZJI+3C7ls1HVZzKNCj7uwKKk02fRnLU70twRMifdhbIwEpqIFQLZW2HXbbif9+74BhetsQiQ/kyzRAhWEqeppNv/KTCtPM5d99S74diQuHHIH0cz4g7Xy9i/9RH8oS315bDAgMBAAECgYEAqpiO/3dXn3kxqRgS0aIuWH1oeX2GKqwE4FOBGpAXhmt8BfwAkm9//8pfISpN7zvgIWXo5Fr9+pA64mQ9bYZA1YDMLxcebn6uRqXZGoa0iZmx0n8/JpTw9L9A0Jt2HBJltrW5vsHqwOkjNL3sPxeeLOnNT9kVRSpp2gRFQuqZPoECQQDvYBpPUOeQ9KC1nouv3ngXOZg0Pw/vJbxaQWwqCAjN/l2m6sBjU6lP2dVB6QSVbD4V6rNABX63PW69uo8V5e1jAkEA2+ImfhcdSM1zS3QnKeyNd0HCKNvXXWXhjnAZ22pHI7tApIexsa/IlbQYNGbL14ZyRD6jq64P2FPwxt4hHUcfIQJAbSBdviz+9GlhXorh2ZJNIyFhjuf05qxIWskae2rgQLCmlzLL9DwuorWG8B4/tbL79tfhUd1vcC/0bVBAbNY+SwJACG2SrCKWrMOzN6EsHx9CDOAoYQiMKLhO/PavBwn70BLNV4Eb/oOOXK6afuexyIEOwC7mdx4k3VXaVMUO3+BqAQJAeMQtg/QEDZJb+frQLOlElYpsUS/J+bASiHHb6j0UTgUYfEtC34oJDd5lX1ZkiaQV5lnGUT8T0da+bzomkZ5xSA=="
            
           
            print(orderNum)
            let order = Order()
            order.appID = "2016083001821606"
            order.partner = partner;
            order.sellerID = seller;
             //订单ID（由商家自行制定）
            if isMessage{
                order.outTradeNO = self.numForGoodS
            }else{
                order.outTradeNO = orderNum ;
            }
            if isGuanggao{
                order.outTradeNO = self.numForGoodS
            }else{
                order.outTradeNO = orderNum ;
            }
            //            order.outTradeNO = "154553456456"
            if self.subject == "" {
                order.subject = "商品标题"
            }else{
                order.subject = self.subject as String; //商品标题
            }
            if self.body == "" {
                order.body = "商品描述"
            }else{
                order.body = self.body as String; //商品描述
            }
            
            if String(self.price) == "" {
                order.totalFee = "0.01"
            }else{
                order.totalFee = String(self.price); //商品价格
            }
            order.notifyURL =  Bang_Open_Header+"apps/index/AlipayNotify"; //回调URL，这个URL是在支付之后，支付宝通知后台服务器，使数据同步更新，必须填，不然支付无法成功
            //下面的参数是固定的，不需要改变
            order.service = "mobile.securitypay.pay";
            order.paymentType = "1";
            order.inputCharset = "utf-8";
            order.itBPay = "30m";
            order.showURL = "m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            let appScheme = "a51bang";
            let orderSpec = order.description;
            
            let signer = CreateRSADataSigner(privateKey);
            let signedString = signer.signString(orderSpec);
            if signedString != nil {
                let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\"";
                
                
//                let user = NSUserDefaults.standardUserDefaults()
                let user = NSUserDefaults.standardUserDefaults()
                if (self.isRenwu) {
                    user.setObject("renwuBook",forKey:"comeFromWechat")
                }else{
                    if self.isMessage{
                        user.setObject("message",forKey:"comeFromWechat")
                    }else{
                        if self.isGuanggao{
                            user.setObject("guanggao",forKey:"comeFromWechat")
                        }else{
                            user.setObject("bookDan",forKey:"comeFromWechat")
                        }
                        
                    }
                    
                }

                
                
                AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme) { (dic)-> Void in
                    
                    print(dic)
                    
                    let diss = dic as NSDictionary
                    if diss["resultStatus"]?.intValue == 9000{
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.animationType = .Zoom
                        //        hud.mode = .Text
                        hud.labelText = "正在努力加载"
                        if self.isRenwu == true {
                            self.mainhelper.upALPState("1_"+self.numForGoodS, state: "1", type: "1", handle: { (success, response) in
                                if !success{
//                                    alert("支付未成功，如有疑问请联系客服", delegate: self)
                                }
                                hud.hide(true)
                                //                self.tabBarController?.selectedIndex = 0
                                let vc = MyFaDan()
                                vc.sign = 1
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }else{
                            self.mainhelper.upALPState("1_"+self.numForGoodS, state: "1", type: "2", handle: { (success, response) in
                                if !success{
//                                    alert("支付未成功，如有疑问请联系客服", delegate: self)
                                }
                                
                                
                                
                                if (self.isRenwu) {
                                    self.goRenwuList()
                                }else{
                                    if self.isMessage{
                                        self.gomessage()
                                    }else{
                                        if self.isGuanggao{
                                            self.guanggao()
                                        }else{
                                            self.goOrderList()
                                        }
                                        
                                    }
                                    
                                }

                                
                            })
                        }
                    }
                    
                    
                    //                    let vc = MyBookDan()
                    //                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            }
        }else if self.payMode == "微信"{
            //微信支付
            print("微信支付")
            print(subject)
            let weChatPay = FZJWeiXinPayMainController()
            print(String(price))
            print(body.length)
            if body.length == 0 || body.length>30{
                body = "无效商品名称"
            }
            if price == 0{
                alert("金额不能为0", delegate: self)
                return
            }
            if  self.numForGoodS.characters.count < 1{
                alert("订单错误", delegate: self)
                return
            }
            if isGuanggao{
                weChatPay.testStart(String(Int(price*100)) ,orderName: body as String,numOfGoods:self.numForGoodS,isRenwu:4);
                return
            }
            
            if isMessage{
                
                weChatPay.testStart(String(Int(price*100)) ,orderName: body as String,numOfGoods:self.numForGoodS,isRenwu:3);
            }else if isGuanggao{
                weChatPay.testStart(String(Int(price*100)) ,orderName: body as String,numOfGoods:self.numForGoodS,isRenwu:3);
            }else{
                if isRenwu{
                     weChatPay.testStart(String(Int(price*100)) ,orderName: body as String,numOfGoods:orderNum,isRenwu:1);
                }else{
                     weChatPay.testStart(String(Int(price*100)) ,orderName: body as String,numOfGoods:orderNum,isRenwu:2);
                }
               
            }
            
        }else{
            alert("钱包支付", delegate: self)
        }
        if isMessage{
            let vc =  ConvenientPeople()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func payForWechat(){
        
        let req = payRequsestHandler()
        req.setKey(PARTNER_ID)
        let dict = req.sendPay_demo()
        if dict != nil {
            let retcode = dict.objectForKey("retcode")
            if retcode  == nil {
                let stamp:NSMutableString = dict.objectForKey("timestamp")as! NSMutableString
                let request = PayReq.init()
                request.openID = dict.objectForKey("appid")as! String
                request.partnerId = dict.objectForKey("partnerid") as! String
                request.prepayId = dict.objectForKey("prepayid")as! String
                request.nonceStr = dict.objectForKey("noncestr")as! String
                request.timeStamp = UInt32(stamp as String)!
                //                request.timeStamp = UInt32(stamp as String)!
                //                request.timeStamp = stamp.intValue as!UInt32
                //                request.timeStamp = UInt32((stamp as NSString).intValue)
                request.package = dict.objectForKey("package")as!String
                request.sign = dict.objectForKey("sign")as!String
                print(stamp.intValue)
                print(UInt32((stamp as NSString).intValue))
                print(request.timeStamp)
                WXApi.sendReq(request)
                
            }else{
                
                alert(dict.objectForKey("retmsg")as!String, delegate: self)
            }
        }else{
            
            alert("服务器返回错误，未获取到json对象", delegate: self)
        }
        
    }
    
    func backpayForweixin()  {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        //        hud.mode = .Text
        hud.labelText = "正在努力加载"
        
        if isRenwu == true {
            self.mainhelper.upALPState("1_"+numForGoodS, state: "2", type: "1", handle: { (success, response) in
                if !success{
//                    alert("支付未成功，如有疑问请联系客服", delegate: self)
                }
                hud.hide(true)
                //                self.tabBarController?.selectedIndex = 3
                //                let vc = MyFaDan()
                //                vc.sign = 1
                //                self.navigationController?.pushViewController(vc, animated: true)
            })
        }else{
            self.mainhelper.upALPState("1_"+numForGoodS, state: "2", type: "2", handle: { (success, response) in
                if !success{
//                    alert("支付未成功，如有疑问请联系客服", delegate: self)
                }
                hud.hide(true)
                //                self.tabBarController?.selectedIndex = 3
                //                let vc = MyBookDan()
                //                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        //        let vc = OrderDetailViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func nextView(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        //        hud.mode = .Text
        hud.labelText = "正在努力加载"
        if isRenwu == true {
            self.mainhelper.upALPState("1_"+numForGoodS, state: "1", type: "1", handle: { (success, response) in
                if !success{
//                    alert("支付未成功，如有疑问请联系客服", delegate: self)
                }
                hud.hide(true)
                //                self.tabBarController?.selectedIndex = 0
                //                self.tabBarController?.selectedIndex = 3
                let vc = MyFaDan()
                vc.sign = 1
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }else{
            self.mainhelper.upALPState("1_"+numForGoodS, state: "1", type: "2", handle: { (success, response) in
                if !success{
//                    alert("支付未成功，如有疑问请联系客服", delegate: self)
                }
                hud.hide(true)
                //                self.tabBarController?.selectedIndex = 3
                let vc = MyBookDan()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
        
        
        //        let vc = OrderDetailViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func getWeChatPayWithOrderName(name:NSString,price:NSString){
        
        let userDufault = NSUserDefaults.standardUserDefaults()
        var orderNum = String()
        if userDufault.objectForKey("ordernumber") != nil {
            orderNum = userDufault.objectForKey("ordernumber") as! String
        }
        print(orderNum)
        
        //----------------------------获取prePayId配置------------------------------
        // 订单标题，展示给用户
        let orderName = name
        // 订单金额,单位（分）, 1是0.01元
        let orderPrice = price
        // 支付类型，固定为APP
        let orderType = "APP"
        // 随机数串
        let noncestr  = CommonUtil.genNonceStr()
        // 商户订单号
        let orderNO   = CommonUtil.genOutTradNo()
        //ip
        let ipString = CommonUtil.getIPAddress(true)
        
        //================================
        //预付单参数订单设置
        //================================
        let  packageParams = NSMutableDictionary()
        packageParams.setObject(WXAppId, forKey: "appid")       //开放平台appid
        packageParams.setObject(WXPartnerId, forKey: "mch_id")  //商户号
        packageParams.setObject(noncestr, forKey: "nonce_str")   //随机串
        packageParams.setObject(orderType, forKey: "trade_type") //支付类型，固定为APP
        packageParams.setObject(orderName, forKey: "body")       //订单描述，展示给用户
        packageParams.setObject(orderNum, forKey: "out_trade_no") //商户订单号
        packageParams.setObject(orderPrice, forKey: "total_fee") //订单金额，单位为分
        packageParams.setObject(ipString, forKey: "spbill_create_ip") //发器支付的机器ip
        packageParams.setObject(Bang_Open_Header+"api/alipay_app/notify_url.php", forKey: "notify_url") //支付结果异步通知
        var prePayid = NSString()
        prePayid = CommonUtil.sendPrepay(packageParams,andUrl: getPrePayIdUrl)
        //---------------------------获取prePayId结束------------------------------
        if prePayid != ""{
            let timeStamp = CommonUtil.genTimeStamp()//时间戳
            let request = PayReq.init()
            request.partnerId = WXPartnerId
            request.prepayId = prePayid as String
            request.package = "Sign=WXPay"
            request.nonceStr = noncestr
            print(timeStamp)
            print(UInt32((timeStamp as NSString).intValue))
            request.timeStamp = UInt32((timeStamp as NSString).intValue)
            // 这里要注意key里的值一定要填对， 微信官方给的参数名是错误的，不是第二个字母大写
            let signParams = NSMutableDictionary()
            signParams.setObject(WXAppId, forKey: "appid")
            signParams.setObject(WXPartnerId, forKey: "partnerid")
            signParams.setObject(noncestr, forKey: "noncestr")
            signParams.setObject(timeStamp, forKey: "timestamp")
            signParams.setObject(prePayid as String, forKey: "prepayid")
            signParams.setObject(orderName, forKey: "body")
            signParams.setObject("Sign=WXPay", forKey: "package")
//            print("------")
//            print(WXAppId)
//            print(WXPartnerId)
//            print(noncestr)
//            print(timeStamp)
//            print(prePayid)
//            print(orderName)
//            print("----")
            
            
            
            
            //生成签名
            //            let sign = CommonUtil.genSign(signParams as [NSObject : AnyObject])
            let md5 = DataMD5.init()
            let sign1 = CommonUtil.genSign(signParams as [NSObject : AnyObject])
            //            genSign
            //            let sign1 = md5.createMd5Sign(signParams)
            //let sign1 = md5.createMD5SingForPay(WXAppId, partnerid:WXPartnerId , prepayid: request.prepayId, package: request.package, noncestr: noncestr, timestamp: request.timeStamp)
            //添加签名
            request.sign = sign1
            print(request)
            WXApi.sendReq(request)
        }else{
            
            print("获取prePayID失败")
        }
        
        
    }
    
    //微信支付回调方法
    func onResp(resp:BaseResp){
        
        if resp.isKindOfClass(PayResp) {
            let strTitle = "支付结果"
            let strMsg = resp.errCode as! String
            //            UIAlertView.init(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "OK", otherButtonTitles: nil)
            let alert = UIAlertView.init(title: strTitle, message: strMsg, delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorStyle = .None
        let cell = tableView.dequeueReusableCellWithIdentifier("paycell")as! PayMethodTableViewCell
        cell.selectionStyle = .None
        cell.selectButton.tag = indexPath.row
        cell.tag = indexPath.row
        cell.selectButton.addTarget(self, action: #selector(self.onClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        if indexPath.row == 0 {
            cell.title.text = "支付宝"
        }else if indexPath.row == 1{
            
            cell.title.text = "微信"
            cell.iconImage.image = UIImage(named: "ic_weixin")
            cell.desc.text = "推荐安装微信5.0及以上版本的使用"
            cell.bottomView.removeFromSuperview()
        }else{
            cell.title.text = "钱包"
            cell.iconImage.image = UIImage(named: "ic_qianbao")
            cell.desc.text = "如果余额足够可用钱包支付"
            cell.bottomView.removeFromSuperview()
        }
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = NSIndexPath.init(forRow: indexPath.row , inSection: 0)
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! PayMethodTableViewCell
        if selectArr.count == 0{
            cell.selectButton.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            selectArr.addObject(cell.selectButton)
            self.payMode = cell.title.text!
            print(selectArr)
        }else{
            for btn in selectArr {
                if btn as! NSObject == cell.selectButton  {
                    cell.selectButton.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                    selectArr.removeObject(cell.selectButton)
                    print(selectArr)
                }else{
                    
                    for btn in selectArr {
                        btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                        selectArr.removeObject(btn)
                    }
                    cell.selectButton.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                    selectArr.addObject(cell.selectButton)
                    self.payMode = cell.title.text!
                    print(selectArr)
                }
            }
        }
        
    }
    
    func agreePro(){
        
        let button = self.view.viewWithTag(15)as! UIButton
        if isAgree == false {
            
            button.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            isAgree = true
        }else{
            button.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
            isAgree = false
        }
        
    }
    
    func onClick(btn:UIButton){
        
        
        let indexPath = NSIndexPath.init(forRow: btn.tag , inSection: 0)
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! PayMethodTableViewCell
        if selectArr.count == 0{
            cell.selectButton.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            selectArr.addObject(cell.selectButton)
            self.payMode = cell.title.text!
            print(selectArr)
        }else{
            for btn in selectArr {
                if btn as! NSObject == cell.selectButton  {
                    cell.selectButton.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                    selectArr.removeObject(cell.selectButton)
                    print(selectArr)
                }else{
                    
                    for btn in selectArr {
                        btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                        selectArr.removeObject(btn)
                    }
                    cell.selectButton.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                    selectArr.addObject(cell.selectButton)
                    self.payMode = cell.title.text!
                    print(selectArr)
                }
            }
        }
        
    }
    
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 100
    //    }
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let headerView =  NSBundle.mainBundle().loadNibNamed("PayHeaderCell", owner: nil, options: nil).first as? PayHeaderCell
    //        view.backgroundColor = RGREY
    //        return headerView
    //
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
