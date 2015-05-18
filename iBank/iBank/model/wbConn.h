//
//  wbConn.h
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface wbConn : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic) NSString *package;

@property (nonatomic) NSString *url;

@property (nonatomic) NSString *soapBody;

@property (nonatomic) NSString *soapAction;

@property (nonatomic) NSString *nameSpace;

@property (nonatomic) NSString *method;

@property (nonatomic) NSDictionary *params;

- (void)request;

- (void)parseResult:(NSString*)result;

- (void)onError:(NSString*)error;

@end
