//
//  myAddressViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class myAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate{
    var row = Int()
    let textfile = UITextField()
    var button = UIButton()
    var userid = NSString()
    let myTableView = UITableView()
    let mainHelper = TCVMLogModel()
    var dataSource : Array<addressInfo>?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的地址"
        self.view.backgroundColor = RGREY
        let ud = NSUserDefaults.standardUserDefaults()
        self.userid = ud.objectForKey("userid")as!String
        
//        let backview = UIView()
//        backview.frame = CGRectMake(0, 50, WIDTH, 50)
//        backview.backgroundColor = UIColor.whiteColor()
//        backview.layer.masksToBounds = true
//        backview.layer.cornerRadius = 10
//        backview.layer.borderColor = COLOR.CGColor
//        backview.layer.borderWidth = 1
//        
//        self.textfile.frame = CGRectMake(20, 0, WIDTH-20, 50)
//        self.textfile.delegate = self
//        backview.addSubview(self.textfile)
        
//        self.view.addSubview(backview)
        
        button = UIButton.init(frame: CGRectMake(0, HEIGHT-118, WIDTH, 50))
        button.backgroundColor = COLOR
        button.setTitle("添加地址", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        let view = UIView()
        self.myTableView.tableFooterView = view
        self.view.addSubview(myTableView)
        self.view.addSubview(button)
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        
        // Do any additional setup after loading the view.
    }
    
    
//    func textFieldDidEndEditing(textField: UITextField){
//        if (self.textfile.text == nil) {
//            alert("请输入正确格式的卷码", delegate: self)
//        }
//        UIView.animateWithDuration(0.4) {
//            self.button.frame = CGRectMake(0, HEIGHT-118, WIDTH, 50)
//        }
//    }
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    func handleTap(sender: UITapGestureRecognizer) {
//        if sender.state == .Ended {
//            print("收回键盘")
//            self.textfile.resignFirstResponder()
//        }
//        sender.cancelsTouchesInView = false
//        UIView.animateWithDuration(0.4) {
//            self.button.frame = CGRectMake(0, HEIGHT-118, WIDTH, 50)
//        }
//    }
//    func textFieldDidBeginEditing(textField: UITextField){
//        UIView.animateWithDuration(0.4) { 
//            self.button.frame = CGRectMake(0, 240, WIDTH, 50)
//        }
//    }
//    

    
    
    func getData(){
    
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        mainHelper.getMyAddress(userid as String) { (success, response) in
            if  !success{
                let alert = UIAlertView.init(title:"提示", message: "数据加载异常或者您还没有地址", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            self.dataSource = response as? Array<addressInfo> ?? []
            print(self.dataSource?.count)
            if self.dataSource?.count == 0{
            
                alert("您还没有添加地址",delegate: self)
            }
            
        }
//        self.createTableView()
//        self.myTableView.reloadData()
    }

    
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "MyAddressTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        
        
        
    
    }
    
    func nextView(){
    
        let vc = AddAddressViewController()
        vc.userid = self.userid as String
        self.navigationController?.pushViewController(vc, animated: true)
    
    
    }
    //  self.dataSource1 = response as? Array<MyGetOrderInfo> ?? []
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
            return 80
      
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(self.dataSource!.count)
        if self.dataSource == nil {
            return 0
        }else{
            return self.dataSource!.count

        }
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.separatorStyle = .None
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")as! MyAddressTableViewCell
        cell.selectionStyle = .None
        cell.delete.tag = indexPath.row
        cell.delete.addTarget(self, action: #selector(self.delectAddress(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.setValueWithInfo(self.dataSource![indexPath.row])
        return cell
    }
    
    func delectAddress(btn:UIButton){
    
       self.row = btn.tag
        let alert = UIAlertView.init(title:"提示", message: "确定删除此地址吗？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        alert.tag = 100
        alert.show()
    
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        if alertView.tag == 100{
            if buttonIndex == 0 {
                self.removeCell()
            }else{
                self.cancle()
            }
        }
        
    }
    
    func removeCell(){
        
        //        let indexPath = NSIndexPath.init(forRow: self.row, inSection: 0)
        //        let cell = myTableView.cellForRowAtIndexPath(indexPath)
        //http://bang.xiaocool.net/index.php?g=apps&m=index&a=DeleteAddress&addressid=4&userid=127
        
        let info = self.dataSource![self.row] 
        mainHelper.deleteAddress(self.userid as String, addressid: info.id!) { (success, response) in
//            alert("删除成功",delegate: self)
            self.dataSource?.removeAtIndex(self.row)
            self.myTableView.reloadData()
        }
        
        
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
