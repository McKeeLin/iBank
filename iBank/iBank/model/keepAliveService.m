//
//  keepAliveService.m
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "keepAliveService.h"
#import "dataHelper.h"
#import "Utility.h"

/*
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:AuthControllerwsdl" xmlns:types="urn:AuthControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:KeepAlive>
 <sid xsi:type="xsd:string">05357713-2dc7-4ca7-90f9-7945108f8edb</sid>
 </tns:KeepAlive>
 </soap:Body>
 </soap:Envelope>
 
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Content-Length:542
 Content-Type:text/xml; charset=utf-8
 Date:Tue, 28 Apr 2015 23:01:26 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:KeepAliveResponse>
 <return xsi:type="xsd:string">{"result":"1","data":"3,1"}</return>
 </ns1:KeepAliveResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 
 */


@implementation keepAliveService


- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/auth/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:AuthControllerwsdl/KeepAlive";
    }
    return self;
}


- (void)request
{
    NSMutableString *soapBody = [[NSMutableString alloc] initWithCapacity:0];
    [soapBody appendString:@"<KeepAlive xmlns=\"urn:AuthControllerwsdl\">"];
    [soapBody appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>", [dataHelper helper].sessionid];
    [soapBody appendString:@"</KeepAlive>"];
    self.soapBody = soapBody;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSInteger code = 1; //执行结果：0 - 成功 1 - 失败
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *num = [dict objectForKey:@"Result"];
    if( num ) code = num.integerValue;
    NSString *data = [dict objectForKey:@"data"];
    if( self.keepAliveBlock ){
        self.keepAliveBlock( code, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.keepAliveBlock ){
        self.keepAliveBlock( 99, error );
    }
}



@end
