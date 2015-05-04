//
//  qryAcctDetailService.m
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/qry-acct/api?ws=1
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:QryAcctControllerwsdl" xmlns:types="urn:QryAcctControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:qryAcctDetail>
 <sid xsi:type="xsd:string">27601ce0-fe69-40f5-b3ef-b659df88d398</sid>
 <AYear xsi:type="xsd:string">2015</AYear>
 <APeriod xsi:type="xsd:string">03</APeriod>
 <AcctID xsi:type="xsd:integer">2</AcctID>
 <pNo xsi:type="xsd:integer">1</pNo>
 </tns:qryAcctDetail>
 </soap:Body>
 </soap:Envelope>
 
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:753
 Content-Type:text/xml; charset=utf-8
 Date:Sun, 03 May 2015 15:28:08 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:QryAcctControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryAcctDetailResponse>
 <return xsi:type="xsd:string">{"result":1,"pgCnt":1,"pgNo":1,"fav":true,"data":[{"alineno":0,"arecid":-1,"atrans_date":"2015-02-28","asettle_mode":"","areceipt_name":"","asummary":"上期余额","adebit":"0","acredit":"0","abalance":"0","adescription":""}]}</return>
 </ns1:qryAcctDetailResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

#import "qryAcctDetailService.h"
#import "dataHelper.h"
#import "Utility.h"

@implementation qryAcctDetailService

- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/qry-acct/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:QryAcctControllerwsdl/qryAcctDetail";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:qryAcctDetail>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AYear xsi:type=\"xsd:string\">%@</AYear>\n", self.year];
    [body appendFormat:@"<APeriod xsi:type=\"xsd:string\">%@</APeriod>\n", self.month];
    [body appendFormat:@"<AcctID xsi:type=\"xsd:integer\">%d</AcctID>\n", self.accountId];
    [body appendFormat:@"<pNo xsi:type=\"xsd:integer\">%d</pNo>\n", self.pageNum];
    [body appendString:@"</tns:qryAcctDetail>"];
    self.soapBody = body;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code;
    NSNumber *pageTotal = [NSNumber numberWithInt:-1];
    NSNumber *pageNum = [NSNumber numberWithInt:-1];
    NSNumber *isFavorite = [NSNumber numberWithBool:NO];
    id data;
    if( dict ){
        code = [dict objectForKey:@"result"];
        data = [dict objectForKey:@"data"];
        pageTotal = [dict objectForKey:@"pgCnt"];
        pageNum = [dict objectForKey:@"pgNo"];
        isFavorite = [dict objectForKey:@"fav"];
    }
    if( self.qryAcctDetailBlock ){
        self.qryAcctDetailBlock( code.intValue, pageTotal.intValue, pageNum.intValue, isFavorite.boolValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.qryAcctDetailBlock ){
        self.qryAcctDetailBlock( 99, -1, -1, NO, @"无法连接服务器！" );
    }
}

@end