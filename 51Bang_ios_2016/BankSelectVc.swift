//
//  BankSelectVc.swift
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class BankSelectVc: UIViewController,UITableViewDelegate,UITableViewDataSource

    
    
{
    
    var BankTable:UITableView!
    let bankArray:[String] = ["中国工商银行","中国建设银行","中国农业银行","中国银行","交通银行","中国邮政储蓄","招商银行","中国民生银行","中国光大银行","中信银行","兴业银行","上海浦东发展银行","中国人民银行","华夏银行","深圳发展银行","广东发展银行","国家开发银行","中国进出口银行","中国农业发展银行","北京银行"]
    static var banName = ""
    override func viewWillAppear(animated: Bool) {
        
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTable()
    }
    
    func setTable()
    {
        BankTable = UITableView.init(frame: CGRectMake(0, 0, WIDTH, self.view.frame.size.height-64 ), style: UITableViewStyle.Grouped)
        BankTable.delegate = self
        BankTable.dataSource = self
        self.view.addSubview(BankTable)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = bankArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        BankSelectVc.banName = bankArray[indexPath.row]
        self.navigationController?.popViewControllerAnimated(true)
    }
}
