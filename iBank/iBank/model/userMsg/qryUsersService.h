//
//  qryUsersService.h
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^QRY_USERS_BLOCK) (int code, id data);

@interface qryUsersService : wbConn

@property (strong) QRY_USERS_BLOCK qryUserBlock;

@end
