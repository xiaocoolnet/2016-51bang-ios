//
//  UPLoadSound.m
//  51Bang_ios_2016
//
//  Created by 815785047 on 16/8/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

#import "UPLoadSound.h"
#import "UpLoadModel.h"

@implementation UPLoadSound
- (void)upload:(NSArray *)models url:(NSString *)url parmas:(NSDictionary *)params uploadComplete:(void(^)(id response))complete failed:(void(^)())failure
{
    
    NSURL *requestUrl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    
    request.HTTPMethod = @"POST";
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[@"--nYinqAR4LEreOVJBRa-k-68rOHU9eK\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (int i = 0; i < models.count; i ++) {
        
        UpLoadModel *model = [models objectAtIndex:i];
        
        NSString *name = model.name;
        
        NSData *data = model.data;
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, [NSString stringWithFormat:@"%@.mp3", [self createUUID]]];
        [body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", @"vedio/mp3"];
        [body appendData:[type dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [body appendData:[@"--nYinqAR4LEreOVJBRa-k-68rOHU9eK\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [body appendData:[@"--nYinqAR4LEreOVJBRa-k-68rOHU9eK--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = body;
    
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data; boundary=nYinqAR4LEreOVJBRa-k-68rOHU9eK" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil)
        {
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            complete(object);
        }else
        {
            failure();
        }
        
    }];
}

- (NSString *) createUUID {
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    NSString *uuidStr = [(__bridge NSString *)uuidRef copy];
    CFRelease(uuidRef);
    CFRelease(uuidObject);
    return uuidStr;
}

@end
