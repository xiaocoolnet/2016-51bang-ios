//
//  FZJWeiXinPayMainController.h
//  FZJWeiXinPayDemo
//
//  Created by fdkj0002 on 16/3/3.
//  Copyright © 2016年 FZJ.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WXApi.h"

@interface FZJWeiXinPayMainController : UIViewController
-(void)testStart:(NSString*)price orderName:(NSString*)orderName numOfGoods:(NSString*)numOfGoods isRenwu:(BOOL) isRenwu;
@end
