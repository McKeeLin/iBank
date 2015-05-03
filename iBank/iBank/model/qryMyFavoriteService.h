//
//  qryMyFavoriteService.h
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^QUERY_MY_FAVORITE_BLOCK) (int code, id data);

@interface qryMyFavoriteService : wbConn

@property NSString *year;

@property NSString *month;

@property (strong) QUERY_MY_FAVORITE_BLOCK qryMyFavoriteBlock;

@end
