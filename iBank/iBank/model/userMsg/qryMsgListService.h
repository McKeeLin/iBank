//
//  qryMsgListService.h
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"
#import "MsgObj.h"

typedef void(^QRY_MSGLIST_BLOCK) (int code, id data);


@interface qryMsgListService : wbConn

@property int type;

@property int count;

@property NSMutableArray *msgs;

@property (strong) QRY_MSGLIST_BLOCK qryMsgListBlock;

@end
