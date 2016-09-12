//
//  CollectionTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var price: UILabel!
    
    
    @IBOutlet weak var buy: UIButton!
    
    
    @IBOutlet weak var distance: UILabel!
    let id = String()
    let userid = String()
    
    var targetView = UIViewController()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buy.layer.borderWidth = 1
        self.buy.layer.borderColor = UIColor.orangeColor().CGColor
        self.buy.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        self.buy.layer.cornerRadius = 5
        
//        buy.addTarget(self, action: #selector(self.buttonaction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        // Initialization code
    }

    func setValueWithInfo(info:CollectionInfo){
        self.title.text = info.title
        self.desc.text = info.description
        if info.price == nil{
            self.price.text = "0¥"
        }else{
            self.price.text = "\(info.price! as String)¥"
        }
        
//        self.distance.text = "1.4km"
        let ud = NSUserDefaults.standardUserDefaults()
        var longitude = String()
        if ud.objectForKey("longitude") != nil {
            longitude = ud.objectForKey("longitude")as! String
        }else{
            longitude = "0.0"
        }
        var latitude = String()
        if ud.objectForKey("latitude") != nil {
            latitude = ud.objectForKey("latitude")as! String
        }else{
            latitude = "0.0"
        }
//        let longitude = ud.objectForKey("longitude")as! String
//        let latitude = ud.objectForKey("latitude")as! String
        let myLongitude = removeOptionWithString(longitude)
        let myLatitude = removeOptionWithString(latitude)
        let current = CLLocation.init(latitude: CLLocationDegrees(myLongitude)!, longitude: CLLocationDegrees(myLatitude)!)
        
        if info.latitude != "0.0"&&info.latitude != "" && info.longitude != "0.0"&&info.longitude != ""  && info.latitude != nil&&info.longitude != nil{
            print(info.latitude! as String,info.longitude! as String,"00000000")
            
            let before = CLLocation.init(latitude: CLLocationDegrees(info.latitude! as String)!, longitude: CLLocationDegrees(info.longitude! as String)!)
            
            let meters = current.distanceFromLocation(before)/1000
            //                let meter:String = "\(meters)"
            //                let array = meter.componentsSeparatedByString(".")
            print(meters)
            if meters > 1000{
                distance.text = "1000+km"
            }else{
                let distance = String(format:"%.2f",meters)
                print(distance)
                self.distance.text = "\(distance)km"
                
            }
            
            }else{
               distance.text = ""
        }

        
        
        if info.pic.count>0 {
            let imageUrl = Bang_Image_Header+info.pic[0].pictureurl!
            
            iconImage.sd_setImageWithURL(NSURL(string:imageUrl), placeholderImage: UIImage(named: ("01")))
        }else{
            iconImage.image = UIImage(named:("01"))
        }

    
    
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func buttonaction( )
//    {
//        
//    }
    
}
