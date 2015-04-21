//
//  keepAliveService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "keepAliveService.h"
#import "dataHelper.h"

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
    ;
}

- (void)onError:(NSString *)error
{
    ;
}

@end
