//
//  qryMsgListService.h
//  iBank
//
//  Created by McKee on 15/5/10.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^QRY_MSGLIST_BLOCK) (int code, id data);

@interface MsgObj : NSObject

@property int msgId;

@property NSString *sender;

@property NSString *title;

@property NSString *time;

@end



@interface qryMsgListService : wbConn

@property int type;

@property int accountId;

@property (strong) QRY_MSGLIST_BLOCK qryMsgListBlock;

@end
