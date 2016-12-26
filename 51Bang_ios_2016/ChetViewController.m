//
//  ViewController.m
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "ChetViewController.h"
#import "messModel.h"
#import "modelFrame.h"
#import "CustomTableViewCell.h"
//#import "MainHelper.swift"
#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>
//#import "51Bang_ios_2016-Swift.h"


#define HEIGHTS [UIScreen mainScreen].bounds.size.height
#define WIDTHS [UIScreen mainScreen].bounds.size.width

//#define Bang_Open_Header @"http://bang.xiaocool.net/"
#define Bang_Open_Header @"http://www.my51bang.com/"

@interface ChetViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (nonatomic,strong)UITextField *inputMess;
@property (nonatomic,strong)UIButton *senderButton;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)NSMutableArray *arrModelData;
@property (nonatomic,assign)CGFloat boreadHight;
@property (nonatomic,assign)CGFloat moveTime;
@property (nonatomic,assign)NSMutableArray *dataSource;
@property (nonatomic,assign)NSTimer *timer;
@property (nonatomic,assign)NSInteger num;
@property (nonatomic,strong)NSString *URL_Str;

@end
@implementation ChetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_customTableView reloadData];
    
}


-(NSMutableArray *)arrModelData{
    if (_arrModelData==nil) {
        _arrModelData=[NSMutableArray array];
    }
    return _arrModelData;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.URL_Str = Bang_Open_Header;
//    self.URL_Str = @"http://www.my51bang.com/";
    [self someSet];
    
    if (_titleTop != nil) {
        self.title = _titleTop;
    }else{
        self.title = _datasource2[0][@"receive_nickname"];
    }
    
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    NSDate *nowdate=[NSDate date];
    NSDateFormatter *forMatter=[[NSDateFormatter alloc]init];
    forMatter.dateFormat=@"HH:mm"; //小时和分钟
    NSString *nowTime=[forMatter stringFromDate:nowdate];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userid = [NSString stringWithFormat:@"%@", [user objectForKey:@"userid"]];
    
    
    if  (_datasource2 != nil){
        for (int i = 0; i<_datasource2.count; i++) {
            
            NSMutableDictionary *dicValues=[NSMutableDictionary dictionary];
            dicValues[@"desc"]=[NSString stringWithFormat:@"%@",[_datasource2[i] objectForKey:@"content"]];
            dicValues[@"time"]=[_datasource2[i] objectForKey:@"time"];
            
            if ([[NSString stringWithFormat:@"%@",[_datasource2[i] objectForKey:@"send_uid"]] isEqualToString:userid]){
                            dicValues[@"imageName"]=@"girl";
                dicValues[@"person"]=[NSNumber numberWithBool:1];
//                mess.person = YES;
            }else{
                            dicValues[@"imageName"]=@"boy";
                dicValues[@"person"]=[NSNumber numberWithBool:0];
//                mess.person = NO;
            }
            NSLog(@"%@",[NSString stringWithFormat:@"%@",[_datasource2[i] objectForKey:@"time"]]);
            if ([[NSString stringWithFormat:@"%@",[_datasource2[i] objectForKey:@"time"]] isEqualToString:@"(null)"]) {
                NSLog(@"%@",dicValues);
                messModel *mess=[[messModel alloc]initWithModel:dicValues];
                modelFrame *frameModel=[modelFrame modelFrame:mess timeIsEqual:YES];
                //            frameModel.myself = YES;
                [self.arrModelData addObject:frameModel];
            }else{
                NSLog(@"%@",dicValues);
                messModel *mess=[[messModel alloc]initWithModel:dicValues];
                modelFrame *frameModel=[modelFrame modelFrame:mess timeIsEqual:[self timeIsEqual:nowTime]];
                //            frameModel.myself = YES;
                [self.arrModelData addObject:frameModel];
            }
           
            
        }
        
        [self.customTableView reloadData];
        NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
        [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }

    
    
    _num=0;
    self.customTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44-64) style:UITableViewStylePlain];

    self.customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.view addSubview:self.customTableView];
    self.senderButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTHS- 40 , 5, 40, 34)];
