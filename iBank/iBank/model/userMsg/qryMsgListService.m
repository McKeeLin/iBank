//
//  qryMsgListService.m
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "qryMsgListService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/user-msg/api?ws=1
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:UserMsgControllerwsdl" xmlns:types="urn:UserMsgControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:qryMsgList>
 <sid xsi:type="xsd:string">35a141df-9785-4ff3-92bf-17df593f9f7c</sid>
 <AType xsi:type="xsd:integer">0</AType>
 <ACount xsi:type="xsd:integer">5</ACount>
 </tns:qryMsgList>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Content-Length:968
 Content-Type:text/xml; charset=utf-8
 Date:Sun, 10 May 2015 12:51:16 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:UserMsgControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryMsgListResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"id":9,"sender":"administrator","time":null,"msg":"test"},{"id":2,"sender":"测试帐号","time":"2015-04-27 22:07:56.73","msg":"来自test的通知"},{"id":4,"sender":"administrator","time":"2015-04-27 22:07:56.73","msg":"公告"},{"id":8,"sender":"administrator","time":"2015-04-27 22:07:56.73","msg":"来自Admin的通知"},{"id":1,"sender":"测试帐号","time":"2015-04-27 22:07:56.73","msg":"来自test的小道消息"}]}</return>
 </ns1:qryMsgListResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */



@implementation qryMsgListService



- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/user-msg/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:UserMsgControllerwsdl/qryMsgList";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:qryMsgList>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AType xsi:type=\"xsd:integer\">%d</AType>\n",_type];
    [body appendFormat:@"<ACount xsi:type=\"xsd:integer\">%d</ACount>\n",_count];
    [body appendString:@"</tns:qryMsgList>"];
    self.soapBody = body;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code = [dict objectForKey:@"result"];
    if( code.integerValue == 1 ){
        NSArray *items = [dict objectForKey:@"data"];
        _msgs = [[NSMutableArray alloc] initWithCapacity:0];
        for( NSDictionary *item in items ){
            MsgObj *msg = [[MsgObj alloc] init];
            NSNumber *msgId = [item objectForKey:@"id"];
            msg.msgId = msgId.intValue;
            msg.sender = [item objectForKey:@"sender"];
            msg.time = [item objectForKey:@"time"];
            msg.title = [item objectForKey:@"msg"];
            [_msgs addObject:msg];
        }
        if( _qryMsgListBlock ){
            _qryMsgListBlock( code.intValue, _msgs );
        }
    }
    else{
        if( _qryMsgListBlock ){
            _qryMsgListBlock( code.intValue, [dict objectForKey:@"data"] );
        }
    }
}

- (void)onError:(NSString *)error
{
    if( _qryMsgListBlock ){
        _qryMsgListBlock( 99, @"未能连接服务器!" );
    }
}


@end
