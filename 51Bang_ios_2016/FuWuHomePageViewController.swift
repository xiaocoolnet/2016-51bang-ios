//
//  FuWuHomePageViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/9.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FuWuHomePageViewController: UIViewController {
    
    //    let myTableView = UITableView()
    var dataSource : Array<SkilllistModel>?
    var isUserid = Bool()
    var userid = String()
    let skillHelper = RushHelper()
    var headerView = FuWuHomePageTableViewCell()
    let totalloc:Int = 5
    var info:RzbInfo? = nil
    var rzbDataSource = Array<RzbInfo>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        self.tabBarController?.tabBar.hidden = true
//        self.navigationController?.title = "服务主页"
        
        
        self.GetData()
        // Do any additional setup after loading the view.
    }
    
    func GetData(){
        
        
        if self.isUserid {
//            print(self.userid)
            skillHelper.getAuthenticationInfoByUserId(self.userid, handle: { (success, response) in
                if !success{
                    alert("数据加载错误", delegate: self)
                    return
                }
                self.headerView =  NSBundle.mainBundle().loadNibNamed("FuWuHomePageTableViewCell", owner: nil, options: nil).first as! FuWuHomePageTableViewCell
                self.headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*200/375)
                //http://bang.xiaocool.net/uploads/images/avatar_man.png
                self.headerView.setValueWithInfo(response as! RzbInfo)
                self.view.addSubview(self.headerView)
                self.dataSource = (response as! RzbInfo).skilllist
                self.createView()
            })
        }else{
//            HEIGHT
            
            self.headerView =  NSBundle.mainBundle().loadNibNamed("FuWuHomePageTableViewCell", owner: nil, options: nil).first as! FuWuHomePageTableViewCell
            self.headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*200/375)
            //http://bang.xiaocool.net/uploads/images/avatar_man.png
            self.headerView.setValueWithInfo(info!)
            self.view.addSubview(self.headerView)
            self.dataSource = info?.skilllist
//            print(dataSource?.count)
//            print(info?.skilllist[1].typename)
//            print(info?.skilllist[0].typename)
//            print(info?.skilllist[2].typename)
            self.createView()
  
        }
        
        //        print(info?.skilllist[1].parent_typeid)
//        
//        skillHelper.getSkillList({[unowned self] (success, response) in
//            dispatch_async(dispatch_get_main_queue(), {
//                if !success {
//                    return
//                }
//                print(response)
//                self.dataSource = response as? Array<SkillModel> ?? []
//                print(self.dataSource)
//                self.createView()
//            })
//            })
////        self.dataSource = info
    }
    
    func createView(){
        
        let view2 = UIView.init(frame: CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+10, WIDTH, 100))
        view2.backgroundColor = UIColor.whiteColor()
        let margin:CGFloat = (WIDTH-CGFloat(self.totalloc) * WIDTH*73/375)/(CGFloat(self.totalloc)+1);
        print(margin)
        for i in 0..<self.dataSource!.count{
            let row:Int = i / totalloc;//行号
            //1/3=0,2/3=0,3/3=1;
            let loc:Int = i % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+WIDTH/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+WIDTH*40/375) * CGFloat(row)
            let btn = UIButton()
            //            btn.backgroundColor = UIColor.redColor()
            btn.frame = CGRectMake(appviewx, appviewy, WIDTH*70/375, WIDTH*30/375)
            btn.layer.cornerRadius = WIDTH*10/375
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.grayColor().CGColor
            let label = UILabel.init(frame: CGRectMake(appviewx, appviewy, WIDTH*70/375, WIDTH*30/375))
            //            label.backgroundColor = UIColor.redColor()
            label.text = self.dataSource![i].typename
            label.textAlignment = .Center
            //            view2.addSubview(btn)
            view2.addSubview(label)
            self.view.addSubview(view2)
            
        }
        view2.frame.size.height = (CGFloat((self.dataSource?.count)!-1)/5+1)*WIDTH*35/375+(CGFloat((self.dataSource?.count)!-1)/5+2)*margin
        self.view.addSubview(view2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    
}
