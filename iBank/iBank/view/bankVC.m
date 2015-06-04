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
#import "yearMonthVC.h"
#import "SRRefreshView.h"


#define BANK_ROW_HEIGHT 47

@implementation baAccountCell
@end

@implementation baInerSummaryCell
@end

@implementation baInserSummaryCell1
@end

@implementation baOrgCell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _org.accounts.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row < _org.accounts.count ) return BANK_ROW_HEIGHT;
    if( _org.rmbSummary && _org.usdSummary ) return 2 * BANK_ROW_HEIGHT;
    return BANK_ROW_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *backgroundColor1 = ROW_COLOR_1;
    UIColor *backgroundColor2 = ROW_COLOR_2;
    UIColor *backgroundColor = backgroundColor1;
    if( (indexPath.row + _startIndex) % 2 == 1 ){
        backgroundColor = backgroundColor2;
    }
    if( indexPath.row < _org.accounts.count ){
        baAccountCell *cell = (baAccountCell*)[tableView dequeueReusableCellWithIdentifier:@"baAccountCell"];
        if( !cell ){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"bankCells" owner:nil options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.accountButton addTarget:self action:@selector(onTouchAccount:) forControlEvents:UIControlEventTouchUpInside];
        }
        bankAccountObj *account = [_org.accounts objectAtIndex:indexPath.row];
        [cell.accountButton setTitle:account.account forState:UIControlStateNormal];
        cell.currencyTypeLabel.text = account.currencyType;
        cell.descLabel.text = account.desc;
        NSString *lastBalance = [Utility moneyFormatString:account.lastBalance];
        NSString *debit = [Utility moneyFormatString:account.debit];
        NSString *credit = [Utility moneyFormatString:account.credit];
        NSString *balance = [Utility moneyFormatString:account.balance];
        cell.lastBalanceLabel.text = lastBalance;
        cell.debitLabel.text= debit;
        cell.creditLabel.text = credit;
        cell.balanceLabel.text = balance;
        cell.backgroundColor = backgroundColor;
        cell.accountButton.tag = indexPath.row;
        return cell;
    }
    else if( _org.rmbSummary && _org.usdSummary ){
        baInerSummaryCell *cell = (baInerSummaryCell*)[tableView dequeueReusableCellWithIdentifier:@"baInerSummaryCell"];
        if( !cell ){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"bankCells" owner:nil options:nil] objectAtIndex:1];
        }
        cell.colorView1.backgroundColor = backgroundColor;
        cell.colorView2.backgroundColor = backgroundColor == backgroundColor1 ? backgroundColor2 : backgroundColor1;
        cell.rmbLastBalanceLabel.text = [Utility moneyFormatString:_org.rmbSummary.lastBalance];
        cell.rmbDebitLabel.text = [Utility moneyFormatString:_org.rmbSummary.debit];
        cell.rmbCreditLabel.text = [Utility moneyFormatString:_org.rmbSummary.credit];
        cell.rmbBalanceLabel.text = [Utility moneyFormatString:_org.rmbSummary.balance];
        cell.usdLastBalanceLabel.text = [Utility moneyFormatString:_org.usdSummary.lastBalance];
        cell.usdDebitLabel.text = [Utility moneyFormatString:_org.usdSummary.debit];
        cell.usdCreditLabel.text = [Utility moneyFormatString:_org.usdSummary.credit];
        cell.usdBalanceLabel.text = [Utility moneyFormatString:_org.usdSummary.balance];
        return cell;
    }
    else{
        baInserSummaryCell1 *cell = (baInserSummaryCell1*)[tableView dequeueReusableCellWithIdentifier:@"baInserSummaryCell1"];
        if( !cell ){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"bankCells" owner:nil options:nil] objectAtIndex:2];
        }
        bankAccountObj *account;
        if( _org.rmbSummary ){
            account = _org.rmbSummary;
        }
        else{
            account = _org.usdSummary;
        }
        cell.currencyTypeLabel.text = account.currencyType;
        NSString *lastBalance = [Utility moneyFormatString:account.lastBalance];
        NSString *debit = [Utility moneyFormatString:account.debit];
        NSString *credit = [Utility moneyFormatString:account.credit];;
        NSString *balance = [Utility moneyFormatString:account.balance];;
        cell.lastBalanceLabel.text = lastBalance;
        cell.debitLabel.text= debit;
        cell.creditLabel.text = credit;
        cell.balanceLabel.text = balance;
        cell.colorView.backgroundColor = backgroundColor;
        return cell;
    }
    
}

