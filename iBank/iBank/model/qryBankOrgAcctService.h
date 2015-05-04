//
//  qryBankOrgAcct.h
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void (^QRY_BANK_ORG_ACCT_BLOCK) (int code, id data);



@interface bankObj : NSObject

@property NSString *name;

@property NSString *Id;

@property NSMutableArray *items;

@property CGFloat rmbLastBalance;

@property CGFloat rmbDebit;

@property CGFloat rmbCredit;

@property CGFloat rmbBalance;

@property CGFloat usdLastBalance;

@property CGFloat usdDebit;

@property CGFloat usdBalance;

@property CGFloat usdCredit;

- (void)addItem:(NSDictionary*)item;

@end



@interface qryBankOrgAcctService : wbConn

@property NSString *year;

@property NSString *month;

@property (strong) QRY_BANK_ORG_ACCT_BLOCK qryBankOrgAcctBlock;

@end
