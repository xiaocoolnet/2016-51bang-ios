//
//  UPLoadSound.h
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface UPLoadSound : NSObject
-(void)upload:(NSArray *)models url:(NSString *)url parmas:(NSDictionary *)params uploadComplete:(void(^)(id response))complete failed:(void(^)())failure;
@end
