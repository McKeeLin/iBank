//
//  qryUsersService.m
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "qryUsersService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth/api?ws=1
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:AuthControllerwsdl" xmlns:types="urn:AuthControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:qryUsers>
 <sid xsi:type="xsd:string">35a141df-9785-4ff3-92bf-17df593f9f7c</sid>
 </tns:qryUsers>
 </soap:Body>
 </soap:Envelope>
 
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Content-Length:625
 Content-Type:text/xml; charset=utf-8
 Date:Sun, 10 May 2015 15:09:28 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryUsersResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"id":1,"name":"administrator","avatar":null},{"id":2,"name":"测试帐号","avatar":null}]}</return>
 </ns1:qryUsersResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */



@implementation qryUsersService


- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/qryUsers";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:qryUsers>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendString:@"</tns:qryUsers>"];
    self.soapBody = body;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code = [dict objectForKey:@"result"];
    if( code.intValue == 1 ){
        NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *items = [dict objectForKey:@"data"];
        for( NSDictionary *item in items ){
            UserObj *user = [[UserObj alloc] init];
            user.name = [item objectForKey:@"name"];
            NSString *imageCode = [item objectForKey:@"avatar"];
            if( [imageCode isKindOfClass:[NSString class]] && imageCode.length > 0 ){
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageCode options:NSDataBase64DecodingIgnoreUnknownCharacters];
                user.image = [UIImage imageWithData:imageData];
            }
            NSNumber *userId = [item objectForKey:@"id"];
            if( userId ){
                user.userId = userId.intValue;
            }
            [users addObject:user];
        }
        if( _qryUserBlock ){
            _qryUserBlock( code.intValue, users );
        }
    }
    else{
        if( _qryUserBlock ){
            _qryUserBlock( code.intValue, [dict objectForKey:@"data"] );
        }
    }
}

- (void)onError:(NSString *)error
{
    if( _qryUserBlock ){
        _qryUserBlock( 99, @"未能连接服务器!" );
    }
}


@end
