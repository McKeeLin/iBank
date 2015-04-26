//
//  dataHelper.m
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "dataHelper.h"
#import "UICKeyChainStore.h"

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
        self.dev = [UIDevice currentDevice].name;
        self.os = [NSString stringWithFormat:@"%@%@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
        self.ip = @"192.168.10.100";
        self.sn = @"S/N: 23135-2135-292198-0283";
    }
    return self;
}

- (NSString*)savedAccount
{
    return [UICKeyChainStore stringForKey:@"IBANK_SAVED_ACCOUNT" service:@"IBANK"];
}

- (void)setSavedAccount:(NSString *)savedAccount
{
    [UICKeyChainStore setString:savedAccount forKey:@"IBANK_SAVED_ACCOUNT" service:@"IBANK"];
}

- (NSString*)savedPassword
{
    return [UICKeyChainStore stringForKey:@"IBANK_SAVED_PASSWORD" service:@"IBANK"];
}

- (void)setSavedPassword:(NSString *)savedPassword
{
    [UICKeyChainStore setString:savedPassword forKey:@"IBANK_SAVED_PASSWORD" service:@"IBANK"];
}

- (void)clearSavedAccount
{
    [UICKeyChainStore removeItemForKey:@"IBANK_SAVED_ACCOUNT" service:@"IBANK"];
    [UICKeyChainStore removeItemForKey:@"IBANK_SAVED_PASSWORD" service:@"IBANK"];
}

@end
