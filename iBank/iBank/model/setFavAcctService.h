//
//  setFavAcctService.h
//  iBank
//
//  Created by McKee on 15/5/9.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^SET_FAV_ACCT_BLOCK) (int code, NSString *data);

@interface setFavAcctService : wbConn

@property int accountId;

@property BOOL favorite;

@property (strong) SET_FAV_ACCT_BLOCK setFavAcctBlock;

@end
