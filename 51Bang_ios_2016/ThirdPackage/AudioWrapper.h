//
//  AudioWrapper.h
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioWrapper : NSObject
+ (NSString*)audioPCMtoMP3 :(NSString *)audioFileSavePath :(NSString *)mp3FilePath;
@end
