//
//  messModel.m
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "messModel.h"

@implementation messModel
-(instancetype)initWithModel:(NSMutableDictionary *)mess{
    if (self=[super init]) {
        
//        self.imageName=mess[@"imageName"];
//        self.imageview = mess[@"imageview"];
        self.desc=mess[@"desc"];
        self.time=mess[@"time"];
//        NSLog(@"%@",mess[@"person"]);
//        if ([mess[@"person"] isEqualToString:@"1"]) {
//            self.person = YES;
//        }else{
//            self.person = NO;
//        }
        self.person=[mess[@"person"] boolValue]; //转为Bool类型
    }
    return self;
}
+(instancetype)messModel:(NSDictionary *)mess{
    return [[self alloc]initWithModel:mess];
}

@end
