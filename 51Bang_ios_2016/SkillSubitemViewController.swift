//
//  SkillSubitemViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol skillProrocol{
    //代理方法
    func sendMessage(arr:NSArray)
}

class SkillSubitemViewController: UIViewController {

    var mytitle: String?
    var info = Array<ClistInfo>()
    var index = Int()
    let totalloc:Int = 2
    var selectButton:UIButton?
    var selectButtonArr = NSMutableArray()
    var jinengID = NSMutableArray()
    let selectArr = NSMutableArray()
    let mySrcollView = UIScrollView()
    var isBangwo = Bool()
    
    
    var delegate : skillProrocol?
    let backview = UIView.init(frame: CGRectMake(0, 0, WIDTH, 64))
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mytitle
        self.view.backgroundColor = RGREY
        let count  = self.info.count
        
        self.mySrcollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        self.mySrcollView.backgroundColor = RGREY
        self.mySrcollView.contentSize = CGSizeMake(WIDTH, WIDTH*60/375*CGFloat((count/2)+1)+64)
        self.view.addSubview(mySrcollView)
        
        backview.backgroundColor = COLOR
        self.view.addSubview(backview)
        self.createView()
        let button = UIButton.init(frame: CGRectMake(WIDTH-80, 20, 80, 30))
        button.setTitle("提交", forState: UIControlState.Normal)
        
        button.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        backview.addSubview(button)
        setLeftBtn()
        // Do any additional setup after loading the view.
    }
    
    
    func setLeftBtn()
    {
        let button = UIButton.init(frame: CGRectMake(0, 20, 80, 30))
        button.setTitle("取消", forState: UIControlState.Normal)
        
        button.addTarget(self, action: #selector(self.leftButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        backview.addSubview(button)

    }
    
    
    func leftButtonAction()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func back(){
    
        let vc = CommitOrderViewController()
    
        vc.skillNum = self.selectArr.count
        self.delegate?.sendMessage(self.selectArr)
       
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func createView(){
        
        var lastFrame = CGRect()
        let margin:CGFloat = 0
        //        print(num)
        let height = WIDTH*60/375
        for i in 0..<info.count {
            
            let row:Int = i / totalloc;//行号
            //1/3=0,2/3=0,3/3=1;
            let loc:Int = i % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+WIDTH/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+height) * CGFloat(row)
            let view = UIView()
            //            view.backgroundColor = UIColor.redColor()
            view.frame = CGRectMake(appviewx, appviewy+64, self.view.frame.size.width/CGFloat(self.totalloc), WIDTH*60/375)
            view.backgroundColor = UIColor.whiteColor()
            lastFrame = view.frame
            let line = UILabel()
            let titLab = UILabel()
            selectButton = UIButton()
            selectButton?.tag = i
            let verticalLine = UILabel()
            let bottomline = UILabel()
            line.frame = CGRectMake(0, 0, WIDTH, 1)
            line.backgroundColor = RGREY
            titLab.frame = CGRectMake(10, 10, WIDTH/3, 20)
            titLab.numberOfLines = 0
            titLab.font = UIFont.systemFontOfSize(14)
            let ClistInfo = info[i]
            titLab.text = ClistInfo.name
//            let titleLabHeight = calculateHeight(ClistInfo.name!,size: 14,width: WIDTH/3)
//            titLab.frame.size.height = titleLabHeight
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
//            selectButton!.tag = tag
            selectButton!.frame = CGRectMake(WIDTH/2-40, one.frame.origin.y-20,40, 40)
            selectButton!.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //            selectButton!.backgroundColor = UIColor.brownColor()
            if i%self.totalloc == 0{
                verticalLine.frame = CGRectMake(selectButton!.frame.origin.x+30, 0, 1, view.frame.size.height)
                verticalLine.backgroundColor = RGREY
            }
                        //selectButton.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Selected)
            selectButton!.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
            self.selectButtonArr.addObject(selectButton!)
            //
            bottomline.frame =  CGRectMake(0, view.frame.size.height - 1,selectButton!.frame.origin.x+30, 1)
            bottomline.backgroundColor = RGREY
            view.addSubview(bottomline)
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
            self.mySrcollView.addSubview(view)
            for id in self.jinengID {
                if id as! String == info[i].id! {
                    selectButton!.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                    self.selectArr.addObject(selectButton!)
                }
            }

            
        }
        
        if(info.count % 2 != 0)
        {
            let fixView = UIView()
            fixView.frame = CGRectMake(lastFrame.size.width, lastFrame.origin.y, WIDTH - lastFrame.size.width, lastFrame.height)
            fixView.backgroundColor = UIColor.whiteColor()
            self.mySrcollView.addSubview(fixView)
        }

    
    
    }
    
    
    func click(btn:UIButton){
        print(btn.tag)
        
        
        
        if selectArr.count == 0{
            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            selectArr.addObject(btn)
            //            selectArr.addObject(btn)
            //            self.payMode = cell.title.text!
            print(selectArr)
        }else{
            print(selectArr.count)
            if !selectArr.containsObject(btn){
                if isBangwo {
                    (selectArr[0] as! UIButton ).setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                    selectArr.removeLastObject()
                }
                
                btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                selectArr.addObject(btn)
                //                    self.payMode = cell.title.text!
                print(selectArr)
            }else{
                btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                selectArr.removeObject(btn)
                print(selectArr)
            }
        }
      
    }

    
    
    
//    func selectedButton(sender:UIButton){
//        
//        self.delegate!.addTager(sender)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
