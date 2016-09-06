//
//  MenuViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    var row = Int()
    let myTableView = UITableView()
    let  shopHelper = ShopHelper()
    var dataSource : Array<GoodsInfo>?
    var userid = String()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.getData()
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家发布"
        self.view.backgroundColor = RGREY
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func getData(){
        
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.animationType = .Zoom
            hud.labelText = "正在努力加载"
//            let ud = NSUserDefaults.standardUserDefaults()
//            let userid = ud.objectForKey("userid")as! String
            
            shopHelper.getMyFaBu(userid) { (success, response) in
                if !success {
                    return
                }
                hud.hide(true)
                print(response)
                self.dataSource = response as? Array<GoodsInfo> ?? []
                print(self.dataSource)
                print(self.dataSource?.count)
                
                self.createTableView()
            }
        }
        
    }
    
    func createTableView(){
        self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.backgroundColor = RGREY
        self.myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName: "MyFabuTableViewCell",bundle: nil), forCellReuseIdentifier: "MyFabuTableViewCell")
        self.view.addSubview(myTableView)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyFabuTableViewCell")as! MyFabuTableViewCell
//        cell.delete.tag = indexPath.row
//        cell.delete.addTarget(self, action:#selector(self.onClick(_:)) , forControlEvents: UIControlEvents.TouchUpInside)
//        cell.edit.tag = indexPath.row+100
//        cell.edit.addTarget(self, action:#selector(self.editAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.setValueWithInfo(self.dataSource![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsVC = BusnissViewController()
        detailsVC.isdetails = true
        detailsVC.id = self.dataSource![indexPath.row].id!
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func editAction(btn:UIButton){
        let addVC = AddViewController()
        addVC.isEdit = true
        addVC.myDatas = [self.dataSource![btn.tag-100]]
//        print(self.dataSource![btn.tag-100].address)
//        print(self.dataSource![btn.tag-100].goodsname)
//        print(self.dataSource![btn.tag-100].id)
        self.navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    
    func onClick(btn:UIButton){
        self.row = btn.tag
        if self.dataSource?.count == 0 {
            return
        }
        let info = self.dataSource![btn.tag]
        print(info.id)
        shopHelper.XiaJia(info.id!) { (success, response) in
            if !success {
                
                return
            }else{
                self.dataSource?.removeAtIndex(self.row)
                let myindexPaths = NSIndexPath.init(forRow: btn.tag, inSection: 0)
                self.myTableView.deleteRowsAtIndexPaths([myindexPaths], withRowAnimation: UITableViewRowAnimation.Right)
                self.myTableView.reloadData()
                //             self.dataSource = response as? Array<GoodsInfo> ?? []
                //            print(self.dataSource?.count)
                //            print(self.dataSource)
                //             self.myTableView.reloadData()
                alert("商品已下架", delegate: self)
            }
            
            
        }
        //        let alert = UIAlertView.init(title: "提示", message: "确定删除吗", delegate: self, cancelButtonTitle: "确定")
        //        let alert = UIAlertView.init(title: "提示", message: "确定删除吗", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        //        alert.tag = 100
        //        alert.show()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == 0 {
            //            self.removeCell()
        }else{
            self.cancle()
        }
    }
    
    func removeCell(){
        
        //        let indexPath = NSIndexPath.init(forRow: self.row, inSection: 0)
        //        let cell = myTableView.cellForRowAtIndexPath(indexPath)
        
        self.dataSource?.removeAtIndex(self.row)
        
        self.myTableView.reloadData()
        
    }
    
    func cancle(){
        
        let alert = self.view.viewWithTag(100)
        alert?.hidden = true
        
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
