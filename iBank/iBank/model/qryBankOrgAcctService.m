//
//  qryBankOrgAcct.m
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
 <tns:qryBankOrgAcct>
 <sid xsi:type="xsd:string">350190cc-e866-4167-8130-94ab8ae5f6bc</sid>
 <AYear xsi:type="xsd:string">15</AYear>
 <APeriod xsi:type="xsd:string">04</APeriod>
 </tns:qryBankOrgAcct>
 </soap:Body>
 </soap:Envelope>
 
 ResponseCode: 200 (OK)
 Vary:Accept-Encoding
 Keep-Alive:timeout=3, max=100
 Connection:Keep-Alive
 Content-Length:3088
 Content-Type:text/xml; charset=utf-8
 Date:Fri, 01 May 2015 12:43:29 GMT
 Server:Apache/2.2.22 (Ubuntu)
 X-Powered-By:PHP/5.4.39-1+deb.sury.org~precise+2
 
 <?xml version="1.0" encoding="utf-16"?>
 <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:QryAcctControllerwsdl" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <SOAP-ENV:Body>
 <ns1:qryBankOrgAcctResponse>
 <return xsi:type="xsd:string">{"result":1,"data":[{"bank_sname":"中国银行","bank_id":"1","org_sname":"超数集团","organ_id":"1","bank_account":"2201001205452158723","accountid":1,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"中国银行","bank_id":"1","org_sname":"超数集团","organ_id":"1","bank_account":"2201001205452158725","accountid":5,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"中国银行","bank_id":"1","org_sname":"超数集团","organ_id":"1","bank_account":"22010546452158723","accountid":2,"currency_code":"USD","currency_symbol":"$","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"中国银行","bank_id":"1","org_sname":"超数股份","organ_id":"2","bank_account":"2201001205452158603","accountid":6,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"中国银行","bank_id":"1","org_sname":"超数股份","organ_id":"2","bank_account":"2201001205452158605","accountid":3,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"中国银行","bank_id":"1","org_sname":"超数股份","organ_id":"2","bank_account":"22010546452158654","accountid":4,"currency_code":"USD","currency_symbol":"$","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"工商银行","bank_id":"2","org_sname":"超数集团","organ_id":"1","bank_account":"5300400120545212222","accountid":9,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"工商银行","bank_id":"2","org_sname":"超数股份","organ_id":"2","bank_account":"17901205452158603","accountid":8,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"建设银行","bank_id":"4","org_sname":"超数集团","organ_id":"1","bank_account":"17601205452158725","accountid":7,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"},{"bank_sname":"招商银行","bank_id":"6","org_sname":"超数股份","organ_id":"2","bank_account":"5301001205452153435","accountid":10,"currency_code":"RMB","currency_symbol":"￥","last_balance":"0","debit_amount":"0","credit_amount":"0","balance":"0"}]}</return>
 </ns1:qryBankOrgAcctResponse>
 </SOAP-ENV:Body>
 </SOAP-ENV:Envelope>
 */

#import "qryBankOrgAcctService.h"
#import "Utility.h"
#import "dataHelper.h"



@interface bankObj ()
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

@implementation bankObj

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
        [_rmbItem setObject:@"0.00" forKey:@"thisb"];
        [_rmbItem setObject:@"0.00" forKey:@"credit"];
        [_rmbItem setObject:@"0.00" forKey:@"debit"];
        [_rmbItem setObject:@"0.00" forKey:@"lastb"];
        [_items addObject:_rmbItem];
        
        _usdItem = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_usdItem setObject:@"0.00" forKey:@"thisb"];
        [_usdItem setObject:@"0.00" forKey:@"credit"];
        [_usdItem setObject:@"0.00" forKey:@"debit"];
        [_usdItem setObject:@"0.00" forKey:@"lastb"];
        [_items addObject:_usdItem];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    if( self ){
        _name = [dict objectForKey:@"bank"];
        _Id = [dict objectForKey:@"bid"];
    }
    return self;
}

- (void)addItem:(NSDictionary *)item
{
    NSString *currencyCode = [item objectForKey:@"ccode"];
    NSString *balance = [item objectForKey:@"thisb"];
    NSString *credit_amount = [item objectForKey:@"credit"];
    NSString *debit_amount = [item objectForKey:@"debit"];
    NSString *last_balance = [item objectForKey:@"lastb"];
    if( [currencyCode isEqualToString:@"RMB"] ){
        _rmbLastBalance += last_balance.floatValue;
        _rmbDebit += debit_amount.floatValue;
        _rmbCredit += credit_amount.floatValue;
        _rmbBalance += balance.floatValue;
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbLastBalance] forKey:@"lastb"];
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbDebit] forKey:@"debit"];
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbCredit] forKey:@"credit"];
        [_rmbItem setObject:[NSString stringWithFormat:@"%.02f", _rmbBalance] forKey:@"thisb"];
    }
    else{
        _usdLastBalance += last_balance.floatValue;
        _usdDebit += debit_amount.floatValue;
        _usdCredit += credit_amount.floatValue;
        _usdBalance += balance.floatValue;
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdLastBalance] forKey:@"lastb"];
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdDebit] forKey:@"debit"];
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdCredit] forKey:@"credit"];
        [_usdItem setObject:[NSString stringWithFormat:@"%.02f", _usdBalance] forKey:@"thisb"];
    }
    
    NSInteger index = 0;
    for( NSInteger i = 0; i < self.items.count - 2; i++ ){
        NSDictionary * dict = [self.items objectAtIndex:i];
        if( [[dict objectForKey:@"oid"] isEqualToString:[item objectForKey:@"oid"]] )
        {
            index = i;
            break;
        }
    }
    [self.items insertObject:item atIndex:index];
}

@end



@implementation qryBankOrgAcctService


- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/qry-acct/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:QryAcctControllerwsdl/qryBankOrgAcct";
    }
    return self;
}

- (void)request
{
    NSMutableString *body = [[NSMutableString alloc] initWithCapacity:0];
    [body appendString:@"<tns:qryBankOrgAcct>\n"];
    [body appendFormat:@"<sid xsi:type=\"xsd:string\">%@</sid>\n",[dataHelper helper].sessionid];
    [body appendFormat:@"<AYear xsi:type=\"xsd:string\">%@</AYear>\n", self.year];
    [body appendFormat:@"<APeriod xsi:type=\"xsd:string\">%@</APeriod>\n", self.month];
    [body appendString:@"</tns:qryBankOrgAcct>"];
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
            NSMutableArray *banks = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *dicts = (NSArray*)data;
            for( NSDictionary *dict in dicts ){
                NSString *bankId = [dict objectForKey:@"bid"];
                bankObj *existBank;
                for( bankObj *bank in banks ){
                    if( [bank.Id isEqualToString:bankId] ){
                        existBank = bank;
                        break;
                    }
                }
                if( !existBank ){
                    existBank = [[bankObj alloc] initWithDictionary:dict];
                    [banks addObject:existBank];
                }
                [existBank addItem:dict];
            }
            data = banks;
        }
    }
    if( self.qryBankOrgAcctBlock ){
        self.qryBankOrgAcctBlock( code.intValue, data );
    }
}

- (void)onError:(NSString *)error
{
    if( self.qryBankOrgAcctBlock ){
        self.qryBankOrgAcctBlock( 99, @"无法连接服务器！" );
    }
}

@end
