//
//  CustomTableViewCell.h
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class modelFrame;
@interface CustomTableViewCell : UITableViewCell

@property (nonatomic,strong)modelFrame *frameModel;
@property (nonatomic,strong)NSString *selfPhoto;
@property (nonatomic,strong)NSString *otherPhoto;
@end
