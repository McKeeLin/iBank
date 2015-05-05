//
//  settingVC.h
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface serverCell : UITableViewCell

@property IBOutlet UIButton *testButton;

@property IBOutlet UIButton *sslButton;

@property IBOutlet UITextField *hostField;

@end


@interface loginCell : UITableViewCell

@property IBOutlet UIButton *logoutButton;

@property IBOutlet UIButton *saveAccountButton;

@property IBOutlet UIButton *autoLogoutButton;

@property IBOutlet UIButton *saveButton;

@property IBOutlet UISlider *slider;

@property IBOutlet UILabel *timeoutIntervalLabel;

@end


@interface settingVC : UIViewController

+ (instancetype)viewController;

@end
