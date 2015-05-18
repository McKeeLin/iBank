//
//  msgListVC.h
//  iBank
//
//  Created by McKee on 15/5/17.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface msgListVC : UIViewController

+ (instancetype)viewController;

@property NSArray *msgs;

@property BOOL forSystem;

@end
