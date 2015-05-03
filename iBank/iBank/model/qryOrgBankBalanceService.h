//
//  qryOrgBankBalanceService.h
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^QUERY_ORG_BANK_BALANCE_BLOCK) (int code, id data);

@interface qryOrgBankBalanceService : wbConn

@property NSString *year;

@property NSString *month;

@property (strong) QUERY_ORG_BANK_BALANCE_BLOCK qryOrgBankBalanceBlock;

@end
