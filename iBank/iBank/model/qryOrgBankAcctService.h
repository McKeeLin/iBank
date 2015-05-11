//
//  qryOrgBankAcct.h
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void (^QRY_ORG_BANK_ACCT_BLOCK) (int code, id data);


@interface orgObj : NSObject

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

@property NSMutableDictionary *rmbItem;

@property NSMutableDictionary *usdItem;

- (void)addItem:(NSDictionary*)item;

@end

@interface qryOrgBankAcctService : wbConn

@property NSString *year;

@property NSString *month;

@property (strong) QRY_ORG_BANK_ACCT_BLOCK qryOrgBankAcctBlock;

@end
