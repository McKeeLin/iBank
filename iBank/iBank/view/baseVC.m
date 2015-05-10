//
//  baseVC.m
//  iBank
//
//  Created by McKee on 15/5/9.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "baseVC.h"
#import "aliveHelper.h"
#import "dataHelper.h"

@interface baseVC ()<UIAlertViewDelegate>

@end

@implementation baseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)onSessionTimeout
{
    [[aliveHelper helper] stopKeepAlive];
    [dataHelper helper].passwordTextField.text = @"";
    [dataHelper helper].verifyCodeTextField.text = @"";
    [dataHelper helper].sessionid = nil;
    [[dataHelper helper].verifyImageSrv request];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"会话超时，请重新登录！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [av show];
}

- (void)showMessage:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
