//
//  aliveHelper.h
//  iBank
//
//  Created by McKee on 15/4/21.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aliveHelper : NSObject

@property NSInteger inteval; //seconds

+ (instancetype)helper;

- (void)startKeepAlive;

- (void)stopKeepAlive;

@end
