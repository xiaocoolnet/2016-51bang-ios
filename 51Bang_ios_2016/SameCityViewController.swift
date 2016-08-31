//
//  SameCityViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class SameCityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let myTableView = UITableView()
    var isShow = Bool()
    let coverView = UIView()
    let leftTableView = UITableView()
    let FMArr = ["百世汇通","韵达快递","中通快递","申通快递","天天快递","圆通快递","顺丰速运","全峰快递","宅急送","EMS"]
    let mainHelper = MainHelper()
    var dataSource : Array<TCHDInfo>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        isShow = false
        self.title = "便民信息"
        self.getData()
        
//        myTableView.registerNib(UINib(nibName: "ConvenienceHeaderViewCell",bundle: nil), forCellReuseIdentifier: "ConvenienceHeader")
        self.view.addSubview(myTableView)
        // Do any additional setup after loading the view.
    }
    
    func getData(){
    
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.labelText = "正在努力加载"
        mainHelper.GetTchdList("1",beginid: "0") { (success, response) in
            if !success {
                return
            }
            hud.hide(true)
            print(response)
            self.dataSource = response as? Array<TCHDInfo> ?? []
           
            print(self.dataSource?.count)
            print(self.dataSource)
            self.createTableView()
            //                self.ClistdataSource = response as? ClistList ?? []
            self.myTableView.reloadData()
        }
    
    }
    
    
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = RGREY
        myTableView.registerNib(UINib(nibName: "ConvenienceTableViewCell",bundle: nil), forCellReuseIdentifier: "Convenience")
        self.createRightNavi()
        
        let headerView = NSBundle.mainBundle().loadNibNamed("ConvenienceHeaderViewCell", owner: nil, options: nil).first as? ConvenienceHeaderViewCell
        //       headerView!.choose.addTarger()
        headerView!.choose.addTarget(self, action: #selector(self.choseFM), forControlEvents:UIControlEvents.TouchUpInside)
        headerView!.jiantou.addTarget(self, action: #selector(self.choseFM), forControlEvents: UIControlEvents.TouchUpInside)
        headerView!.query.backgroundColor = COLOR
        headerView?.query.addTarget(self, action: #selector(query(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerView?.tag = 5
        myTableView.tableHeaderView = headerView
    }
    
    func query(btn:UIButton){
    
        let vc = LogisticsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func createRightNavi(){
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 20, 20)
//        button.backgroundColor = UIColor.redColor()
        button.setImage(UIImage(named: "ic_fabu"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView:button)
        self.navigationItem.rightBarButtonItem = item
        
    }
    
    //MARK:跳转发布页
    func nextView(){
        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AddView")
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = FaBuBianMinViewController()
            self.navigationController?.pushViewController(vc, animated: true)
//            vc.title = "发布便民信息"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
    
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return CGFloat(tableView.frame.height/CGFloat(FMArr.count))
        }else{
            let array = self.dataSource![indexPath.row].pic 
            print(array.count)
//            if array.count==0 {
                let info = self.dataSource![indexPath.row]
                let height =  calculateHeight(info.content!, size: 15, width:WIDTH-20)
                print(100+height)
//                if 100+height>100{
//                
//                    return 100+height
//                }else{
//                
//                    return 90
//                }
//                
//            }else{
//            
//                return 220
//            }
            
            
            if( info.pic.count <= 3 )
            {
                return height + WIDTH*100/375
            }else if( info.pic.count > 3 && info.pic.count <= 6)
            {
                return 500
            }else{
                
                return height + WIDTH*100/375*3
                
            }

        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return FMArr.count
        }else{
           return self.dataSource!.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            tableView.separatorStyle = .None
            let cell = tableView.dequeueReusableCellWithIdentifier("leftTableView")
            
            cell?.textLabel?.text = FMArr[indexPath.row]
            cell?.selectionStyle = .None
            return cell!
        }else{
            tableView.separatorStyle = .None
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Convenience")as! ConvenienceTableViewCell
            cell.selectionStyle = .None
            cell.phone.addTarget(self, action: #selector(self.callPhone(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.phone.tag = indexPath.row
            cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
            cell.icon.clipsToBounds = true
            cell.setValueWithInfo(self.dataSource![indexPath.row])
            return cell
        }
        
    }
    
    
    func callPhone(btn:UIButton){
        
//        print(self.taskInfo.phone!)
        let info = self.dataSource![btn.tag]
        //        let phone = removeOptionWithString(self.taskInfo.phone!)
        //        print(phone)
//        UIApplication.sharedApplication().openURL(NSURL(string :"tel://"+"\(info.phone!)")!)
    
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if tableView.tag != 1 {
//            return 60
//        }else{
//        
//            return 0
//        }
//        
//    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if tableView.tag != 1 {
//            let headerView = NSBundle.mainBundle().loadNibNamed("ConvenienceHeaderViewCell", owner: nil, options: nil).first as? ConvenienceHeaderViewCell
//            //       headerView!.choose.addTarger()
//            headerView!.choose.addTarget(self, action: #selector(self.choseFM), forControlEvents:UIControlEvents.TouchUpInside)
//            headerView!.jiantou.addTarget(self, action: #selector(self.choseFM), forControlEvents: UIControlEvents.TouchUpInside)
//            headerView!.query.backgroundColor = COLOR
//            headerView?.tag = 5
//            return headerView
//        }else{
//        
//            return nil
//        }
//       
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 1 {
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow = false
            let view = self.view.viewWithTag(5)as? ConvenienceHeaderViewCell
//            let view = tableView.headerViewForSection(0) as! ConvenienceHeaderViewCell
            view!.choose.setTitle(FMArr[indexPath.row], forState: UIControlState.Normal)
        }
    }
    
    func choseFM(){
        
        if isShow == false {
            coverView.frame = CGRectMake(0, 60, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            leftTableView.frame = CGRectMake(0, 60, WIDTH/3, HEIGHT/2)
            leftTableView.tag = 1
            leftTableView.delegate = self
            leftTableView.dataSource = self
            leftTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "leftTableView")
            self.myTableView.addSubview(leftTableView)
            self.myTableView.addSubview(coverView)
            self.myTableView.bringSubviewToFront(leftTableView)
            isShow = true
        }else{
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            isShow = false
        }

    }
    
    
   
    
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
