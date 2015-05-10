//
//  detailVC.h
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseVC.h"

@interface detailVC : baseVC

@property int accountId;

@property NSString *account;

@property NSString *company;

@property NSString *bank;

@property NSString *currencyType;

+ (instancetype)viewController;

@end
