//
//  OrderDetailViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBProgressHUD

class OrderDetailViewController: UIViewController,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createRightItem()
//        self.navigationController?.title = "订单详情"
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "OrderDetailTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName: "OrderRWTableViewCell",bundle: nil), forCellReuseIdentifier: "rwcell")
        myTableView.registerNib(UINib(nibName: "OrderDetailTableViewCell1",bundle: nil), forCellReuseIdentifier: "location")
        let headerView = NSBundle.mainBundle().loadNibNamed("OrderDetailHeaderTableViewCell", owner: nil, options: nil).first as? OrderDetailHeaderTableViewCell
        myTableView.tableHeaderView = headerView
        let footView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 60))
        let button = UIButton.init(frame: CGRectMake(WIDTH-60, 10, 50, 30))
        button.layer.cornerRadius = 5
        button.setTitle("取消", forState:UIControlState.Normal)
        button.addTarget(self, action: #selector(self.cancel), forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.borderColor = COLOR.CGColor
//        button.layer.borderColor = COLOR as! CGColor
        button.setTitleColor(COLOR, forState: UIControlState.Normal)
        button.layer.borderWidth = 1
        footView.addSubview(button)
        myTableView.tableFooterView = footView
        self.view.addSubview(myTableView)
        // Do any additional setup after loading the view.
    }
    func createRightItem(){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 20, 20);
        button.setTitle(title, forState: UIControlState.Normal)
        button.setImage(UIImage(named: "ic_weizhi-shou"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.location), forControlEvents:UIControlEvents.TouchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = item
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 3 {
            
            return 50
        }else{
            return 50
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! OrderDetailTableViewCell
        if indexPath.row == 0 {
            cell.title.text = "下单时间"
            cell.desc.text = "04-24 14:30"
            return cell
        }else if indexPath.row == 1{
        
            cell.title.text = "任务号"
            cell.desc.text = "HUGF23566234"
            return cell
        }else if indexPath.row == 2{
        
            cell.title.text = "完成码"
            cell.desc.text = "3627"
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("rwcell")as!OrderRWTableViewCell
            cell.backView.removeFromSuperview()
            return cell
        
        }else if indexPath.row == 4{
        
            cell.title.text = "服务费"
            cell.desc.text = "26.00"
            return cell
        
        }else if indexPath.row == 5{
        
            cell.title.text = "联系电话"
            cell.desc.text = "123456789"
            return cell
            
        }else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCellWithIdentifier("location")as! OrderDetailTableViewCell1
            cell.location.tag = 10
            cell.location.addTarget(self, action: #selector(self.location(_:)), forControlEvents: UIControlEvents.TouchUpInside)

            cell.title.text = "上门地点"
            let ud = NSUserDefaults.standardUserDefaults()
            if ud.objectForKey("shangMenLocation") != nil {
                cell.desc.text = ud.objectForKey("shangMenLocation")as?String
            }
            
            return cell
            
        }else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCellWithIdentifier("location")as! OrderDetailTableViewCell1
            cell.location.tag = 11
            cell.location.addTarget(self, action: #selector(self.location(_:)), forControlEvents: UIControlEvents.TouchUpInside)
             let ud = NSUserDefaults.standardUserDefaults()
            cell.title.text = "服务地点"
            if ud.objectForKey("FuWuLocation") != nil {
                cell.desc.text = ud.objectForKey("FuWuLocation")as?String
            }
            
            return cell
        }else if indexPath.row == 8{
        
            cell.title.text = "上门时间"
            cell.desc.text = "04-24 14:30"
            return cell
        }else{
            cell.title.text = "服务时间"
            cell.desc.text = "04-24 14:30"
            return cell
        }
        
    }

    func location(btn:UIButton){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var myadddress = String()
        if btn.tag == 10 {
            myadddress = ud.objectForKey("shangMenLocation")as!String
        }else if btn.tag == 11{
        
            myadddress = ud.objectForKey("FuWuLocation")as!String
        }
        
        let vc = LocationViewController()
        //vc.address = myadddress
        //        vc.longitude = Double(self.longitude)!
        //        vc.latitude = Double(self.latitude)!
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func cancel(){
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.5
        view.tag = 10
        let alertView = NSBundle.mainBundle().loadNibNamed("OrderDetailAlertTableViewCell", owner: nil, options: nil).first as? OrderDetailAlertTableViewCell
        
        alertView?.leave.addTarget(self, action: #selector(self.leave), forControlEvents: UIControlEvents.TouchUpInside)
        alertView?.wait.addTarget(self, action: #selector(self.wait), forControlEvents: UIControlEvents.TouchUpInside)
        alertView?.frame = CGRectMake(50, 150, 250, 120)
        alertView?.layer.cornerRadius = 10
        alertView?.tag = 11
        self.view.addSubview(view)
        self.view.addSubview(alertView!)
    }

    func leave(){
        let view = self.view.viewWithTag(10)
        let alertView = self.view.viewWithTag(11)
        view?.removeFromSuperview()
        alertView?.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func wait(){
        let view = self.view.viewWithTag(10)
        let alertView = self.view.viewWithTag(11)
        view?.removeFromSuperview()
        alertView?.removeFromSuperview()
    
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
