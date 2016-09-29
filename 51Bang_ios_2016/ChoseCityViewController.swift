//
//  ChoseCityViewController.swift
//  51Bang_ios_2016
//
//  Created by zhang on 16/6/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ChoseCityViewController: UIViewController {

    let button=UIButton()
    let selectCity = NSString()
    let pickerView = LZXPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        pickerView.frame = CGRectMake(0, 50, WIDTH, self.view.frame.size.height-300)
        button.frame = CGRectMake(50, pickerView.frame.size.height+pickerView.frame.origin.y,WIDTH-100, WIDTH*40/375)
        button.clipsToBounds = true
        button.cornerRadius = 10
        button.setTitle("确定", forState: UIControlState.Normal)
        button.backgroundColor = COLOR
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.click), forControlEvents: UIControlEvents.TouchUpInside)
//        button.backgroundColor = UIColor.redColor()
//        pickerView.backgroundColor = UIColor.redColor()
        self.view.addSubview(pickerView)
        self.view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    func click(){

        print(pickerView.selectString)
        self.navigationController?.popViewControllerAnimated(true)
        print("点击")
        let city = NSUserDefaults.standardUserDefaults()
        city.setObject(pickerView.selectString, forKey: "city")
        //vc.myTableView.reloadData()
        print(pickerView.selectString)
        
        
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
