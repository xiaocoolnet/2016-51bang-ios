//
//  CollectionViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let helper = TCVMLogModel()
    let myTableView = UITableView()
    var dataSource : Array<CollectionInfo>?
    var tag = Int()
    override func viewWillAppear(animated: Bool) {
        self.title = "我的收藏"
        self.getData()
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        
   
    }
    
    func getData(){
       let ud = NSUserDefaults.standardUserDefaults()
       let uid = ud.objectForKey("userid")as!String
       helper.getCollectionList(uid) { (success, response) in
            print(response)
            self.dataSource = response as? Array<CollectionInfo> ?? []
             print(self.dataSource)
             print(self.dataSource!.count)
            self.createTableView()
        }
        
        self.myTableView.reloadData()
    
    }
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.registerNib(UINib(nibName: "CollectionTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        
        self.view.addSubview(myTableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.dataSource!.count)
        return self.dataSource!.count
    }
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let nextController = BusnissViewController()
        nextController.id = (dataSource![(dataSource?.count)! - indexPath.row - 1].object_id)! as String
        print(nextController.id)
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorStyle = .None
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!CollectionTableViewCell
        cell.targetView = self
        cell.selectionStyle = .None
        let info = self.dataSource![(dataSource?.count)! - indexPath.row - 1]
        cell.setValueWithInfo(info)
        cell.buy.addTarget(self,action: #selector(self.buttonaction), forControlEvents: UIControlEvents.TouchUpInside)
        tag = indexPath.row
        return cell
        
    }
    
    func buttonaction(){
        let nextController = BusnissViewController()
        nextController.id = (dataSource![(dataSource?.count)! - tag - 1].object_id)! as String
        print(nextController.id)
        self.navigationController?.pushViewController(nextController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
