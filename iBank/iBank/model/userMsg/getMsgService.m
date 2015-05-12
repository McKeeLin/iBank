//
//  getMsgService.m
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "getMsgService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/user-msg/api?ws=1
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:UserMsgControllerwsdl" xmlns:types="urn:UserMsgControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:getMsg>
 <sid xsi:type="xsd:string">35a141df-9785-4ff3-92bf-17df593f9f7c</sid>
 <AMsgID xsi:type="xsd:integer">8</AMsgID>
 </tns:getMsg>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:711
 Content-Type:text/xml; charset=utf-8
 Date:Sun, 10 May 2015 12:57:48 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:UserMsgControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:getMsgResponse>
 <return xsi:type="xsd:string">{"result":1,"data":{"id":8,"type":1,"state":0,"sender":"administrator","recv":"administrator","time":"2015-04-27 22:07:56.73","title":"来自Admin的通知","msg":"今天下午15:00开小组会议"}}</return>
 </ns1:getMsgResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

@implementation getMsgService



- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@//api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendString:@"</tns:>"];
    self.soapBody = body;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code;
}

- (void)onError:(NSString *)error
{
}


@end
