//
//  qryAcctDetailService.h
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void (^QRY_ACCT_DETAIL_BLOCK)(int code, int pageTotal, int pageNum, BOOL isFavorite, id data, NSString *org);

@interface qryAcctDetailService : wbConn

@property NSString *year;

@property NSString *month;

@property int pageNum;

@property int accountId;

@property (strong) QRY_ACCT_DETAIL_BLOCK qryAcctDetailBlock;

@end
