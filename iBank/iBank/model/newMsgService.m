//
//  newMsgService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "newMsgService.h"
#import "dataHelper.h"

@implementation newMsgService


- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/CheckNewMsg";
    }
    return self;
}


- (void)request
{
    NSMutableString *soapBody = [[NSMutableString alloc] initWithCapacity:0];
    [soapBody appendString:@"<CheckNewMsg xmlns=\"urn:AuthControllerwsdl\">"];
    [soapBody appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>", [dataHelper helper].sessionid];
    [soapBody appendString:@"</CheckNewMsg>"];
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


/*
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body>
 <KeepAlive xmlns="urn:AuthControllerwsdl"><sid xsi:type="xsd:string">3c5d37d-e59b-4dba-804d-3126d6d844ac</sid></KeepAlive>
 </soap:Body>
 </soap:Envelope>
 2015-04-21 08:18:51.880 iBank[1460:20703] -[wbConn connection:didReceiveResponse:],url:
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth/api?ws=1
 2015-04-21 08:18:51.880 iBank[1460:20703] -[wbConn connection:didReceiveData:]
 2015-04-21 08:18:51.880 iBank[1460:20703] -[wbConn connectionDidFinishLoading:], response:
 <?xml version="1.0" encoding="UTF-8"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:KeepAliveResponse><return xsi:type="xsd:string">{"result":1,"data":"update has failed"}</return></ns1:KeepAliveResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>
 
 
 json:
 {"result":1,"data":"update has failed"}
 2015-04-21 08:20:22.727 iBank[1460:20703] soap:
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body>
 <CheckNewMsg xmlns="urn:AuthControllerwsdl"><sid xsi:type="xsd:string">3c5d37d-e59b-4dba-804d-3126d6d844ac</sid></CheckNewMsg>
 </soap:Body>
 </soap:Envelope>
 2015-04-21 08:20:23.032 iBank[1460:20703] -[wbConn connection:didReceiveResponse:],url:
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth/api?ws=1
 2015-04-21 08:20:23.033 iBank[1460:20703] -[wbConn connection:didReceiveData:]
 2015-04-21 08:20:23.033 iBank[1460:20703] -[wbConn connectionDidFinishLoading:], response:
 exception 'yii\base\ErrorException' with message 'Procedure 'CheckNewMsg' not present' in /srv/www/dev/ibank/test/vendor/mongosoft/yii2-soap-server/Service.php:166
 Stack trace:
 #0 [internal function]: yii\base\ErrorHandler->handleFatalError()
 #1 {main}
 
 json:
 2015-04-21 08:21:18.120 iBank[1460:20703] soap:
 <?xml version="1.0" encoding="utf-8"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body>
 <SignOut xmlns="urn:AuthControllerwsdl"><sid xsi:type="xsd:string">3c5d37d-e59b-4dba-804d-3126d6d844ac</sid><dev xsi:type="xsd:string">mypad</dev><ip xsi:type="xsd:string">192.168.10.1</ip></SignOut>
 </soap:Body>
 </soap:Envelope>
 2015-04-21 08:21:18.476 iBank[1460:20703] -[wbConn connection:didReceiveResponse:],url:
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth/api?ws=1
 2015-04-21 08:21:18.476 iBank[1460:20703] -[wbConn connection:didReceiveData:]
 2015-04-21 08:21:18.476 iBank[1460:20703] -[wbConn connectionDidFinishLoading:], response:
 <?xml version="1.0" encoding="UTF-8"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><ns1:SignOutResponse><return xsi:type="xsd:string">{"result":-1,"data":"other errors"}</return></ns1:SignOutResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>
 
 
 json:
 {"result":-1,"data":"other errors"}
 
 */

@end
