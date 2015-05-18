//
//  setFavAcctService.m
//  iBank
//
//  Created by McKee on 15/5/9.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "setFavAcctService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/user-opt/api?ws=1
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:UserOptControllerwsdl" xmlns:types="urn:UserOptControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:setFavAcct>
 <sid xsi:type="xsd:string">36fcfd9a-0bd7-4570-bd7a-16c6b1b212f5</sid>
 <AcctID xsi:type="xsd:integer">1</AcctID>
 <is_Enable xsi:type="xsd:integer">1</is_Enable>
 </tns:setFavAcct>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:563
 Content-Type:text/xml; charset=utf-8
 Date:Sat, 09 May 2015 01:34:33 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:UserOptControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:setFavAcctResponse>
 <return xsi:type="xsd:string">{"result":1,"data":"已设置关注状态"}</return>
 </ns1:setFavAcctResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

@implementation setFavAcctService

- (instancetype)init
{
    self = [super init];
    if( self )
    {
        //self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/user-opt/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:UserOptControllerwsdl/setFavAcct";
        self.package = @"ibankbiz/user-opt";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:setFavAcct>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AcctID xsi:type=\"xsd:integer\">%d</AcctID>\n", self.accountId];
    [body appendFormat:@"<is_Enable xsi:type=\"xsd:integer\">%d</is_Enable>\n", self.favorite];
    [body appendString:@"</tns:setFavAcct>"];
    self.soapBody = body;
    [super request];
}


- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code;
    NSString *data;
    if( dict ){
        code = [dict objectForKey:@"result"];
        data = [dict objectForKey:@"data"];
    }
    if( self.setFavAcctBlock ){
        self.setFavAcctBlock( code.intValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.setFavAcctBlock ){
        self.setFavAcctBlock( 99, @"无法连接服务器！" );
    }
}



@end
