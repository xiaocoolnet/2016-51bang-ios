//
//  FriendListViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let myTableView = UITableView()
    var isShow1 = Bool()
    var isShow2 = Bool()
    var isShow3 = Bool()
    let coverView = UIView()
    let leftTableView = UITableView()
    let middleTableView = UITableView()
    let rightTableView = UITableView()
    let skillHelper = RushHelper()
    let mainHelper = MainHelper()
    var dataSource : Array<SkillModel>?
    var tchdDataSource:Array<TCHDInfo>?
    var rzbDataSource : Array<RzbInfo>?
    let middleArr = ["服务最多","评分最多","离我最近"]
    let rightArr = ["在线","全部"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShow1 = false
        isShow2 = false
        isShow3 = false
        self.view.backgroundColor = RGREY
        self.GetData1()
        
        //        let view = UIView.init(frame: CGRectMake(0, 0, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>))
        self.view.backgroundColor = UIColor.whiteColor()
        self.GetData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func GetData1(){
        
        mainHelper.GetRzbList ({[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                self.rzbDataSource = response as? Array<RzbInfo> ?? []
                print(self.rzbDataSource)
                print(self.rzbDataSource!.count)
                self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-WIDTH*50/375-15)
                self.myTableView.delegate = self
                self.myTableView.dataSource = self
                self.myTableView.backgroundColor = RGREY
                self.myTableView.tag = 0
                self.myTableView.registerNib(UINib(nibName: "RenZhengBangTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
                self.view.addSubview(self.myTableView)
                
            })
            })
    }
    
    
    func GetData(){
        
        skillHelper.getSkillList({[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                print(response)
                self.dataSource = response as? Array<SkillModel> ?? []
                print(self.dataSource)
                let headerView =  NSBundle.mainBundle().loadNibNamed("RenZhengBangHeaderViewCell", owner: nil, options: nil).first as? RenZhengBangHeaderViewCell
                headerView?.frame = CGRectMake(0, 0, WIDTH, WIDTH*50/375)
                headerView?.tag = 5
                //                headerView?.label1.
                let gesture1 = UITapGestureRecognizer(target: self, action:#selector(self.onClick1))
                //附加识别器到视图
                headerView?.label1.addGestureRecognizer(gesture1)
                headerView?.label1.userInteractionEnabled = true
                let gesture2 = UITapGestureRecognizer(target: self, action:#selector(self.onClick2))
                //附加识别器到视图
                headerView?.label2.addGestureRecognizer(gesture2)
                headerView?.label2.userInteractionEnabled = true
                
                let gesture3 = UITapGestureRecognizer(target: self, action:#selector(self.onClick3))
                //附加识别器到视图
                headerView?.label3.addGestureRecognizer(gesture3)
                headerView?.label3.userInteractionEnabled = true
                headerView?.button1.addTarget(self, action: #selector(self.onClick1), forControlEvents: UIControlEvents.TouchUpInside)
                headerView?.button2.addTarget(self, action: #selector(self.onClick2), forControlEvents: .TouchUpInside)
                headerView?.button3.addTarget(self, action: #selector(self.onClick3), forControlEvents: .TouchUpInside)
                self.myTableView.tableHeaderView = headerView
                self.myTableView.reloadData()
                
            })
            })
    }
    
    func onClick1(){
        if isShow2 == true {
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
        }
        if isShow3 == true {
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
        }
        if isShow1 == false {
            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            leftTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH/3,HEIGHT-200)
            leftTableView.tag = 1
            leftTableView.delegate = self
            leftTableView.dataSource = self
            leftTableView.registerNib(UINib(nibName: "QuanBuFenLeiTableViewCell",bundle: nil), forCellReuseIdentifier: "QuanBuFenLei")
            leftTableView.backgroundColor = UIColor.whiteColor()
            
            self.view.addSubview(coverView)
            self.view.addSubview(leftTableView)
            isShow1 = true
        }else{
            
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
            
        }
        
    }
    
    func onClick2(){
        if isShow1 == true {
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
        }
        if isShow3 == true {
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
        }
        if isShow2 == false {
            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            middleTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,30*CGFloat(middleArr.count))
            middleTableView.tag = 2
            middleTableView.delegate = self
            middleTableView.dataSource = self
            middleTableView.registerNib(UINib(nibName: "FuWuTableViewCell",bundle: nil), forCellReuseIdentifier: "FuWu")
            middleTableView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(coverView)
            self.view.addSubview(middleTableView)
            isShow2 = true
        }else{
            
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
            
        }
        
    }
    func onClick3(){
        if isShow1 == true {
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
        }
        if isShow2 == true {
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
        }
        if isShow3 == false {
            coverView.frame = CGRectMake(0, WIDTH*50/375, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            rightTableView.frame = CGRectMake(0, WIDTH*50/375, WIDTH,30*CGFloat(rightArr.count))
            rightTableView.tag = 3
            rightTableView.delegate = self
            rightTableView.dataSource = self
            rightTableView.registerNib(UINib(nibName: "FuWuTableViewCell",bundle: nil), forCellReuseIdentifier: "FuWu")
            rightTableView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(coverView)
            self.view.addSubview(rightTableView)
            isShow3 = true
        }else{
            
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .None
        if tableView.tag == 0 {
            
            //tableView.separatorStyle = .None
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")as!RenZhengBangTableViewCell
            cell.selectionStyle = .None
            cell.weizhiButton.addTarget(self, action: #selector(self.dingWeiAction), forControlEvents: UIControlEvents.TouchUpInside)
            cell.setValueWithInfo(self.rzbDataSource![indexPath.row])
            return cell
            
        }else if tableView.tag == 1{
            
            var cell = tableView.dequeueReusableCellWithIdentifier("QuanBuFenLei")as? QuanBuFenLeiTableViewCell
            if cell==nil {
                cell = QuanBuFenLeiTableViewCell(style: UITableViewCellStyle.Default,reuseIdentifier: "QuanBuFenLei")
            }
            if indexPath.row == 0 {
                cell!.title.text =  "全部分类"
                //                cell!.title.textColor = UIColor.greenColor()
            }else{
                let model = self.dataSource![indexPath.row-1]
                cell!.title.text = model.name
            }
            return cell!
            
        }else if tableView.tag == 2{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FuWu")as! FuWuTableViewCell
            cell.title.text = middleArr[indexPath.row]
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FuWu")as! FuWuTableViewCell
            cell.title.text = rightArr[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.rzbDataSource!.count
        }else if tableView.tag == 1 {
            
            return self.dataSource!.count+1
        }else if tableView.tag == 2{
            
            return middleArr.count
        }else{
            
            return rightArr.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return 170
        }else{
            
            return 30
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.separatorStyle = .None
        if tableView.tag == 0 {
            let vc = FuWuHomePageViewController()
            vc.info = self.rzbDataSource![indexPath.row]
            //            vc.rzbDataSource = self.rzbDataSource!
            self.navigationController?.pushViewController(vc, animated: true)
        }else if tableView.tag == 1{
            
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow1 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            if indexPath.row == 0 {
                view?.label1.text = "全部分类"
            }else{
                view?.label1.text = self.dataSource![indexPath.row-1].name
            }
            
        }else if tableView.tag == 2{
            
            coverView.removeFromSuperview()
            middleTableView.removeFromSuperview()
            isShow2 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            view?.label2.text = middleArr[indexPath.row]
            
        }else{
            coverView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            isShow3 = false
            let view = self.view.viewWithTag(5)as? RenZhengBangHeaderViewCell
            view?.label3.text = rightArr[indexPath.row]
            
        }
    }
    
    func dingWeiAction()  {
        let vc = LocationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
}
