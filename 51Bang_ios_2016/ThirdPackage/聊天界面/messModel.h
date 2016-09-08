//
//  messModel.h
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messModel : NSObject
@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,assign)BOOL person;

/** 将plist里的data转为model */
-(instancetype)initWithModel:(NSDictionary *)mess;
//同理
+(instancetype)messModel:(NSDictionary *)mess;

@end