- (void)onTouchAccount:(UIButton*)button
{
    bankAccountObj *account = [_org.accounts objectAtIndex:button.tag];
    if( _target && _action ){
        [_target performSelector:_action withObject:account];
    }
}

@end

@implementation bankCell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bank.orgs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bankOrgObj *org = [_bank.orgs objectAtIndex:indexPath.row];
    return org.itemCount * BANK_ROW_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    baOrgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baOrgCell"];
    if( !cell ){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"bankCells" owner:nil options:nil] objectAtIndex:3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orgLabel.backgroundColor = [UIColor clearColor];
        cell.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.target = _target;
        cell.action = _action;
    }
    int startIndex = _startIndex;
    for( int i = 0; i < indexPath.row; i++ ){
        bankOrgObj *org = [_bank.orgs objectAtIndex:i];
        startIndex += org.itemCount;
    }
    cell.org = [_bank.orgs objectAtIndex:indexPath.row];
    cell.orgLabel.text = cell.org.orgName;
    cell.startIndex = startIndex;
    [cell.accountTableView reloadData];
    return cell;
}

@end


@interface bankVC ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    qryBankOrgAcctService *_qryBankOrgAcctSrv;
    NSString *_year;
    NSString *_month;
}

@property IBOutlet UITableView *tableView;

@property IBOutlet UIButton *yearMonthButton;

@property IBOutlet UIButton *chooseDateButton;

@property NSArray *banks;

@property indicatorView *iv;

@property outerSumaryCell *footerView;

@property outerSumaryCell1 *footerView1;

@property UIPopoverController *pop;

@property SRRefreshView *refreshView;

