//
//  logoutService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "logoutService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:AuthControllerwsdl" xmlns:types="urn:AuthControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:SignOut>
 <sid xsi:type="xsd:string">05357713-2dc7-4ca7-90f9-7945108f8edb</sid>
 <dev xsi:type="xsd:string">iPad Simulator</dev>
 <ip xsi:type="xsd:string">192.168.10.100</ip>
 </tns:SignOut>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Content-Length:546
 Content-Type:text/xml; charset=utf-8
 Date:Tue, 28 Apr 2015 23:20:55 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:SignOutResponse>
 <return xsi:type="xsd:string">{"result":1,"data":"注销成功!"}</return>
 </ns1:SignOutResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 
 */

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
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code;
    NSString *data;
    if( dict ){
        code = [dict objectForKey:@"code"];
        data = [dict objectForKey:@"data"];
        if( code && code.intValue == 1 ){
            [dataHelper helper].users = nil;
        }
    }
    if( self.logoutBlock ){
        self.logoutBlock( code.integerValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.logoutBlock ){
        self.logoutBlock( 99, @"未能连接服务器！" );
    }
}

@end
