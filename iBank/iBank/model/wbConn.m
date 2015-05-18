//
//  wbConn.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"
#import "dataHelper.h"

@implementation wbConn
{
    NSURLConnection *_conn;
    NSMutableData *_datas;
}

- (instancetype)init
{
    self = [super init];
    if( self )
    {
        _datas = [[NSMutableData alloc] initWithCapacity:0];
    }
    return self;
}


- (void)parseResult:(NSString*)result
{
    ;
}

- (void)onError:(NSString *)error
{
    ;
}


/*
 <?xml version="1.0" encoding="utf-16"?>
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="urn:AuthControllerwsdl" xmlns:types="urn:AuthControllerwsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
 <tns:reqVerifyMsg />
 </soap:Body>
 </soap:Envelope>
 */

- (void)request
{
    if( !self.url || self.url.length == 0 )
    {
        self.url = [NSString stringWithFormat:@"%@/%@/%@/api?ws=1", [dataHelper helper].host, [dataHelper helper].site, self.package];
    }
    NSLog(@"request:%@", self.url);
    NSMutableString *soap = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"];
    [soap appendString:@"<soap:Envelope "];
    [soap appendString:@"xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""];
    [soap appendString:@"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "];
    [soap appendString:@"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n"];
    [soap appendString:@"<soap:Body>\n"];
    [soap appendString:self.soapBody];
    [soap appendString:@"\n</soap:Body>\n"];
    [soap appendString:@"</soap:Envelope>\n"];
    NSLog(@"soap:\n%@", soap);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soap length]];
    [request setValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue: self.soapAction forHTTPHeaderField:@"SOAPAction"];
    [request setValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soap dataUsingEncoding:NSUTF8StringEncoding]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_datas setLength:0];
    NSLog(@"%s,url:\n%@", __func__, self.url);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_datas appendData:data];
    NSLog(@"%s", __func__);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:_datas encoding:NSUTF8StringEncoding];
    NSString *startTag = @"<return xsi:type=\"xsd:string\">";
    NSString *endTag = @"</return>";
    NSString *json = @"";
    NSRange startRange = [response rangeOfString:startTag];
    NSRange endRange = [response rangeOfString:endTag];
    if( startRange.location != NSNotFound && endRange.location != NSNotFound )
    {
        NSInteger location = startRange.location + startRange.length;
        NSInteger length = endRange.location - location;
        json = [response substringWithRange:NSMakeRange(location, length)];
    }
    NSLog(@"%s, response:\n%@\n\njson:\n%@", __func__, response, json);
    [self parseResult:json];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s,%@", __func__, error.localizedDescription);
    [self onError:error.localizedDescription];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"%s", __func__);
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"%s", __func__);
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

/*
//使用私有证书验证
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    static CFArrayRef certs;
    if (!certs) {
        NSData *certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"srca" ofType:@"cer"]];
        SecCertificateRef rootcert =SecCertificateCreateWithData(kCFAllocatorDefault,CFBridgingRetain(certData));
        const void *array[1] = { rootcert };
        certs = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
        CFRelease(rootcert);    // for completeness, really does not matter
    }
    
    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
    int err;
    SecTrustResultType trustResult = 0;
    err = SecTrustSetAnchorCertificates(trust, certs);
    if (err == noErr) {
        err = SecTrustEvaluate(trust,&trustResult);
    }
    CFRelease(trust);
    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed)||(trustResult == kSecTrustResultConfirm) || (trustResult == kSecTrustResultUnspecified));
    
    if (trusted) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }else{
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}
 */
@end
