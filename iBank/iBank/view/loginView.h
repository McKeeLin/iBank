//
//  loginView.h
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldEx.h"


@interface loginView : UIView

@property  TextFieldEx *accountTextField;

@property  TextFieldEx *passwordTextField;

@property  TextFieldEx *codeTextField;

@property  UIImageView *codeImageView;

@property  UIButton *refreshButton;

@property  UIButton *loginButton;

@property UIImageView *backgroudView;

@property UIView *codeIndicatorView;

@end
