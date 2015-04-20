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


@interface loginVC ()
{
    verifyImageService *_vImgSrv;
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
    // Do any additional setup after loading the view.
    __weak UIImageView *weakImageView = _codeImageView;
    __weak loginVC *weakSelf = self;
    _vImgSrv = [[verifyImageService alloc] init];
    _vImgSrv.getImageBlock = ^(UIImage *image, NSString *code, NSString *error){
        weakImageView.image = image;
        weakSelf.imageSN = code;
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
    loginService *service = [[loginService alloc] init];
    service.uid = _accountTextField.text;
    service.pcode = _passwordTextField.text;
    service.vcode = _codeTextField.text;
    service.qid = _imageSN;
    [service request];
}

@end
