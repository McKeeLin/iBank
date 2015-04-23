//
//  keepAliveService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "keepAliveService.h"
#import "dataHelper.h"
#import "Utility.h"

@implementation keepAliveService


- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/KeepAlive";
    }
    return self;
}


- (void)request
{
    NSMutableString *soapBody = [[NSMutableString alloc] initWithCapacity:0];
    [soapBody appendString:@"<KeepAlive xmlns=\"urn:AuthControllerwsdl\">"];
    [soapBody appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>", [dataHelper helper].sessionid];
    [soapBody appendString:@"</KeepAlive>"];
    self.soapBody = soapBody;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSInteger code = 1; //执行结果：0 - 成功 1 - 失败
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *num = [dict objectForKey:@"Result"];
    if( num ) code = num.integerValue;
    NSString *data = [dict objectForKey:@"data"];
    if( self.keepAliveBlock ){
        self.keepAliveBlock( code, data );
    }
}

- (void)onError:(NSString *)error
{
    ;
}

@end
