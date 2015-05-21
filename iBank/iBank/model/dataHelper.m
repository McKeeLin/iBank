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



@interface dataHelper ()
{
    NSString *_settingFilePath;
    NSString *_documentsPath;
    NSMutableDictionary *_setting;
}

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
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsPath = paths.firstObject;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        if( ![fm fileExistsAtPath:_documentsPath] ){
            [fm createDirectoryAtPath:_documentsPath withIntermediateDirectories:YES attributes:nil error:&error];
            if( error ){
                NSLog(@"create documentsPath failed:%@", error.localizedDescription);
            }
        }
        _settingFilePath = [_documentsPath stringByAppendingPathComponent:@"setting.plist"];
        if( ![fm fileExistsAtPath:_settingFilePath] ){
            NSString *originalSettingFile = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
            [fm copyItemAtPath:originalSettingFile toPath:_settingFilePath error:&error];
            if( error ){
                NSLog(@"copy setting file failed:%@", error.localizedDescription);
            }
        }
        _setting = [[NSMutableDictionary alloc] initWithContentsOfFile:_settingFilePath];
       NSLog(@"%@", _settingFilePath);
    }
    return self;
}

- (NSString*)savedAccount
{
    //return [UICKeyChainStore stringForKey:@"IBANK_SAVED_ACCOUNT" service:SERVICE_NAME];
    return [_setting objectForKey:@"Last_LoginUser"];
}

- (void)setSavedAccount:(NSString *)savedAccount
{
    //[UICKeyChainStore setString:savedAccount forKey:@"IBANK_SAVED_ACCOUNT" service:SERVICE_NAME];
    [_setting setObject:savedAccount forKey:@"Last_LoginUser"];
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
    //[UICKeyChainStore removeItemForKey:@"IBANK_SAVED_ACCOUNT" service:SERVICE_NAME];
    //[UICKeyChainStore removeItemForKey:@"IBANK_SAVED_PASSWORD" service:SERVICE_NAME];
    [_setting setObject:@"" forKey:@"Last_LoginUser"];
}

- (NSString*)host
{
    NSString *protocol = @"http";
    NSString *port = self.port;
    if( self.useSSL ){
        protocol = @"https";
        port = self.sslPort;
    }
    if( [port isEqualToString:@"80"] || [port isEqualToString:@"443"] ){
        port = @"";
    }
    NSString *host = [NSString stringWithFormat:@"%@://%@", protocol, self.server];
    if( port.length > 0 ){
        host = [NSString stringWithFormat:@"%@:%@", host, port];
    }
    return host;
}

- (NSString*)server
{
    NSString *svr = [_setting objectForKey:@"Option_Server"];// [UICKeyChainStore stringForKey:@"IBANK_SERVER" service:SERVICE_NAME];
    if( !svr ){
        svr = @"222.49.117.9";
    }
    return svr;
}

- (void)setServer:(NSString *)server
{
    //[UICKeyChainStore setString:server forKey:@"IBANK_SERVER" service:SERVICE_NAME];
    [_setting setObject:server forKey:@"Option_Server"];
}

- (NSString*)port
{
    return [_setting objectForKey:@"Option_Port"];
}

- (void)setPort:(NSString *)port
{
    [_setting setObject:port forKey:@"Option_Port"];
}

- (NSString*)sslPort
{
    return [_setting objectForKey:@"Option_Port_SSL"];
}

- (void)setSslPort:(NSString *)sslPort
{
    [_setting setObject:sslPort forKey:@"Option_Port_SSL"];
}

- (BOOL)useSSL
{
    /*
    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_USE_SSL" service:SERVICE_NAME];
    if( [str isEqualToString:@"1"] ){
        return YES;
    }
    else{
        return NO;
    }
    */
    NSString *str =  [_setting objectForKey:@"Option_SSL"];
    if( [str isEqualToString:@"TURE"] ){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)setUseSSL:(BOOL)useSSL
{
    //[UICKeyChainStore setString:[NSString stringWithFormat:@"%d", useSSL] forKey:@"IBANK_USE_SSL" service:SERVICE_NAME];
    [_setting setObject:useSSL ? @"TRUE" : @"FALSE" forKey:@"Option_SSL"];
}

- (BOOL)autoSaveAccount
{
//    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_AUTO_SAVE_ACCOUNT" service:SERVICE_NAME];
//    if( [str isEqualToString:@"1"] ){
//        return YES;
//    }
//    else{
//        return NO;
//    }
    NSString *str =  [_setting objectForKey:@"Option_LoginUser"];
    if( [str isEqualToString:@"TRUE"] ){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)setAutoSaveAccount:(BOOL)autoSaveAccount
{
//    [UICKeyChainStore setString:[NSString stringWithFormat:@"%d", autoSaveAccount] forKey:@"IBANK_AUTO_SAVE_ACCOUNT" service:SERVICE_NAME];
    [_setting setObject:autoSaveAccount ? @"TRUE" : @"FALSE" forKey:@"Option_LoginUser"];
    if( !autoSaveAccount ){
        self.savedAccount = @"";
    }
    else{
        self.savedAccount = self.loginAccount;
    }
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
//    NSString *str =  [UICKeyChainStore stringForKey:@"IBANK_TIMEOUT_INTERVAL" service:SERVICE_NAME];
//    if( str ){
//        return str.intValue;
//    }
//    else{
//        return 30 * 60;
//    }
    NSString *str = [_setting objectForKey:@"Option_AutoLogoutTime"];
    if( str ){
        return str.intValue;
    }
    else{
        return 30;
    }
}

- (void)setTimeoutInterval:(int)timeoutInterval
{
    //[UICKeyChainStore setString:[NSString stringWithFormat:@"%d", timeoutInterval] forKey:@"IBANK_TIMEOUT_INTERVAL" service:SERVICE_NAME];
    [_setting setObject:[NSString stringWithFormat:@"%d",timeoutInterval] forKey:@"Option_AutoLogoutTime"];
}

- (NSString*)sn
{
    return [_setting objectForKey:@"cls_sn"];
}

- (void)setSn:(NSString *)sn
{
    [_setting setObject:sn forKey:@"cls_sn"];
}

- (NSString*)site
{
    return [_setting objectForKey:@"Option_Site"];
}

- (void)setSite:(NSString *)site
{
    [_setting setObject:site forKey:@"Option_Site"];
}

- (UIImage*)logo2Img
{
    NSString *imageName = [_setting objectForKey:@"Option_logo2"];
    UIImage *image = [UIImage imageWithContentsOfFile:[_documentsPath stringByAppendingPathComponent:imageName]];
    if( !image ){
        image = [UIImage imageNamed:@"customer_logo.jpg"];
    }
    return image;
}

- (void)saveSettingToFile
{
    [_setting writeToFile:_settingFilePath atomically:YES];
}

@end