//    [self.senderButton setBackgroundImage:[UIImage imageNamed:@"servicesS"] forState:UIControlStateNormal];
    self.senderButton.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:196.0 / 255.0 blue:171.0 / 255.0 alpha:1];
    [self.senderButton setImage:[UIImage imageNamed:@"servicesS"] forState:UIControlStateNormal];
    [self.senderButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHTS- 44-60-4, WIDTHS, 44)];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:196.0 / 255.0 blue:171.0 / 255.0 alpha:1];
    [self.bgView addSubview:self.inputMess];
    [self.bgView addSubview:self.senderButton];
    [self.view addSubview:self.bgView];
    
//    NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
//    [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timego) userInfo:nil repeats:YES];
    
    // 监听键盘出现的出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     if  (_datasource2 != nil){
         
         NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
         [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];

     }
    
    
}

#pragma mark - timego

-(void)timego{
    if (_num==2) {
        [_timer invalidate];
    }
    _num++;
    [_customTableView reloadData];
}

#pragma mark - set

-(UITextField*)inputMess{
    
    if (!_inputMess) {
        _inputMess = [[UITextField alloc]initWithFrame:CGRectMake(8, 6, WIDTHS-35-20, 32)];
        _inputMess.layer.masksToBounds = YES;
        _inputMess.backgroundColor = [UIColor whiteColor];
        _inputMess.layer.cornerRadius = 5;
        _inputMess.layer.borderColor = [UIColor grayColor].CGColor;
        _inputMess.layer.borderWidth = 1;
        _inputMess.font = [UIFont systemFontOfSize:12];
        _inputMess.placeholder = @"说点什么吧...";
        
    }
    
    return _inputMess;
}
#pragma mark 一Action

- (void)sendAction:(UIButton *)sender {
 
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userid = [user objectForKey:@"userid"];
//    NSLog(@"%@",_datasource2.firstObject);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requestSerializer;
    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"send_uid":userid,@"receive_uid":_receive_uid,@"content":_inputMess.text};
    NSString *url = [NSString stringWithFormat:@"%@%@", self.URL_Str,@"index.php?g=apps&m=index&a=SendChatData"];
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        printf("上传失败");
        NSLog(@"%@",error);
        
    }];
    
    [self sendMess:self.inputMess.text]; //发送信息
}


#pragma mark 一些UI设置
-(void)someSet{
    self.inputMess.delegate=self;//设置UITextField的代理
    self.inputMess.returnKeyType=UIReturnKeySend;//更改返回键的文字 (或者在sroryBoard中的,选中UITextField,对return key更改)
    self.inputMess.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    self.customTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    [self.customTableView setBackgroundView:bgView];
    [self.customTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.customTableView setShowsVerticalScrollIndicator:NO];
}
#pragma mark 得到Cell上面的Frame的模型
-(void)messModelArr{
    NSString *strPath=[[NSBundle mainBundle]pathForResource:@"dataPlist.plist" ofType:nil];//得到Plist文件里面的数据
    NSArray *arrData=[NSArray arrayWithContentsOfFile:strPath];
    for (NSDictionary *dicData in arrData) {
        messModel *model=[[messModel alloc]initWithModel:dicData]; //将数据转为模型
        
        BOOL isEquel;
        if(self.arrModelData){
            isEquel=[self timeIsEqual:model.time];//判断上一个模型数据里面的时间是否和现在的时间相等
        }
        modelFrame *frameModel=[[modelFrame alloc]initWithFrameModel:model timeIsEqual:isEquel];//将模型里面的数据转为Frame,并且判断时间是否相等
        [self.arrModelData addObject:frameModel];//添加Frame的模型到数组里面
    }
}
#pragma mark  -TableView的DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrModelData.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    modelFrame *frameModel=self.arrModelData[indexPath.row];
//    NSLog(@"%lu",(unsigned long)self.arrModelData.count);
//    NSLog(@"%f",frameModel.cellHeight);
//    NSLog(@"%f",HEIGHTS-64-216);
    
    return frameModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *strId=@"cellId";
    CustomTableViewCell *customCell=[tableView dequeueReusableCellWithIdentifier:strId];

    if (customCell == nil){
        customCell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
        if (self.datasource2.count>0 && self.datasource2[0][@"send_face"] != nil) {
            customCell.selfPhoto = self.datasource2[0][@"send_face"];
        }
        if (self.datasource2.count>0 && self.datasource2[0][@"receive_face"] != nil) {
            customCell.otherPhoto = self.datasource2[0][@"receive_face"];
        }
        if (self.datasource2.count==0 || self.datasource2[0][@"send_face"] == nil) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"photo"] != nil) {
                NSUserDefaults *photo = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo"];
                NSString *url = [NSString stringWithFormat:@"%@",photo];
                customCell.selfPhoto = url;
            }
            
           
            
        }
    }
    
   
    
   
    
