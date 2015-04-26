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


@interface loginVC ()
{
    verifyImageService *_vImgSrv;
    loginService *_loginSrv;
    IBOutlet UIImageView *_codeImageView;
    IBOutlet UITextField *_accountTextField;
    IBOutlet UITextField *_passwordTextField;
    IBOutlet UITextField *_codeTextField;
}

@property NSString *imageSN;


@end

@implementation loginVC

- (instancetype)init
{
    self = [super init];
    if( self ){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    __weak UIImageView *weakImageView = _codeImageView;
    __weak loginVC *weakSelf = self;
    _vImgSrv = [[verifyImageService alloc] init];
    _vImgSrv.getImageBlock = ^(UIImage *image, NSString *code, NSString *error){
        weakImageView.image = image;
        weakSelf.imageSN = code;
    };
    
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

- (IBAction)onTouchRefresh:(id)sender
{
    [_vImgSrv request];
}

- (IBAction)onTouchLogin:(id)sender
{
    _loginSrv.uid = _accountTextField.text;
    _loginSrv.pcode = _passwordTextField.text;
    _loginSrv.vcode = _codeTextField.text;
    _loginSrv.qid = _imageSN;
    [_loginSrv request];
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

@end
