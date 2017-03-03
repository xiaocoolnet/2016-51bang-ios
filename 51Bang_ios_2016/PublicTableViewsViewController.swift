//
//  PublicTableViewsViewController.swift
//  51Bang_ios_2016
//
//  Created by purepure on 17/2/28.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class PublicTableViewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    let myTableView = UITableView()
    var myArray = ["吃的","喝的","哈哈哈"]
    var nationArray = NSArray()
    var indexs = NSInteger()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "套餐类型"
        indexs = 0
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.separatorStyle = .None
        self.myTableView.registerNib(UINib(nibName: "PublicTableViewCell",bundle: nil), forCellReuseIdentifier: "PublicTableViewCell")
//        self.myTableView.editing = true
//        self.myTableView.allowsMultipleSelectionDuringEditing = true
        
        self.view.addSubview(myTableView)
        
        let backView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 60))
        backView.backgroundColor = LGBackColor
        let payButton = UIButton.init(frame: CGRectMake(40, 10, WIDTH-80, 40))
        payButton.backgroundColor = UIColor.orangeColor()
        payButton.layer.masksToBounds = true
        payButton.layer.cornerRadius = 10
        payButton.setTitle("去购买", forState: .Normal)
        payButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        payButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        payButton.addTarget(self, action: #selector(self.payButtonAction), forControlEvents: .TouchUpInside)
        backView.addSubview(payButton)
        self.myTableView.tableFooterView = backView
        // Do any additional setup after loading the view.
    }
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexs != indexPath.row{
            let oldindex = indexs
            indexs = indexPath.row
            self.myTableView.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: oldindex, inSection: 0),NSIndexPath.init(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    
    //MARK: ------TableViewDatasource
    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myArray.count
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style: .Default)
        if self.indexs == indexPath.row{
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        
        cell.textLabel?.text = self.myArray[indexPath.row]
            
        
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.selected = true
        cell.selectionStyle = .None
        return cell
    }
    
    
//    //MARK:-------tableViewEdit
//    //是否可以编辑  默认的时YES
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    //选择编辑的方式,按照选择的方式对表进行处理
//    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .None {
//            
//        }
//    }
//    //选择你要对表进行处理的方式  默认是删除方式
//    
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        
//        return .None
//    }
//    
//    //取消选中时 将存放在self.deleteArr中的数据移除
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
    func payButtonAction(){
        
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
