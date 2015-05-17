//
//  SendMsgService.h
//  iBank
//
//  Created by McKee on 15/5/16.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^SEND_MSG_BLOCK) (int code, NSString *error);

@interface SendMsgService : wbConn

@property NSString *reciverIds;

@property NSString *title;

@property NSString *msg;

@property int repId;

@property (strong) SEND_MSG_BLOCK sendMsgBlock;

@end
