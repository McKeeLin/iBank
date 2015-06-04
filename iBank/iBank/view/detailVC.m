//
//  detailVC.m
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "detailVC.h"
#import "dataHelper.h"
#import "Utility.h"
#import "qryAcctDetailService.h"
#import "detailCell.h"
#import "indicatorView.h"
#import "yearMonthVC.h"
#import "setFavAcctService.h"
#import "SRRefreshView.h"


@interface detailVC ()<UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
{
    qryAcctDetailService *_qryAcctDetailService;
    setFavAcctService *_setFavAcctService;
    NSArray *_items;
    IBOutlet UILabel *_companyLabel;
    IBOutlet UILabel *_bankLabel;
    IBOutlet UILabel *_accountLabel;
    IBOutlet UIButton *_yearMonthButton;
    IBOutlet UIButton *_favoriteButton;
    IBOutlet UILabel *_currencyTypeLabel;
    IBOutlet UILabel *_unitLabel;
    IBOutlet UILabel *_pageInfoLabel;
    IBOutlet UIView *_topBarView;
    int _pageNum;
    int _pageTotal;
    NSString *_year;
    NSString *_month;
}

@property IBOutlet UITableView *tableView;

@property UILabel *companyLabel;

@property UILabel *bankLabel;

@property UILabel *accountLabel;

@property UILabel *unitLabel;

@property UILabel *pageInfoLabel;

@property IBOutlet UIButton *firstPageButton;

@property IBOutlet UIButton *nextpageButton;

@property IBOutlet UIButton *previousPageButton;

@property IBOutlet UIButton *lastPageButton;

@property IBOutlet UIButton *chooseDateButton;

@property NSArray *items;

@property int pageNum;

@property int pageTotal;

@property UIButton *favoriteButton;

@property BOOL isFavorite;

@property indicatorView *iv;

@property UIPopoverController *pop;

@property SRRefreshView *refreshView;

@property BOOL isRefreshing;

@end






@implementation detailVC

