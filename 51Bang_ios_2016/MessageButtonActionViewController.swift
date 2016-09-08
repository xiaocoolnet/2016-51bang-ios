//
//  MessageButtonActionViewController.swift
//  51Bang_ios_2016
//
//  Created by 何明阳 on 16/9/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MessageButtonActionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate{
    let myMessageTableView = UITableView()
    var messageData = NSArray()
    let messagePushView = UIView()
    var data = TCHDInfo()
    
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(true)
        self.tabBarController?.tabBar.hidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        self.title = ""
        //注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardChange(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        self.messagePushView.frame = CGRectMake(0, HEIGHT-64-70, WIDTH, 70)
        let messageTextFiled = UITextField()
        messageTextFiled.frame = CGRectMake(20, 10, WIDTH-150, 50)
        messageTextFiled.layer.masksToBounds = true
        messageTextFiled.layer.borderColor = COLOR.CGColor
        messageTextFiled.layer.borderWidth = 1
        messageTextFiled.layer.cornerRadius = 10
        messageTextFiled.delegate = self
        self.messagePushView.addSubview(messageTextFiled)
        let sendButton = UIButton()
        sendButton.frame = CGRectMake(WIDTH-80, 10, 80, 50)
        sendButton.backgroundColor = COLOR
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 10
        sendButton.setTitle("发送", forState:UIControlState.Normal)
        self.messagePushView.addSubview(sendButton)
        self.messagePushView.backgroundColor = UIColor.whiteColor()
        self.messagePushView.layer.masksToBounds = true
//        self.messagePushView.layer.cornerRadius = 10
        self.messagePushView.layer.borderWidth = 1
        self.messagePushView.layer.borderColor = COLOR.CGColor
        self.view.addSubview(self.messagePushView)
        
        messageData = ["156465454165463","5456456423135464654","58464231454564321234316456143245314343543543514","54654354654564s5df45as4f54dsa54f54sdf546545646545645f4ads5f456ds4f54ds56f456sd4f56ds4f564sd56f45sd4f56sd4f56s4d65f4s56d4f56sd4"]
        self.myMessageTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-70)
        self.myMessageTableView.delegate = self
        self.myMessageTableView.dataSource = self
        self.myMessageTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(self.myMessageTableView)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let messageLabel = UITextView()
        messageLabel.frame = CGRectMake(0, 0, WIDTH-150, 0)
        messageLabel.text = self.messageData[indexPath.row] as? String
        messageLabel.sizeToFit()
        return messageLabel.height+30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if indexPath.row%2 == 1 {
            let headerImage = UIImageView()
            headerImage.frame = CGRectMake(10, 10, 40, 40)
            if data.photo != nil && data.photo! != "" {
                let url = Bang_Image_Header+data.photo!
                
                headerImage.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "01"))
            }else{
                headerImage.image = UIImage(named:"01" )
            }
            headerImage.layer.masksToBounds = true
            headerImage.layer.cornerRadius = 20
            headerImage.backgroundColor = UIColor.redColor()
            cell.addSubview(headerImage)
            
            
            let messageLabel = UITextView()
            messageLabel.endEditing(false)
            messageLabel.userInteractionEnabled = false
            messageLabel.frame = CGRectMake(80, 10, WIDTH-150, 0)
            messageLabel.text = self.messageData[indexPath.row] as? String
            messageLabel.layer.masksToBounds = true
            messageLabel.layer.cornerRadius = 5
            messageLabel.layer.borderColor = COLOR.CGColor
            messageLabel.layer.borderWidth = 1
            messageLabel.sizeToFit()
            messageLabel.textAlignment = NSTextAlignment.Right
            cell.addSubview(messageLabel)
            return cell
        }else{
            
            let headerImage = UIImageView()
            headerImage.frame = CGRectMake(WIDTH-50, 10, 40, 40)
            let ud = NSUserDefaults.standardUserDefaults()
            let photo = ud.objectForKey("photo")
            if photo != nil && photo as! String != "" {
                let url = Bang_Image_Header+(photo! as! String)
                
                headerImage.sd_setImageWithURL(NSURL(string:url), placeholderImage: UIImage(named: "01"))
            }else{
                headerImage.image = UIImage(named:"01" )
            }
            headerImage.layer.masksToBounds = true
            headerImage.layer.cornerRadius = 20
            headerImage.backgroundColor = UIColor.redColor()
            cell.addSubview(headerImage)
            
            let messageLabel = UITextView()
            messageLabel.endEditing(false)
            messageLabel.userInteractionEnabled = false
            messageLabel.frame = CGRectMake(100, 10, WIDTH-150, 0)
            messageLabel.text = self.messageData[indexPath.row] as? String
            messageLabel.sizeToFit()
            messageLabel.layer.masksToBounds = true
            messageLabel.layer.cornerRadius = 5
            messageLabel.layer.borderColor = COLOR.CGColor
            messageLabel.layer.borderWidth = 1
            messageLabel.textAlignment = NSTextAlignment.Left

            cell.addSubview(messageLabel)
            return cell
        }
    }
    
    func keyBoardChange(notification:NSNotification){
        let dict = notification.userInfo! as NSDictionary
        let aValue = dict.objectForKey("UIKeyboardAnimationDurationUserInfoKey")
        let animationTime = dict.objectForKey("UIKeyboardAnimationDurationUserInfoKey")
        
        let keyboardRect = aValue?.CGRectValue()
//        print(keyboardRect?.size.height)
        UIView.animateWithDuration((animationTime?.doubleValue)!) { 
            self.messagePushView.frame = CGRectMake(0, HEIGHT-64-70-216, WIDTH, 70)
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        
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
