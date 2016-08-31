//
//  ConnectModel.m
//  LaoGanMa_v2
//
//  Created by 刘畅 on 14-12-18.
//

#import "ConnectModel.h"
@implementation ConnectModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myData = [NSMutableData data];
    }
    return self;
}

+ (void)uploadWithImageName:(NSString *)name imageData:(NSData *)imageData URL:(NSString *)url finish:(ConnectBlock)block
{
    ConnectModel * p = [[ConnectModel alloc] init];
    p.myBolck = block;
    [p startFormConnectWithImageName:name URL:url imageData:imageData];
    if (p.myBolck) {
        p.myBolck(p.myData);
    }
}
+ (void)uploadWithVideoName:(NSString *)name imageData:(NSData *)imageData URL:(NSString *)url finish:(ConnectBlock)block
{
    ConnectModel * p = [[ConnectModel alloc] init];
    p.myBolck = block;
    [p startFormConnectWithVideoName:name URL:url imageData:imageData];
}
- (void)startFormConnectWithImageName:(NSString *)name URL:(NSString *)defaulturl imageData:(NSData *)imageData
{
    
    NSURL * url = [NSURL URLWithString:defaulturl];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *formLine = @"--0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27";
    NSMutableString *value = [NSMutableString stringWithFormat:@"%@\r\n", formLine];
    //    [value appendFormat:@"Content-Disposition: form-data;\r\n"];
    [value appendFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@.png\"\r\n", name];
    //声明上传文件的格式
    [value appendFormat:@"Content-Type: image/*\r\n\r\n"];
    NSMutableData *data = [NSMutableData dataWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:imageData];
    [data appendData:[[NSString stringWithFormat:@"\r\n%@--", formLine] dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"value ====== %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [request setHTTPBody:data];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27"];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
- (void)startFormConnectWithVideoName:(NSString *)name URL:(NSString *)defaulturl imageData:(NSData *)imageData
{
    NSURL * url = [NSURL URLWithString:defaulturl];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *formLine = @"--0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27";
    NSMutableString *value = [NSMutableString stringWithFormat:@"%@\r\n", formLine];
    //    [value appendFormat:@"Content-Disposition: form-data;\r\n"];
    [value appendFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@.mp3\"\r\n", name];
    //声明上传文件的格式
    [value appendFormat:@"Content-Type: audio/mp3/*\r\n\r\n"];
    NSMutableData *data = [NSMutableData dataWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:imageData];
    [data appendData:[[NSString stringWithFormat:@"\r\n%@--", formLine] dataUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"value ====== %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [request setHTTPBody:data];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27"];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}
//+ (void)uploadWithVideoName:(NSString *)name imageData:(NSData *)imageData URL:(NSString *)url finish:(ConnectBlock)block
//{
//    ConnectModel * p = [[ConnectModel alloc] init];
//    p.myBolck = block;
//    [p startFormConnectWithVideoName:name URL:url imageData:imageData];
//}
//- (void)startFormConnectWithImageName:(NSString *)name URL:(NSString *)defaulturl imageData:(NSData *)imageData
//{
//    
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PICURL, defaulturl]];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    NSString *formLine = @"--0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27";
//    NSMutableString *value = [NSMutableString stringWithFormat:@"%@\r\n", formLine];
////    [value appendFormat:@"Content-Disposition: form-data;\r\n"];
//    [value appendFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@.png\"\r\n", name];
//        //声明上传文件的格式
//    [value appendFormat:@"Content-Type: image/*\r\n\r\n"];
//    NSMutableData *data = [NSMutableData dataWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:imageData];
//    [data appendData:[[NSString stringWithFormat:@"\r\n%@--", formLine] dataUsingEncoding:NSUTF8StringEncoding]];
////    NSLog(@"value ====== %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    [request setHTTPBody:data];
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27"];
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    [NSURLConnection connectionWithRequest:request delegate:self];
//}
//- (void)startFormConnectWithVideoName:(NSString *)name URL:(NSString *)defaulturl imageData:(NSData *)imageData
//{
//    
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PICURL, defaulturl]];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    NSString *formLine = @"--0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27";
//    NSMutableString *value = [NSMutableString stringWithFormat:@"%@\r\n", formLine];
//    //    [value appendFormat:@"Content-Disposition: form-data;\r\n"];
//    [value appendFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@.mov\"\r\n", name];
//    //声明上传文件的格式
//    [value appendFormat:@"Content-Type: mov/*\r\n\r\n"];
//    NSMutableData *data = [NSMutableData dataWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:imageData];
//    [data appendData:[[NSString stringWithFormat:@"\r\n%@--", formLine] dataUsingEncoding:NSUTF8StringEncoding]];
//    //    NSLog(@"value ====== %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    [request setHTTPBody:data];
//    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",@"0xKhTmLbOuNdArY-44DF1AB4-7622-4163-948C-8A1FEADDBF27"];
//    [request setValue:content forHTTPHeaderField:@"Content-Type"];
//    [NSURLConnection connectionWithRequest:request delegate:self];
//}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_myData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.myBolck(_myData);
}


@end
