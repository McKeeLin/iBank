//
//  loginVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "loginVC.h"
#import "verifyImageService.h"
#import "loginService.h"
#import "dataHelper.h"
#import "logoutService.h"
#import "keepAliveService.h"
#import "newMsgService.h"
#import "settingVC.h"
#import "aboutVC.h"
#import "loginView.h"
#import "mainVC.h"
#import "indicatorView.h"
#import "aliveHelper.h"


@interface loginVC ()<UITextFieldDelegate>
{
    verifyImageService *_vImgSrv;
    loginService *_loginSrv;
    IBOutlet UIImageView *_codeImageView;
    IBOutlet UITextField *_accountTextField;
    IBOutlet UITextField *_passwordTextField;
    IBOutlet UITextField *_codeTextField;
    IBOutlet UIView *_container;
    IBOutlet UIView *_tempView;
    IBOutlet UIImageView *_bgImageView;
    IBOutlet UIButton *_aboutButton;
    IBOutlet UIButton *_settingButton;
    UITextField *_currentTextField;
    CGRect _loginViewFrame;
    UITapGestureRecognizer *_tgr;
}

@property NSString *imageSN;
@property IBOutlet UIButton *loginButton;
@property loginView *loginView;
@property indicatorView *loginIV;
@property indicatorView *imageIV;
@property UIImageView *codeImageView;

@end

@implementation loginVC

- (instancetype)init
{
    self = [super init];
    if( self ){
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    
    _container.hidden = YES;
    _loginViewFrame = CGRectMake(291, 300, 442, 292);
    _loginView = [[loginView alloc] initWithFrame:_loginViewFrame];
    _loginView.frame = _loginViewFrame;
    _loginView.accountTextField.text = @"admin";
    _loginView.accountTextField.delegate = self;
    _loginView.accountTextField.returnKeyType = UIReturnKeyNext;
    _loginView.passwordTextField.text = @"admin";
    _loginView.passwordTextField.delegate = self;
    _loginView.passwordTextField.returnKeyType = UIReturnKeyNext;
    _loginView.codeTextField.delegate = self;
    _loginView.codeTextField.returnKeyType = UIReturnKeyDone;
    _loginView.loginButton.enabled = NO;
    [_loginView.loginButton addTarget:self action:@selector(onTouchLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.refreshButton addTarget:self action:@selector(onTouchRefreshCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardFrameWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    __weak __block loginVC *weakSelf = self;
    _vImgSrv = [[verifyImageService alloc] init];
    _vImgSrv.getImageBlock = ^(UIImage *image, NSString *code, NSString *error){
        [indicatorView dismissOnlyIndicatorAtView:weakSelf.loginView.codeIndicatorView];
        weakSelf.loginView.codeImageView.image = image;
        weakSelf.imageSN = code;
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.refreshButton.enabled = YES;
    };
    [self requestVerifyCodeImage];
    
    _loginSrv = [[loginService alloc] init];
    _loginSrv.loginBlock = ^(NSInteger code, NSString *data){
        [indicatorView dismissAtView:weakSelf.view];
        weakSelf.loginView.loginButton.enabled = YES;
        if( code == 1 ){
            [dataHelper helper].sessionid = data;
            [[aliveHelper helper] startKeepAlive];
            [weakSelf.navigationController pushViewController:[mainVC viewController] animated:YES];
        }
        else if( data.length > 0 ){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:data delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    };
    [_aboutButton addTarget:self action:@selector(onTouchAbout:) forControlEvents:UIControlEventTouchUpInside];
    [_settingButton addTarget:self action:@selector(onTouchSetting:) forControlEvents:UIControlEventTouchUpInside];
    [dataHelper helper].loginViewController = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)doLogin
{
    if( _loginView.accountTextField.text.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入帐号！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [av show];
        return;
    }
    if( _loginView.passwordTextField.text.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [av show];
        return;
    }
    if( _loginView.codeTextField.text.length == 0 ){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [av show];
        return;
    }
    [_loginView.accountTextField resignFirstResponder];
    [_loginView.passwordTextField resignFirstResponder];
    [_loginView.codeTextField resignFirstResponder];
    [indicatorView showMessage:@"正在登录，请稍候..." atView:self.view];
    _loginView.loginButton.enabled = NO;
    _loginSrv.uid = _loginView.accountTextField.text;
    _loginSrv.pcode = _loginView.passwordTextField.text;
    _loginSrv.vcode = _loginView.codeTextField.text.uppercaseString;
    _loginSrv.qid = _imageSN;
    [_loginSrv request];
}

- (void)requestVerifyCodeImage
{
    [indicatorView showOnlyIndicatorAtView:_loginView.codeIndicatorView];
    _loginView.refreshButton.enabled = NO;
    [_vImgSrv request];
}


- (void)onTouchRefreshCode:(id)sender
{
    [self requestVerifyCodeImage];
}

- (void)onTouchLogin:(id)sender
{
    [self doLogin];
}

- (IBAction)onTouchLogout:(id)sender
{
    logoutService *logoutSrv = [[logoutService alloc] init];
    [logoutSrv request];
}

- (IBAction)onTouchKeepAlive:(id)sender
{
    keepAliveService *keepAliveSrv = [[keepAliveService alloc] init];
    [keepAliveSrv request];
}

- (IBAction)onTouchNewMsg:(id)sender
{
    newMsgService *newMsgSrv = [[newMsgService alloc] init];
    [newMsgSrv request];
}

- (void)onTouchSetting:(id)sender
{
    settingVC *vc = [settingVC viewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchAbout:(id)sender
{
    aboutVC *vc = [aboutVC viewController];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onKeyboardFrameWillShowNotification:(NSNotification*)notification
{
    NSLog(@"%s", __func__);
    [self.view addGestureRecognizer:_tgr];
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect keyboardFrameSelfView = [window convertRect:endFrame toView:self.view];
    __block CGRect newFrame = _loginView.frame;
    newFrame.origin.y = keyboardFrameSelfView.origin.y - newFrame.size.height - 5;
    [UIView animateWithDuration:duration animations:^(){
        _loginView.frame = newFrame;
    }completion:^(BOOL finished){
    }];
}

- (void)onKeyboardWillHideNotification:(NSNotification*)notification
{
    NSLog(@"%s", __func__);
    [self.view removeGestureRecognizer:_tgr];
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationCurve:curve.unsignedIntegerValue];
    [UIView setAnimationDuration:duration];
    _loginView.frame = _loginViewFrame;
    [UIView commitAnimations];
}


- (void)onViewTap:(UITapGestureRecognizer*)tgr
{
    [_currentTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField == _loginView.accountTextField )
    {
        [_loginView.passwordTextField becomeFirstResponder];
    }
    else if( textField == _loginView.passwordTextField ){
        [_loginView.codeTextField becomeFirstResponder];
    }
    else if( textField == _loginView.codeTextField ){
        [self doLogin];
    }
    return YES;
}

- (void)prepareLoginAgain
{
    _loginView.passwordTextField.text = @"";
    _loginView.codeTextField.text = @"";
    [[aliveHelper helper] stopKeepAlive];
    [dataHelper helper].sessionid = nil;
    [self requestVerifyCodeImage];
}

@end
