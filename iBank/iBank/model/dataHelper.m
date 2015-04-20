//
//  dataHelper.m
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "dataHelper.h"

@implementation dataHelper

+ (instancetype)helper
{
    static dataHelper *helper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(void){
        helper = [[dataHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if( self ){
        self.host = @"http://222.49.117.9";
    }
    return self;
}

@end
