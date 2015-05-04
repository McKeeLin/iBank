//
//  qryOrgBankAcct.m
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
 <tns:qryOrgBankAcct>
 <sid xsi:type="xsd:string">350190cc-e866-4167-8130-94ab8ae5f6bc</sid>
 <AYear xsi:type="xsd:string">2015</AYear>
 <APeriod xsi:type="xsd:string">04</APeriod>
 </tns:qryOrgBankAcct>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:3387
 Content-Type:text/xml; charset=utf-8
 Date:Fri, 01 May 2015 12:40:25 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:QryAcctControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryOrgBankAcctResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"org_sname":"超数集团","organ_id":"1","bank_sname":"中国银行","bank_id":"1","bank_account":"2201001205452158723","accountid":1,"currency_code":"RMB","currency_symbol":"￥","last_balance":"11290.0000","debit_amount":"2020.0000","credit_amount":"25100.0000","balance":"34370.0000"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"中国银行","bank_id":"1","bank_account":"2201001205452158725","accountid":5,"currency_code":"RMB","currency_symbol":"￥","last_balance":"11490.0000","debit_amount":"2500.0000","credit_amount":"25500.0000","balance":"34490.0000"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"中国银行","bank_id":"1","bank_account":"22010546452158723","accountid":2,"currency_code":"USD","currency_symbol":"$","last_balance":"11340.0000","debit_amount":"2080.0000","credit_amount":"25200.0000","balance":"34460.0000"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"工商银行","bank_id":"2","bank_account":"5300400120545212222","accountid":9,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0.0000","credit_amount":"25900.0000","balance":"25900.0000"},{"org_sname":"超数集团","organ_id":"1","bank_sname":"建设银行","bank_id":"4","bank_account":"17601205452158725","accountid":7,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0.0000","credit_amount":"25700.0000","balance":"25700.0000"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"中国银行","bank_id":"1","bank_account":"2201001205452158603","accountid":6,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"5700.0000","credit_amount":"25600.0000","balance":"19900.0000"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"中国银行","bank_id":"1","bank_account":"2201001205452158605","accountid":3,"currency_code":"RMB","currency_symbol":"￥","last_balance":"11390.0000","debit_amount":"2180.0000","credit_amount":"25300.0000","balance":"34510.0000"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"中国银行","bank_id":"1","bank_account":"22010546452158654","accountid":4,"currency_code":"USD","currency_symbol":"$","last_balance":"11440.0000","debit_amount":"2320.0000","credit_amount":"25400.0000","balance":"34520.0000"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"工商银行","bank_id":"2","bank_account":"17901205452158603","accountid":8,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"6900.0000","credit_amount":"25800.0000","balance":"18900.0000"},{"org_sname":"超数股份","organ_id":"2","bank_sname":"招商银行","bank_id":"6","bank_account":"5301001205452153435","accountid":10,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"4000.0000","credit_amount":"26000.0000","balance":"22000.0000"}]}</return>
 </ns1:qryOrgBankAcctResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 
 */

#import "qryOrgBankAcctService.h"
#import "dataHelper.h"
#import "Utility.h"

@interface orgObj ()
{
    NSMutableDictionary *_rmbItem;
    NSMutableDictionary *_usdItem;
    CGFloat _rmbLastBalance;
    CGFloat _rmbDebit;
    CGFloat _rmbCredit;
    CGFloat _rmbBalance;
    CGFloat _usdLastBalance;
    CGFloat _usdDebit;
    CGFloat _usdBalance;
    CGFloat _usdCredit;
}

@end

@implementation orgObj

- (instancetype)init
{
    self = [super init];
    if( self ){
        _rmbLastBalance = 0.00;
        _rmbDebit = 0.00;
        _rmbCredit = 0.00;
        _rmbLastBalance = 0.00;
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _rmbItem = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_rmbItem setObject:@"0.00" forKey:@"balance"];
        [_rmbItem setObject:@"0.00" forKey:@"credit_amount"];
        [_rmbItem setObject:@"0.00" forKey:@"debit_amount"];
        [_rmbItem setObject:@"0.00" forKey:@"last_balance"];
        [_items addObject:_rmbItem];
        
        _usdItem = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_usdItem setObject:@"0.00" forKey:@"balance"];
        [_usdItem setObject:@"0.00" forKey:@"credit_amount"];
        [_usdItem setObject:@"0.00" forKey:@"debit_amount"];
        [_usdItem setObject:@"0.00" forKey:@"last_balance"];
        [_items addObject:_usdItem];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    if( self ){
        _name = [dict objectForKey:@"org_sname"];
        _Id = [dict objectForKey:@"organ_id"];
    }
    return self;
}

- (void)addItem:(NSDictionary *)item
{
    NSString *currencyCode = [item objectForKey:@"currency_code"];
    NSString *balance = [item objectForKey:@"balance"];
    NSString *credit_amount = [item objectForKey:@"credit_amount"];
    NSString *debit_amount = [item objectForKey:@"debit_amount"];
    NSString *last_balance = [item objectForKey:@"last_balance"];
    if( [currencyCode isEqualToString:@"RMB"] ){
        _rmbLastBalance += last_balance.floatValue;
        _rmbDebit += debit_amount.floatValue;
        _rmbCredit += credit_amount.floatValue;
        _rmbBalance += balance.floatValue;
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbLastBalance] forKey:@"last_balance"];
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbDebit] forKey:@"debit_amount"];
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbCredit] forKey:@"credit_amount"];
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbBalance] forKey:@"balance"];
    }
    else{
        _usdLastBalance += last_balance.floatValue;
        _usdDebit += debit_amount.floatValue;
        _usdCredit += credit_amount.floatValue;
        _usdBalance += balance.floatValue;
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdLastBalance] forKey:@"last_balance"];
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdDebit] forKey:@"debit_amount"];
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdCredit] forKey:@"credit_amount"];
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdBalance] forKey:@"balance"];
    }

    NSInteger index = 0;
    for( NSInteger i = 0; i < self.items.count - 2; i++ ){
        NSDictionary * dict = [self.items objectAtIndex:i];
        if( [[dict objectForKey:@"bank_id"] isEqualToString:[item objectForKey:@"bank_id"]] )
        {
            index = i;
            break;
        }
    }
    [self.items insertObject:item atIndex:index];
}

@end





@implementation qryOrgBankAcctService

- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/qry-acct/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:QryAcctControllerwsdl/qryOrgBankAcct";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:qryOrgBankAcct>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AYear xsi:type=\"xsd:string\">%@</AYear>\n", self.year];
    [body appendFormat:@"<APeriod xsi:type=\"xsd:string\">%@</APeriod>\n", self.month];
    [body appendString:@"</tns:qryOrgBankAcct>"];
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
        if( code.intValue == 1 ){
            NSMutableArray *orgs = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *dicts = (NSArray*)data;
            for( NSDictionary *dict in dicts ){
                NSString *orgId = [dict objectForKey:@"organ_id"];
                orgObj *existOrg;
                for( orgObj *org in orgs ){
                    if( [org.Id isEqualToString:orgId] ){
                        existOrg = org;
                        break;
                    }
                }
                if( !existOrg ){
                    existOrg = [[orgObj alloc] initWithDictionary:dict];
                    [orgs addObject:existOrg];
                }
                [existOrg addItem:dict];
            }
            data = orgs;
        }
    }
    if( self.qryOrgBankAcctBlock ){
        self.qryOrgBankAcctBlock( code.intValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.qryOrgBankAcctBlock ){
        self.qryOrgBankAcctBlock( 99, @"无法连接服务器！" );
    }
}

@end
