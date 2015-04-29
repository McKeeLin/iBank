//
//  dataHelper.h
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface moneyFlow : NSObject

@property NSString *account;

@property NSString *date;

@property NSString *operType;

@property NSString *account2;

@property NSString *digest;

@property NSString *theBorrow;

@property NSString *theLoan;

@property NSString *total;

@property NSString *comment;

@end


@interface accountData : NSObject

@property NSString *companyName;

@property NSString *companyId;

@property NSString *bankName;

@property NSString *bankId;

@property NSString *account;

@property NSString *currencyType;

@property NSString *total;

@property NSString *comment;

@end


@interface dataHelper : NSObject

@property NSString *host;

@property NSString *sessionid;

@property NSString *dev;

@property NSString *ip;

@property NSString *os;

@property NSString *savedAccount;

@property NSString *savedPassword;

@property NSString *sn;

@property NSMutableArray *focusAccounts;

@property NSMutableArray *accounts;


+ (instancetype)helper;

- (void)clearSavedAccount;

@end
