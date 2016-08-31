//
//  ConnectionViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var info = TaskInfo()
    var sign = Int()
    let myTableView = UITableView()
    var shangMenLocation = NSString()
    var fuWuLocation = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.backgroundColor = RGREY
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.registerNib(UINib(nibName: "MyOrderTableViewCell",bundle: nil), forCellReuseIdentifier: "MyOrderTableViewCell")
        let button4 = UIButton.init(frame: CGRectMake(10, HEIGHT-150, WIDTH/2-20, 50))
        button4.tag = 4
        button4.setTitle("联系对方", forState: UIControlState.Normal)
        button4.backgroundColor = UIColor.orangeColor()
        button4.addTarget(self, action: #selector(self.callPhone), forControlEvents: UIControlEvents.TouchUpInside)
        button4.layer.cornerRadius = 10
        let button5 = UIButton.init(frame: CGRectMake(WIDTH/2+10, HEIGHT-150, WIDTH/2-20, 50))
        if sign == 0 {
            button5.setTitle("完成服务", forState: UIControlState.Normal)
            button5.backgroundColor = COLOR
        }else if sign == 1{
        
            button5.setTitle("已上门", forState: UIControlState.Normal)
            button5.backgroundColor = COLOR
            button5.addTarget(self, action: #selector(self.button5Action), forControlEvents: UIControlEvents.TouchUpInside)
        }else{
        
            button5.setTitle("完成服务", forState: UIControlState.Normal)
            button5.enabled = false
            button5.backgroundColor = RGREY
            
        }
        
        button5.tag = 5
        button5.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button5.layer.cornerRadius = 10
        self.view.addSubview(myTableView)
        self.view.addSubview(button4)
        self.view.addSubview(button5)
        // Do any additional setup after loading the view.
    }
    
    func button5Action() {
        
        alert("已通知对方,请等待对方确认", delegate: self)
        
//        let vc = FaDanDetailViewController()
//        vc.info = self.info
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func callPhone() {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://"+self.info.phone! as String)!)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(self.info)
        tableView.separatorStyle = .None
        let cell = tableView.dequeueReusableCellWithIdentifier("MyOrderTableViewCell")as! MyOrderTableViewCell
        cell.shangmenMap.addTarget(self, action: #selector(self.nextView), forControlEvents: UIControlEvents.TouchUpInside)
        cell.fuwuMap.addTarget(self, action: #selector(self.nextView1), forControlEvents: UIControlEvents.TouchUpInside)
        self.shangMenLocation = cell.shangmen.text!
        cell.selectionStyle = .None
        cell.setValueWithInfo(info)
        return cell
    }

    func nextView(){
    
        let locationVc = LocationViewController()
        //        LocationViewController.myAddressOfpoint = self.dataSource![sender.tag].address!
        //        let latitudeStr1 = self.dataSource![sender.tag].latitude! as NSString
        //        let longitudeStr1 = self.dataSource![sender.tag].longitude! as NSString
        //        LocationViewController.pointOfSelected = CLLocationCoordinate2D.init(latitude: latitudeStr1.doubleValue, longitude: longitudeStr1.doubleValue)
        print(self.info.latitude)
        //        print(self.dataSource![sender.tag].longitude)
        locationVc.isWobangPush = true
        locationVc.addressPoint = self.info.address!
        if info.latitude == nil {
            locationVc.latitudeStr = ""
        }else{
            locationVc.latitudeStr = info.latitude!
        }
        if info.longitude == nil{
            locationVc.longitudeStr = ""
        }else{
            locationVc.longitudeStr = self.info.longitude!
        }
        
        
        self.navigationController?.pushViewController(locationVc, animated: true)

    }

    func nextView1(){
        let locationVc = LocationViewController()
        //        LocationViewController.myAddressOfpoint = self.dataSource![sender.tag].address!
        //        let latitudeStr1 = self.dataSource![sender.tag].latitude! as NSString
        //        let longitudeStr1 = self.dataSource![sender.tag].longitude! as NSString
        //        LocationViewController.pointOfSelected = CLLocationCoordinate2D.init(latitude: latitudeStr1.doubleValue, longitude: longitudeStr1.doubleValue)
        print(self.info.latitude)
        //        print(self.dataSource![sender.tag].longitude)
        locationVc.isWobangPush = true
        locationVc.addressPoint = self.info.saddress!
        if info.slatitude == nil {
            locationVc.latitudeStr = ""
        }else{
            locationVc.latitudeStr = info.slatitude!
        }
        if info.longitude == nil{
            locationVc.longitudeStr = ""
        }else{
            locationVc.longitudeStr = self.info.slongitude!
        }
        
        
        self.navigationController?.pushViewController(locationVc, animated: true)

    
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
