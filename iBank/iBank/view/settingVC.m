//
//  settingVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "settingVC.h"
#import "dataHelper.h"
#import "logoutService.h"
#import "indicatorView.h"

@implementation serverCell

@end

@implementation loginCell

@end


@interface settingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    logoutService *_logoutService;
    indicatorView *_indicatorView;
}
@property indicatorView *indicatorView;
@end

@implementation settingVC

+ (instancetype)viewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    settingVC * vc = [storyBoard  instantiateViewControllerWithIdentifier:@"settingVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if( [dataHelper helper].sessionid.length > 0 ){
        self.navigationController.navigationBarHidden = YES;
    }
    else{
        self.navigationController.navigationBarHidden = NO;
        self.title = @"设置";
    }
    
    _indicatorView = [indicatorView view];
    _indicatorView.label.text = @"正在退出系统，请稍候...";
    __weak settingVC *weakSelf = self;
    _logoutService = [[logoutService alloc] init];
    _logoutService.logoutBlock = ^(NSInteger code, NSString *data){
        [weakSelf.indicatorView dismiss];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 ){
        return 290;
    }
    else{
        return 345;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = [NSString stringWithFormat:@"%ld_%ld", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if( !cell )
    {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil];
        if( indexPath.row == 0 )
        {
            serverCell *cll = cells.firstObject;
            cll.backgroundColor = [UIColor clearColor];
            [cll.testButton addTarget:self action:@selector(onTouchTest:) forControlEvents:UIControlEventTouchUpInside];
            return cll;
        }
        else{
            loginCell *cll = [cells objectAtIndex:1];
            cll.backgroundColor = [UIColor clearColor];
            if( [dataHelper helper].sessionid.length > 0 ){
                [cll.logoutButton addTarget:self action:@selector(onTouchLogout:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                cll.logoutButton.hidden = YES;
            }
            return cll;
        }
    }
    else{
        return cell;
    }
}

- (void)onTouchLogout:(id)sender
{
    [_indicatorView showAtMainWindow];
    [_logoutService request];
    [dataHelper helper].passwordTextField.text = @"";
    [dataHelper helper].verifyCodeTextField.text = @"";
    [[dataHelper helper].verifyImageSrv request];
}

- (void)onTouchTest:(id)sender
{
    ;
}

@end
