
#import <Foundation/Foundation.h>
#import "ApiXml.h"
#import "CommonCrypto/CommonDigest.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
/*
 XML 解析库
 */
@implementation XMLHelper
-(void) startParse:(NSData *)data{

    dictionary =[NSMutableDictionary dictionary];
    contentString=[NSMutableString string];
    
    //Demo XML解析实例
    xmlElements = [[NSMutableArray alloc] init];
    
    xmlParser = [[NSXMLParser alloc] initWithData:data];

    [xmlParser setDelegate:self];
    [xmlParser parse];
    
}
-(NSMutableDictionary*) getDict{
    return dictionary;
}
//解析文档开始
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //NSLog(@"解析文档开始");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //NSLog(@"遇到启始标签:%@",elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"遇到内容:%@",string);
    [contentString setString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"遇到结束标签:%@",elementName);
    
    if( ![contentString isEqualToString:@"\n"] && ![elementName isEqualToString:@"root"]){
        [dictionary setObject: [contentString copy] forKey:elementName];
        //NSLog(@"%@=%@",elementName, contentString);
    }
}


#pragma mark ---  http 请求
-(NSData *) httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    //设置提交方式
    [request setHTTPMethod:method];
    //设置数据类型
    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    //设置编码
    [request setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    //如果是POST
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    return response;
    //return [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
}

-(NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    sign = [self createMd5Sign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}
#pragma mark ---  创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%s", "risF2owP8yAdmZgfVYnmqZoElIpD5Bz1"];
    NSLog(@"%@",contentString);
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    //输出Debug Info
    //    [self.debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}
#pragma mark ---  将字符串进行MD5加密，返回加密后的字符串
-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

//解析文档结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"文档解析结束");
    [xmlElements release];
    [xmlParser release];
}

@end