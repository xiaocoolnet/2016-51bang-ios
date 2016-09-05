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
    var idStr = String()
    var sign = Int()
    var data = Array<MyOrderInfo>?()
    var  zhifubaoprice = String()
    var  zhifubaosubject = String()
    var targets:UIViewController!
    let mainHelp = MainHelper()
    var id = String()
    var order_num = String()
    var DXFDataSource : Array<MyOrderInfo>?
    var tableView = UITableView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(Data:MyOrderInfo,sign:Int)
    {
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
        if self.sign == 0 {
            Statue.text = "待评价"
            Btn.setTitle("评价", forState: UIControlState.Normal)
            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
            
        }else if self.sign == 1{
            Statue.text = "待付款"
            Btn.setTitle("付款", forState: UIControlState.Normal)
//            Btn.addTarget(self, action: #selector(MyBookDanCell.Comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }else if self.sign == 2{
//            Btn.frame = CGRectMake(WIDTH - 50, tipLabel.frame.origin.y + 30, 55, 30)
            Statue.text = "待消费"
            Btn.setTitle("取消订单", forState: UIControlState.Normal)
//            Btn.addTarget(self, action: #selector(MyBookDanCell.Comment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }else{
            Statue.text = "待评价"
            Btn.setTitle("评价", forState: UIControlState.Normal)
            Btn.addTarget(self, action: #selector(self.Comment), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
//        }
        
        
        
        titleLabel.frame = CGRectMake(showImage.frame.origin.x + 105, 5, WIDTH - (showImage.frame.origin.x + 105) - Statue.frame.width - 10, 30)
        self.addSubview(titleLabel)
        titleLabel.text = Data.goodsname
        
        tipLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + 30, WIDTH - titleLabel.frame.origin.x , 30)
        
//        tipLabel.text = Data.
//        self.addSubview(tipLabel)
        
        
        Btn.frame = CGRectMake(WIDTH - 80, tipLabel.frame.origin.y + 30, 75, 30)
        self.addSubview(Btn)
        Btn.layer.cornerRadius = 10
        Btn.layer.masksToBounds = true
        Btn.layer.borderWidth = 1
        Btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        Btn.layer.borderColor = UIColor.orangeColor().CGColor
        Btn.titleLabel?.font = UIFont.systemFontOfSize(15)
//        Btn.adjustsFontSizeToFitWidth = true
        
        Price.frame = CGRectMake(titleLabel.frame.origin.x,  tipLabel.frame.origin.y + 30, 100, 30)
        Price.text = "￥" + Data.price!
        Price.textColor = UIColor.redColor()
        zhifubaoprice = Data.price!
        zhifubaosubject = Data.goodsname!
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
    
    func Comment()
    {
        print("评价")
        let orderCommentViewController = OrderCommentViewController()
        orderCommentViewController.idStr = self.idStr
        targets.navigationController?.pushViewController(orderCommentViewController, animated: true)
    }
    
    func pay()
    {
        print("付款")
        let vc = PayViewController()
        vc.price = ((zhifubaoprice) as NSString).doubleValue
        vc.subject = zhifubaosubject as NSString
        targets.navigationController?.pushViewController(vc, animated: true)

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
