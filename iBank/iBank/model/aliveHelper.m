//
//  aliveHelper.m
//  iBank
//
//  Created by McKee on 15/4/21.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "aliveHelper.h"
#import "dataHelper.h"
#import "keepAliveService.h"

@interface aliveHelper ()
{
    NSTimer *_timer;
    BOOL _returned;
    keepAliveService *_keepAliveSrv;
}

@end

@implementation aliveHelper

+ (instancetype)helper
{
    static aliveHelper *helper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(void){
        helper = [[aliveHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if( self ){
        _keepAliveSrv = [[keepAliveService alloc] init];
        _keepAliveSrv.keepAliveBlock = ^(NSInteger code, NSString *data){
            ;
        };
    }
    return self;
}


- (void)startKeepAlive
{
    if( ![dataHelper helper].sessionid ){
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.inteval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stopKeepAlive
{
    [_timer invalidate];
}

- (void)onTimer:(NSTimer*)timer
{
    ;
}


@end
