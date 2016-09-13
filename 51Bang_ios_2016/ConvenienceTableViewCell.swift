//
//  ConvenienceTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage

class ConvenienceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var mesage: UIButton!
    
    
    @IBOutlet weak var phone: UIButton!
    
    
    @IBOutlet weak var view: UIView!
    
    let totalloc = 3
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topView.backgroundColor = RGREY
        // Initialization code
        
    }
   
    func setValueWithInfo(info:TCHDInfo){
    
        self.desc.text = info.content
        self.time.text = info.create_time
        self.username.text = info.name
//        self.desc.text = info.title
        print(info.photo)
        if info.photo==nil {
            self.icon.image = UIImage(named:"ic_moren")
        }else{
            let photoUrl:String = Bang_Open_Header+"uploads/images/"+info.photo!
            print(photoUrl)
            //self.myimage.setImage("01"), forState: UIControlState.Normal)
            //        self.myimage.image =
            self.icon.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "ic_moren"))
        }
        
        if info.pic.count == 0 {
//            self.view.frame.size.height = 0
            self.view.removeFromSuperview()
            self.frame.size.height = 60
        }else{
            let viewWidth = self.view.frame.size.width
            let margin:CGFloat = (viewWidth-CGFloat(self.totalloc) * WIDTH*115/375)/(CGFloat(self.totalloc)+1);
            print(margin)
            for i in 0..<info.pic.count {
                let row:Int = i / totalloc;//行号
                //1/3=0,2/3=0,3/3=1;
                
                let loc:Int = i % totalloc;//列号
                let appviewx:CGFloat = margin+(margin+viewWidth/CGFloat(self.totalloc))*CGFloat(loc)
                let appviewy:CGFloat = margin+(margin+WIDTH*10/375) * CGFloat(row)
                let imageView = UIImageView()
                imageView.frame = CGRectMake(appviewx, appviewy, WIDTH*100/375, WIDTH*100/375)
//                imageView.backgroundColor = UIColor.redColor()
                let model = info.pic[i]
                let url = Bang_Image_Header+model.pictureurl!
                print(info.title)
                print(url)
                imageView.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "1.png"))
//                imageView.sd_setImageWithURL(NSURL(string: model.pictureurl)
                view.addSubview(imageView)
            }
//            self.view.frame.size.height = 500 //CGFloat(info.pic.count-1)/3*WIDTH*80/375+10
//            self.frame.size.height = 60+self.view.frame.size.height
        }
    
    }
    
    
       override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
