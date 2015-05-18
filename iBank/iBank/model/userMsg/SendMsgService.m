//
//  SendMsgService.m
//  iBank
//
//  Created by McKee on 15/5/16.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "SendMsgService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 http://222.49.117.9/ibankdev/index.php/ibankbiz/user-msg/api?ws=1
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:UserMsgControllerwsdl" xmlns:types="urn:UserMsgControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:sendMsg>
 <sid xsi:type="xsd:string">a165039f-6ce8-4885-8b7e-50189f63871f</sid>
 <AReceivers xsi:type="xsd:string">2,1</AReceivers>
 <ATitle xsi:type="xsd:string">hello</ATitle>
 <AMsg xsi:type="xsd:string">:) </AMsg>
 <RepID xsi:type="xsd:integer">-1</RepID>
 </tns:sendMsg>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:556
 Content-Type:text/xml; charset=utf-8
 Date:Sat, 16 May 2015 09:07:25 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:UserMsgControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:sendMsgResponse>
 <return xsi:type="xsd:string">{"result":1,"data":"成功发送2消息!"}</return>
 </ns1:sendMsgResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

@implementation SendMsgService



- (instancetype)init
{
    self = [super init];
    if( self ){
        //self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/user-msg/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:UserMsgControllerwsdl/sendMsg";
        self.package = @"ibankbiz/user-msg";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:sendMsg>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AReceivers xsi:type=\"xsd:string\">%@</AReceivers>", _reciverIds];
    [body appendFormat:@"<ATitle xsi:type=\"xsd:string\">%@</ATitle>", _title];
    [body appendFormat:@"<AMsg xsi:type=\"xsd:string\">%@</AMsg>", _msg];
    [body appendFormat:@"<RepID xsi:type=\"xsd:integer\">%d</RepID>", _repId];
    [body appendString:@"</tns:sendMsg>"];
    self.soapBody = body;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code = [dict objectForKey:@"result"];
    NSString *error = [dict objectForKey:@"data"];
    if( _sendMsgBlock ){
        _sendMsgBlock( code.intValue, error );
    }
}

- (void)onError:(NSString *)error
{
    if( _sendMsgBlock ){
        _sendMsgBlock( 99, @"未能连接服务器！" );
    }
}


@end
