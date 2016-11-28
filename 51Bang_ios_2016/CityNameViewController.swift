//
//  CityNameViewController.swift
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/9/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit



class CityNameViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var myinfo = NSDictionary()
    var mydataSource = NSMutableArray()
    var mydataSourcequ = NSMutableArray()
    let myTableView = UITableView()
    var mycityStr = String()
    var istwo = Bool()
    var isDingwei = Bool()
    var isNotDingwei = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
//        self.title = "选择城市"
        self.view.backgroundColor = UIColor.grayColor()
        if !self.istwo {
            for city in myinfo.allValues {
                for ciyt1 in city.allKeys {
                    let citynamee = ciyt1 as! String
                    let cityvalue = city as! NSDictionary
                    self.mydataSource.addObject(ciyt1)
                    self.mydataSourcequ.addObject(cityvalue.objectForKey(citynamee)!)
                }
            }
        }
        
        
        
        self.myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.view.addSubview(self.myTableView)
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mydataSource.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !self.istwo {
            let myVc = CityNameViewController()
            myVc.istwo = true
            myVc.isDingwei = true
            myVc.title = "县区选择"
            myVc.isNotDingwei = self.isNotDingwei
            myVc.mycityStr = self.mydataSource[indexPath.row] as! String
            myVc.mydataSource = self.mydataSourcequ[indexPath.row] as! NSMutableArray
            self.navigationController?.pushViewController(myVc, animated: true)
        }else{
//           let mainVC =  MainViewController()
//            print(self.mycityStr)
            if isDingwei && self.isNotDingwei{
                let cityStr = self.mycityStr+(self.mydataSource[indexPath.row] as! String)
//                let dic = ["name":cityStr];
                let dic = ["cityName":cityStr]
                
                NSNotificationCenter.defaultCenter().postNotificationName("changeCityStr", object: dic)
                let b = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-4]
//                let a = self.navigationController?.viewControllers[2]
                self.navigationController?.popToViewController(b!, animated: true)
            }else{
                let cityStr = self.mycityStr+(self.mydataSource[indexPath.row] as! String)
                let dic = ["name":cityStr,"quname":self.mydataSource[indexPath.row] as! String];
                //            发送通知
                NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: dic)
                let a = self.navigationController?.viewControllers[0]
                self.navigationController?.popToViewController(a!, animated: true)
 
            }
            
            
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
         var cell:TableViewCell? = table.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell;
        
        if(cell == nil){
            let nib:UINib = UINib(nibName: "TableViewCell", bundle: NSBundle.mainBundle());
            table.registerNib(nib, forCellReuseIdentifier: identifier);
            cell = table.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell;
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell!.setData(self.mydataSource[indexPath.row] as! String)
        return cell!
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