@property BOOL isRefreshing;

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
    _footerView1 = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:12];
    _tableView.tableFooterView = _footerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 20;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor grayColor];
    _refreshView.slime.skinColor = [UIColor grayColor];
    _refreshView.slime.lineWith = 0;
    _refreshView.slime.shadowBlur = 2;
    _refreshView.slime.shadowColor = [UIColor blackColor];
    [_tableView addSubview:_refreshView];
    
    NSDateComponents *componets = [Utility currentDateComponents];
    _year = [NSString stringWithFormat:@"%ld", componets.year];
    _month = [NSString stringWithFormat:@"%02ld", componets.month];
    [_yearMonthButton setTitle:[NSString stringWithFormat:@"%@-%@", _year, _month] forState:UIControlStateNormal];
    _iv = [[indicatorView alloc] initWithFrame:self.view.bounds];
    _qryBankOrgAcctSrv = [[qryBankOrgAcctService alloc] init];
    _qryBankOrgAcctSrv.qryBankOrgAcctBlock = ^( int code, id data){
        [indicatorView dismissOnlyIndicatorAtView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        if( weakSelf.isRefreshing ){
            [weakSelf.refreshView endRefresh];
            weakSelf.isRefreshing = NO;
        }
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
    [indicatorView showOnlyIndicatorAtView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
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
    BOOL hasRmbItem = NO;
    BOOL hasUsdItem = NO;
    NSInteger itemCount = 0;
    for( bankObj *bank in _banks ){
        if( bank.rmbSummary ){
            rmbLastBalance += bank.rmbSummary.balance;
            rmbDebit += bank.rmbSummary.debit;
            rmbCredit += bank.rmbSummary.credit;
            rmbBalance += bank.rmbSummary.balance;
            hasRmbItem = YES;
        }
        if( bank.usdSummary ){
            usdLastBalance += bank.usdSummary.balance;
            usdDebit += bank.usdSummary.debit;
            usdCredit += bank.usdSummary.credit;
            usdBalance += bank.usdSummary.balance;
            hasUsdItem = YES;
        }
        itemCount += bank.itemCount;
    }
    
    if( hasRmbItem && hasUsdItem ){
        _footerView.rmbLastBalanceLabel.text = [Utility moneyFormatString:rmbLastBalance];
        _footerView.rmbDebitLabel.text = [Utility moneyFormatString:rmbDebit];
        _footerView.rmbCreditLabel.text = [Utility moneyFormatString:rmbCredit];
        _footerView.rmbBalanceLabe.text = [Utility moneyFormatString:rmbBalance];
        _footerView.usdLastBalanceLabel.text = [Utility moneyFormatString:rmbLastBalance];
        _footerView.usdDebitLabel.text = [Utility moneyFormatString:rmbDebit];
        _footerView.usdCreditLabel.text = [Utility moneyFormatString:rmbCredit];
        _footerView.usdBalanceLabe.text = [Utility moneyFormatString:rmbBalance];
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
        _tableView.tableFooterView = _footerView;
    }
    else{
        if( hasRmbItem ){
            _footerView1.lastBalanceLabel.text = [Utility moneyFormatString:rmbLastBalance];
            _footerView1.debitLabel.text = [Utility moneyFormatString:rmbDebit];
            _footerView1.creditLabel.text = [Utility moneyFormatString:rmbCredit];
            _footerView1.balanceLabe.text = [Utility moneyFormatString:rmbBalance];
            _footerView1.currencyTypeLabel.text = @"RMB";
        }
        else{
            _footerView1.lastBalanceLabel.text = [Utility moneyFormatString:usdLastBalance];
            _footerView1.debitLabel.text = [Utility moneyFormatString:usdDebit];
            _footerView1.creditLabel.text = [Utility moneyFormatString:usdCredit];
            _footerView1.balanceLabe.text = [Utility moneyFormatString:usdLastBalance];
            _footerView1.currencyTypeLabel.text = @"USD";
        }
        if( itemCount % 2 == 0 ){
            _footerView1.container.backgroundColor = ROW_COLOR_1;
        }
        else{
            _footerView1.container.backgroundColor = ROW_COLOR_2;
        }
        if( _banks.count % 2 == 0 ){
            _footerView.backgroundColor = [UIColor whiteColor];
        }
        else{
            _footerView.backgroundColor = [UIColor colorWithRed:242.00/255.00 green:242.00/255.00 blue:242.00/255.00 alpha:1];
        }
        _tableView.tableFooterView = _footerView1;
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
    return bank.itemCount * BANK_ROW_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bankObj *bank = [_banks objectAtIndex:indexPath.row];
    bankCell *cell = (bankCell*)[tableView dequeueReusableCellWithIdentifier:@"bankCell"];
    if( !cell ){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"bankCells" owner:nil options:nil] objectAtIndex:4];
        cell.target = self;
        cell.action = @selector(onTouchAccount:);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.bankLabel.backgroundColor = [UIColor clearColor];
    }
    if( indexPath.row % 2 == 1 ){
        cell.backgroundColor = [UIColor colorWithRed:242.00/255.00 green:242.00/255.00 blue:242.00/255.00 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    int startIndex = 0;
    for( NSInteger i = 0; i < indexPath.row; i++ ){
        bankObj *b = [_banks objectAtIndex:i];
        startIndex += b.itemCount;
    }
    cell.bankLabel.text = bank.name;
    cell.bank = bank;
    cell.startIndex = startIndex;
    [cell.orgTableView reloadData];
    return cell;
}


- (void)onTouchAccount:(bankAccountObj*)account
{
    if( account ){
        detailVC *vc = [detailVC viewController];
        vc.accountId = account.accountId;
        vc.bank = account.bank;
        vc.company = account.org;
        vc.currencyType = account.ccode;
        vc.account = account.account;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (IBAction)onTouchYearMonth:(id)sender
{
    yearMonthVC *vc = [[yearMonthVC alloc] init];
    vc.selectedMonth = _month.integerValue;
    vc.selectedYear = _year.integerValue;
    vc.block = ^(NSInteger year, NSInteger month){
        [_pop dismissPopoverAnimated:YES];
        _year = [NSString stringWithFormat:@"%ld", year];
        _month = [NSString stringWithFormat:@"%02ld", month];
        [_yearMonthButton setTitle:[NSString stringWithFormat:@"%@-%@", _year,_month] forState:UIControlStateNormal];
        [self loadData];
    };
    vc.isPopOver = YES;
    _pop = [[UIPopoverController alloc] initWithContentViewController:vc];
    _pop.popoverContentSize = CGSizeMake(320, 202);
    [_pop presentPopoverFromRect:_chooseDateButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    _isRefreshing = YES;
    [self loadData];
    [_refreshView.activityIndicationView stopAnimating];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if( !_isRefreshing ){
        [_refreshView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( !_isRefreshing ){
        [_refreshView scrollViewDidEndDraging];
    }
}

@end
