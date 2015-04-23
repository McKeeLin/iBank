//
//  keepAliveService.h
//  iBank
//
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^KEEP_ALIVE_BLOCK) (NSInteger code, NSString *data);

@interface keepAliveService : wbConn

@property (strong) KEEP_ALIVE_BLOCK keepAliveBlock;

@end
