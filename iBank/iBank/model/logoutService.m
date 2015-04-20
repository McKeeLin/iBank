//
//  logoutService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "logoutService.h"
#import "dataHelper.h"

@implementation logoutService

- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/SignOut";
    }
    return self;
}

- (void)request
{
    NSMutableString *soapBody = [[NSMutableString alloc] initWithCapacity:0];
    [soapBody appendString:@"<SignOut xmlns=\"urn:AuthControllerwsdl\">"];
    [soapBody appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>", [dataHelper helper].sessionid];
    [soapBody appendFormat:@"<dev xsi:type=\"xsd:string\">%@</dev>", [dataHelper helper].dev];
    [soapBody appendFormat:@"<ip xsi:type=\"xsd:string\">%@</ip>", [dataHelper helper].ip];
    [soapBody appendString:@"</SignOut>"];
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
