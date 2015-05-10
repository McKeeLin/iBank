//
//  baseVC.h
//  iBank
//
//  Created by McKee on 15/5/9.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseVC : UIViewController

- (void)onSessionTimeout;

- (void)showMessage:(NSString*)message;

@end
