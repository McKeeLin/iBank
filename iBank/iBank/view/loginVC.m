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
    UITextField *_currentTextField;
    CGFloat _yOffset;
    CGRect _containerFrame;
    UITapGestureRecognizer *_tgr;
}

@property NSString *imageSN;
@property IBOutlet UIButton *loginButton;


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
    self.navigationController.navigationBarHidden = YES;
//    self.loginButton.enabled = NO;
    _containerFrame = _container.frame;
    _yOffset = 0;
    _tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    _accountTextField.delegate = self;
    _accountTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _codeTextField.delegate = self;
    _codeTextField.returnKeyType = UIReturnKeyGo;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardFrameWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onKeyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    __weak UIImageView *weakImageView = _codeImageView;
    __weak loginVC *weakSelf = self;
    _vImgSrv = [[verifyImageService alloc] init];
    _vImgSrv.getImageBlock = ^(UIImage *image, NSString *code, NSString *error){
        weakImageView.image = image;
        weakSelf.imageSN = code;
        weakSelf.loginButton.enabled = YES;
    };
//    [_vImgSrv request];
    
    _loginSrv = [[loginService alloc] init];
    _loginSrv.loginBlock = ^(NSInteger code, NSString *data){
        if( code == 1 ){
            [dataHelper helper].sessionid = data;
        }
        [dataHelper helper].sessionid = @"3c5d37d-e59b-4dba-804d-3126d6d844ac";
    };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _loginSrv.uid = _accountTextField.text;
    _loginSrv.pcode = _passwordTextField.text;
    _loginSrv.vcode = _codeTextField.text;
    _loginSrv.qid = _imageSN;
//    [_loginSrv request];
}

- (IBAction)onTouchRefresh:(id)sender
{
    [_vImgSrv request];
}

- (IBAction)onTouchLogin:(id)sender
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


- (void)onKeyboardFrameWillShowNotification:(NSNotification*)notification
{
    NSLog(@"%s", __func__);
    [self.view addGestureRecognizer:_tgr];
    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect endFrame;
    double duration;
    [endFrameValue getValue:&endFrame];
    [durationValue getValue:&duration];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect keyboardFrameSelfView = [window convertRect:endFrame toView:self.view];
    __block CGRect newFrame = _container.frame;
    newFrame.origin.y = keyboardFrameSelfView.origin.y - newFrame.size.height;
    CGRect frame = CGRectMake(_container.frame.origin.x,keyboardFrameSelfView.origin.y - 10 - _container.frame.size.height, _container.frame.size.width, _container.frame.size.height);
    
    [UIView animateWithDuration:duration animations:^(){
        _container.frame = frame;
    }completion:^(BOOL finished){
        _container.frame = frame;
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
    _container.frame = _containerFrame;
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
        [_passwordTextField becomeFirstResponder];
    }
    else if( textField == _passwordTextField ){
        [_codeTextField becomeFirstResponder];
    }
    else if( textField == _codeTextField ){
        [_codeTextField resignFirstResponder];
        [self doLogin];
    }
    return YES;
}

@end
