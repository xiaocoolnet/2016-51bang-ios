//
//  ShopTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage

class ShopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myimage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var context: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var sales: UILabel!
    
    @IBOutlet weak var goodnames: AutoScrollLabel!
    @IBOutlet weak var comment: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueWithModel(goodsInfo:GoodsInfo){
        title.hidden = true
        if goodsInfo.goodsname != nil {
            self.goodnames.text = goodsInfo.goodsname
        }else{
            self.goodnames.text = ""
        }
        
        if goodsInfo.description != nil {
            self.context.text = goodsInfo.description
        }else{
            self.context.text = ""
        }
        if goodsInfo.commentcount != nil{
            self.comment.text = "评价\(goodsInfo.commentcount! as String)条"
        }else{
            self.comment.text = "评价0条"
        }
        
        
        
        if goodsInfo.oprice != nil {
            self.title.text = goodsInfo.goodsname
        }else{
            self.title.text = ""
        }
        
        if goodsInfo.goodsname != nil {
            self.oldPrice.text = goodsInfo.oprice!
        }else{
            self.oldPrice.text = ""
        }
        
        if goodsInfo.price != nil {
            self.price.text = "¥"+goodsInfo.price!
        }else{
            self.price.text = "¥"
        }
        
        if goodsInfo.sellnumber != nil {
            self.sales.text = "已售"+goodsInfo.sellnumber!
        }else{
            self.sales.text = "已售"
        }
        
        if goodsInfo.username != nil {
           self.username.text = goodsInfo.username!
        }else{
            self.username.text = ""
        }
        
//        print(goodsInfo.goodsname)
        if goodsInfo.pic.count>0 {
            
            let imageUrl = Bang_Image_Header+goodsInfo.pic[0].pictureurl!
            
            myimage.sd_setImageWithURL(NSURL(string:imageUrl), placeholderImage: UIImage(named: ("01")))
        }else{
            myimage.image = UIImage(named:("01"))
        }
        
        
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
