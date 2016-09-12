//
//  RushViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class RushViewController: UIViewController,myDelegate ,UITableViewDelegate,UITableViewDataSource{

    var cityName = String()
    var longitude = String()
    var latitude = String()
    let mainHelper = MainHelper()
    var dataSource : Array<TaskInfo>?
    let myTableView = UITableView()
    let certifyImage = UIImageView()
    let certiBtn = UIButton()
    var kai = false
    var sign = Int()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        let function = BankUpLoad()
        function.CheckRenzheng()
        let ud = NSUserDefaults.standardUserDefaults()
        print(ud.objectForKey("ss"))
        if(ud.objectForKey("ss") != nil){
            
            
            
        if(ud.objectForKey("ss") as! String == "no")
            
        {
//            certiBtn.setTitle("已认证", forState: UIControlState.Normal)
//            certiBtn.userInteractionEnabled = false
//            certiBtn.hidden = true
//        certifyImage.hidden = true
//        self.GetData()
            }
        }
        self.tabBarController?.selectedIndex = 1
        if(ud.objectForKey("userid")==nil)
        {
            
            self.tabBarController?.selectedIndex = 3
            
            
        }
       
     
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.view = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sign = 0
        self.createRightItemWithTitle("任务(0)")
        self.createLeftItem()
        setBtnAndImage()
      //self.GetData()
        // Do any additional setup after loading the view.
    }
    
  
    
    func setBtnAndImage()
    {
        certifyImage.frame = CGRectMake(WIDTH / 2 - 100, HEIGHT / 2 - 150, 200,100)
        certifyImage.image =  UIImage.init(named: "未认证")
        self.view.addSubview(certifyImage)
        certiBtn.frame = CGRectMake(15, certifyImage.frame.origin.y + 150, WIDTH - 30, 50)
        certiBtn.layer.cornerRadius = 10
        certiBtn.layer.masksToBounds = true
        certiBtn.backgroundColor = COLOR
        certiBtn.addTarget(self, action: #selector(self.nowToCertification(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(certiBtn)
        certiBtn.setTitle("立即认证", forState: UIControlState.Normal)
        
    }
    func createLeftItem(){
        let button = UIButton.init(frame: CGRectMake(0, 10, 50, 92 * 50 / 174))
        button.setImage(UIImage(named: "ic_kai-3"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        button.selected = true
//        let mySwitch = UISwitch.init(frame: CGRectMake(0, 0, 30, 30))
        
//        mySwitch.onImage = UIImage(named: "ic_kai-1")
//        mySwitch.offImage = UIImage(named: "ic_guan-0")
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = item
    }
    //174/92
    func click(btn:UIButton){
    
        print(self.sign)
        if self.sign == 0 {
            btn.setImage(UIImage(named: "ic_guan-2"), forState: UIControlState.Normal)
            self.sign = 1
        }else{
            btn.setImage(UIImage(named: "ic_kai-3"), forState: UIControlState.Normal)
            self.sign = 0
        }
//        print(btn.selected)
//        if btn.selected == true {
//            btn.setImage(UIImage(named: "ic_guan-0"), forState: UIControlState.Selected)
//               btn.selected = false
//        }else{
//            btn.setImage(UIImage(named: "ic_kai-1"), forState: UIControlState.Normal)
//            btn.selected = true
//        }
        

    }
    
    
    func createRightItemWithTitle(title:String){
        let button = UIButton.init(type:.Custom)
        button.frame = CGRectMake(0, 0, 60, 40);
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.myTask), forControlEvents:UIControlEvents.TouchUpInside)
        let item:UIBarButtonItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = item
    }

    func myTask(){
    
        let vc = MyTaskViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    
    }

    
    

    func GetData(){
        
        print(loginSign)
        if loginSign == 0 {
            
            
            
        }else{
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            if ud.objectForKey("cityName") != nil {
                self.cityName = ud.objectForKey("cityName")as! String
            }
            if (ud.objectForKey("longitude") != nil) {
                self.longitude = ud.objectForKey("longitude")as! String
            }
            if (ud.objectForKey("latitude") != nil) {
                self.latitude = ud.objectForKey("latitude")as! String
            }
//            self.cityName = ud.objectForKey("cityName")as! String
//            self.longitude = ud.objectForKey("longitude")as! String
//            self.latitude = ud.objectForKey("latitude")as! String
            mainHelper.getTaskList (userid,cityName: self.cityName,longitude: self.longitude,latitude: self.latitude,handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if !success {
                        return
                    }
                    print(response)
                    self.dataSource?.removeAll()
                    print(self.dataSource?.count)
                    self.dataSource = response as? Array<TaskInfo> ?? []
                    print(self.dataSource)
                    print(self.dataSource?.count)
                    self.createTableView()
                    //                self.ClistdataSource = response as? ClistList ?? []
//                    self.myTableView.reloadData()
                    //self.configureUI()
                })
                
                })
        }
        
    }

    
//    @IBAction func startAndEnd(sender: UIButton) {
//        if kai == true {
//            sender.setImage(UIImage(named: "ic_kai-1"), forState: .Normal)
//            kai = false
//        }else{
//            sender.setImage(UIImage(named: "ic_guan-0"), forState: .Normal)
//            kai = true
//        }
//        
//    }
    func nowToCertification(sender: AnyObject) {
        
        if loginSign == 0 {//未登陆
            
            self.tabBarController?.selectedIndex = 3
            
        }else{//已登陆
            print("立即认证")
            let vc = CertificationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "身份认证"
        
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createView() {

//        myTableView.hidden = false
        
//        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)
//        myTableView.reloadData()
//        self.view.addSubview(myTableView)
//        self.createTableView()
//        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)
//        myTableView.backgroundColor = UIColor.redColor()

    }
    
    func createTableView(){
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height)

        myTableView.backgroundColor = RGREY
//        self.myTableView = UITableView.init(frame: CGRectMake(0, -38, WIDTH, self.view.frame.size.height), style: .Grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerNib(UINib(nibName: "OrderTableViewCell",bundle: nil), forCellReuseIdentifier: "order")
        //        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH/2, 120))
        let btn = UIButton(frame: CGRectMake(0, HEIGHT-110, WIDTH/2,50))
        btn.alpha = 0.7
        btn.setTitle("我的任务", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.grayColor()
        let label = UILabel()
        label.frame = CGRectMake(WIDTH/2, HEIGHT-109, 1, btn.frame.size.height-2)
        label.backgroundColor = UIColor.whiteColor()
        let btn2 = UIButton(frame: CGRectMake(WIDTH/2, HEIGHT-110, WIDTH/2,50))
        btn2.alpha = 0.7
        btn2.setTitle("刷新列表", forState: .Normal)
        btn2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn2.backgroundColor = UIColor.grayColor()
//        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
//        myTableView.hidden = false
        self.view.addSubview(myTableView)
        //        self.view.addSubview(btn)
        //        self.view.addSubview(btn2)
        //        self.view.addSubview(label)
        
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataSource?.count)!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("order") as! OrderTableViewCell
        cell.setValueWithInfo(self.dataSource![indexPath.row])
        
        cell.selectionStyle = .None
        cell.icon.layer.cornerRadius = cell.icon.frame.size.height/2
        cell.icon.clipsToBounds = true
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = TaskDetailViewController()
        let taskInfo = dataSource![indexPath.row]
        vc.taskInfo = taskInfo
        self.navigationController?.pushViewController(vc, animated: true)
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
