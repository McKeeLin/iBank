//
//  newMsgService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "newMsgService.h"
#import "dataHelper.h"

/*
http://222.49.117.9/ibankdev/index.php/ibankbiz/user-msg
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:UserMsgControllerwsdl" xmlns:types="urn:UserMsgControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:CheckNewMsg>
 <sid xsi:type="xsd:string">05357713-2dc7-4ca7-90f9-7945108f8edb</sid>
 </tns:CheckNewMsg>
 </soap:Body>
 </soap:Envelope>
 
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Content-Length:547
 Content-Type:text/xml; charset=utf-8
 Date:Tue, 28 Apr 2015 23:13:02 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:UserMsgControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:CheckNewMsgResponse>
 <return xsi:type="xsd:string">{"result":1,"data":"3,1"}</return>
 </ns1:CheckNewMsgResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 
 */


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



@end
