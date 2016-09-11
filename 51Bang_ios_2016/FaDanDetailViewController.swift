//
//  FaDanDetailViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FaDanDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    let myTableView = UITableView()
    let mainHelper = MainHelper()
    var dataSource = NSMutableArray()
    var dataSource1 = fadanDetaiInfo()
    var info = TaskInfo()
    var helper = TCVMLogModel()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGREY
        self.title = "订单详情"
        self.getData()
       //TaskDetailTableViewCell2
        // Do any additional setup after loading the view.
    }
    
    func getData(){
    
        mainHelper.getFaDanDetail(info.id!) { (success, response) in
            print("----")
            print(response)
            print("----")
            let myinfo1:fadanDetaiInfo = response as! fadanDetaiInfo
            print(myinfo1)
            self.dataSource.addObject(myinfo1)
            self.dataSource1 = response as! fadanDetaiInfo

            self.createTableView()
        }

    }
    
    func createTableView(){
    
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "TaskDetailTableViewCell2",bundle: nil), forCellReuseIdentifier: "cell")
        
        let headerView = NSBundle.mainBundle().loadNibNamed("faDanDetailHeaderTableViewCell", owner: nil, options: nil).first as! faDanDetailHeaderTableViewCell
        
        let myInfo = self.dataSource[0] as! fadanDetaiInfo
        headerView.name.text = myInfo.apply?.name
//        let str = Bang_Image_Header+(myInfo.apply?.photo)!
//        headerView.iconImage.sd_setImageWithURL(NSURL(string:str), placeholderImage: UIImage(named: "1.png"))
        headerView.frame = CGRectMake(0, 0, WIDTH, 150)
        myTableView.tableHeaderView = headerView
        
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, 50))
        let button = UIButton.init(frame: CGRectMake(WIDTH-60, 0, 50, 30))
//        button.backgroundColor = UIColor.redColor()
        button.setTitle("取消", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.quxiao), forControlEvents: UIControlEvents.TouchUpInside)
//        button.setTitleColor(COLOR, forState: UIControlState.Normal)
        button.backgroundColor = COLOR
        view.addSubview(button)
        self.myTableView.tableFooterView = view
        self.view.addSubview(myTableView)
    
    }
    
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK:取消订单
    func quxiao(){
        let myInfo = self.dataSource[0] as! fadanDetaiInfo
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid") as! String
        helper.cancleOrder(userid, taskid: info.id!) { (success, response) in
        
            print(response)
            alert("取消成功", delegate: self)
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
    
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return (self.dataSource?.count)!
//        
//        
//    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TaskDetailTableViewCell2
        cell.selectionStyle = .None
//        let myInfo = self.dataSource[0] as! fadanDetaiInfo
        let myInfo = dataSource1
        if indexPath.row == 0 {
            cell.title.text = "任务号"
            cell.desc.text = myInfo.order_num
            
        }else if indexPath.row == 1{
        
            cell.title.text = "完成码"
            cell.desc.text = myInfo.order_num
        }else if indexPath.row == 2{
            
            cell.title.text = "任务"
            cell.desc.text = myInfo.title
        }else if indexPath.row == 3{
            
            cell.title.text = "服务费"
            cell.desc.text = myInfo.price
        }else if indexPath.row == 4{
            
            cell.title.text = "联系电话"
            cell.desc.text = myInfo.apply?.phone
            
        }else if indexPath.row == 5{
            
            cell.title.text = "上门地址"
            cell.desc.text = myInfo.address
        }else if indexPath.row == 6{
            
            cell.title.text = "服务地址"
            cell.desc.text = myInfo.address
        }else if indexPath.row == 7{
            
            cell.title.text = "上门时间"
            let time = timeStampToString(myInfo.time!)
            cell.desc.text = time
        }else{
            
            cell.title.text = "有效期"
            let time = timeStampToString(myInfo.time!)
            cell.desc.text = time
//            cell.desc.text = myInfo.order_num
        }
        return cell
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
