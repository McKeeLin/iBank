//
//  yearMonthVC.h
//  SRMonthPickerExample
//
//  Created by 林景隆 on 10/27/14.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YEAR_MONTH_VC_BLOCK)(NSInteger year, NSInteger month);

@interface yearMonthVC : UIViewController

@property UIImage *backImage;

@property NSInteger selectedYear;

@property NSInteger selectedMonth;

@property BOOL isPopOver;

@property (strong) YEAR_MONTH_VC_BLOCK block;

+ (UIImage*)screenShotImage;


@end
