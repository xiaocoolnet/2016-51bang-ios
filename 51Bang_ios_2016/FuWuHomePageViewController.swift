//
//  FuWuHomePageViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/9.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FuWuHomePageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //    let myTableView = UITableView()
    var dataSource : Array<SkilllistModel>?
    var dataSource4 : Array<commentlistInfo>?
    var isUserid = Bool()
    var userid = String()
    let myTableView = UITableView()
    
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
        self.title = "认证帮详情"
        if info?.commentlist.count > 0  {
            self.dataSource4 = self.info!.commentlist
        }
        
        
        print(dataSource4?.count)
//        print(self.info!.commentlist)
        
        self.GetData()
        // Do any additional setup after loading the view.
    }
    
    
    func createTableView(){
        myTableView.frame = CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+10, WIDTH, HEIGHT-64-(headerView.frame.size.height+headerView.frame.origin.y+12))
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableFooterView = UIView()
        self.view.addSubview(myTableView)
//        myTableView.backgroundColor
    }
    
    func GetData(){
        
        
//        if self.isUserid {
//            print(self.userid)
        if userid == "" {
            userid = (info?.id)!
        }
            skillHelper.getAuthenticationInfoByUserId(self.userid, handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    alert("数据加载错误", delegate: self)
                    return
                }
                self.headerView =  NSBundle.mainBundle().loadNibNamed("FuWuHomePageTableViewCell", owner: nil, options: nil).first as! FuWuHomePageTableViewCell
                self.headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*200/375)
               
                self.headerView.setValueWithInfo(response as! RzbInfo)
                self.view.addSubview(self.headerView)
                self.dataSource = (response as! RzbInfo).skilllist
                if self.dataSource4 == nil{
                    self.dataSource4 = (response as! RzbInfo).commentlist
                }
                
                self.createView()
                })
            })
//        }else{
////            HEIGHT
//            
//            self.headerView =  NSBundle.mainBundle().loadNibNamed("FuWuHomePageTableViewCell", owner: nil, options: nil).first as! FuWuHomePageTableViewCell
//            self.headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*200/375)
//            
//            self.headerView.setValueWithInfo(info!)
//            self.view.addSubview(self.headerView)
//            self.dataSource = info?.skilllist
//
//            self.createView()
//  
//        }
        
            }
    
    func createView(){
        self.createTableView()
        let view2 = UIView .init(frame: CGRectMake(0, 0, WIDTH, HEIGHT-64-(headerView.frame.size.height+headerView.frame.origin.y+10)))
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
            btn.frame = CGRectMake(appviewx-CGFloat(loc-1)*4, appviewy, WIDTH*70/375, WIDTH*30/375)
            btn.layer.cornerRadius = WIDTH*10/375
            btn.layer.borderWidth = 1
            
            btn.layer.borderColor = UIColor.grayColor().CGColor
            let label = UILabel.init(frame: CGRectMake(appviewx-CGFloat(loc-1)*4, appviewy, WIDTH*70/375, WIDTH*30/375))
            //            label.backgroundColor = UIColor.redColor()
            label.text = self.dataSource![i].typename
            label.textAlignment = .Center
            label.layer.masksToBounds = true
            label.layer.borderColor = COLOR.CGColor
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 5
            label.textColor = COLOR
            //            view2.addSubview(btn)
            view2.addSubview(label)
            
            
        }
//        self.view.addSubview(view2)
        let height1 = (CGFloat((self.dataSource?.count)!+4)/5)*(WIDTH*35/375 + 6)
        view2.frame = CGRectMake(0, 0, WIDTH, height1)
        myTableView.tableHeaderView = view2
//        self.view.addSubview(view2)
    }
    //MARK--tableview
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }else{
            let str = dataSource4![indexPath.row-1].content
            let height = calculateHeight( str!, size: 15, width: WIDTH - 10 )
            return 75 + height + 20 + 40
        }
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource4!.count > 0 {
            return (self.dataSource4!.count)+1
        }
        return 0
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = UITableViewCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let view1 = UIView.init(frame: CGRectMake(0, 0, WIDTH, 10))
            view1.backgroundColor = RGREY
            view1.userInteractionEnabled = false
            cell.addSubview(view1)
            
            let labelcomment = UILabel.init(frame: CGRectMake(20, 15, 60, 38))
            labelcomment.text = "评价"
            labelcomment.userInteractionEnabled = true
            cell.addSubview(labelcomment)
            
            let view2 = UIView.init(frame: CGRectMake(0, 48, WIDTH, 2))
            view2.backgroundColor = RGREY
            view2.userInteractionEnabled = false
            cell.addSubview(view2)
            
            return cell
        }else{
            if self.dataSource4?.count>0 {
                let cell = ConveniceCell.init(myinfo: self.dataSource4![indexPath.row-1] )
                //                print(self.dataSource![indexPath.row-3].add_time)
                //                print(self.dataSource![indexPath.row-3].id)
                //                print(self.dataSource![indexPath.row-3].content)
                //                print(self.dataSource![indexPath.row-3].name)
                //                print(self.dataSource![indexPath.row-3].userid)
                //                print(self.dataSource![indexPath.row-3].photo)
                //                print(self.dataSource![indexPath.row-2].add_time)
                return cell
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.clearColor()
                return cell
            }
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    
}