+ (instancetype)viewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailVC * vc = [storyBoard  instantiateViewControllerWithIdentifier:@"detailVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    
    [_firstPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_previousPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_nextpageButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_lastPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_favoriteButton setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateSelected];
    _companyLabel.text = _company;
    _bankLabel.text = [NSString stringWithFormat:@"%@     %@", _bank, _account];
    _pageNum = 1;
    _pageTotal = 1;
    NSString *type = @"人民币";
    if( [_currencyType isEqualToString:@"USD"] ){
        type = @"美元";
    }
    _currencyTypeLabel.text = [NSString stringWithFormat:@"币种：%@", type];
    NSDateComponents *components = [Utility currentDateComponents];
    _year = [NSString stringWithFormat:@"%ld", components.year];
    _month = [NSString stringWithFormat:@"%02ld", components.month];
    [_yearMonthButton setTitle:[NSString stringWithFormat:@"%@-%@", _year, _month] forState:UIControlStateNormal];
    __weak detailVC *weakSelf = self;
    _qryAcctDetailService = [[qryAcctDetailService alloc] init];
    _qryAcctDetailService.qryAcctDetailBlock = ^(int code, int pageTotal, int pageNum, BOOL isFavorite, id data, NSString *org){
        if( weakSelf.iv ){
            [weakSelf.iv dismiss];
        }
        if( weakSelf.isRefreshing ){
            [weakSelf.refreshView endRefresh];
            weakSelf.isRefreshing = NO;
        }
        if( code == 1 ){
            weakSelf.companyLabel.text = org;
            weakSelf.pageInfoLabel.text = [NSString stringWithFormat:@"%d/%d", pageNum, pageTotal];
            weakSelf.pageTotal = pageTotal;
            weakSelf.pageNum = pageNum;
            weakSelf.isFavorite = isFavorite;
            weakSelf.favoriteButton.selected = isFavorite;
            weakSelf.items = (NSArray*)data;
            if( pageNum > 1 ){
                weakSelf.previousPageButton.enabled = YES;
                weakSelf.firstPageButton.enabled = YES;
            }
            if( pageNum < pageTotal ){
                weakSelf.lastPageButton.enabled = YES;
                weakSelf.nextpageButton.enabled = YES;
            }
            [weakSelf.tableView reloadData];
        }
        else if( code == -1201 || code == -1202 ){
            [weakSelf onSessionTimeout];
        }
        else{
            [weakSelf showMessage:data];
        }
    };
    
    _setFavAcctService = [[setFavAcctService alloc] init];
    _setFavAcctService.setFavAcctBlock = ^(int code, NSString *data){
        if( weakSelf.iv ){
            [weakSelf.iv dismiss];
        }
        if( code == 1 ){
            weakSelf.favoriteButton.selected = weakSelf.isFavorite;
            [[dataHelper helper].homeViewController loadFavorites];
        }
        else{
            weakSelf.favoriteButton.selected = !weakSelf.favoriteButton.selected;
            if( code == -1201 || code == -1202 ){
                [weakSelf onSessionTimeout];
            }
            else{
                [weakSelf showMessage:data];
            }

        }
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:9];
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailCell *cell = (detailCell*)[tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if( !cell ){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:10];
    }
    NSDictionary *item = [_items objectAtIndex:indexPath.row];
    NSString *balance = [item objectForKey:@"balance"];
    NSString *credit = [item objectForKey:@"credit"];
    NSString *debit = [item objectForKey:@"debit"];
    cell.dateLabel.text = [item objectForKey:@"date"];
    cell.smodeLabel.text = [item objectForKey:@"smode"];
    cell.receiptLabel.text = [[item objectForKey:@"receipt"] isKindOfClass:[NSString class]] ? [item objectForKey:@"receipt"] : @"";
    cell.debitLabel.text = [Utility moneyFormatString:debit.floatValue];
    cell.creditLabel.text = [Utility moneyFormatString:credit.floatValue];
    cell.sumaryLabel.text = [[item objectForKey:@"summary"] isKindOfClass:[NSString class]] ? [item objectForKey:@"summary"] : @"";
    cell.descLabel.text = [[item objectForKey:@"desc"] isKindOfClass:[NSString class]] ? [item objectForKey:@"desc"] : @"";
    cell.balanceLabel.text = [Utility moneyFormatString:balance.floatValue];
    NSNumber *ln = [item objectForKey:@"ln"];
    cell.numLabel.text = [NSString stringWithFormat:@"%d", ln.intValue + 1 ];
    return cell;
}

- (IBAction)onTouchYearMonth:(id)sender
{
    _pageNum = 1;
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
    [_pop presentPopoverFromRect:_chooseDateButton.frame inView:_topBarView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)onTouchNextPage:(id)sender
{
    _pageNum++;
    if( _pageNum > _pageTotal )
    {
        _pageNum = _pageTotal;
        return;
    }
    [self loadData];
}

- (IBAction)onTouchPrePage:(id)sender
{
    _pageNum--;
    if( _pageNum < 1 )
    {
        _pageNum = 1;
        return;
    }
    [self loadData];
}

- (IBAction)onTouchFirstPage:(id)sender
{
    if( _pageNum == 1 ) return;
    _pageNum = 1;
    [self loadData];
}

- (IBAction)onTouchLastPage:(id)sender
{
    if( _pageNum == _pageTotal ) return;
    _pageNum = _pageTotal;
    [self loadData];
}

- (IBAction)onTouchFavorite:(id)sender
{
    _isFavorite = !_isFavorite;
    _iv = [indicatorView view];
    [_iv showAtMainWindow];
    _setFavAcctService.accountId = _accountId;
    _setFavAcctService.favorite = _isFavorite;
    [_setFavAcctService request];
}

- (IBAction)onTouchClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onTouchBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadData
{
    _iv = [indicatorView view];
    [_iv showAtMainWindow];
    self.firstPageButton.enabled = NO;
    self.previousPageButton.enabled = NO;
    self.nextpageButton.enabled = NO;
    self.lastPageButton.enabled = NO;
    _qryAcctDetailService.pageNum = _pageNum;
    _qryAcctDetailService.accountId = _accountId;
    _qryAcctDetailService.year = _year;
    _qryAcctDetailService.month = _month;
    [_qryAcctDetailService request];
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
