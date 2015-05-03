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

@implementation qryBankOrgAcctService

@end
