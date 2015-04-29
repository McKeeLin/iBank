//
//  getAuthListService.m
//  iBank
//
//  Created by McKee on 15/4/29.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "getAuthListService.h"

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:AuthControllerwsdl" xmlns:types="urn:AuthControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:qryAuthList>
 <sid xsi:type="xsd:string">05357713-2dc7-4ca7-90f9-7945108f8edb</sid>
 </tns:qryAuthList>
 </soap:Body>
 </soap:Envelope>
 
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:681
 Content-Type:text/xml; charset=utf-8
 Date:Tue, 28 Apr 2015 23:06:20 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:AuthControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryAuthListResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"right_id":1100,"is_visible":1,"is_enable":1},{"right_id":1101,"is_visible":1,"is_enable":1},{"right_id":1200,"is_visible":1,"is_enable":1}]}</return>
 </ns1:qryAuthListResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 
 */

@implementation getAuthListService

@end
