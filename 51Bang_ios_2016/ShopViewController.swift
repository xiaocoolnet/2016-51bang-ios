//
//  ShopViewController.swift
//  51Bang_ios_2016
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh
class ShopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,ViewControllerDelegate,UISearchBarDelegate {
    
//    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var fenLeiType: UIBarButtonItem!
    var myTableView = UITableView()
    let leftTypeButton = UIButton()//左侧全部分类按钮
    var showLogin = false
//    var type = String()
    var goodType = String()//商品分类
    let shopHelper = ShopHelper()
    var dataSource : Array<GoodsInfo>?
//    var dataSource2 =  NSMutableArray()
    var myDic : Array<DicInfo>?
    let mainHelper = MainHelper()
    let leftTableView = UITableView()
    let rightTableView = UITableView()
    var isShow = Bool()
    let coverView = UIView()
    let leftArr = ["全部分类","餐饮美食","休闲娱乐","个护化妆","按摩","养生","健身"]
    var rightArr = ["全部","足疗按摩","运动健身","KTV","其他养生保健","游乐园","其他游乐活动"]
    var rightArr0 = ["全部","足疗按摩","运动健身","KTV","其他养生保健","游乐园","其他游乐活动"]
    let rightArr1 = ["油压按摩","足底按摩","泰式按摩","养生","保健","治疗","美容"]
    let rightArr2 = ["八仙粉","辣子鸡","糖霜花生","武汉热干面","串串香","菌子汤","豌豆黄"]
    let rightArr3 = ["体育类","旅游类","游戏类","喝茶","聊天","上网","健身"]
    let rightArr4 = ["影视化妆","平面化妆","现代人物","经典化妆","普通化妆","化妆学习","化妆招聘"]
    let rightArr5 = ["饮食养生","调息养生","运动养生","保健养生","道家养生","大众养生","中医养生"]
    let rightArr6 = ["全部","足疗按摩","运动健身","KTV","其他养生保健","游乐园","其他游乐活动"]
    var rightKind:Array<[String]>?
    
    var searchBar = UISearchBar.init(frame: CGRectMake(0, 0, WIDTH, 50))
    let searchHistoryTableview = UITableView()
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    var searchHistory = NSMutableArray()
    var keyword = String()
    
//    var array = ["餐饮美食","休闲/娱乐/酒店","服饰/箱包","运动户外/休闲/健身","日用百货","培训机构/教育器材","汽车用品/买卖","二手买卖","家纺家饰/家装建材","美装日化/美容美发","代购进口产品","黄金珠宝","数码家电/安全防护/电工电气","印刷广告/包装市场/行政采购","照明/电子/五金工具/机械/仪器仪表","橡塑/精细/钢材","纺织、皮革市场","医药保健","货运/物流","食品/海鲜/果蔬/农产品/茶叶","婚纱摄影/个人写真","其他"]
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        self.GetData()
        self.keyword = ""
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "特卖"
        self.view.backgroundColor = UIColor.whiteColor()
        
        let leftTypeView = UIView.init(frame: CGRectMake(0, 0, 150, 40))
        
        leftTypeButton.backgroundColor = COLOR
        leftTypeButton.frame = CGRectMake(0, 0, 100, 40)
        leftTypeButton.setTitle("分类", forState:UIControlState.Normal)
        leftTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        //        leftTypeButton.titleLabel?.textAlignment = .Left
        leftTypeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        leftTypeButton.addTarget(self, action: #selector(self.goToMenu), forControlEvents: UIControlEvents.TouchUpInside)
        leftTypeView.addSubview(leftTypeButton)
        
        let findButton = UIButton.init(frame: CGRectMake(leftTypeButton.width, 0, 50, 40))
        findButton.setImage(UIImage(named: "ic_sousuo"), forState: .Normal)
        findButton.addTarget(self, action: #selector(self.findButtonAction), forControlEvents: .TouchUpInside)
//        leftTypeView.addSubview(findButton)
        
        //        self.fenLeiType.customView = leftTypeButton
        let aaa = UIBarButtonItem.init(customView: leftTypeView)
        self.navigationItem.leftBarButtonItem = aaa
        
        self.createTableView()
        rightKind = [rightArr0,rightArr2,rightArr,rightArr4,rightArr1,rightArr5,rightArr6]
        
        isShow = false
        self.GetData("0",keyword: self.keyword)
        
        // Do any additional setup after loading the view.
    }
    
    func GetData(type:String,keyword:String){

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.mode = .Text
        hud.labelText = "正在努力加载"
        self.view.bringSubviewToFront(hud)
        shopHelper.getGoodsList("0",type:type,keyword:keyword,handle:{[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    hud.hide(true)
                    alert("暂无数据", delegate: self)
                     self.dataSource?.removeAll()
                    self.myTableView.reloadData()
                    return
                }
                hud.hide(true)
//                print(response)
                self.dataSource?.removeAll()
                self.dataSource = response as? Array<GoodsInfo> ?? []
//                print(self.dataSource)
//                print(self.dataSource?.count)
                
                //                self.ClistdataSource = response as? ClistList ?? []
                self.myTableView.reloadData()
                //self.configureUI()
            })
            })
        
    }
    
    func createTableView(){
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerNib(UINib(nibName: "ShopTableViewCell",bundle: nil), forCellReuseIdentifier: "cell")
        myTableView.rowHeight = WIDTH*80/375
        myTableView.tag = 0
        myTableView.separatorStyle = .None
        myTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            print("MJ:(下拉刷新)")
            self.headerRefresh(self.keyword)
            
        })
        
        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            print("MJ:(上拉加载)")
            self.footerRefresh(self.keyword)
            
        })
        
        self.view.addSubview(myTableView)
