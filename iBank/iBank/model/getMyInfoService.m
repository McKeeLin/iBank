//
//  getMyInfoService.m
//  iBank
//
//  Created by McKee on 15/4/29.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "getMyInfoService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:AuthControllerwsdl" xmlns:types="urn:AuthControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:getMyInfo>
 <sid xsi:type="xsd:string">05357713-2dc7-4ca7-90f9-7945108f8edb</sid>
 </tns:getMyInfo>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:624
 Content-Type:text/xml; charset=utf-8
 Date:Tue, 28 Apr 2015 23:03:32 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:getMyInfoResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"user_no":"9999","user_name":"admin","real_name":"系统管理员","user_avatar":null}]}</return>
 </ns1:getMyInfoResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

@implementation getMyInfoService


- (instancetype)init
{
    self = [super init];
    if( self ){
        //self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/getMyInfo";
        self.package = @"ibankbiz/auth";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:getMyInfo\n>"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendString:@"</tns:getMyInfo>"];
    self.soapBody = body;
    [super request];
}


- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code;
    id data;
    if( dict ){
        code = [dict objectForKey:@"result"];
        data = [dict objectForKey:@"data"];
    }
    if( self.getMyInfoBlock ){
        self.getMyInfoBlock( code.intValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.getMyInfoBlock ){
        self.getMyInfoBlock( 99, @"无法连接服务器！" );
    }
}



@end
