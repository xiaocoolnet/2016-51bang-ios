//
//  ConnectModel.h
//  LaoGanMa_v2
//
//  Created by 刘畅 on 14-12-18.
//

#import <Foundation/Foundation.h>

typedef void(^ConnectBlock)(NSData * resultData);

@interface ConnectModel : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic, retain)NSMutableData * myData;
@property (nonatomic, copy) ConnectBlock myBolck;

// 上传图片
+ (void)uploadWithImageName:(NSString *)name imageData:(NSData *)imageData URL:(NSString *)url finish:(ConnectBlock)block;

// 上传视频
+ (void)uploadWithVideoName:(NSString *)name imageData:(NSData *)imageData URL:(NSString *)url url:(NSURL *)url1 finish:(ConnectBlock)block;

@end