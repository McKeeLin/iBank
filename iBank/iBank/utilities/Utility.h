//
//  Utility.h
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+(NSArray*)arrayWithResponseObject:(id)responseObject;

+(NSDictionary*)dictionaryWithResponseObject:(id)responseObject;

+(NSDictionary*)dictionaryWithJsonString:(NSString *)jsonString;

+(NSString*)jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString*)URLEncode:(NSString*)unencodedString;

+(NSString*)URLDecode:(NSString*)encodedString;

+(NSString*)md5String:(NSString*)src;

+(NSDateComponents*)currentDateComponents;

+(UIColor*)colorWithRead:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

+(NSString*)moneyFormatString:(CGFloat)amount;

@end
