//
//  qryBankOrgAcct.h
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void (^QRY_BANK_ORG_ACCT_BLOCK) (int code, id data);


@interface bankAccountObj : NSObject

@property NSString *account;

@property NSString *desc;

@property NSString *currencyType;

@property CGFloat lastBalance;

@property CGFloat debit;

@property CGFloat credit;

@property CGFloat balance;

@end

@interface bankOrgObj : NSObject

@property NSString *orgId;

@property NSString *orgName;

@property NSMutableArray *accounts;

@property bankAccountObj *rmbSummary;

@property bankAccountObj *usdSummary;

@property int itemCount;

@end

@interface bankObj : NSObject

@property NSString *name;

@property NSString *Id;

@property NSMutableArray *orgs;

@property bankAccountObj *rmbSummary;

@property bankAccountObj *usdSummary;

@property int itemCount;

- (void)addItem:(NSDictionary*)item;

@end



@interface qryBankOrgAcctService : wbConn

@property NSString *year;

@property NSString *month;

@property (strong) QRY_BANK_ORG_ACCT_BLOCK qryBankOrgAcctBlock;

@end
