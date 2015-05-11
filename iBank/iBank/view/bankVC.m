//
//  bankVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "bankVC.h"
#import "qryBankOrgAcctService.h"
#import "Utility.h"
#import "dataHelper.h"
#import "indicatorView.h"
#import "cells.h"
#import "detailVC.h"

@interface bankVC ()<UITableViewDataSource,UITableViewDelegate>
{
    qryBankOrgAcctService *_qryBankOrgAcctSrv;
    NSString *_year;
    NSString *_month;
}

@property IBOutlet UITableView *tableView;

@property NSArray *banks;

@property indicatorView *iv;

@property outerSumaryCell *footerView;

@end

@implementation bankVC


+ (instancetype)viewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bankVC * vc = [storyBoard  instantiateViewControllerWithIdentifier:@"bankVC"];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak bankVC *weakSelf = self;
    _footerView = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:7];
    _tableView.tableFooterView = _footerView;
    NSDateComponents *componets = [Utility currentDateComponents];
    _year = [NSString stringWithFormat:@"%ld", componets.year];
    _month = [NSString stringWithFormat:@"%02ld", componets.month];
    _iv = [[indicatorView alloc] initWithFrame:self.view.bounds];
    _qryBankOrgAcctSrv = [[qryBankOrgAcctService alloc] init];
    _qryBankOrgAcctSrv.qryBankOrgAcctBlock = ^( int code, id data){
        [indicatorView dismissOnlyIndicatorAtView:weakSelf.view];
        if( code == 1 ){
            weakSelf.banks = (NSArray*)data;
            [weakSelf.tableView reloadData];
            [weakSelf.iv dismiss];
            [weakSelf updateFooterView];
        }
        else if( code == 0 || code == -1201 || code == -1202 ){
            [weakSelf onSessionTimeout];
        }
        else{
            [weakSelf showMessage:data];
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
    [indicatorView showOnlyIndicatorAtView:self.view];
    _qryBankOrgAcctSrv.year = _year;
    _qryBankOrgAcctSrv.month = _month;
    [_iv showAtView:self.view];
    [_qryBankOrgAcctSrv request];
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
    NSInteger itemCount = 0;
    for( bankObj *bank in _banks ){
        rmbLastBalance += bank.rmbLastBalance;
        rmbDebit += bank.rmbDebit;
        rmbCredit += bank.rmbCredit;
        rmbBalance += bank.rmbBalance;
        usdLastBalance += bank.usdLastBalance;
        usdDebit += bank.usdDebit;
        usdCredit += bank.usdCredit;
        usdBalance += bank.usdCredit;
        itemCount += bank.items.count;
    }
    _footerView.rmbLastBalanceLabel.text = [NSString stringWithFormat:@"%.02f", rmbLastBalance];
    _footerView.rmbDebitLabel.text = [NSString stringWithFormat:@"%.02f", rmbDebit];
    _footerView.rmbCreditLabel.text = [NSString stringWithFormat:@"%.02f", rmbCredit];
    _footerView.rmbBalanceLabe.text = [NSString stringWithFormat:@"%.02f", rmbBalance];
    _footerView.usdLastBalanceLabel.text = [NSString stringWithFormat:@"%.02f", usdLastBalance];
    _footerView.usdDebitLabel.text = [NSString stringWithFormat:@"%.02f", usdDebit];
    _footerView.usdCreditLabel.text = [NSString stringWithFormat:@"%.02f", usdCredit];
    _footerView.usdBalanceLabe.text = [NSString stringWithFormat:@"%.02f", usdBalance];
    if( itemCount % 2 == 0 ){
        _footerView.container1.backgroundColor = ROW_COLOR_1;
        _footerView.container2.backgroundColor = ROW_COLOR_2;
    }
    else{
        _footerView.container1.backgroundColor = ROW_COLOR_2;
        _footerView.container2.backgroundColor = ROW_COLOR_1;
    }
    if( _banks.count % 2 == 0 ){
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    else{
        _footerView.backgroundColor = [UIColor colorWithRed:242.00/255.00 green:242.00/255.00 blue:242.00/255.00 alpha:1];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    cbHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:4];
    view.firstLabel.text = @"银行";
    view.secondLabel.text = @"公司";
    return view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.banks.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bankObj *bank = [_banks objectAtIndex:indexPath.row];
    return [cbCell heightForRowsCount:bank.items.count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bankObj *bank = [_banks objectAtIndex:indexPath.row];
    cbCell *cell = (cbCell*)[tableView dequeueReusableCellWithIdentifier:@"cbCell"];
    if( !cell ){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:8];
        cell.target = self;
        cell.action = @selector(onTouchAccount:);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.label.backgroundColor = [UIColor clearColor];
        cell.forBank = YES;
    }
    if( indexPath.row % 2 == 1 ){
        cell.backgroundColor = [UIColor colorWithRed:242.00/255.00 green:242.00/255.00 blue:242.00/255.00 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSInteger startIndex = 0;
    for( NSInteger i = 0; i < indexPath.row; i++ ){
        bankObj *o = [_banks objectAtIndex:i];
        startIndex += o.items.count;
    }
    cell.label.text = bank.name;
    cell.items = bank.items;
    cell.startIndex = startIndex;
    [cell.tableview reloadData];
    return cell;
}


- (void)onTouchAccount:(NSDictionary*)item
{
    if( item ){
        detailVC *vc = [detailVC viewController];
        vc.bank = [item objectForKey:@"bank"];
        vc.company = [item objectForKey:@"org"];
        vc.account = [item objectForKey:@"acct"];
        vc.accountId = [[item objectForKey:@"aid"] intValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
