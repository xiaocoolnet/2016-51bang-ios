//
//  MyBookDanCell.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class MyBookDanCell: UITableViewCell {
    let  showImage = UIImageView()
    let  titleLabel = UILabel()
    let  tipLabel = UILabel()
    let  Price = UILabel()
    let  Statue = UILabel()
    let  Btn = UIButton()
    let  Btn1 = UIBounceButton()//取消订单按钮
    let  headerImageBtn = UIButton()
    var idStr = String()
    var sign = Int()
    var data = Array<MyOrderInfo>?()
    var  zhifubaoprice = String()
    var  zhifubaosubject = String()
    var  zhifubaoNum = String()
    var targets:UIViewController!
    let mainHelp = MainHelper()
    var id = String()
    var order_num = String()
    var DXFDataSource : Array<MyOrderInfo>?
    var tableView = UITableView()
    var isSigle = Bool()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(Data:MyOrderInfo,sign:Int,isSigle:Bool)
    {
        self.isSigle = isSigle
        super.init(style: UITableViewCellStyle.Default
            , reuseIdentifier: "MyBookDanCell")
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.sign = sign
        
        setLayout(Data)
        self.idStr = Data.id!
        self.order_num = Data.order_num!
        
    }
    
    func setLayout(Data:MyOrderInfo)
    {
        
        showImage.frame = CGRectMake(5, 5, 100, 90)
//        headerImageBtn.frame = CGRectMake(5, 5, 100, 90)
//        headerImageBtn.backgroundColor = UIColor.redColor()
        
        if Data.pic.count>0 {
            let imageUrl = Bang_Image_Header+Data.pic[0].pictureurl!
            
            showImage.sd_setImageWithURL(NSURL(string:imageUrl), placeholderImage: UIImage(named: ("01")))
        }else{
            showImage.image = UIImage(named:("01"))
        }

//        showImage.image = Data.DshowImage
        
        self.addSubview(showImage)
        
        Statue.frame = CGRectMake(WIDTH - 50, 5, 45, 30)
        self.addSubview(Statue)
        Statue.adjustsFontSizeToFitWidth = true
        
//        if(Data.Dflag == 5)
//        {
//            Statue.textColor = UIColor.grayColor()
//            Statue.text = Data.DDistance + "Km"//重用此Cell让状态改为距离用于我收藏界面
//        
//        }else{
        Statue.textColor = COLOR
        if Data.state == "4" {
            
            
                Statue.text = "待评价"
                Btn.setTitle("未评价", forState: UIControlState.Normal)
                Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
                Btn.userInteractionEnabled = true
                Btn1.hidden = true
            
        }else if Data.state == "1"{
            Statue.text = "待付款"
            Btn.setTitle("待付款", forState: UIControlState.Normal)
            Btn1.setTitle("取消订单", forState: UIControlState.Normal)
//            Btn.addTarget(self, action: #selector(MyBookDanCell.Comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }else if Data.state == "2" && Data.delivery == "送货上门"{
//            Btn.frame = CGRectMake(WIDTH - 50, tipLabel.frame.origin.y + 30, 55, 30)
            Statue.text = "待发货"
            Btn.setTitle("已支付", forState: UIControlState.Normal)
            Btn1.setTitle("取消订单", forState: UIControlState.Normal)
//            Btn1.hidden = true
//            Btn.addTarget(self, action: #selector(MyBookDanCell.Comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }else if Data.state == "-1"{
            Statue.text = "已取消"
            Btn1.hidden = true
            Btn.setTitle("已取消", forState: UIControlState.Normal)
            Btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }else if Data.state == "10"{
            Statue.text = "已完成"
            Btn1.hidden = true
            Btn.setTitle("已完成", forState: UIControlState.Normal)
            Btn.setTitleColor(COLOR, forState: UIControlState.Normal)
        }else if (Data.state == "3" && Data.delivery != "送货上门") || (Data.state == "2" && Data.delivery != "送货上门"){
            //            Btn.frame = CGRectMake(WIDTH - 50, tipLabel.frame.origin.y + 30, 55, 30)
            Statue.text = "待消费"
            Btn1.setTitle("取消订单", forState: UIControlState.Normal)
            Btn.setTitle("已支付", forState: UIControlState.Normal)
//            Btn1.hidden = true
        }else if Data.state == "5"{
                Statue.text = "已评价"
                Btn.setTitle("已评价", forState: UIControlState.Normal)
                Btn.userInteractionEnabled = false
                Btn1.hidden = true
            

        
        }else if Data.state == "3" && Data.delivery == "送货上门"{
            Statue.text = "已发货"
            Btn.setTitle("已发货", forState: UIControlState.Normal)
            Btn1.setTitle("确认收货", forState: UIControlState.Normal)
            Btn.userInteractionEnabled = false
//            Btn1.hidden = true
            
            
            
        }
        if self.isSigle {
            Btn.enabled = false
        }
        
        
        titleLabel.frame = CGRectMake(showImage.frame.origin.x + 105, 5, WIDTH - (showImage.frame.origin.x + 105) - Statue.frame.width - 10, 30)
        self.addSubview(titleLabel)
        titleLabel.text = Data.goodsname
        
        tipLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + 30, WIDTH - titleLabel.frame.origin.x , 30)
        
