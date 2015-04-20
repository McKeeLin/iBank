//
//  webService.h
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface webService : NSObject

+ (void)getVerifyImage:(void(^)(UIImage *image))block;

@end
