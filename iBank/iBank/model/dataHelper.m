//
//  dataHelper.m
//  iBank
//
//  Created by McKee on 15/4/19.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "dataHelper.h"
#import "UICKeyChainStore.h"

#define SERVICE_NAME    @"IBANK"

@implementation moneyFlow

@end


@implementation accountData

@end



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
        self.dev = [UIDevice currentDevice].name;
        self.os = [NSString stringWithFormat:@"%@%@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
        self.ip = @"192.168.10.100";
        self.sn = @"S/N: 23135-2135-292198-0283";
        self.focusAccounts = [[NSMutableArray alloc] initWithCapacity:0];
        self.accounts = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (NSString*)savedAccount
{
    return [UICKeyChainStore stringForKey:@"IBANK_SAVED_ACCOUNT" service:SERVICE_NAME];
}

- (void)setSavedAccount:(NSString *)savedAccount
{
    [UICKeyChainStore setString:savedAccount forKey:@"IBANK_SAVED_ACCOUNT" service:SERVICE_NAME];
}

- (NSString*)savedPassword
{
    return [UICKeyChainStore stringForKey:@"IBANK_SAVED_PASSWORD" service:SERVICE_NAME];
}

- (void)setSavedPassword:(NSString *)savedPassword
{
    [UICKeyChainStore setString:savedPassword forKey:@"IBANK_SAVED_PASSWORD" service:SERVICE_NAME];
}

- (void)clearSavedAccount
{
    [UICKeyChainStore removeItemForKey:@"IBANK_SAVED_ACCOUNT" service:SERVICE_NAME];
    [UICKeyChainStore removeItemForKey:@"IBANK_SAVED_PASSWORD" service:SERVICE_NAME];
}

- (NSString*)host
{
    NSString *host = @"http://222.49.117.9";
    if( self.server ){
        NSString *protocol = @"http";
        if( self.useSSL ){
            protocol = @"https";
        }
        host = [NSString stringWithFormat:@"%@://%@", protocol, self.server];
    }
    return host;
}

- (NSString*)server
{
    return [UICKeyChainStore stringForKey:@"IBANK_SERVER" service:SERVICE_NAME];
}

- (void)setServer:(NSString *)server
{
    [UICKeyChainStore setString:server forKey:@"IBANK_SERVER" service:SERVICE_NAME];
}

- (BOOL)useSSL
{
    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_USE_SSL" service:SERVICE_NAME];
    if( [str isEqualToString:@"1"] ){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)setUseSSL:(BOOL)useSSL
{
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", useSSL] forKey:@"IBANK_USE_SSL" service:SERVICE_NAME];
}

- (BOOL)autoSaveAccount
{
    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_AUTO_SAVE_ACCOUNT" service:SERVICE_NAME];
    if( [str isEqualToString:@"1"] ){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)setAutoSaveAccount:(BOOL)autoSaveAccount
{
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", autoSaveAccount] forKey:@"IBANK_AUTO_SAVE_ACCOUNT" service:SERVICE_NAME];
}

- (BOOL)autoTimeout
{
    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_AUTO_TIMEOUT" service:SERVICE_NAME];
    if( [str isEqualToString:@"1"] ){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)setAutoTimeout:(BOOL)autoTimeout
{
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", autoTimeout] forKey:@"IBANK_AUTO_TIMEOUT" service:SERVICE_NAME];
}

- (int)timeoutInterval
{
    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_TIMEOUT_INTERVAL" service:SERVICE_NAME];
    if( str ){
        return str.intValue;
    }
    else{
        return 30;
    }
}

- (void)setTimeoutInterval:(int)timeoutInterval
{
    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", timeoutInterval] forKey:@"IBANK_TIMEOUT_INTERVAL" service:SERVICE_NAME];
}

@end
