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
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var sales: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueWithModel(goodsInfo:GoodsInfo){
        
        self.title.text = goodsInfo.goodsname
        self.context.text = goodsInfo.description
        //        self.distance.text = "现在没有"
        self.comment.text = "评论\(goodsInfo.commentlist.count)条"
        self.oldPrice.text = goodsInfo.oprice!
        self.price.text = "¥"+goodsInfo.price!
        self.sales.text = "已售"+goodsInfo.sellnumber!
        
        print(goodsInfo.goodsname)
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
