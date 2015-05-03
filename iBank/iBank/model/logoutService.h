//
//  logoutService.h
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"


typedef void (^LOGOUT_BLOCK) (NSInteger code, NSString *data);


@interface logoutService : wbConn

@property (strong) LOGOUT_BLOCK logoutBlock;

@end
