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
        self.os = @"iOS7.0";
    }
    return self;
}

/*
 testtest:      05A671C66AEFEA124CC08B76EA6D30BB
                05a671c66aefea124cc08b76ea6d30bb
 
 adminadmin:    F6FDFFE48C908DEB0F4C3BD36C032E72
                f6fdffe48c908deb0f4c3bd36c032e72
 */

- (void)request
{
    NSMutableString *soapBody = [[NSMutableString alloc] initWithCapacity:0];
    [soapBody appendString:@"<SignIn xmlns=\"urn:AuthControllerwsdl\">\n"];
    [soapBody appendFormat:@"<uid xsi:type=\"xsd:string\">%@</uid>\n", self.uid];
    [soapBody appendFormat:@"<pcode xsi:type=\"xsd:string\">%@</pcode>\n", [Utility md5String:[NSString stringWithFormat:@"%@%@", self.uid, self.pcode]]];
    [soapBody appendFormat:@"<qid xsi:type=\"xsd:integer\">%@</qid>\n", self.qid];
    [soapBody appendFormat:@"<vcode xsi:type=\"xsd:string\">%@</vcode>\n", [Utility md5String:self.vcode]];
    [soapBody appendFormat:@"<ctp xsi:type=\"xsd:integer\">%@</ctp>\n", self.ctp];
    [soapBody appendFormat:@"<os xsi:type=\"xsd:string\">%@</os>\n", [dataHelper helper].os];
    [soapBody appendFormat:@"<dev xsi:type=\"xsd:string\">%@</dev>\n", [dataHelper helper].dev];
    [soapBody appendFormat:@"<ip xsi:type=\"xsd:string\">%@</ip>\n", [dataHelper helper].ip];
    [soapBody appendString:@"</SignIn>"];
    self.soapBody = soapBody;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSInteger code = 0;
    NSString *data;
    if( result ){
        NSDictionary *dict = [Utility dictionaryWithJsonString:result];
        NSNumber *num = [dict objectForKey:@"result"];
        code = num.integerValue;
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
