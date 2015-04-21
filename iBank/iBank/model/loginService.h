//
//  loginService.h
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void (^LOGIN_BLOCK) (NSInteger code, NSString *data);

@interface loginService : wbConn

@property NSString *uid;

@property NSString *pcode;

@property NSString *qid;

@property NSString *vcode;

@property NSString *ctp;

@property NSString *os;


@property (strong) LOGIN_BLOCK loginBlock;

@end
