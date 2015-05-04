//
//  companyVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "companyVC.h"
#import "qryOrgBankAcctService.h"
#import "Utility.h"
#import "dataHelper.h"
#import "indicatorView.h"
#import "cells.h"

@interface companyVC ()<UITableViewDataSource,UITableViewDelegate>
{
    qryOrgBankAcctService *_qryOrgBankAcctSrv;
    NSString *_year;
    NSString *_month;
}

@property IBOutlet UITableView *tableView;

@property NSArray *orgs;

@property indicatorView *iv;

@property outerSumaryCell *footerView;

@end

@implementation companyVC


+ (instancetype)viewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    companyVC * vc = [storyBoard  instantiateViewControllerWithIdentifier:@"companyVC"];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak companyVC *weakSelf = self;
    _footerView = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:7];
    _tableView.tableFooterView = _footerView;
    NSDateComponents *componets = [Utility currentDateComponents];
    _year = [NSString stringWithFormat:@"%ld", componets.year];
    _month = [NSString stringWithFormat:@"%02ld", componets.month];
    _iv = [[indicatorView alloc] initWithFrame:self.view.bounds];
    _qryOrgBankAcctSrv = [[qryOrgBankAcctService alloc] init];
    _qryOrgBankAcctSrv.qryOrgBankAcctBlock = ^( int code, id data){
        if( code == 1 ){
            weakSelf.orgs = (NSArray*)data;
            [weakSelf.tableView reloadData];
            [weakSelf.iv dismiss];
            [weakSelf updateFooterView];
        }
    };
    [self loadData];
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

- (void)loadData
{
    _qryOrgBankAcctSrv.year = _year;
    _qryOrgBankAcctSrv.month = _month;
    [_iv showAtView:self.view];
    [_qryOrgBankAcctSrv request];
}

- (void)updateFooterView
{
    CGFloat rmbLastBalance = 0;
    CGFloat rmbDebit = 0;
    CGFloat rmbCredit = 0;
    CGFloat rmbBalance = 0;
    CGFloat usdLastBalance = 0;
    CGFloat usdDebit = 0;
    CGFloat usdCredit = 0;
    CGFloat usdBalance = 0;
    for( orgObj *org in _orgs ){
        rmbLastBalance += org.rmbLastBalance;
        rmbDebit += org.rmbDebit;
        rmbCredit += org.rmbCredit;
        rmbBalance += org.rmbBalance;
        usdLastBalance += org.usdLastBalance;
        usdDebit += org.usdDebit;
        usdCredit += org.usdCredit;
        usdBalance += org.usdCredit;
    }
    _footerView.rmbLastBalanceLabel.text = [NSString stringWithFormat:@"%.02f", rmbLastBalance];
    _footerView.rmbDebitLabel.text = [NSString stringWithFormat:@"%.02f", rmbDebit];
    _footerView.rmbCreditLabel.text = [NSString stringWithFormat:@"%.02f", rmbCredit];
    _footerView.rmbBalanceLabe.text = [NSString stringWithFormat:@"%.02f", rmbBalance];
    _footerView.usdLastBalanceLabel.text = [NSString stringWithFormat:@"%.02f", usdLastBalance];
    _footerView.usdDebitLabel.text = [NSString stringWithFormat:@"%.02f", usdDebit];
    _footerView.usdCreditLabel.text = [NSString stringWithFormat:@"%.02f", usdCredit];
    _footerView.usdBalanceLabe.text = [NSString stringWithFormat:@"%.02f", usdBalance];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    cbHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:4];
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orgs.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    orgObj *org = [_orgs objectAtIndex:indexPath.row];
    return [cbCell heightForRowsCount:org.items.count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    orgObj *org = [_orgs objectAtIndex:indexPath.row];
    cbCell *cell = (cbCell*)[tableView dequeueReusableCellWithIdentifier:@"cbCell"];
    if( !cell ){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:8];
        cell.target = self;
        cell.action = @selector(onTouchAccount:);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if( indexPath.row % 2 == 1 ){
        cell.backgroundColor = [UIColor colorWithRed:242.00/255.00 green:242.00/255.00 blue:242.00/255.00 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.label.text = org.name;
    cell.items = org.items;
    [cell.tableview reloadData];
    return cell;
}


- (void)onTouchAccount:(UIButton*)button
{
    NSString *account = button.titleLabel.text;
    NSLog(@"----------%@", account);
}

@end
