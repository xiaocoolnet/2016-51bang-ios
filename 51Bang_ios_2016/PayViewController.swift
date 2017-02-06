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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.goOrderList), name:"goOrderList", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.goRenwuList), name:"goRenwuList", object: nil)
        
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
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 150))
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
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    func goRenwuList(){
        let bookVC = MyFaDan()
        self.navigationController?.pushViewController(bookVC, animated: true)
        
    }
    
    
    func xieyi(btn:UIButton){
        
        let vc = JiaoChengViewController()
        vc.sign = 3
        self.navigationController?.pushViewController(vc, animated: true)
        
        
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
            //            let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK4a3fO2l5Jn82ywtsBmWCKUDz/J0KKqmEXgu2VjO98dMjN7C+eO48kmhEe7JFpwVYZ9+tuO3TsSDonJ1DOsxVY/341/zYr8tV3SPjhChPTObAswUXznQ8qChIP8sCLdakw/YnlxnOvJneztmg++bIlMIGZUZy17rMKCgHTloJ7LAgMBAAECgYBv/RIlUJ7AaqL2l9iFe49Xdps0cbEE4OyfjgWcGq+JPTNsT8qBgLTeTyspJKQmlDk/EEvK7GM7OsslMDCRqKEpYGqgMJDZGYwanUc/gP4PNarsYY9J7yckRNMoUL2X8ROatiHLv2gHhaQ8zqQf0xG9/9uz+RG9KBiOhQzhEb7DmQJBAN40brXMEJdqqAxQ/de80M1vhgSu5nG+d/ztF2JHG/00DlUGu4AWypPL/6Xys5/GaWWCX3/XawZSHeias9NHdS0CQQDIlalKdsuFKSmrtH24hc/fYOp2VsWFUmMSDBzcizytT+zVKs1CBUbk5R7Pg/PS5iyeqYR6fbvs0HuArkD/f87XAkAQPLqeVEQeHHAdPkneWvDTIkQj0XgLdcSk2dpslw+niAdIFU7cRE4XUL/kq4COu1v2S/mYiPBMLPH8jll3pfAdAkAwhGLKbCmWL/qwWZv/Qf6h3WNY9Gwab28fMmbYwaUPlsGGXi//xB79xp3JO/WCEcLBLeepaThHc7YrzfpS0qtJAkEArxp4t06xxjWRKHpZdDFdtzpEdYg0sIDRhfepVCKxI496HRlrlo+7WipncI4Pm5fJIvm0IXbTlmlIVJx8EYKPPA=="
            
            //            let privateKey = "MIICXgIBAAKBgQC6z/0IcNsxiPOubH3XyvTAi7q5FSMegZuab4YFdPD9HgJhTUd1lwomyKIWTSRWuIg8LKvuJ0Yj+0JTJJaSocYfD4C6D83uYQ+bgeuD+GZiFeZ+9DyxGP2TPSYL5jIUFCiFmj+Y1KxfADeEpST4Rb2pRUufUHjhZyQav7+Ns1QOtQIDAQABAoGBAIVPDMLsPg7QKwxqUTcflp6cV6fh5IjNdmuzb9EPDTWjJ5Gl4vuPx+e7PqdpbygPUPCX9Czji9L7Zu4L6wNCPC0OvnQCkzelYKtmrb8+DJ39eGIjefZG/KGnvvDZOjU6zcsHVP/8HAUo23bG2ViymFdZ8D0VsygXqaz2uxzzS62VAkEA7ueVjL+eQcQYkUtwF5/B7v7mCdTijuZhaLpCVFW+PRdpjky+RCyMoWh6j07UK3d5DPyLi+TXg79F5zO4HTwUOwJBAMguJQ8mO5/htlgG/mTXT1nABz/PN2jXpOPZTSVk5vtQr1P1T1FQQz0A8+zQZr4lwAN0aM5TeBc48ugUs3yi6c8CQQCmJqPIpn+fB416hzenBnGvENHV5pvGfI0kc92rn5JWFJFR6SeubDlGDE6omk9PB6FFmeJHYdlNBFrOaBbVJjJ/AkEAkG4i1PRb7rZW7tpU8AMdQH85e8ORkfaNBMxDSiisM0V6ytPin6OOb9RhKksO5kCscpGqELvOmMrBD8vn2JRepwJAaTbiqbURGNgmGReO+sxMRBX3Gesdll9L158mHLUyPhZynLIhQYJfy4JsQj8jUc5xdZnonmvPz6oP6NSiuFwNwA=="
            
            let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM2arVc/DULOrVn5VVdkALDETOa1sznxviFaDD/+bZJI+3C7ls1HVZzKNCj7uwKKk02fRnLU70twRMifdhbIwEpqIFQLZW2HXbbif9+74BhetsQiQ/kyzRAhWEqeppNv/KTCtPM5d99S74diQuHHIH0cz4g7Xy9i/9RH8oS315bDAgMBAAECgYEAqpiO/3dXn3kxqRgS0aIuWH1oeX2GKqwE4FOBGpAXhmt8BfwAkm9//8pfISpN7zvgIWXo5Fr9+pA64mQ9bYZA1YDMLxcebn6uRqXZGoa0iZmx0n8/JpTw9L9A0Jt2HBJltrW5vsHqwOkjNL3sPxeeLOnNT9kVRSpp2gRFQuqZPoECQQDvYBpPUOeQ9KC1nouv3ngXOZg0Pw/vJbxaQWwqCAjN/l2m6sBjU6lP2dVB6QSVbD4V6rNABX63PW69uo8V5e1jAkEA2+ImfhcdSM1zS3QnKeyNd0HCKNvXXWXhjnAZ22pHI7tApIexsa/IlbQYNGbL14ZyRD6jq64P2FPwxt4hHUcfIQJAbSBdviz+9GlhXorh2ZJNIyFhjuf05qxIWskae2rgQLCmlzLL9DwuorWG8B4/tbL79tfhUd1vcC/0bVBAbNY+SwJACG2SrCKWrMOzN6EsHx9CDOAoYQiMKLhO/PavBwn70BLNV4Eb/oOOXK6afuexyIEOwC7mdx4k3VXaVMUO3+BqAQJAeMQtg/QEDZJb+frQLOlElYpsUS/J+bASiHHb6j0UTgUYfEtC34oJDd5lX1ZkiaQV5lnGUT8T0da+bzomkZ5xSA=="
            
            //let privateKey = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAL9MUaZqnb8XrhMxURZmhnhPN8JsgWURnAkOoqdiZZZl6IqXyhWqldFTCACDZt/j8gcfCt7PFTjshD13i+jm1VoRexEntVU1cn5qQ06lnCEOmBDQX1VEP1lzpYYqvbWiUtqzLxDloVpkgArlrzJB0mScwNE1AaChZ1i01ULH+uB1AgMBAAECgYAL15SiYa08PCIJjB8B7PzcC8Ne5Mqp0ApBwUcuZ3f0dICNu9HFv5agq6wuI/RFXd4ItNI+csFUkcep6nGdzFResIWzcyrSypHN8o8Cue2Yov5yjA7Fu4MEjTsy/hI9ch78GP+bfA4Ovx9Z+e1BWMMhgoNoBPoxgg1zld54sC5N7QJBAO7nVEOY+6q8n6tLTEmQHGjxJWpWyairYf40UV4n2aJrlJMCeuWXnKrsC5lUYvYljTpB+eEg2AQZ8ADKGzdfFCMCQQDM/N2V6V3vIRveJKqnPiXNBYlfAk/FLVxXW90yux6MVrI36y7aBGPbpXhO3TjMj1spZP/QbPaJTU4+a4mVFtaHAkEAjnwbrqFcYA1VsYUcP7eaqiBA73ZJmbZ1oHY1nVFpJMzC9RcCk1JkVzCnDlDdIO9ulrNoxBOhoniRwvbHWrPzPwJAbr2Iw+0f5wje8kKiwtkLONht3xrzl1UrFrK1LCv0k+JeQ2FVnUhT3hxlg0112uTzXciHfsTu5zwRMh2MZTPCTwJBAMXMksxezoK4wPEscWwEwzEJRB7bklVEMpcOf4QR90HQAFRH4bDffISI4RUc8I8FLMCGdDzkNFoI4LdwE9hGeZI="
            print(orderNum)
            let order = Order()
            order.appID = "2016083001821606"
            order.partner = partner;
            order.sellerID = seller;
            order.outTradeNO = orderNum ; //订单ID（由商家自行制定）
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
                //                AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic)->Void in
                //                    print("reslut = \(resultDic)");
                //                    if let Alipayjson = resultDic as? NSDictionary{
                //                        let resultStatus = Alipayjson.valueForKey("resultStatus") as! String
                //                        if resultStatus == "9000"{
                //                            print("OK")
                //                            let vc = OrderDetailViewController()
                //                            self.navigationController?.pushViewController(vc, animated: true)
                //                        }else if resultStatus == "8000" {
                //                            print("正在处理中")
                //                            self.navigationController?.popViewControllerAnimated(true)
                //                        }else if resultStatus == "4000" {
                //                            print("订单支付失败");
                //                            self.navigationController?.popViewControllerAnimated(true)
                //                        }else if resultStatus == "6001" {
                //                            print("用户中途取消")
                //                            self.navigationController?.popViewControllerAnimated(true)
                //                        }else if resultStatus == "6002" {
                //                            print("网络连接出错")
                //                            self.navigationController?.popViewControllerAnimated(true)
                //                        }
                //                    }
                //                })
                
                //                let dic = ["isRenwu":self.isRenwu,"numForGoodS":self.numForGoodS];
                //            发送通知
                //                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.payback(_:)), name:"payBack", object: nil)
                
                let user = NSUserDefaults.standardUserDefaults()
                if (isRenwu) {
                    user.setObject("renwuBook",forKey:"comeFromWechat")
                }else{
                    user.setObject("bookDan",forKey:"comeFromWechat")
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
                                hud.hide(true)
                                //                self.tabBarController?.selectedIndex = 3
                                let vc = MyBookDan()
                                self.navigationController?.pushViewController(vc, animated: true)
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
            weChatPay.testStart(String(Int(price*100)) ,orderName: body as String,numOfGoods:orderNum,isRenwu:self.isRenwu);
            //            aa.testStart("1" ,orderName: body as String,numOfGoods:self.numForGoodS);
            
            //            let vc = MyBookDan()
            //            self.navigationController?.pushViewController(vc, animated: true)
            
            //            //随机数
            //            let orderNO   = CommonUtil.genOutTradNo()
            //            //随机数串
            //            let noncestr  = CommonUtil.genNonceStr()
            //            //ip地址
            //            let addressIP = CommonUtil.getIPAddress(true)
            //            //回调地址
            //            let urlStr = "http://www.weixin.qq.com/wxpay/pay.php"
            //
            //            let genTimeStamp = CommonUtil.genTimeStamp() + "51bang"
            //
            //
            //
            //
            //
            //
            //            //声称签名
            //            let signParams = NSMutableDictionary()
            //            signParams.setObject(WXAppId as String, forKey: "appid")
            //            signParams.setObject(WXPartnerId as String, forKey: "mch_id")
            //            signParams.setObject(noncestr as String, forKey: "nonce_str")
            //            signParams.setObject(body as String, forKey: "body")
            //            signParams.setObject(subject as String, forKey: "detail")
            //            signParams.setObject(genTimeStamp as String, forKey: "attach")
            //            signParams.setObject(String(price), forKey: "total_fee")
            //            signParams.setObject(addressIP as String, forKey: "spbill_create_ip")
            //            signParams.setObject(urlStr as String, forKey: "notify_url")
            //            signParams.setObject("APP", forKey: "trade_type")
            ////            signParams.setObject(WXAPIKey as String, forKey: "key")
            //            var str1 = NSString()
            ////            let array = NSMutableArray()
            //            for key in signParams.allKeys {
            //
            //                str1 = str1 as String + String(key as! String) + "=" + String(signParams.valueForKey(key as! String)) + "&"
            //            }
            //            print(str1)
            //
            //
            //            let sign1 = CommonUtil.genSign(signParams as [NSObject : AnyObject])
            //
            ////            print(sign1)
            ////            let sign = CommonUtil.md5(sign1)
            //
            //            let xmlData = XMLHelper()
            //            let url = "https://api.mch.weixin.qq.com/pay/unifiedorder"
            //
            //
            //            let  aa = xmlData.genPackage(NSMutableDictionary(dictionary: signParams))
            //
            //            let data = xmlData.httpSend(url, method: "POST", data: aa)
            //            xmlData.startParse(data)
            //            let dict = xmlData.getDict()
            //            print(dict)
            //
            //            if dict != nil{
            //                let retcode = dict.objectForKey("retcode") as! NSString
            //
            //                if retcode.intValue == 0{
            //                    let stamp = dict.objectForKey("timestamp") as! NSString
            //
            //
            //                    //调起微信支付
            //                    let req = PayReq.init()
            //                    req.partnerId = dict.objectForKey("partnerid") as! String
            //                    req.prepayId = dict.objectForKey("prepayid") as! String
            //                    req.nonceStr = dict.objectForKey("noncestr") as! String
            //                    req.timeStamp = UInt32(stamp as String)!
            //                    req.package = dict.objectForKey("package") as! String
            //                    req.sign = dict.objectForKey("sign") as! String
            //
            //                    WXApi.sendReq(req)
            //                    //日志输出
            //
            //
            //                }else{
            //
            //                }
            //            }else{
            //
            //            }
            //
            //
            //            shopHelper.getWeixinDingdan(WXAppId, mch_id: WXPartnerId, device_info: "", nonce_str: orderNO, sign: sign1, body: body as String, detail:subject as String, attach: "", out_trade_no: genTimeStamp, fee_type: "", total_fee: price, spbill_create_ip: addressIP, time_start: "", time_expire: "", goods_tag: "", notify_url: urlStr, trade_type: "trade_type", limit_pay: "", handle: { (success, response) in
            //
            //
            //
            //            })
            //
            //
            //            let payred = PayReq.init()
            //            payred.partnerId = WXPartnerId as NSString as String
            //            payred.prepayId = "wx201608251458218270593b310274371597"
            //            payred.nonceStr = "0dabdecff46177f8e214fd1facdeb72d"
            //
            
            
            
            //            WXApi.registerApp:"wxd930ea5d5a258f4f" withDescription:"demo 2.0"
            //
            //
            //            self.getWeChatPayWithOrderName("我的订单", price: "1")
            //              self.payForWechat()
            //              let req = payRequsestHandler
            //              req.payForWechat()
        }else{
            alert("钱包支付", delegate: self)
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
            print("------")
            print(WXAppId)
            print(WXPartnerId)
            print(noncestr)
            print(timeStamp)
            print(prePayid)
            print(orderName)
            print("----")
            
            
            
            
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
