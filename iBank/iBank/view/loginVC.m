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
    _loginViewFrame = CGRectMake(291, 300, 442, 292);
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    
    _container.hidden = YES;
    _loginView = [[NSBundle mainBundle] loadNibNamed:@"views" owner:nil options:nil].firstObject;
    _loginView.frame = _loginViewFrame;
    _loginView.accountTextField.delegate = self;
    _loginView.accountTextField.returnKeyType = UIReturnKeyNext;
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
        weakSelf.loginView.codeImageView.image = image;
        weakSelf.imageSN = code;
        weakSelf.loginView.loginButton.enabled = YES;
        weakSelf.loginView.refreshButton.enabled = YES;
    };
    [_vImgSrv request];
    
    _loginSrv = [[loginService alloc] init];
    _loginSrv.loginBlock = ^(NSInteger code, NSString *data){
        if( code == 1 ){
            [dataHelper helper].sessionid = data;
            [weakSelf.navigationController pushViewController:[mainVC viewController] animated:YES];
        }
        else if( data.length > 0 ){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:data delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    };
    [_aboutButton addTarget:self action:@selector(onTouchAbout:) forControlEvents:UIControlEventTouchUpInside];
    [_settingButton addTarget:self action:@selector(onTouchSetting:) forControlEvents:UIControlEventTouchUpInside];
    [dataHelper helper].verifyImageSrv = _vImgSrv;
    [dataHelper helper].passwordTextField = _loginView.passwordTextField;
    [dataHelper helper].verifyCodeTextField = _loginView.codeTextField;
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
    _loginSrv.uid = _loginView.accountTextField.text;
    _loginSrv.pcode = _loginView.passwordTextField.text;
    _loginSrv.vcode = _loginView.codeTextField.text;
    _loginSrv.qid = _imageSN;
    [_loginSrv request];
}


- (void)onTouchRefreshCode:(id)sender
{
    _loginView.refreshButton.enabled = NO;
    [_vImgSrv request];
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
    if( textField == _accountTextField )
    {
        [_loginView.passwordTextField becomeFirstResponder];
    }
    else if( textField == _passwordTextField ){
        [_loginView.codeTextField becomeFirstResponder];
    }
    else if( textField == _codeTextField ){
        [_loginView.codeTextField resignFirstResponder];
        [self doLogin];
    }
    return YES;
}

@end
