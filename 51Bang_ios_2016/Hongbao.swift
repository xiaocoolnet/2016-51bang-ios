//
//  Hongbao.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class Hongbao: UIViewController,TencentApiInterfaceDelegate {
    
    
    var bottom = UIView()
    var ShareButton = UIButton()
    var shareImage = UIImageView(image: UIImage(named: "57b017f4a9f26"))
//    var TipLabel    = UILabel()
    var bottom_title = UILabel()
    let titleArray = ["微信好友","朋友圈"]
    var btn1 = UIButton()
    var btn2 = UIButton()
    var btn3 = UIButton()
    var btn4 = UIButton()
    var btn5 = UIButton()
    var btn6 = UIButton()
    var cancelBtn = UIButton()
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setShareButton()
        self.title = "分享"
        self.view.backgroundColor = RGREY
        SetBottomView()
        bottom.hidden = true
        
    }
    
    func setShareButton()
    {
    
        ShareButton.frame = CGRectMake( WIDTH / 2 - 100, self.view.frame.size.height - 200, 200, 40)
        ShareButton.backgroundColor = COLOR
        ShareButton.setTitle("分享给好友", forState: UIControlState.Normal)
        ShareButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        ShareButton.addTarget(self, action: #selector(self.ShareAction), forControlEvents: UIControlEvents.TouchUpInside)
        ShareButton.layer.masksToBounds = true
        ShareButton.layer.cornerRadius = 10
        self.view.addSubview(ShareButton)
        
//        shareImage.frame = CGRectMake(WIDTH/2-100, self.view.frame.size.height/2-200, 200, 200)
//        self.view.addSubview(shareImage)
        let web = UIWebView()
        web.frame = CGRectMake(WIDTH/2-150, self.view.frame.size.height/2-250, 300, 300)
        web.backgroundColor = RGREY
        web.loadRequest(NSURLRequest(URL: NSURL(string: Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7")!))
        self.view.addSubview(web)

    }
    
    
    func ShareAction()
    {
    
        print("分享")
        UIView.animateWithDuration(0.4) { 
            self.bottom.hidden = false
        }
        
    }
    
    
    func SetBottomView()
    {
        bottom.frame = CGRectMake(0, self.view.frame.size.height - 250-250-50 , WIDTH , 500+50)
        bottom.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(bottom)
        
        bottom_title.frame = CGRectMake(0, 0, WIDTH, 35)
        bottom_title.text = "分享到"
        bottom.addSubview(bottom_title)
        bottom_title.textAlignment = NSTextAlignment.Center
        
        btn1.frame = CGRectMake(WIDTH / 5, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
        btn1.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn1.tag = 1
        btn1.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn1.layer.masksToBounds = true
        btn1.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn1)
        
        btn2.frame = CGRectMake(WIDTH / 5 * 3, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
        btn2.tag = 2
        btn2.setImage(UIImage.init(named: "ic_pengyouquan"), forState: UIControlState.Normal )
        btn2.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn2.layer.masksToBounds = true
        btn2.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn2)
        
        btn3.frame = CGRectMake(WIDTH / 5, bottom_title.frame.size.height+WIDTH / 5+50, WIDTH / 5, WIDTH / 5)
//        btn3.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn3.tag = 3
//        btn3.backgroundColor = UIColor.redColor()
//        btn3.setTitle(" 支付宝好友", forState: UIControlState.Normal)
//        btn3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn3.setImage(UIImage.init(named: "zhifubao"), forState: UIControlState.Normal )
        
        btn3.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn3.layer.masksToBounds = true
        btn3.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn3)
        let label = UILabel()
        label.text = "支付宝好友"
        label.textAlignment = NSTextAlignment.Center
        label.frame = CGRectMake(WIDTH / 5-15, btn3.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label)
        
        btn4.frame = CGRectMake(WIDTH / 5 * 3, bottom_title.frame.size.height+WIDTH / 5+50, WIDTH / 5, WIDTH / 5)
        //        btn3.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn4.tag = 4
//        btn4.backgroundColor = UIColor.redColor()
//        btn4.setTitle(" 支付宝生活圈", forState: UIControlState.Normal)
//        btn4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn4.setImage(UIImage.init(named: "ic_支付宝shenghuoquan"), forState: UIControlState.Normal )
        
        btn4.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn4.layer.masksToBounds = true
        btn4.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn4)
        let label4 = UILabel()
        label4.text = "支付宝生活圈"
        label4.textAlignment = NSTextAlignment.Center
        label4.frame = CGRectMake(WIDTH / 5*3-15, btn3.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label4)

//        
        
        btn5.frame = CGRectMake(WIDTH  / 5, bottom_title.frame.size.height+WIDTH / 5*2+50+50, WIDTH / 5, WIDTH / 5)
        btn5.tag = 5
        btn5.setImage(UIImage.init(named: "ic_QQ"), forState: UIControlState.Normal)
        btn5.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn5.layer.masksToBounds = true
        btn5.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn5)
        
        let label5 = UILabel()
        label5.text = "QQ好友"
        label5.textAlignment = NSTextAlignment.Center
        label5.frame = CGRectMake(WIDTH / 5-15, btn5.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label5)
        
        btn6.frame = CGRectMake(WIDTH / 5 * 3, bottom_title.frame.size.height+WIDTH / 5*2+50+50, WIDTH / 5, WIDTH / 5)
        //        btn3.setImage(UIImage.init(named: "ic_weixin-1"), forState: UIControlState.Normal)
        btn6.tag = 9
        //        btn4.backgroundColor = UIColor.redColor()
        //        btn4.setTitle(" 支付宝生活圈", forState: UIControlState.Normal)
        //        btn4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn6.setImage(UIImage.init(named: "ic_kongjianF"), forState: UIControlState.Normal )
        
        btn6.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn6.layer.masksToBounds = true
        btn6.layer.cornerRadius = WIDTH / 10
        bottom.addSubview(btn6)
        let label6 = UILabel()
        label6.text = "QQ空间"
        label6.textAlignment = NSTextAlignment.Center
        label6.frame = CGRectMake(WIDTH / 5*3-15, btn5.origin.y + WIDTH / 5 + 10, WIDTH / 5+30, 20)
        bottom.addSubview(label6)

        
        var count:CGFloat = 0
        for title in titleArray {
            
            let label = UILabel()
            label.text = title
            label.textAlignment = NSTextAlignment.Center
            label.frame = CGRectMake( (count+1) * WIDTH / 5, btn1.origin.y + WIDTH / 5 + 10, WIDTH / 5, 20)
            count += 2
            bottom.addSubview(label)
        }
        cancelBtn.tag = 6
        cancelBtn.frame = CGRectMake(WIDTH/2/2, btn1.origin.y + WIDTH / 5 + 30+100+100+20+50, WIDTH/2 , 250 - 35 - WIDTH / 5 - 95 )
        cancelBtn.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelBtn.backgroundColor = COLOR
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 10
        bottom.addSubview(cancelBtn)
    }
    
    
    func btnAction(btn:UIButton)
    {
        let img = UIImagePNGRepresentation(UIImage(named: "57b017f4a9f26")!)
        let newsObj = QQApiNewsObject(URL: NSURL(string: Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7"), title: "红包", description: "红包", previewImageData: img, targetContentType: QQApiURLTargetTypeNews)
        
        
        let req = SendMessageToQQReq(content: newsObj)
        switch btn.tag {
        case 1:
            print("微信")
            let sendReq = SendMessageToWXReq.init()
            sendReq.bText = false
            sendReq.scene = 0
            let urlMessage = WXMediaMessage.init()
            urlMessage.title = "红包"
            urlMessage.description = "红包"
            let webObj = WXWebpageObject.init()
            webObj.webpageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7"
            urlMessage.mediaObject = webObj
            sendReq.message = urlMessage
            WXApi.sendReq(sendReq)
            
        case 2:
            print("朋友圈")
            let sendReq = SendMessageToWXReq.init()
            sendReq.bText = false
            sendReq.scene = 1
            //sendReq.text = "测试，请忽略"
            let urlMessage = WXMediaMessage.init()
            urlMessage.title = "红包"
            urlMessage.description = "红包"
            let webObj = WXWebpageObject.init()
            webObj.webpageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7"
            urlMessage.mediaObject = webObj
            sendReq.message = urlMessage
            WXApi.sendReq(sendReq)

        case 3:
            //支付宝分享
            let message = APMediaMessage()
            let webObj = APShareWebObject()
//            let textObj = APShareTextObject()
            webObj.wepageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7";
            
            message.title = "红包";
            message.desc = "红包";
//            message.thumbUrl = "http://img.sucaifengbao.com/vector/logosjbz/31_309_bp.jpg";
            message.mediaObject = webObj
            
            
            
            let request = APSendMessageToAPReq()
            
            request.message = message
            
            request.scene = APSceneSession
            let result = APOpenAPI.sendReq(request)
            if !result {
                alert("分享失败", delegate: self)
            }
//
        case 4:
            //支付宝分享
            let message = APMediaMessage()
            let webObj = APShareWebObject()
            //            let textObj = APShareTextObject()
            webObj.wepageUrl = Bang_Open_Header+"index.php?g=portal&m=article&a=index&id=7";
            
            message.title = "红包";
            message.desc = "红包";
            //            message.thumbUrl = "http://img.sucaifengbao.com/vector/logosjbz/31_309_bp.jpg";
            message.mediaObject = webObj
            
            
            
            let request = APSendMessageToAPReq()
            
            request.message = message
            
            request.scene = APSceneTimeLine
            let result = APOpenAPI.sendReq(request)
            if !result {
                alert("分享失败", delegate: self)
            }
        case 5:
//            var newsObj = QQApiNewsObject()
            
            
            
            _ = QQApiInterface.sendReq(req)
            bottom.hidden = true
        case 6:
            bottom.hidden = true
        case 9:
            //            var newsObj = QQApiNewsObject()
            
            
            
            _ = QQApiInterface.SendReqToQZone(req)
            bottom.hidden = true
        default:
            print("微博")
        }
    }
    
}
