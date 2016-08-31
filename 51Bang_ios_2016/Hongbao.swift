//
//  Hongbao.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class Hongbao: UIViewController {
    
    
    var bottom = UIView()
    var ShareButton = UIButton()
    var shareImage = UIImageView(image: UIImage(named: "57b017f4a9f26"))
//    var TipLabel    = UILabel()
    var bottom_title = UILabel()
    let titleArray = ["微信好友","朋友圈"]
    var btn1 = UIButton()
    var btn2 = UIButton()
//    var btn3 = UIButton()
//    var btn4 = UIButton()
//    var btn5 = UIButton()
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
        
        shareImage.frame = CGRectMake(WIDTH/2-100, self.view.frame.size.height/2-200, 200, 200)
        self.view.addSubview(shareImage)
        
//        TipLabel.frame = CGRectMake( WIDTH / 2 - 100, self.view.frame.size.height - 400, 200, 40)
//        TipLabel.text = "分享邀请有红包"
//        TipLabel.textColor  = UIColor.grayColor()
//        TipLabel.textAlignment = NSTextAlignment.Center
//        self.view.addSubview(TipLabel)
    }
    
    
    func ShareAction()
    {
    
        print("分享")
        bottom.hidden = false
    }
    
    
    func SetBottomView()
    {
        bottom.frame = CGRectMake(0, self.view.frame.size.height - 250 , WIDTH , 250)
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
        
//        btn3.frame = CGRectMake(WIDTH * 2 / 5, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
//        btn3.tag = 3
//        btn3.setImage(UIImage.init(named: "ic_QQ"), forState: UIControlState.Normal)
//        btn3.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        btn3.layer.masksToBounds = true
//        btn3.layer.cornerRadius = WIDTH / 10
//        bottom.addSubview(btn3)
//        
//        
//        btn4.frame = CGRectMake(WIDTH * 3 / 5, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
//        btn4.tag = 4
//        btn4.setImage(UIImage.init(named: "ic_kongjian"), forState: UIControlState.Normal)
//        btn4.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        btn4.layer.masksToBounds = true
//        btn4.layer.cornerRadius = WIDTH / 10
//        bottom.addSubview(btn4)
//        
//        
//        btn5.frame = CGRectMake(WIDTH * 4 / 5, bottom_title.frame.size.height, WIDTH / 5, WIDTH / 5)
//        btn5.tag = 5
//        btn5.setImage(UIImage.init(named: "ic_weibo"), forState: UIControlState.Normal)
//        btn5.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        btn5.layer.masksToBounds = true
//        btn5.layer.cornerRadius = WIDTH / 10
//        bottom.addSubview(btn5)
        
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
        cancelBtn.frame = CGRectMake(0, btn1.origin.y + WIDTH / 5 + 30, WIDTH , 250 - 35 - WIDTH / 5 - 75 )
        cancelBtn.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        bottom.addSubview(cancelBtn)
    }
    
    
    func btnAction(btn:UIButton)
    {
        
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
            webObj.webpageUrl = "http://bang.xiaocool.net/index.php?g=portal&m=article&a=index&id=7"
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
            webObj.webpageUrl = "http://bang.xiaocool.net/index.php?g=portal&m=article&a=index&id=7"
            urlMessage.mediaObject = webObj
            sendReq.message = urlMessage
            WXApi.sendReq(sendReq)

        case 3:
            print("qq")
        case 4:
            print("空间")
        case 6:
            print("取消")
            bottom.hidden = true
        default:
            print("微博")
        }
    }
    
}
