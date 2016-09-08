//
//  messModel.m
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "messModel.h"

@implementation messModel
-(instancetype)initWithModel:(NSDictionary *)mess{
    if (self=[super init]) {
        self.imageName=mess[@"imageName"];
        self.desc=mess[@"desc"];
        self.time=mess[@"time"];
        self.person=[mess[@"person"] boolValue]; //转为Bool类型
    }
    return self;
}
+(instancetype)messModel:(NSDictionary *)mess{
    return [[self alloc]initWithModel:mess];
}

@end
