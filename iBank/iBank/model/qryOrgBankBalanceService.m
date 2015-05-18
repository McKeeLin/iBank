//
//  qryOrgBankBalanceService.m
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

/*
 http://222.49.117.9/ibankbizdev/index.php/ibankbiz/qry-acct
 
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:QryAcctControllerwsdl" xmlns:types="urn:QryAcctControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:qryOrgBankBalance>
 <sid xsi:type="xsd:string">350190cc-e866-4167-8130-94ab8ae5f6bc</sid>
 <AYear xsi:type="xsd:string">2015</AYear>
 <APeriod xsi:type="xsd:string">05</APeriod>
 </tns:qryOrgBankBalance>
 </soap:Body>
 </soap:Envelope>
 
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:1743
 Content-Type:text/xml; charset=utf-8
 Date:Fri, 01 May 2015 12:32:40 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:QryAcctControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryOrgBankBalanceResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"org_sname":"超数集团","organ_id":"1","bank_sname":"中国银行","bank_id":"1","currency_code":"RMB","currency_symbol":"￥","balance":"0.00"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"中国银行","bank_id":"1","currency_code":"USD","currency_symbol":"$","balance":"0.00"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"工商银行","bank_id":"2","currency_code":"RMB","currency_symbol":"￥","balance":"0.00"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"建设银行","bank_id":"4","currency_code":"RMB","currency_symbol":"￥","balance":"0.00"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"中国银行","bank_id":"1","currency_code":"RMB","currency_symbol":"￥","balance":"0.00"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"中国银行","bank_id":"1","currency_code":"USD","currency_symbol":"$","balance":"0.00"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"工商银行","bank_id":"2","currency_code":"RMB","currency_symbol":"￥","balance":"0.00"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"招商银行","bank_id":"6","currency_code":"RMB","currency_symbol":"￥","balance":"0.00"}]}</return>
 </ns1:qryOrgBankBalanceResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

#import "qryOrgBankBalanceService.h"
#import "dataHelper.h"
#import "Utility.h"

@implementation qryOrgBankBalanceService

- (instancetype)init
{
    self = [super init];
    if( self ){
        //self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/qry-acct/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:QryAcctControllerwsdl/qryOrgBankBalance";
        self.package = @"ibankbiz/qry-acct";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:qryOrgBankBalance>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AYear xsi:type=\"xsd:string\">%@</AYear>\n", self.year];
    [body appendFormat:@"<APeriod xsi:type=\"xsd:string\">%@</APeriod>\n", self.month];
    [body appendString:@"</tns:qryOrgBankBalance>"];
    self.soapBody = body;
    [super request];
}

- (void)parseResult:(NSString *)result
{
    NSDictionary *dict = [Utility dictionaryWithJsonString:result];
    NSNumber *code;
    id data;
    if( dict ){
        code = [dict objectForKey:@"result"];
        data = [dict objectForKey:@"data"];
    }
    if( self.qryOrgBankBalanceBlock ){
        self.qryOrgBankBalanceBlock( code.intValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.qryOrgBankBalanceBlock ){
        self.qryOrgBankBalanceBlock( 99, @"无法连接服务器！" );
    }
}

@end
