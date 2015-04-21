//
//  wbConn.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

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



@end
