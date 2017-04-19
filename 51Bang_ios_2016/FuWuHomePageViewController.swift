//
//  FuWuHomePageViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/9.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FuWuHomePageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var ismainCome = Bool()
    
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
        //MARK:消除导航栏与self.view之间的黑色分割线
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController!.navigationBar.shadowImage=UIImage()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    
    
    func createTableView(){
//        myTableView.frame = CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+10, WIDTH, HEIGHT-64-(headerView.frame.size.height+headerView.frame.origin.y+12))
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableFooterView = UIView()
        self.view.addSubview(myTableView)
//        if self.ismainCome {
            myTableView.frame = CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+10, WIDTH, HEIGHT-64-(headerView.frame.size.height+headerView.frame.origin.y+12-40))
            
            let footBackView = UIView.init(frame: CGRectMake(0, HEIGHT-40-64, WIDTH, 40))
            footBackView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(footBackView)
            let gogoButton = UIButton.init(frame: CGRectMake(WIDTH-80, 0, 80, 40))
            gogoButton.backgroundColor = UIColor.orangeColor()
            gogoButton.setTitle("立即雇佣", forState: .Normal)
            gogoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            gogoButton.titleLabel?.font = UIFont.systemFontOfSize(14)
            gogoButton.addTarget(self, action: #selector(self.gogoButtonAction), forControlEvents: .TouchUpInside)
            footBackView.addSubview(gogoButton)
//        }
        
    }
    
    
    func gogoButtonAction(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("userid") != nil&&ud.objectForKey("userid") as! String != ""{
            if self.userid == ud.objectForKey("userid") as! String{
                alert("请不要雇用自己！", delegate: self)
                return
            }
        }
        if self.info != nil&&self.info?.isworking != nil{
            if self.info?.isworking == "0"{
                alert("该服务者正在休息状态！", delegate: self)
                return
            }
        }
        if self.info != nil&&self.info?.isworking != nil{
            if self.info?.insurancestatus != "1"{
                alert("该服务者保险认证中或未认证！", delegate: self)
                return
            }
        }
        if self.dataSource?.count == 0{
            alert("该服务者没有注册技能！", delegate: self)
            return
        }
        
        let vc = CommitOrderViewController()
        vc.skilllistDataSource = self.dataSource
        vc.employeeid = self.userid
        vc.iszhuanxiang = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GetData(){
        
        

        if userid == "" {
            if info?.id == nil{
                alert("数据错误", delegate: self)
                return
            }
            userid = (info?.id)!
        }
        skillHelper.getAuthenticationInfoByUserId(self.userid,longitude:"",latitude: "", handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                if !success{
                    alert("数据加载错误或此用户不是服务者", delegate: self)
                    self.navigationController?.popViewControllerAnimated(true)
                    return
                }
                self.headerView =  NSBundle.mainBundle().loadNibNamed("FuWuHomePageTableViewCell", owner: nil, options: nil).first as! FuWuHomePageTableViewCell
                    self.headerView.targets = self
                self.headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*200/375)
               
                self.headerView.setValueWithInfo(response as! RzbInfo)
                self.info = response as? RzbInfo
                self.view.addSubview(self.headerView)
                self.dataSource = (response as! RzbInfo).skilllist
                if self.dataSource4 == nil{
                    self.dataSource4 = (response as! RzbInfo).commentlist
                }
                
                self.createView()
                })
            })

        
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
            let btn = UIButton.init(frame: CGRectMake(appviewx-CGFloat(loc-1)*4, appviewy, WIDTH*70/375, WIDTH*30/375))
            //            label.backgroundColor = UIColor.redColor()
            btn.setTitle(self.dataSource![i].typename, forState: .Normal)
            //                btn.textAlignment = .Center
            btn.layer.masksToBounds = true
            btn.layer.borderColor = COLOR.CGColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.titleLabel?.font = UIFont.systemFontOfSize(12)
            btn.setTitleColor(COLOR, forState: .Normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(self.btnAction(_:)), forControlEvents: .TouchUpInside)            //            view2.addSubview(btn)
            view2.addSubview(btn)
            
            
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
                return cell
            }else{
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.clearColor()
                return cell
            }
            
        }
    }
    
    //MARK:Action
    func btnAction(sender:UIButton){
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.objectForKey("userid") != nil&&ud.objectForKey("userid") as! String != ""{
            if self.userid == ud.objectForKey("userid") as! String{
                alert("请不要雇用自己！", delegate: self)
                return
            }
        }
        if self.info != nil&&self.info?.isworking != nil{
            if self.info?.isworking == "0"{
                alert("该服务者正在休息状态！", delegate: self)
                return
            }
        }
        if self.info != nil&&self.info?.isworking != nil{
            if self.info?.insurancestatus != "1"{
                alert("该服务者保险认证中或未认证！", delegate: self)
                return
            }
        }
        if self.dataSource?.count == 0{
            alert("该服务者没有注册技能！", delegate: self)
            return
        }
        
        let vc = CommitOrderViewController()
        vc.skilllistDataSource = self.dataSource
        if self.dataSource![sender.tag].type != nil{
             vc.selectedTypeid = self.dataSource![sender.tag].type!
        }
       
        vc.employeeid = self.userid
        vc.iszhuanxiang = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    
}
