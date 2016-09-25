//
//  SkillTableViewCell.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol cellDelegate{
    //代理方法
    func addTager(sender:UIButton,sectionNum:Int )
}


class SkillTableViewCell: UITableViewCell {

//    let line = UILabel()
//    let titLab = UILabel()
//    let num = UILabel()
//    let selectButton = UIButton()
    var num = Int()
    let totalloc:Int = 2
    var delegate : cellDelegate?
    var selectButton:UIButton?
    var sectionNum = Int()
    var selectButtonArr = NSMutableArray()
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectButtonArr = NSMutableArray()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }

    }
    
    func setCellWithClistInfo(clistInfos:NSArray,num:Int,tag:Int){
        sectionNum = tag
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        let margin:CGFloat = 0
//        print(num)
        let height = WIDTH*60/375
        for i in 0..<num {
            selectButton = UIButton()
            let row:Int = i / totalloc;//行号
            //1/3=0,2/3=0,3/3=1;
            let loc:Int = i % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+WIDTH/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+height) * CGFloat(row)
            let view = HittestfuncView.init(frame: CGRectMake(appviewx, appviewy, self.frame.size.width/CGFloat(self.totalloc), WIDTH*60/375), btn: selectButton!)
      
//            view.backgroundColor = UIColor.redColor()
            //view.frame = CGRectMake(appviewx, appviewy, self.frame.size.width/CGFloat(self.totalloc), WIDTH*60/375)
            let line = UILabel()
            let titLab = UILabel()
            
            let verticalLine = UILabel()
            line.frame = CGRectMake(0, 0, WIDTH, 1)
            line.backgroundColor = RGREY
            titLab.frame = CGRectMake(10, 10, WIDTH/3, 20)
            titLab.numberOfLines = 0
            titLab.font = UIFont.systemFontOfSize(14)
            let info = clistInfos[i] as! ClistInfo
            titLab.text = info.name
            let titleLabHeight = calculateHeight(info.name!,size: 14,width: WIDTH/3)
            titLab.frame.size.height = titleLabHeight
            //            titLab.backgroundColor = UIColor.greenColor()
            let one = UILabel(frame: CGRectMake(10, titLab.frame.size.height+titLab.frame.origin.y+5 , WIDTH/4+10, 10))
            one.font = UIFont.systemFontOfSize(12)
            one.numberOfLines = 0
//            one.backgroundColor = UIColor.redColor()
            //        one.textAlignment = .Center
            one.textColor = UIColor.grayColor()
            one.text = "描述"
            let oneHeight = calculateHeight("描述",size: 12,width:WIDTH/2-10)
            one.frame.size.height = oneHeight
            
            selectButton!.tag = tag
            selectButton!.frame = CGRectMake(WIDTH/2-40, one.frame.origin.y-20,40, 40 )/////////////////////////////////////////////////
            selectButton?.imageView?.userInteractionEnabled = true
            selectButton!.addTarget(self, action: #selector(self.selectedButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
//            selectButton!.backgroundColor = UIColor.brownColor()
            if i%self.totalloc == 0{
                verticalLine.frame = CGRectMake(selectButton!.frame.origin.x+30, 0, 1, view.frame.size.height)
                verticalLine.backgroundColor = RGREY
            }
            //selectButton.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Selected)
            selectButton!.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
            if !selectButtonArr.containsObject(selectButton!){
                self.selectButtonArr.addObject(selectButton!)
            }
            
//
            view.addSubview(line)
            view.addSubview(titLab)
            view.addSubview(one)
            view.addSubview(selectButton!)
            view.addSubview(verticalLine)
            //            view.backgroundColor = UIColor.blueColor()
            print(view.frame.size.height)
            
            print(view.frame.size.height)
//            if i%2 == 1 {
//                if titleLabHeight+one.frame.size.height+30>WIDTH*60/375{
//                    view.frame.size.height = titleLabHeight+one.frame.size.height+30
//                    height = view.frame.size.height
//                }else{
//                    height = WIDTH*60/375
//                }
//               
//            }else{
//                height = WIDTH*60/375
//            }
            
//            appviewy = margin+(margin+view.frame.size.height) * CGFloat(row)
            self.addSubview(view)

        }
        
    }
    
    func selectedButton(sender:UIButton){
        
         self.delegate!.addTager(sender,sectionNum: self.sectionNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
