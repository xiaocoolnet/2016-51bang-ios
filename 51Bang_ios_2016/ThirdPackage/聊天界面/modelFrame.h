//
//  modelFrame.h
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class messModel;
@interface modelFrame : NSObject
/** 时间的Frame */
@property (nonatomic,assign)CGRect timeFrame;
/** 头像的Frame */
@property (nonatomic,assign)CGRect headImageFrame;
/** 按钮(内容)的Frame */
@property (nonatomic,assign)CGRect btnFrame;
/** 是否是自己发送的信息 */
@property (nonatomic,assign)BOOL myself;
/** cell的高度 */
@property (nonatomic,assign)CGFloat cellHeight;

/** 模型数据 */
@property (nonatomic,strong)messModel *dataModel;

/** 通过模型数据计算出对应的Frame,并且返回出modelFrame自己这个对象 */
-(instancetype)initWithFrameModel:(messModel *)modelData timeIsEqual:(BOOL)timeBool;
//和上面同理
+(instancetype)modelFrame:(messModel *)modelData timeIsEqual:(BOOL)timeBool;
@end