//
    }
    
    func headerRefresh(keyword:String){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.mode = .Text
        hud.labelText = "正在努力加载"
        self.view.bringSubviewToFront(hud)
        shopHelper.getGoodsList("0",type: self.goodType,keyword:keyword,handle:{[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    self.myTableView.mj_header.endRefreshing()
                    hud.hide(true)
                    return
                }
                hud.hide(true)
                self.dataSource?.removeAll()
                self.myTableView.mj_header.endRefreshing()
                self.dataSource = response as? Array<GoodsInfo> ?? []
                self.createTableView()
                self.myTableView.reloadData()
                
            })
            })

    }
    func footerRefresh(keyword:String){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.animationType = .Zoom
        hud.mode = .Text
        hud.labelText = "正在努力加载"
        self.view.bringSubviewToFront(hud)
        var  beginId = String()
        if self.dataSource!.count > 0{
             beginId = (self.dataSource![(self.dataSource?.count)!-1] as GoodsInfo).id! as String
        }
       
        shopHelper.getGoodsList(beginId,type: self.goodType,keyword:keyword,handle:{[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    if response as! String == "no data"{
                        self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                        hud.hide(true)
                        return
                    }else{
                        self.myTableView.mj_footer.endRefreshing()
                        hud.hide(true)
                        return
                    }
                    
                }
                hud.hide(true)
                self.myTableView.mj_footer.endRefreshing()
                if (response as? Array<GoodsInfo> ?? []).count<1{
                    self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
                for datas in response as? Array<GoodsInfo> ?? []{
                    self.dataSource?.append(datas)
                }
                
                
//                self.dataSource = self.dataSource?.append(response as? Array<GoodsInfo> ?? [])
                
                self.createTableView()
                self.myTableView.reloadData()
                
            })
            })
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.searchHistoryTableview{
            return 30
        }
        if tableView.tag == 0 {
            return 80
        }else if tableView.tag == 1{
            
            return 45
        }else{
            
            return CGFloat(tableView.frame.size.height/CGFloat(rightArr.count))
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchHistoryTableview{
            return self.searchHistory.count
        }
        if tableView.tag == 0 {
            if dataSource == nil{
                return 0
            }else{
                return (dataSource?.count)!
            }
                
           
        }else if tableView.tag == 1{
            if myDic == nil {
                return 0
            }
            
            return myDic!.count + 1
        }else{
            
            return self.rightArr.count
        }
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.searchHistoryTableview {
            let cell = PublicTableViewCell.init(style: .Default)
            cell.textLabel?.font = UIFont.systemFontOfSize(12)
            cell.textLabel?.textColor = UIColor(red: 149/255.0, green: 149/255.0, blue: 149/255.0, alpha: 1)
            cell.textLabel?.text = self.searchHistory[self.searchHistory.count-1-indexPath.row] as? String
            return cell
        }
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!ShopTableViewCell
            
//            let commentButton = UIButton()
//            commentButton.frame = CGRectMake(WIDTH/2, 60, WIDTH/2-80, 10)
//            commentButton.backgroundColor = UIColor.whiteColor()
//            commentButton.setTitle("评论"+String(indexPath.row)+"条", forState: UIControlState.Normal)
//            commentButton.setTitleColor(COLOR, forState: UIControlState.Normal)
//            commentButton.titleLabel?.font = UIFont.systemFontOfSize(10)
//            cell.addSubview(commentButton)
            
            let viewzhegai = UIView()
            viewzhegai.frame = CGRectMake(WIDTH/2, 60, WIDTH/2-80, 10)
            viewzhegai.alpha = 1
            cell.addSubview(viewzhegai)
            
            cell.selectionStyle = .None
//            print(self.dataSource![indexPath.row].price)
            //            if type == dataSource![indexPath.row].type {
            
            let goodsInfo = self.dataSource![indexPath.row]
            cell.setValueWithModel(goodsInfo)
           
            //            }
            return cell
            
        }else if tableView.tag == 1{
            //            tableView.separatorStyle = .None
            let cell = tableView.dequeueReusableCellWithIdentifier("leftTableView")
            if indexPath.row == 0{
                cell?.textLabel?.text = "全部"
            }else{
                 cell?.textLabel?.text = self.myDic![indexPath.row - 1].name
            }
           
            cell?.selectionStyle = .None
            //            cell!.accessoryType = .DisclosureIndicator
            cell?.selectedBackgroundView = UIView.init(frame: (cell?.frame)!)
            cell?.backgroundColor = RGREY
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell!
        }else{
            tableView.separatorStyle = .None
            let cell = tableView.dequeueReusableCellWithIdentifier("rightTableView")
            cell?.selectionStyle = .None
            cell?.textLabel?.text = rightArr[indexPath.row]
            cell?.backgroundColor = RGREY
            return cell!
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if tableView == self.searchHistoryTableview {
            self.searchHistoryTableview.hidden = true
            searchBar.resignFirstResponder()
            self.searchBar.removeFromSuperview()
            self.GetData(self.goodType, keyword: self.searchHistory[indexPath.row] as! String)
        }
        
//        print(indexPath.row)
        if tableView.tag == 0 {
            let next = BusnissViewController()
            
                next.id = self.dataSource![indexPath.row].id!
//                print(next.id)
                next.dataSource = self.dataSource![indexPath.row].commentlist
            
            
            self.navigationController?.pushViewController(next, animated: true)
            //            next.title = "风景自助"
        }else if tableView.tag == 1{
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            if indexPath.row == 0{
                self.goodType = "0"
                self.GetData(self.goodType,keyword: self.keyword)
                isShow = false
                 self.leftTypeButton.setTitle("分类", forState: UIControlState.Normal)
            }else{
                self.goodType = self.myDic![indexPath.row - 1].id!
                self.leftTypeButton.setTitle(self.myDic![indexPath.row - 1].name!, forState: UIControlState.Normal)
                self.keyword = ""
                self.GetData(self.goodType,keyword: self.keyword)
                self.myTableView.mj_footer.beginRefreshing()
                isShow = false
                //                self.dataSource = self.dataSource2
                self.myTableView.reloadData()
                    
                
            }
            
            
            
            myTableView.reloadData()
            self.tabBarController?.tabBar.hidden = false
            //
            //            //刷新右侧tableView
            //            switch indexPath.row {
            //            case 0:
            //                rightArr = rightKind![0]
            //                rightTableView.reloadData()
            //            case 1:
            //                rightArr = rightKind![1]
            //                rightTableView.reloadData()
            //            case 2:
            //                rightArr = rightKind![2]
            //                rightTableView.reloadData()
            //            case 3:
            //                rightArr = rightKind![3]
            //                rightTableView.reloadData()
            //            case 4:
            //                rightArr = rightKind![4]
            //                rightTableView.reloadData()
            //            case 5:
            //                rightArr = rightKind![5]
            //                rightTableView.reloadData()
            //            default:
            //                rightArr = rightKind![6]
            //                rightTableView.reloadData()
            //            }
            //            print("点击cell")
        }else if(tableView.tag == 2 ){
            
            print("点击了右侧cell")
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            //            coverView.frame = CGRectMake(0, 0, 0, 0)
            isShow = false
        }
        
        
    }
    //MARK:ACTION
    @IBAction func goToMenu(sender: AnyObject) {
        print("菜单")
        mainHelper.getDicList("3",handle: {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if !success {
                    return
                }
                //                print(response)
                
                self.myDic?.removeAll()
                self.myDic = response as? Array<DicInfo> ?? []
                //                for name in self.myDic!{
                //                    print(name.id)
                //                    print(name.name)
                //                }
                self.leftTableView.reloadData()
                //                print(self.myDic![0].id)
                //
                //                print(self.myDic?.count)
                
                //                }
            })
            })

        
        if isShow == false {
            coverView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-48)
            coverView.backgroundColor = UIColor.grayColor()
            coverView.alpha = 0.8
            leftTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
            leftTableView.tag = 1
            leftTableView.delegate = self
            leftTableView.dataSource = self
            leftTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "leftTableView")
            //        view.addSubview(leftTableView)
            leftTableView.backgroundColor = UIColor.whiteColor()
            rightTableView.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, leftTableView.frame.size.height)
            rightTableView.backgroundColor = UIColor.grayColor()
            rightTableView.tag = 2
            rightTableView.delegate = self
            rightTableView.dataSource = self
            rightTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "rightTableView")
            self.view.addSubview(leftTableView)
            self.view.addSubview(rightTableView)
            self.view.addSubview(coverView)
            self.view.bringSubviewToFront(leftTableView)
            //            self.view.bringSubviewToFront(rightTableView)
            self.tabBarController?.tabBar.hidden = true
            isShow = true
        }else{
            coverView.removeFromSuperview()
            leftTableView.removeFromSuperview()
            rightTableView.removeFromSuperview()
            self.tabBarController?.tabBar.hidden = false
            isShow = false
        }
        
    }
    @IBAction func goToAdd(sender: AnyObject) {
        print("增加")
//        print(loginSign)
        if loginSign == 0 {
            
            self.tabBarController?.selectedIndex = 3
            
        }else{
            let ud = NSUserDefaults.standardUserDefaults()
            
            if(ud.objectForKey("ss") as! String == "no")
            {
                let vc  = WobangRenZhengController()
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = false
                return
                
            }
            //            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            //            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AddView")
            let vc = AddViewController()
            vc.title = "特卖发布"
//            vc.array = self.myDic!
            self.navigationController?.pushViewController(vc, animated: true)
            //            vc.title = "特卖发布"
        }
//        let vc = OrderCommentViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //搜索
    func setSearchBar()
    {
        
        searchBar.showsCancelButton = true
        searchBar.barStyle = .Default
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1)
        searchBar.placeholder = "输入商家名、商品名       "
        for views in searchBar.subviews[0].subviews {
            if views.isKindOfClass(NSClassFromString("UINavigationButton")!) {
                (views as! UIButton).setTitle("取消", forState: .Normal)
                (views as! UIButton).titleLabel?.font = UIFont.systemFontOfSize(13)
                (views as! UIButton).setTitleColor(UIColor(red: 98/255.0, green: 98/255.0, blue: 98/255.0, alpha: 1), forState: .Normal)
            }
        }
        let searchBarSearchField = searchBar.valueForKey("_searchField") as! UITextField
        searchBarSearchField.font = UIFont.systemFontOfSize(13)
        //        (searchBar.valueForKey("_searchField") as! UITextField).textAlignment = .Left
        searchBarSearchField.setValue(UIFont.systemFontOfSize(13), forKeyPath: "_placeholderLabel.font")
        searchBarSearchField.returnKeyType = .Search
        //        searchBarSearchField.delegate = self
        //        (searchBar.valueForKey("_searchField") as! UITextField).layer.masksToBounds = true
        //        (searchBar.valueForKey("_searchField") as! UITextField).layer.cornerRadius = (searchBar.valueForKey("_searchField") as! UITextField).frame.size.height
        self.view.addSubview(searchBar)
        
    }
    
    func findButtonAction(){
        setSearchBar()
        searchHistoryTableview.frame = CGRectMake(0, searchBar.height, WIDTH, HEIGHT-searchBar.height)
        searchHistoryTableview.delegate = self
        searchHistoryTableview.dataSource = self
        searchHistoryTableview.backgroundColor = UIColor.whiteColor()
        searchHistoryTableview.separatorStyle = .None
        searchHistoryTableview.registerClass(PublicTableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
//        searchHistoryTableview.hidden = true
        let headerLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 35))
        headerLabel.text = "搜索历史"
        headerLabel.textAlignment = .Left
        headerLabel.font = UIFont.systemFontOfSize(13)
        self.searchHistoryTableview.tableHeaderView = headerLabel
        self.view.addSubview(searchHistoryTableview)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if !viewController.isKindOfClass(MineViewController.self){
            
            if showLogin {
                return false
            }
            let vc = childViewControllers[0] as! UINavigationController
            let controller = MineViewController()
            controller.delegate = self
            controller.navigationController?.navigationBar.hidden = false
            controller.title = "登录"
            vc.pushViewController(controller, animated: true)
            showLogin = true
            return false
        }
        return true
    }
    
    func viewcontrollerDesmiss(){
        showLogin = false
    }
    
    //MARK: -UISarchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if userLocationCenter.objectForKey("SearchFieldHistory") != nil{
            self.searchHistory = userLocationCenter.objectForKey("SearchFieldHistory") as! NSMutableArray
            
        }
        searchHistoryTableview.hidden = false
        searchHistoryTableview.reloadData()
//        NSLOG("将要开始编辑")
        
    }
    //取消按钮点击事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchHistoryTableview.hidden = true
        self.searchBar.removeFromSuperview()
        
    }
    
    //MARK:uitextfiledDelegate搜索点击事件
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        searchHistoryTableview.hidden = true
        if (searchBar.valueForKey("_searchField") as! UITextField).text?.characters.count>0{
            let str = (searchBar.valueForKey("_searchField") as! UITextField).text!
            let newArray = NSMutableArray.init(array: self.searchHistory)
            newArray.addObject(str)
            if self.searchHistory.count > 5{
                self.searchHistory.removeObjectAtIndex(0)
            }
            self.userLocationCenter.setObject(newArray, forKey: "SearchFieldHistory")
            self.GetData("0", keyword: str)
        }
        
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
