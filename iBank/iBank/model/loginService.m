//
//  loginService.m
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "loginService.h"
#import "dataHelper.h"
#import "Utility.h"

@implementation loginService

- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/SignIn";
        self.ctp = @"2";
        self.os = @"iOS";
    }
    return self;
}

- (void)request
{
    NSMutableString *soapBody = [[NSMutableString alloc] initWithCapacity:0];
    [soapBody appendString:@"<SignIn xmlns=\"urn:AuthControllerwsdl\">"];
    [soapBody appendFormat:@"<uid xsi:type=\"xsd:string\">%@</uid>", self.uid];
    [soapBody appendFormat:@"<pcode xsi:type=\"xsd:string\">%@</pcode>", [Utility md5String:[NSString stringWithFormat:@"%@+%@", self.uid, self.pcode]]];
    [soapBody appendFormat:@"<qid xsi:type=\"xsd:integer\">%@</qid>", self.qid];
    [soapBody appendFormat:@"<vcode xsi:type=\"xsd:string\">%@</vcode>", self.vcode];
    [soapBody appendFormat:@"<ctp xsi:type=\"xsd:integer\">%@</ctp>", self.ctp];
    [soapBody appendFormat:@"<os xsi:type=\"xsd:string\">%@</os>", self.os];
    [soapBody appendFormat:@"<dev xsi:type=\"xsd:string\">%@</dev>", [dataHelper helper].dev];
    [soapBody appendFormat:@"<ip xsi:type=\"xsd:string\">%@</ip>", [dataHelper helper].ip];
    [soapBody appendString:@"</SignIn>"];
    self.soapBody = soapBody;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSString *code;
    NSString *data;
    if( result ){
        NSDictionary *dict = [Utility dictionaryWithJsonString:result];
        code = [dict objectForKey:@"result"];
        data = [dict objectForKey:@"data"];
    }
    if( self.loginBlock ){
        self.loginBlock( code, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.loginBlock )
    {
        self.loginBlock( 0, error );
    }
}

@end
