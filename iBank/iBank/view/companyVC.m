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
#import "detailVC.h"
#import "yearMonthVC.h"
#import "SRRefreshView.h"

@interface companyVC ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    qryOrgBankAcctService *_qryOrgBankAcctSrv;
    NSString *_year;
    NSString *_month;
    SRRefreshView *_refreshView;
    BOOL _isRefreshing;
}

@property IBOutlet UITableView *tableView;

@property IBOutlet UIButton *yearMonthButton;

@property IBOutlet UIButton *chooseDateButton;

@property NSArray *orgs;

@property indicatorView *iv;

@property outerSumaryCell *footerView;

@property outerSumaryCell1 *footerView1;

@property UIPopoverController *pop;

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
    _footerView1 = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:12];
    _tableView.tableFooterView = _footerView;
    _refreshView = [[SRRefreshView alloc] init];
    _refreshView.delegate = self;
    _refreshView.upInset = 20;
    _refreshView.slimeMissWhenGoingBack = YES;
    _refreshView.slime.bodyColor = [UIColor grayColor];
    _refreshView.slime.skinColor = [UIColor grayColor];
    _refreshView.slime.lineWith = 0;
    _refreshView.slime.shadowBlur = 2;
    _refreshView.slime.shadowColor = [UIColor blackColor];
    [_refreshView addSubview:_refreshView];
    
    NSDateComponents *componets = [Utility currentDateComponents];
    _year = [NSString stringWithFormat:@"%ld", componets.year];
    _month = [NSString stringWithFormat:@"%02ld", componets.month];
    _qryOrgBankAcctSrv = [[qryOrgBankAcctService alloc] init];
    _qryOrgBankAcctSrv.qryOrgBankAcctBlock = ^( int code, id data){
        [indicatorView dismissOnlyIndicatorAtView:weakSelf.view];
        if( code == 1 ){
            weakSelf.orgs = (NSArray*)data;
            [weakSelf.tableView reloadData];
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
    _qryOrgBankAcctSrv.year = _year;
    _qryOrgBankAcctSrv.month = _month;
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
    NSInteger itemCount = 0;
    BOOL hasRmbItem = NO;
    BOOL hasUsdItem = NO;
    for( orgObj *org in _orgs ){
        rmbLastBalance += org.rmbLastBalance;
        rmbDebit += org.rmbDebit;
        rmbCredit += org.rmbCredit;
        rmbBalance += org.rmbBalance;
        usdLastBalance += org.usdLastBalance;
        usdDebit += org.usdDebit;
        usdCredit += org.usdCredit;
        usdBalance += org.usdBalance;
        itemCount += org.items.count;
        if( org.rmbItem ) hasRmbItem = YES;
        if( org.usdItem ) hasUsdItem = YES;
    }
    if( hasRmbItem && hasUsdItem ){
        _footerView.rmbLastBalanceLabel.text = [Utility moneyFormatString:rmbLastBalance];
        _footerView.rmbDebitLabel.text = [Utility moneyFormatString:rmbDebit];
        _footerView.rmbCreditLabel.text = [Utility moneyFormatString:rmbCredit];
        _footerView.rmbBalanceLabe.text = [Utility moneyFormatString:rmbBalance];
        _footerView.usdLastBalanceLabel.text = [Utility moneyFormatString:usdLastBalance];
        _footerView.usdDebitLabel.text = [Utility moneyFormatString:usdDebit];
        _footerView.usdCreditLabel.text = [Utility moneyFormatString:usdCredit];
        _footerView.usdBalanceLabe.text = [Utility moneyFormatString:usdBalance];
        if( itemCount % 2 == 0 ){
            _footerView.container1.backgroundColor = ROW_COLOR_1;
            _footerView.container2.backgroundColor = ROW_COLOR_2;
        }
        else{
            _footerView.container1.backgroundColor = ROW_COLOR_2;
            _footerView.container2.backgroundColor = ROW_COLOR_1;
        }
        if( _orgs.count % 2 == 0 ){
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
            _footerView1.lastBalanceLabel.text = [Utility moneyFormatString:usdBalance];
            _footerView1.debitLabel.text = [Utility moneyFormatString:usdDebit];
            _footerView1.creditLabel.text = [Utility moneyFormatString:usdCredit];
            _footerView1.balanceLabe.text = [Utility moneyFormatString:usdBalance];
            _footerView1.currencyTypeLabel.text = @"USD";
        }
        if( itemCount % 2 == 0 ){
            _footerView1.container.backgroundColor = ROW_COLOR_1;
        }
        else{
            _footerView1.container.backgroundColor = ROW_COLOR_2;
        }
        if( _orgs.count % 2 == 0 ){
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
        cell.label.backgroundColor = [UIColor clearColor];
    }
    if( indexPath.row % 2 == 1 ){
        cell.backgroundColor = [UIColor colorWithRed:242.00/255.00 green:242.00/255.00 blue:242.00/255.00 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSInteger startIndex = 0;
    for( NSInteger i = 0; i < indexPath.row; i++ ){
        orgObj *o = [_orgs objectAtIndex:i];
        startIndex += o.items.count;
    }
    cell.label.text = org.name;
    cell.items = org.items;
    cell.org = org;
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
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [self.view addSubview:maskView];
    _isRefreshing = YES;
    [self loadData];
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
