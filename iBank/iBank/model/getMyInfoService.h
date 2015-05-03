//
//  getMyInfoService.h
//  iBank
//
//  Created by McKee on 15/4/29.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^GET_MY_INFO_BLOCK) (int code, id data);


@interface getMyInfoService : wbConn

@property (strong) GET_MY_INFO_BLOCK getMyInfoBlock;

@end
