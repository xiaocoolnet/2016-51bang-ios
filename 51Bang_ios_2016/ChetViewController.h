//
//  ChetViewController.h
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/9/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "chatModel.swift"

@interface ChetViewController : UIViewController

@property (nonatomic,strong)NSString *receive_uid;
@property (nonatomic,strong)NSArray *datasource2;
@property (nonatomic,strong)UITableView *customTableView;
@property (nonatomic,strong)NSString *send_uid;
@property (nonatomic,strong)NSString *titleTop;
@property (nonatomic,assign)NSString *urlphoto;
@end
