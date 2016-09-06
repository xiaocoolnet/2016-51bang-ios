//
//  MyFaDan.swift
//  51Bang_ios_2016
//
//  Created by ios on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
class DanModel {
    var taskid:String = ""
    var taskName:String = ""
    var taskMan:String = ""
    var receive:String = ""
    var statuMoney:String = ""
    
}
class MyFaDan: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    //此处有bug
    var finshTable = UITableView()
    let weiBtn = UIButton()
    let finshBtn = UIButton()
    var cellData = TaskInfo()
    var Data = []
    var mTable = UITableView()
    let decorView = UIView()
    let rect  = UIApplication.sharedApplication().statusBarFrame
    
    let mainHelper = MainHelper()
    var dataSource : Array<TaskInfo>?
    var dataSource1 : Array<TaskInfo>?
    var info = TaskInfo()
    var xiaofeiview = XiaoFeiTableViewCell()
//    var dataSource2 : Array<TaskInfo>?
    var sign = Int()
    
    override func  viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let view = self.view.viewWithTag(48)
        view?.removeFromSuperview()
//        xiaofeiview = self.view.viewWithTag(23)
        xiaofeiview.removeFromSuperview()
        sign = 1
    }
    
    
    override func viewDidLoad() {
        
        GetWWCData("0,1,2,3")
        
        self.title = "我的发单"
        self.navigationController?.navigationBar.hidden = false
        decorView.frame = CGRectMake(0, 35, WIDTH / 2, 5)
        decorView.backgroundColor = COLOR
        self.view.addSubview(decorView)
//        cellData.taskName="充公交卡"
//        cellData.receive = "15589542081"
//        cellData.statuMoney = "10元"
//        cellData.taskid = "wyb123456"
//        cellData.taskMan = "15589542081"
        Data = [cellData,cellData,cellData,cellData,cellData]
//        mTable = UITableView.init(frame: CGRectMake(0, 40, WIDTH, self.view.frame.size.height - 45 - rect.height ), style: UITableViewStyle.Grouped)
       
//        self.view.addSubview(mTable)
//        mTable.delegate = self
//        mTable.dataSource = self
//        mTable.tag = 0
        
        setButton()
        self.view.backgroundColor = RGREY
        
    }
    
    
    func GetYWCData(state:NSString){
    
        
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        mainHelper.GetTaskList (userid,state: state,handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                print(response)
                
//                self.dataSource?.removeAll()
//                self.dataSource = response as? Array<TaskInfo> ?? []
//                self.Data = self.dataSource!
//                if state == "0"{
                    self.dataSource1?.removeAll()
                    self.dataSource1 = response as? Array<TaskInfo> ?? []
                if self.dataSource1?.count == 0{
                
                    alert("还没有已完成的任务", delegate: self)
                }
//                    self.Data = self.dataSource1!
                
                    self.createTableView()
                    print(self.dataSource1?.count)
              
//                }
            })
           })

    }
    
    func GetWWCData(state:NSString){
        
        let ud = NSUserDefaults.standardUserDefaults()
        let userid = ud.objectForKey("userid")as! String
        mainHelper.GetTaskList (userid,state: state,handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                print(response)
//                self.dataSource?.removeAll()
                self.dataSource = response as? Array<TaskInfo> ?? []
                self.Data = self.dataSource!
//                self.GetYWCData("4")
                self.createTableView()
                print(self.dataSource?.count)
                
            })
            
            })
    }

    func createTableView(){
        
        mTable = UITableView.init(frame: CGRectMake(0, 40, WIDTH, self.view.frame.size.height  - rect.height ), style: UITableViewStyle.Grouped)
        self.view.addSubview(mTable)
        mTable.delegate = self
        mTable.dataSource = self
        mTable.tag = 0
        mTable.registerNib(UINib(nibName: "YwcTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        finshTable =  UITableView.init(frame: CGRectMake(0,35, WIDTH, self.view.frame.size.height - 45 - rect.height), style: UITableViewStyle.Grouped)
        finshTable.hidden = true
        finshTable.delegate = self
        finshTable.dataSource = self
        finshTable.tag = 1
//        self.view.addSubview(finshTable)
        
        let HeaderView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 0.01))
        mTable.tableHeaderView = HeaderView
    
        //划动手势
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleRight))
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
    }
    func handleRight(){
        
       weiBtnAction()
    
    }
    
    func handleLeft(){
        
         finshBtnAction()
    }
    func setButton()
    {
        weiBtn.frame = CGRectMake(0, 0, WIDTH / 2, 35)
        finshBtn.frame  = CGRectMake(WIDTH / 2, 0, WIDTH / 2, 35)
        weiBtn.setTitle("未完成", forState: UIControlState.Normal)
        weiBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        finshBtn.setTitle("已完成", forState: UIControlState.Normal)
        
        finshBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        finshBtn.addTarget(self, action: #selector(self.finshBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        weiBtn.addTarget(self, action: #selector(self.weiBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        weiBtn.backgroundColor = UIColor.whiteColor()
        finshBtn.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(weiBtn)
        self.view.addSubview(finshBtn)
        
    }
    
    
    
    func finshBtnAction()
    {
        sign = 0
        GetYWCData("4")
        self.dataSource?.removeAll()
        
//        self.GetYWCData("4")
//        self.GetWWCData("0,1,2,3")
        weiBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        finshBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        decorView.frame = CGRectMake( WIDTH / 2, 35, WIDTH / 2, 5)
        mTable.reloadData()
//        mTable.hidden = true
//        finshTable.hidden = false
        
        
    }
    
    func weiBtnAction()
    {
        sign = 1
        self.dataSource1?.removeAll()
        self.GetWWCData("0,1,2,3")
        weiBtn.setTitleColor(COLOR, forState: UIControlState.Normal)
        finshBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        decorView.frame = CGRectMake( 0, 35, WIDTH / 2, 5)
        mTable.reloadData()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(sign == 1)
        {
            print(self.dataSource?.count)
            if self.dataSource == nil {
                return 0
            }else{
                return (self.dataSource?.count)!
            }
            
            
        }else{
            if self.dataSource1 == nil {
                return 0
            }else{
                return (self.dataSource1?.count)!
            }
            
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(sign == 1)
        {
           
            if dataSource?.count != 0{
                print(self.dataSource!)
                print(indexPath.section)
                print(self.dataSource![indexPath.section])
                let cell = MyFaDanCell.init(model: self.dataSource![indexPath.section])
                cell.payBtn.tag = indexPath.row
                //            let payBtn = cell.viewWithTag(10)as! UIButton
                cell.payBtn.addTarget(self, action: #selector(self.pay(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                 return cell
            }else{
                let cell = UITableViewCell()
                 return cell
            }
           
        }else{
            if dataSource1?.count != 0 {
                print(self.dataSource1)
                print(indexPath.section)
                print(self.dataSource1![indexPath.section])
                
                let cell = tableView.dequeueReusableCellWithIdentifier("cell")as! YwcTableViewCell
                cell.setValueWithInfo(self.dataSource1![indexPath.section])
                cell.selectionStyle = .None
                cell.pingjia.addTarget(self, action: #selector(self.goPingJia), forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            }else{
                let cell = UITableViewCell()
                return cell
            }
            
            
        }
        
        
    }
    
    func pay(btn:UIButton){
    
        self.info = self.dataSource![btn.tag]
        let view = UIView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        view.backgroundColor = UIColor.grayColor()
        view.alpha = 0.6
        view.tag = 48
        self.view.addSubview(view)
         xiaofeiview = NSBundle.mainBundle().loadNibNamed("XiaoFeiTableViewCell", owner: nil, options: nil).first as! XiaoFeiTableViewCell
        xiaofeiview.tag = 23
        xiaofeiview.frame = CGRectMake(WIDTH/2-125, HEIGHT/2-50, 250, 110)
        xiaofeiview.yes.tag = 45
        xiaofeiview.no.tag = 46
        xiaofeiview.textField.tag = 47
        xiaofeiview.textField.delegate = self
        xiaofeiview.yes.layer.cornerRadius = 5
        xiaofeiview.no.layer.cornerRadius = 5
        xiaofeiview.yes.addTarget(self, action: #selector(self.nextView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        xiaofeiview.no.addTarget(self, action: #selector(self.nextView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(xiaofeiview)
//        let view = NSBundle.mainBundle().loadNibNamed("XiaoFeiTableViewCell", owner: nil, options: nil).first as! XiaoFeiTableViewCell
    
    }
    
    // MARK: -UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 47 {
            UIView.animateWithDuration(0.4, animations: {
                self.xiaofeiview.frame = CGRectMake(WIDTH/2-125, HEIGHT/2-50-150, 250, 110)
            })
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 47 {
            UIView.animateWithDuration(0.4, animations: {
                self.xiaofeiview.frame = CGRectMake(WIDTH/2-125, HEIGHT/2-50, 250, 110)
            })
            
        }
        
    }
    
    func nextView(btn:UIButton){
        
        let vc = PayViewController()
        let textField = self.view.viewWithTag(47)as!UITextField
        if btn.tag == 46 {
            vc.xiaofei = "0"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if btn.tag == 45{
            if textField.text == ""{
                
                alert("请输入小费金额", delegate: self)
            }else{
                vc.xiaofei = textField.text!
                vc.price = Double(self.info.price!)!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let view = self.view.viewWithTag(48)
        view?.removeFromSuperview()
//        let xiaofeiview = self.view.viewWithTag(23)
        self.xiaofeiview.textField.resignFirstResponder()
        self.xiaofeiview.removeFromSuperview()
        self.xiaofeiview.hidden = true
    }
    
    
    func viewTap(sender: UITapGestureRecognizer) {
        
        let vc = PingJiaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goPingJia(){
    
        let vc = PingJiaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = FaDanDetailViewController()
        if sign == 1 {
           
            vc.info = self.dataSource![indexPath.section]
            
        }else{
        
            vc.info = self.dataSource1![indexPath.row]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
