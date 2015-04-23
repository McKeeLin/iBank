//
//  dataHelper.h
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface dataHelper : NSObject

@property NSString *host;

@property NSString *sessionid;

@property NSString *dev;

@property NSString *ip;

@property NSString *os;

@property NSString *savedAccount;

@property NSString *savedPassword;


+ (instancetype)helper;

- (void)clearSavedAccount;

@end
