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

@implementation bankAccountObj
@end

@implementation bankOrgObj
@end



@interface bankObj ()
{
}

@end

@implementation bankObj

- (instancetype)init
{
    self = [super init];
    if( self ){
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    if( self ){
        _name = [dict objectForKey:@"bank"];
        _Id = [dict objectForKey:@"bid"];
        _orgs = [[NSMutableArray alloc] initWithCapacity:0];
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
    NSString *orgId = [item objectForKey:@"oid"];
    
    bankOrgObj *foundOrg;
    for( bankOrgObj *org in _orgs ){
        if( [org.orgId isEqualToString:orgId] ){
            foundOrg = org;
            break;
        }
    }
    if( !foundOrg ){
        foundOrg = [[bankOrgObj alloc] init];
        foundOrg.orgId = orgId;
        foundOrg.orgName = [item objectForKey:@"org"];
        foundOrg.accounts = [[NSMutableArray alloc] initWithCapacity:0];
        [_orgs addObject:foundOrg];
    }
    
    NSNumber *aid = [item objectForKey:@"aid"];
    bankAccountObj *account = [[bankAccountObj alloc] init];
    account.accountId = aid.intValue;
    account.account = [item objectForKey:@"acct"];
    account.bank = [item objectForKey:@"bank"];
    account.org = [item objectForKey:@"org"];
    account.ccode = [item objectForKey:@"ccode"];
    account.desc = [item objectForKey:@"desc"];
    account.currencyType = currencyCode;
    account.balance = balance.floatValue;
    account.credit = credit_amount.floatValue;
    account.debit = debit_amount.floatValue;
    account.lastBalance = last_balance.floatValue;
    if( [currencyCode isEqualToString:@"RMB"] ){
        if( !foundOrg.rmbSummary ){
            foundOrg.rmbSummary = [[bankAccountObj alloc] init];
            foundOrg.rmbSummary.account = @"RMB";
            foundOrg.rmbSummary.currencyType = @"RMB";
            foundOrg.itemCount++;
            _itemCount++;
        }
        if( !_rmbSummary ){
            _rmbSummary = [[bankAccountObj alloc] init];
            _rmbSummary.account = @"RMB";
            _rmbSummary.currencyType = @"RMB";
        }
        foundOrg.rmbSummary.lastBalance += account.lastBalance;
        foundOrg.rmbSummary.debit += account.debit;
        foundOrg.rmbSummary.credit += account.credit;
        foundOrg.rmbSummary.balance += account.balance;
        
        _rmbSummary.lastBalance += account.lastBalance;
        _rmbSummary.debit += account.debit;
        _rmbSummary.credit += account.credit;
        _rmbSummary.balance += account.balance;
    }
    else{
        if( !foundOrg.usdSummary ){
            foundOrg.usdSummary = [[bankAccountObj alloc] init];
            foundOrg.usdSummary.account = @"USD";
            foundOrg.usdSummary.currencyType = @"USD";
            foundOrg.itemCount++;
            _itemCount++;
        }
        if( !_usdSummary ){
            _usdSummary = [[bankAccountObj alloc] init];
            _usdSummary.account = @"USD";
            _usdSummary.currencyType = @"USD";
        }
        foundOrg.usdSummary.lastBalance += account.lastBalance;
        foundOrg.usdSummary.debit += account.debit;
        foundOrg.usdSummary.credit += account.credit;
        foundOrg.usdSummary.balance += account.balance;

        _usdSummary.lastBalance += account.lastBalance;
        _usdSummary.debit += account.debit;
        _usdSummary.credit += account.credit;
        _usdSummary.balance += account.balance;
    }
    [foundOrg.accounts addObject:account];
    foundOrg.itemCount++;
    _itemCount++;
}

@end



@implementation qryBankOrgAcctService


- (instancetype)init
{
    self = [super init];
    if( self ){
        //self.url = [NSString stringWithFormat:@"%@/ibankbizdev/index.php/ibankbiz/qry-acct/api?ws=1", [dataHelper helper].host];
        self.soapAction = @"urn:QryAcctControllerwsdl/qryBankOrgAcct";
        self.package = @"ibankbiz/qry-acct";
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
