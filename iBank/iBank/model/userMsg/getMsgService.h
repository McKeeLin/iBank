//
//  getMsgService.h
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"
#import "MsgObj.h"

typedef void(^GET_MSG_BLOCK) (int code, id data);

@interface getMsgService : wbConn

@property int msgId;

@property (strong) GET_MSG_BLOCK getMsgBlock;

@end
