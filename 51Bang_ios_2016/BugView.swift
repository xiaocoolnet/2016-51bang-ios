//
//  BugView.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class BuyView: UIViewController {
    
    
    var TopView = UIView()
    var NumberLabel = UIView()
    var MiddleTable = UITableView()
    var bottomView = UIView()
    var ReceiveMan = UILabel()
    var phone = UILabel()
    var address = UILabel()
    var count = 0
    var addresslabel = UILabel()
    var showLable = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认订单"
        self.view.backgroundColor = RGREY
        setTopView()
    }
    
    func setTopView()
    {
        
        self.view.sd_addSubviews([TopView,NumberLabel,MiddleTable,bottomView])
        
        TopView.sd_addSubviews([ReceiveMan,phone,address])
        TopView.frame = CGRectMake(0, 0, WIDTH, 150)
        TopView.backgroundColor = UIColor.whiteColor()
        
        ReceiveMan.text = "    收货人：***"
        ReceiveMan.frame = CGRectMake(0, 0, WIDTH / 2, 35)
        
        phone.frame = CGRectMake(WIDTH / 2, 0, WIDTH / 2, 35)
        phone.text = "17847389495"
        
        let addressImage = UIImageView()
        addressImage.frame = CGRectMake(10, 35, 20, 20)
        addressImage.image = UIImage.init(named: "ic_wodeweizhi")
        TopView.addSubview(addressImage)
        
        addresslabel.text = "%%%%%%%%%%%%%%%%%%%%%"
        addresslabel.frame = CGRectMake(35, 35, WIDTH - 35, 20)
        TopView.addSubview(addresslabel)
        
        
        
        
        let tipLabel = UILabel()
        tipLabel.text = "数量"
        tipLabel.frame = CGRectMake(10, 0, 20, 20)
        let countMach = UIView()
        countMach.frame = CGRectMake(WIDTH - 100, 5, 95, 35)
        NumberLabel.addSubview(countMach)
        NumberLabel.addSubview(tipLabel)
        
    }
    
}
