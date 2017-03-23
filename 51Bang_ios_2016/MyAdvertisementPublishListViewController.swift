//
//  MyAdvertisementPublishListViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/3/23.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class MyAdvertisementPublishListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var status = String()
    let mytableView = UITableView()
    var beginmid = "0"
    let mainHelper = MainHelper()
    var dataSource2 = NSMutableArray()
    var dataSource : Array<AdVlistInfo> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-43)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
//        self.mytableView.registerClass(MyAdvertisementPublishListTableViewCell.self, forCellReuseIdentifier: "MyAdvertisementPublishListTableViewCell")
        mytableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.beginmid = "0"
            self.headerRefresh()
            
        })
        mytableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            print("MJ:(上拉加载)")
            self.footerRefresh()
            
        })
        
        self.view.addSubview(self.mytableView)

        self.mytableView.mj_header.beginRefreshing()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func headerRefresh(){
        
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        
        mainHelper.getMyAdlist(self.status, beginid: "0",userid: userid) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.mytableView.mj_header.endRefreshing()
                    return
                }
                if self.beginmid=="0"{
                    self.dataSource = response as? Array<AdVlistInfo> ?? []
                    self.mytableView.mj_header.endRefreshing()
                    self.mytableView.mj_footer.endRefreshing()
                    self.mytableView.reloadData()
                }
                
                
            })
        }
        
    }
    
    func footerRefresh(){
        let ud = NSUserDefaults.standardUserDefaults()
        var userid = String()
        if ud.objectForKey("userid") != nil {
            userid = ud.objectForKey("userid") as! String
        }
        self.beginmid = (self.dataSource.last?.slide_id)!
        print(beginmid)
        mainHelper.getbbspostlist(self.status, beginid: beginmid,userid:userid ) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.mytableView.mj_footer.endRefreshing()
                    return
                }
                self.dataSource = self.dataSource + (response as? Array<AdVlistInfo> ?? [])
                self.mytableView.mj_footer.endRefreshing()
                if self.dataSource.count == 0{
                    self.mytableView.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
                
                self.mytableView.reloadData()
            })
        }
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 350
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataSource.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = MyAdvertisementPublishListTableViewCell.init(myinfo: self.dataSource[indexPath.row])
        cell.selectionStyle = .None
        if self.status=="1"{
            cell.payButton.hidden = true
        }else{
            cell.payButton.hidden = false
            cell.payButton.tag = indexPath.row
            cell.payButton.addTarget(self, action: #selector(self.payButtonAction(_:)), forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    func payButtonAction(sender:UIButton){
        
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
