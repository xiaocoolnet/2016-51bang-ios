//
//  MyCollectonView.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MycollectionModel {
    
    var Title  = ""
    var catLog = ""
    var price  = ""
}

class MyCollectionView: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var mTableview = UITableView()
    let topView = UIView()
    var Source:[BookDanDataModel] = []
    let rect = UIApplication.sharedApplication().statusBarFrame
    override func viewDidLoad() {
        
        
        self.navigationController?.navigationBar.hidden = false
        self.view.backgroundColor = RGREY
        super.viewDidLoad()
        mTableview = UITableView.init(frame: CGRectMake(0, 0, WIDTH, self.view.frame.size.height - rect.height )
            , style: UITableViewStyle.Grouped)
        mTableview.delegate = self
        mTableview.dataSource  = self
        mTableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(mTableview)
        self.title = "我的收藏"
        topView.frame = CGRectMake(0, 0, WIDTH, 40)
        self.view.addSubview(topView)
    }
    
       
    
    
        
        
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MyCollectionViewCell.init()
        return cell

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeightForIndexPath(indexPath, cellContentViewWidth: UIScreen.mainScreen().bounds.size.width, tableView: tableView)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
