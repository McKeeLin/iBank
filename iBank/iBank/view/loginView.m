//
//  loginView.m
//  iBank
//
//  Created by McKee on 15/5/1.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "loginView.h"
#import "Utility.h"

@implementation loginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self ){
        _backgroudView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroudView.image = [UIImage imageNamed:@"登录框"];
        [self addSubview:_backgroudView];
        
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 39, 50, 30)];
        accountLabel.backgroundColor = [UIColor clearColor];
        accountLabel.text = @"帐号：";
        accountLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
        accountLabel.textColor = [UIColor blackColor];
        [self addSubview:accountLabel];
        
        _accountTextField = [[TextFieldEx alloc] initWithFrame:CGRectMake(135, 39, 225, 31)];
        _accountTextField.backgroundColor = [UIColor clearColor];
        _accountTextField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
        _accountTextField.background = [UIImage imageNamed:@"输入框01"];
        _accountTextField.enabled = YES;
        [_accountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_accountTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self addSubview:_accountTextField];
        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 89, 50, 30)];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.text = @"密码：";
        passwordLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
        passwordLabel.textColor = [UIColor blackColor];
        [self addSubview:passwordLabel];
        
        _passwordTextField = [[TextFieldEx alloc] initWithFrame:CGRectMake(135, 89, 225, 31)];
        _passwordTextField.backgroundColor = [UIColor clearColor];
        _passwordTextField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
        _passwordTextField.background = [UIImage imageNamed:@"输入框01"];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.enabled = YES;
        [self addSubview:_passwordTextField];
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 139, 50, 30)];
        codeLabel.backgroundColor = [UIColor clearColor];
        codeLabel.text = @"验证：";
        codeLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
        codeLabel.textColor = [UIColor blackColor];
        [self addSubview:codeLabel];
        
        _codeTextField = [[TextFieldEx alloc] initWithFrame:CGRectMake(135, 139, 100, 31)];
        _codeTextField.backgroundColor = [UIColor clearColor];
        _codeTextField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
        _codeTextField.background = [UIImage imageNamed:@"输入框02"];
        _codeTextField.enabled = YES;
        [self addSubview:_codeTextField];
        
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(238, 139, 87, 30)];
        [self addSubview:_codeImageView];
        
        _codeIndicatorView = [[UIView alloc] initWithFrame:_codeImageView.frame];
        _codeImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_codeIndicatorView];
        
        _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(330, 139, 30, 30)];
        [_refreshButton setImage:[UIImage imageNamed:@"刷新认证码-标准状态"] forState:UIControlStateNormal];
        [self addSubview:_refreshButton];
        
        
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(71, 205, 300, 48)];
        [_loginButton setImage:[UIImage imageNamed:@"登录按钮-标准状态"] forState:UIControlStateNormal];
        [self addSubview:_loginButton];
    }
    
    return self;
}

@end
