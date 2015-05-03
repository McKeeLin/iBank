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

@implementation qryOrgBankAcctService

@end