//    [customCell setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    [customCell setBackgroundColor:[UIColor whiteColor]];
    customCell.selectionStyle=UITableViewCellSelectionStyleNone;
    customCell.frameModel=self.arrModelData[indexPath.row];
  
    return customCell;
}

#pragma mark 键盘将要出现
-(void)keyboardWillShow:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 键盘消失完毕
-(void)keyboardWillHide:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 处理键盘的位置
-(void)dealKeyboardFrame:(NSNotification *)changeMess{
    NSDictionary *dicMess=changeMess.userInfo;//键盘改变的所有信息
    CGFloat changeTime=[dicMess[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];//通过userInfo 这个字典得到对得到相应的信息//0.25秒后消失键盘
    CGFloat keyboardMoveY=[dicMess[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y-[UIScreen mainScreen].bounds.size.height;//键盘Y值的改变(字典里面的键UIKeyboardFrameEndUserInfoKey对应的值-屏幕自己的高度)
    self.boreadHight = keyboardMoveY;
    NSLog(@"%f",keyboardMoveY);
    
    self.moveTime = changeTime;
    CGFloat hightCount = 0.0;
    for (modelFrame *frameModel in self.arrModelData) {
        hightCount = hightCount + frameModel.cellHeight;
    }
    NSLog(@"%f",hightCount);
    
//    modelFrame *frameModel=self.arrModelData[indexPath.row];
//    return frameModel.cellHeight;
    
    [UIView animateWithDuration:changeTime animations:^{ //0.25秒之后改变tableView和bgView的Y轴
        self.bgView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
        self.customTableView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
    }];
    
    
    if (hightCount>(HEIGHTS-64+keyboardMoveY)) {
        [UIView animateWithDuration:changeTime animations:^{ //0.25秒之后改变tableView和bgView的Y轴
            self.customTableView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
           
            
        }];
        NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
        [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];//将tableView的行滚到最下面的一行
    }
    
}
#pragma mark 滚动TableView去除键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputMess resignFirstResponder];
}
#pragma mark TextField的Delegate send后的操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{  //
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userid = [user objectForKey:@"userid"];
    //    NSLog(@"%@",_datasource2.firstObject);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = requestSerializer;
    
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"send_uid":userid,@"receive_uid":_receive_uid,@"content":_inputMess.text};
    NSString *url = [NSString stringWithFormat:@"%@%@", self.URL_Str,@"index.php?g=apps&m=index&a=SendChatData"];
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        printf("上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        printf("上传失败");
        NSLog(@"%@",error);
        
    }];
    
    [self sendMess:self.inputMess.text]; //发送信息
    [self.customTableView reloadData];
    return YES;
}
//- (IBAction)sendAction:(UIButton *)sender {
//    [self sendMess:self.inputMess.text]; //发送信息
//}
#pragma mark 发送消息,刷新数据
-(void)sendMess:(NSString *)messValues{
    //添加一个数据模型(并且刷新表)
    //获取当前的时间
    NSDate *nowdate=[NSDate date];
    NSDateFormatter *forMatter=[[NSDateFormatter alloc]init];
    forMatter.dateFormat=@"HH:mm"; //小时和分钟
    NSString *nowTime=[forMatter stringFromDate:nowdate];
    NSMutableDictionary *dicValues=[NSMutableDictionary dictionary];
    
//    dicValues[@"imageName"]=@"girl";
    dicValues[@"desc"]=messValues;
    dicValues[@"time"]=nowTime; //当前的时间
    dicValues[@"person"]=[NSNumber numberWithBool:1]; //转为Bool类型
    messModel *mess=[[messModel alloc]initWithModel:dicValues];
    modelFrame *frameModel=[modelFrame modelFrame:mess timeIsEqual:[self timeIsEqual:nowTime]]; //判断前后时候是否一致
    frameModel.myself = YES;
    [self.arrModelData addObject:frameModel];
    [self.customTableView reloadData];
    
    self.inputMess.text=nil;
    
    //自动回复就是再次添加一个frame模型
//    NSArray *arrayAutoData=@[@"蒸桑拿蒸馒头不争名利，弹吉它弹棉花不谈感情",@"女人因为成熟而沧桑，男人因为沧桑而成熟",@"男人善于花言巧语，女人喜欢花前月下",@"笨男人要结婚，笨女人要减肥",@"爱与恨都是寂寞的空气,哭与笑表达同样的意义",@"男人的痛苦从结婚开始，女人的痛苦从认识男人开始",@"女人喜欢的男人越成熟越好，男人喜欢的女孩越单纯越好。",@"做男人无能会使女人寄希望于未来，做女人失败会使男人寄思念于过去",@"我很优秀的，一个优秀的男人，不需要华丽的外表，不需要有渊博的知识，不需要有沉重的钱袋",@"世间纷繁万般无奈，心头只求片刻安宁"];
    //添加自动回复的
//    int num= arc4random() %(arrayAutoData.count); //获取数组中的随机数(数组的下标)
//    
//    
//    //    NSLog(@"得到的时间是:%@",nowdate);
//    NSMutableDictionary *dicAuto=[NSMutableDictionary dictionary];
//    dicAuto[@"imageName"]=@"boy";
//    dicAuto[@"desc"]=[arrayAutoData objectAtIndex:num];
//    dicAuto[@"time"]=nowTime;
//    dicAuto[@"person"]=[NSNumber numberWithBool:0]; //转为Bool类型
//    messModel *messAuto=[[messModel alloc]initWithModel:dicAuto];
//    modelFrame *frameModelAuto=[modelFrame modelFrame:messAuto timeIsEqual:[self timeIsEqual:nowTime]];//判断前后时候是否一致
//    [self.arrModelData addObject:frameModelAuto];
//    [self.customTableView reloadData];
    
    CGFloat hightCount = 0.0;
    for (modelFrame *frameModel in self.arrModelData) {
        hightCount = hightCount + frameModel.cellHeight;
    }
    if (hightCount>HEIGHTS-64+self.boreadHight) {
        [UIView animateWithDuration:self.moveTime animations:^{ //0.25秒之后改变tableView和bgView的Y轴
            self.customTableView.transform=CGAffineTransformMakeTranslation(0, self.boreadHight);
            
            
        }];
        NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
        [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];//将tableView的行滚到最下面的一行
    }
    
    NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
    [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark 判断前后时间是否一致
-(BOOL)timeIsEqual:(NSString *)comStrTime{
    modelFrame *frame=[self.arrModelData lastObject];
    NSString *strTime=frame.dataModel.time; //frame模型里面的NSString时间
    if ([strTime isEqualToString:comStrTime]) { //比较2个时间是否相等
        return YES;
    }
    return NO;
}
@end
