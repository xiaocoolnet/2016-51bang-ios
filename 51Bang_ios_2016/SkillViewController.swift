//
//  SkillViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
protocol myDelegate{
    //代理方法
    func createView()
}

class SkillViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,cellDelegate{
    
    var isxiugai = Bool()
    
//    @IBOutlet weak var myTableView: UITableView!
    var myTableView = UITableView()
    let skillHelper = RushHelper()
    var dataSource : Array<SkillModel>?
    var ClistdataSource = ClistList()
//    var array = NSMutableArray()
    var selectAllArray = NSMutableArray()
    var selectArr = NSMutableArray()
    var selectIDArr = NSMutableArray()//已经选中的技能ID
    
    var cellMarkArray:NSMutableArray?
    var cellMarkDic:NSMutableDictionary?
    var delegate:myDelegate?
    var cellArray:[SkillTableViewCell] = []
//    NSMutableDictionary *cellMarkDic;
//    NSMutableArray *cellMarkArray;
    var loadTag = 0
    var loadCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        cellMarkArray = NSMutableArray()
        self.GetData()
        
        let vc = RushViewController()
        self.delegate = vc
        
        // Do any additional setup after loading the view.
    }

  
    func GetData(){
        
        skillHelper.getSkillList({[unowned self] (success, response) in
//            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                print(response)
            if response != nil{
                if (response?.isKindOfClass(NSArray)) == true{
                    if (response as! NSArray).count>0{
                        if ((response as! NSArray)[0]).isKindOfClass(SkillModel){
                            self.dataSource = response as? Array<SkillModel> ?? []
                        }else{
                            alert("加载错误", delegate: self)
                        }
                        
                    }else{
                        alert("加载错误", delegate: self)
                    }
                    
                }else{
                    alert("加载错误", delegate: self)
                }
            }else{
                alert("加载错误", delegate: self)
            }
                print(self.dataSource)
                print(self.dataSource!.count)
                let num = self.dataSource!.count
                for _ in 0..<num {
//                    self.cellMarkDic = NSMutableDictionary()
                    self.selectArr = NSMutableArray()
                    self.cellMarkArray?.addObject(self.selectArr)
        //            cellMarkArray.addObject(cellMarkDic)
                    //            [cellMarkDic setObject:@"0" forKey:@"cellMark"];
                    //            [cellMarkArray addObject:cellMarkDic];
                }
                print(self.cellMarkArray)
                self.createTableView()
//                self.ClistdataSource = response as? ClistList ?? []
//                self.myTableView.reloadData()
                //self.configureUI()
            
        })

    }
    
    func createTableView(){
        myTableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, self.view.frame.size.height), style: .Grouped)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
       
        myTableView.registerClass(SkillTableViewCell.self, forCellReuseIdentifier: "OneCell")
        
        myTableView.registerNib(UINib(nibName: "OneTableViewCell",bundle: nil), forCellReuseIdentifier: "One")
        myTableView.registerNib(UINib(nibName: "TwoTableViewCell",bundle: nil), forCellReuseIdentifier: "Two")
        myTableView.registerNib(UINib(nibName: "ThreeTableViewCell",bundle: nil), forCellReuseIdentifier: "Three")
        myTableView.registerNib(UINib(nibName: "HousekeepingTableViewCell",bundle: nil), forCellReuseIdentifier: "House")
        myTableView.registerNib(UINib(nibName: "FoveTableViewCell",bundle: nil), forCellReuseIdentifier: "Fove")
        myTableView.registerNib(UINib(nibName: "PetTableViewCell",bundle: nil), forCellReuseIdentifier: "Pet")
        myTableView.registerNib(UINib(nibName: "SevenTableViewCell",bundle: nil), forCellReuseIdentifier: "Seven")
        myTableView.registerNib(UINib(nibName: "MarriageTableViewCell",bundle: nil), forCellReuseIdentifier: "Marriage")
        
        let bottom = UIView(frame: CGRectMake(0, 0, WIDTH, 120))
        let btn = UIButton(frame: CGRectMake(15, 30, WIDTH-30, 50))
        btn.layer.cornerRadius = 8
        btn.setTitle("确认提交", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = COLOR
        btn.addTarget(self, action: #selector(self.nextToView), forControlEvents: .TouchUpInside)
        bottom.addSubview(btn)
        myTableView.tableFooterView = bottom
        self.view.addSubview(myTableView)
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.ClistdataSource.objectlist[section].name
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRectMake(0, 0, WIDTH, 40)
        view.backgroundColor = UIColor.whiteColor()
        //let imageView = UIImageView()
        //imageView.frame = CGRectMake(10, 5, 30, 20)
//        imageView.backgroundColor = UIColor.redColor()
        let titleLabel = UILabel()
        titleLabel.frame = CGRectMake(10, 5, 60, 20)
        let skillModel = self.dataSource![section]
        titleLabel.text = skillModel.name
//        selectButton.frame = CGRectMake(WIDTH/2-30, one.frame.origin.y-20,20, 20)
        let mySelectButton = UIButton.init(frame: CGRectMake(WIDTH-30, 5, 20, 20))
        mySelectButton.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
        mySelectButton.addTarget(self, action: #selector(self.selectAllButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        mySelectButton.tag = section
//        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(mySelectButton)
//        view.backgroundColor = UIColor.greenColor()
//        myTableView.tableHeaderView = view
        return view
        
    }
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.headerViewForSection(3)?.backgroundColor = UIColor.redColor()
        return 40
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource!.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let skillModel = self.dataSource![indexPath.section]
        let num = skillModel.clist.count
        if num==0 {
            return 0
        }else{
            return  CGFloat((num-1)/2+1) * WIDTH*60/375
        }

    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("OneCell")as!SkillTableViewCell
        let cell = SkillTableViewCell()
//        cell = tableView.cellForRowAtIndexPath(indexPath) as! SkillTableViewCell
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
       
        let skillModel = self.dataSource![indexPath.section]
        let num1 = skillModel.clist.count
        cell.setCellWithClistInfo(skillModel.clist,num: num1,tag:indexPath.section)
        cell.delegate = self
        cell.selectionStyle = .None
        
        if(loadCount < dataSource?.count && loadTag == 0 )
        {
        
        cellArray.append(cell)
        loadCount += 1
            
        
        }else{
        
        loadTag = 1
        
        
        }
        
        return cellArray[indexPath.section]
        
    /*var cell = tableView.dequeueReusableCellWithIdentifier("OneCell")as? SkillTableViewCell
//        SkillTableViewCell()
        if cell==nil {
            cell = SkillTableViewCell(style: UITableViewCellStyle.Default,reuseIdentifier: "OneCell")
        }
            cell!.delegate = self
            print(self.ClistdataSource.objectlist.count)
            let skillModel = self.dataSource![indexPath.section]
            
            let num1 = skillModel.clist.count
            print(skillModel.clist.count)
            cell!.setCellWithClistInfo(skillModel.clist,num: num1,tag:indexPath.section)
            cell!.selectionStyle = .None
        print(selectArr)
        for btn in selectArr {
            
            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            
        }
        let array = self.cellMarkArray![indexPath.section]
        print(indexPath.section)
        print(array)
        cellArray.append(cell!)
//        print("---")
//        print(cell?.selectButtonArr)
//        print("---")
//        for i in 0..<array.count {
//            let index = array[i]as! Int
//            print(cell!.selectButtonArr[index])
//            cell!.selectButtonArr[index].setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
//        }
//        myTableView.reloadData()
        //for i in 0..<num1 {
//            let button  = cell!.viewWithTag(i+10)as! UIButton
//            print(selectArr)
//            if selectArr.containsObject(button) {
//                button.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
//
//            }
//            button.addTarget(self, action: #selector(click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
       // }
            return cell!*/

        
    }
    
    func selectAllButton(btn:UIButton){
    
        let index = NSIndexPath.init(forRow: 0, inSection: btn.tag)
        let cell = myTableView.cellForRowAtIndexPath(index) as! SkillTableViewCell
        let array = cell.selectButtonArr
//        let btnIndex = array.indexOfObject(btn)
        let selectArr = self.cellMarkArray![btn.tag] as! NSMutableArray
        
        print(array)
        
        if selectAllArray.count == 0{
            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            selectAllArray.addObject(btn)
            
            for button in array {
                button.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                let buttonIndex = array.indexOfObject(button)
                selectArr.addObject(buttonIndex)
                self.selectIDArr.addObject(self.dataSource![btn.tag].clist[buttonIndex].id!)
                
            }
            print(selectArr)
            //            self.payMode = cell.title.text!
//            print(selectAllArray)
        }else{
            print(selectAllArray.count)
            if !selectAllArray.containsObject(btn){
                btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                selectAllArray.addObject(btn)
                for button in array {
                    button.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                    let buttonIndex = array.indexOfObject(button)
                    selectArr.addObject(buttonIndex)
                    self.selectIDArr.addObject(self.dataSource![btn.tag].clist[buttonIndex].id!)
                   
                }
                 print(selectArr)
                //                    self.payMode = cell.title.text!
//                print(selectAllArray)
            }else{
                btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                selectAllArray.removeObject(btn)
                for button in array {
                    button.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                    let buttonIndex = array.indexOfObject(button)
                    selectArr.removeObject(buttonIndex)
                    self.selectIDArr.removeObject(self.dataSource![btn.tag].clist[buttonIndex].id!)
                }
                print(selectAllArray)
            }
         }
//        print(selectArr)
    }
    
    
    func addTager(btn:UIButton,sectionNum:Int){
    
        let index = NSIndexPath.init(forRow: 0, inSection: btn.tag)
        let cell = myTableView.cellForRowAtIndexPath(index) as! SkillTableViewCell
        let array = cell.selectButtonArr
        let btnIndex = array.indexOfObject(btn)
        let selectArr = self.cellMarkArray![btn.tag] as! NSMutableArray
        print(btnIndex)
        
        print("----")
        print(selectArr)
        print("----")
        if selectArr.count == 0{
            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            selectArr.addObject(btnIndex)
            self.selectIDArr.addObject(self.dataSource![sectionNum].clist[btnIndex].id!)
//            selectArr.addObject(btn)
            //            self.payMode = cell.title.text!
            print(selectArr)
        }else{
            print(selectArr.count)
            if !selectArr.containsObject(btnIndex){
                btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                selectArr.addObject(btnIndex)
                self.selectIDArr.addObject(self.dataSource![sectionNum].clist[btnIndex].id!)
                //                    self.payMode = cell.title.text!
                print(selectArr)
            }else{
                btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                selectArr.removeObject(btnIndex)
                self.selectIDArr.removeObject(self.dataSource![sectionNum].clist[btnIndex].id!)
                print(selectArr)
            }
       }
        myTableView.reloadData()
        
    }
    
    func click(btn:UIButton){
//        let indexPath = NSIndexPath.init(forRow: 0 , inSection: 0)
//        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! SkillTableViewCell
        if selectArr.count == 0{
            btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
            selectArr.addObject(btn)
//            self.payMode = cell.title.text!
            print(selectArr)
        }else{
            print(selectArr.count)
            if !selectArr.containsObject(btn){
                btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
                selectArr.addObject(btn)
                //                    self.payMode = cell.title.text!
                print(selectArr)
            }else{
                btn.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
                selectArr.removeObject(btn)
                print(selectArr)
            }
            
//            for btn1 in selectArr {
//                if btn1 as! NSObject == btn  {
//                    btn1.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
//                    selectArr.removeObject(btn1)
//                    print(selectArr)
////                    return
//                }else{
//                    
////                    for btn1 in selectArr {
////                        btn1.setImage(UIImage(named: "ic_weixuanze"), forState: UIControlState.Normal)
////                        selectArr.removeObject(btn1)
////                    }
//                    btn.setImage(UIImage(named: "ic_xuanze"), forState: UIControlState.Normal)
//                    selectArr.addObject(btn)
////                    self.payMode = cell.title.text!
//                    print(selectArr)
////                    return
//                }
//            }
        }

        
        
    }
    func nextToView() {
        
        
        if loginSign == 0 {//未登陆
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            
            
            let userdefault = NSUserDefaults.standardUserDefaults()
            
            
            if  userdefault.objectForKey("isxiugai") as! String == "yes"  {
                alert("正在开发", delegate: self)
                return
            }
            print("立即提交")
            let info = NSUserDefaults.standardUserDefaults()
            let array = info.objectForKey("infomation")as! NSDictionary
//            print(array)
//            print(array.count)
            
            
            self.createView()
            let ud = NSUserDefaults.standardUserDefaults()
            let userid = ud.objectForKey("userid")as! String
            //测试方便，以后打开
            print(array)
            var positive_pic = String()
            var opposite_pic = String()
            var driver_pic = String()
            if array["positive_pic"] == nil {
                positive_pic = ""
            }else{
                positive_pic = array["positive_pic"] as! String
            }
            if array["opposite_pic"] == nil {
                opposite_pic = ""
            }else{
                opposite_pic = array["opposite_pic"] as! String
            }
            if array["driver_pic"] == nil {
                driver_pic = ""
            }else{
                driver_pic = array["driver_pic"] as! String
            }

            let types = NSMutableString()
            
//            let strrr = NSMutableString()
            for i in 0..<self.selectIDArr.count{
                if i == selectIDArr.count-1{
                    types.appendString(selectIDArr[i]as! String)
                }else{
                    types.appendString(selectIDArr[i]as! String)
                    types.appendString(",")
                }
            }
            print(types)
            if array.count<6 {
                let alert = UIAlertView.init(title: "温馨提示", message: "请完善信息", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            }else{
                print(array)
                
                skillHelper.identityAffirm(userid, city: array["city"] as! String, realname:array["name"] as! String, idcard: array["idcard"] as! String, contactperson: array["contactperson"] as! String, contactphone: array["contactphone"] as! String, positive_pic:positive_pic, opposite_pic:opposite_pic, driver_pic: driver_pic,types:types as String) { (success, response) in
                    if success{
                        
                        print(response)
                        //let homepage = RushHomePageViewController()
                        //self.presentViewController(homepage, animated: true, completion: nil)
                        let ud = NSUserDefaults.standardUserDefaults()
//                        ud.setObject("no", forKey: "ss")
                        ud.synchronize()
                        //self.navigationController?.pushViewController(homepage, animated: true)
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }else{
                        let alert = UIAlertView.init(title: "温馨提示", message: "认证失败", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                    }
                }
                
            }

        }
        
    }
    
    func createView(){
    
       
        self.delegate?.createView()
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