//        tipLabel.text = Data.
//        self.addSubview(tipLabel)
        
        
        Btn.frame = CGRectMake(WIDTH - 70, tipLabel.frame.origin.y + 30, 65, 30)
        self.addSubview(Btn)
        Btn.layer.cornerRadius = 10
        Btn.layer.masksToBounds = true
        Btn.layer.borderWidth = 1
        Btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        Btn.layer.borderColor = UIColor.orangeColor().CGColor
        Btn.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        
        
        Btn1.frame = CGRectMake(WIDTH - 80 - 70, tipLabel.frame.origin.y + 30, 75, 30)
        self.addSubview(Btn1)
        Btn1.layer.cornerRadius = 10
        Btn1.layer.masksToBounds = true
        Btn1.layer.borderWidth = 1
        Btn1.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        Btn1.layer.borderColor = UIColor.orangeColor().CGColor
        Btn1.titleLabel?.font = UIFont.systemFontOfSize(15)
//        Btn.adjustsFontSizeToFitWidth = true
        
        Price.frame = CGRectMake(titleLabel.frame.origin.x,  tipLabel.frame.origin.y + 30, 100, 30)
        Price.text = "￥" + Data.price!
        Price.textColor = UIColor.redColor()
        zhifubaoprice = Data.price!
        zhifubaosubject = Data.goodsname!
        zhifubaoNum = Data.order_num!
        self.addSubview(Price)
        
        
        
//        switch Data.Dflag {
//        case 1:
//            Btn.setTitle("评价", forState: UIControlState.Normal)
//
//            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
//        case 2:
//            Btn.setTitle("付款", forState: UIControlState.Normal)
//            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
//        case 3:
//            Btn.hidden = true
//        case 4:
//            Btn.setTitle("取消订单", forState: UIControlState.Normal)
//            
//            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
//            let btnFrame = Btn.frame
//            Btn.frame = CGRectMake(btnFrame.origin.x - 20,btnFrame.origin.y, 70, 30)
//        case 5:
//            Btn.setTitle("立即购买", forState: UIControlState.Normal)
//            
//            Btn.addTarget(self, action: #selector(self.imdiaBuy), forControlEvents: UIControlEvents.TouchUpInside)
//            let btnFrame = Btn.frame
//            Btn.frame = CGRectMake(btnFrame.origin.x - 20,btnFrame.origin.y, 70, 30)
//            
//        default:
//            print("没有此button")
//            
//            
//            
//        }
//        headerImageBtn.addTarget(self, action: #selector(self.goGOGOGO), forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(headerImageBtn)
        
    }
//    
//    func onClick(btn:UIButton){
//        
//        self.row = btn.tag
//        if self.dataSource?.count == 0 {
//            return
//        }
//        let info = self.dataSource![btn.tag]
//        print(info.id)
//        shopHelper.XiaJia(info.id!) { (success, response) in
//            if !success {
//                
//                return
//            }else{
//                self.dataSource?.removeAtIndex(self.row)
//                let myindexPaths = NSIndexPath.init(forRow: btn.tag, inSection: 0)
//                self.myTableView.deleteRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Right)
//                self.myTableView.reloadData()
//                
//                alert("商品已下架", delegate: self)
//            }
//            
//            
//        }
//        
//        
//    }
//
    
    
    func goGOGOGO(){
        let next = BusnissViewController()
        next.id = idStr
        targets.navigationController?.pushViewController(next, animated: true)
    }
    
    func Comment()
    {
        print("评价")
        let orderCommentViewController = OrderCommentViewController()
        orderCommentViewController.idStr = self.idStr
        orderCommentViewController.order_num = order_num
        orderCommentViewController.usertype = "1"
        orderCommentViewController.types = "2"
        targets.navigationController?.pushViewController(orderCommentViewController, animated: true)
    }
    
    func pay()
    {
        print("付款")
        

    }
    
    func Cancel()
    {
//        print("取消订单")
//        let ud = NSUserDefaults.standardUserDefaults()
//        let userid = ud.objectForKey("userid")as! String
//        mainHelp.quXiaoDingdan(self.order_num, userid: userid) { (success, response) in
//            if !success {
//                print("..........")
//                print(self.order_num)
//                return
//            }else{
//                self.removeFromSuperview()
//
//                self.tableView.reloadData()
////                self.dataSource?.removeAtIndex(self.row)
////                let myindexPaths = NSIndexPath.init(forRow: btn.tag, inSection: 0)
////                self.myTableView.deleteRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Right)
////                self.myTableView.reloadData()
//
//
////                alert("取消订单", delegate: self)
//            }
//            
//            
//        }
//        
    }
    
    func imdiaBuy()
    {
        print("立即购买")
    }
    
}
