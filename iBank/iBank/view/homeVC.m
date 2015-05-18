//
//  homeVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "homeVC.h"
#import "qryOrgBankBalanceService.h"
#import "qryMyFavoriteService.h"
#import "getMyInfoService.h"
#import "qryMsgListService.h"
#import "logoutService.h"
#import "Utility.h"
#import "homeCell.h"
#import "detailVC.h"
#import "indicatorView.h"
#import "dataHelper.h"
#import "msgVC.h"
#import "sendMsgVC.h"
#import "msgListVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation homeItem
@end

@implementation homeCurrency
@end

@implementation homeBank

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if( self ){
        _currentcies = [[NSMutableArray alloc] initWithCapacity:0];
        _Id = [dict objectForKey:@"bid"];
        _name = [dict objectForKey:@"bank"];
        _rmb = 0.00;
        _dollar = 0.00;
        NSString *balance = [dict objectForKey:@"amount"];
        NSString *code = [dict objectForKey:@"ccode"];
        if( [code isEqualToString:@"RMB"] ){
            _rmb = balance.floatValue;
        }
        else if( [code isEqualToString:@"USD"] ){
            _dollar = balance.floatValue;
        }
    }
    
    return self;
}

@end

@implementation homeOrg

- (instancetype)init
{
    self = [super init];
    if( self ){
        _banks = [[NSMutableArray alloc] initWithCapacity:0];
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _currentcies = [[NSMutableArray alloc] initWithCapacity:0];
    }    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if( self ){
        _Id = [dict objectForKey:@"oid"];
        _name = [dict objectForKey:@"org"];
        _rmb = 0.00;
        _dollar = 0.00;
    }
    return self;
}

- (void)addBank:(homeBank *)bank
{
    _rmb += bank.rmb;
    _dollar += bank.dollar;
    for( homeBank *item in _banks ){
        if( [item.Id isEqualToString:bank.Id] ){
            item.rmb += bank.rmb;
            item.dollar += bank.dollar;
            return;
        }
    }
    [_banks addObject:bank];
}

- (void)add:(NSDictionary*)dict
{
    homeBank *bank = [[homeBank alloc] initWithDictionary:dict];
    [self addBank:bank];
}

@end



@implementation favoriteCell
@end



@interface homeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_leftTableView;
    IBOutlet UITableView *_rightTableView;
    qryOrgBankBalanceService *_balanceSrv;
    getMyInfoService *_infoSrv;
    qryMyFavoriteService *_favoriteSrv;
    qryMsgListService *_qryUserMsgListSrv;
    qryMsgListService *_qrySystemMsgListSrv;
    NSMutableArray *_orgs;
    NSArray *_favoriteAccounts;
}

@property NSMutableArray *orgs;
@property NSArray *favoriteAccounts;
@property UITableView *leftTableView;
@property UITableView *rightTableView;
@property IBOutlet UILabel *userInfoLabel;
@property IBOutlet UILabel *dayInfoLabel;
@property IBOutlet UIView *userInfoView;
@property IBOutlet UIButton *systemMsgButton;
@property IBOutlet UIImageView *portraitView;
@property IBOutlet UILabel *userName;

@end

@implementation homeVC

+ (instancetype)viewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeVC * vc = [storyBoard  instantiateViewControllerWithIdentifier:@"homeVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [dataHelper helper].homeViewController = self;
    _portraitView.layer.masksToBounds = YES;
    _orgs = [[NSMutableArray alloc] initWithCapacity:0];
    __weak homeVC *weakSelf = self;
    _balanceSrv = [[qryOrgBankBalanceService alloc] init];
    _balanceSrv.qryOrgBankBalanceBlock = ^(int code, id data){
        [indicatorView dismissOnlyIndicatorAtView:weakSelf.leftTableView];
        if( code == 1 ){
            [weakSelf.orgs removeAllObjects];
            NSArray *items = (NSArray*)data;
            for( NSDictionary *item in items ){
                NSString *orgId = [item objectForKey:@"oid"];
                homeOrg *foundOrg;
                for( homeOrg *org in weakSelf.orgs )
                {
                    if( [org.Id isEqualToString:orgId] ){
                        foundOrg = org;
                        break;
                    }
                }
                
                if( !foundOrg ){
                    foundOrg = [[homeOrg alloc] initWithDictionary:item];
                    [weakSelf.orgs addObject:foundOrg];
                }
                [foundOrg add:item];
            }
            [weakSelf updateLeftTableView];
        }
        else{
            if( code == -1202 || code == -1201 ){
                [weakSelf onSessionTimeout];
            }
        }
    };
    
    _favoriteSrv = [[qryMyFavoriteService alloc] init];
    _favoriteSrv.qryMyFavoriteBlock = ^(int code, id data){
        [indicatorView dismissOnlyIndicatorAtView:weakSelf.rightTableView];
        if( code == 1 ){
            weakSelf.favoriteAccounts = (NSArray*)data;
            [weakSelf.rightTableView reloadData];
        }
        else{
            ;
        }
    };
    
    _infoSrv = [[getMyInfoService alloc] init];
    _infoSrv.getMyInfoBlock = ^(int code, id data){
        if( code == 1 ){
            NSArray *arr = (NSArray*)data;
            NSDictionary *info = arr.firstObject;
            weakSelf.userName.text = [info objectForKey:@"name"];
            NSString *user_avatar = [info objectForKey:@"user_avatar"];
            if( user_avatar ){
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:user_avatar options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *image = [UIImage imageWithData:imageData];
                if( image ){
                    weakSelf.portraitView.image = image;
                }
            }
        }
        else{
            ;
        }
    };
    
    _qrySystemMsgListSrv = [[qryMsgListService alloc] init];
    _qrySystemMsgListSrv.type = 1;
    _qrySystemMsgListSrv.count = 0;
    _qrySystemMsgListSrv.qryMsgListBlock = ^(int code, id data){
        if( code == 1 ){
            NSArray *msgs = (NSArray*)data;
            MsgObj *msg = msgs.firstObject;
            if( [msg.time isKindOfClass:[NSString class]] && msg.time.length > 0 ){
                NSArray *componets = [msg.time componentsSeparatedByString:@" "];
                NSString *date = componets.firstObject;
                [weakSelf.systemMsgButton setTitle:[NSString stringWithFormat:@"%@ %@", date, msg.title] forState:UIControlStateNormal];
            }
            else{
                [weakSelf.systemMsgButton setTitle:msg.title forState:UIControlStateNormal];
            }
        }
        else{
            ;
        }
    };
    [_qryUserMsgListSrv request];
    [dataHelper helper].qrySystemMsgListSrv = _qrySystemMsgListSrv;
    
    _qryUserMsgListSrv = [[qryMsgListService alloc] init];
    _qryUserMsgListSrv.type = 0;
    _qryUserMsgListSrv.count = 0;
    _qryUserMsgListSrv.qryMsgListBlock = ^(int code, id data){
        ;
    };
    [_qrySystemMsgListSrv request];
    [dataHelper helper].qryUserMsgListSrv = _qryUserMsgListSrv;

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd日EEEE";
    _dayInfoLabel.text = [df stringFromDate:[NSDate date]];
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
    NSDateComponents *components = [Utility currentDateComponents];
    NSString *year = [NSString stringWithFormat:@"%ld", components.year];
    NSString *month = [NSString stringWithFormat:@"%02ld", components.month];
    [indicatorView showOnlyIndicatorAtView:_leftTableView];
    _balanceSrv.year = year;
    _balanceSrv.month = month;
    [_balanceSrv request];
    
    [indicatorView showOnlyIndicatorAtView:_rightTableView];
    _favoriteSrv.year = year;
    _favoriteSrv.month = month;
    [_favoriteSrv request];
    
    [_infoSrv request];
}

- (void)updateLeftTableView
{
    NSString *prefixTag = @"    ";
    for( homeOrg *org in _orgs ){
        for( homeBank *bank in org.banks ){
            homeItem *rmbItem = [[homeItem alloc] init];
            rmbItem.title = [NSString stringWithFormat:@"%@%@", prefixTag, bank.name];
            rmbItem.value = [NSString stringWithFormat:@"￥%@", [Utility moneyFormatString:bank.rmb]];
            [org.items addObject:rmbItem];
            if( bank.dollar > 0 ){
                homeItem *dollarItem = [[homeItem alloc] init];
                dollarItem.title = rmbItem.title;
                dollarItem.value = [NSString stringWithFormat:@"$%@", [Utility moneyFormatString:bank.dollar]];
                [org.items addObject:dollarItem];
            }
        }
        
        if( org.dollar > 0 ){
            homeItem *orgDollarItem = [[homeItem alloc] init];
            orgDollarItem.title = @"";
            orgDollarItem.value = [NSString stringWithFormat:@"$%@", [Utility moneyFormatString:org.dollar]];
            [org.items insertObject:orgDollarItem atIndex:0];
        }
        homeItem *orgRmbItem = [[homeItem alloc] init];
        orgRmbItem.title = org.name;
        orgRmbItem.value = [NSString stringWithFormat:@"￥%@", [Utility moneyFormatString:org.rmb]];
        [org.items insertObject:orgRmbItem atIndex:0];
    }
    [_leftTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if( tableView == _leftTableView ){
        return _orgs.count;
    }
    else{
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( tableView == _leftTableView ){
        homeOrg *org = [_orgs objectAtIndex:section];
        return org.items.count;
    }
    else{
        if( _favoriteAccounts ){
            return _favoriteAccounts.count;
        }
        else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == _leftTableView ){
        return 52;
    }
    else{
        return 80;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( tableView == _leftTableView ){
        NSString *Id = @"homeCell";
        homeCell *cell = (homeCell*)[_leftTableView dequeueReusableCellWithIdentifier:Id];
        if( !cell ){
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil];
            cell = [cells objectAtIndex:2];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        homeOrg *org = [_orgs objectAtIndex:indexPath.section];
        homeItem *item = [org.items objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title.length > 0 ? [NSString stringWithFormat:@"%@：", item.title] : @"";
        cell.valueLabel.text = [NSString stringWithFormat:@"%@", item.value];
        if( indexPath.row == 0 || item.title.length == 0 ){
            cell.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:30];
            cell.valueLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:30];
        }
        else{
            cell.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:25];
            cell.valueLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:25];
        }
        return cell;
    }
    else{
        NSString *Id = @"favoriteCell";
        favoriteCell *cell = (favoriteCell*)[_leftTableView dequeueReusableCellWithIdentifier:Id];
        if( !cell ){
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil];
            cell = [cells objectAtIndex:3];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *info = [_favoriteAccounts objectAtIndex:indexPath.row];
        cell.bankLabel.text = [NSString stringWithFormat:@"%@：", [info objectForKey:@"bank"]];
        cell.accountButton.tag = indexPath.row;
        [cell.accountButton setTitle:[info objectForKey:@"acct"] forState:UIControlStateNormal];
        [cell.accountButton addTarget:self action:@selector(onTouchAccount:) forControlEvents:UIControlEventTouchUpInside];
        NSString *amount = [info objectForKey:@"amount"];
        cell.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",[info objectForKey:@"cstr"], [Utility moneyFormatString:amount.floatValue]];
        return cell;
    }
}

- (void)onTouchAccount:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSDictionary *info = [_favoriteAccounts objectAtIndex:button.tag];
    detailVC *vc = [detailVC viewController];
    vc.bank = [info objectForKey:@"bank"];
    vc.company = [info objectForKey:@"org"];
    vc.account = [info objectForKey:@"acct"];
    vc.accountId = [[info objectForKey:@"aid"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchSystemMsgButton:(id)sender
{
    if( [dataHelper helper].qrySystemMsgListSrv.msgs.count == 0 ){
        return;
    }
    /*
    UIButton *button = (UIButton*)sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    msgVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"msgVC"];
    vc.msgs = _qrySystemMsgListSrv.msgs;
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:vc];
    pop.popoverContentSize = CGSizeMake(600, 600);
    CGRect frame = CGRectMake((self.view.frame.size.width-pop.popoverContentSize.width)/2, (self.view.frame.size.height-pop.popoverContentSize.height)/2, pop.popoverContentSize.width, 1);
    [pop presentPopoverFromRect:[self.view convertRect:button.bounds fromView:button] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    */
    msgListVC *vc = [msgListVC viewController];
    vc.msgs = _qrySystemMsgListSrv.msgs;
    vc.forSystem = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchSendMsg:(id)sender
{
    sendMsgVC *vc = [sendMsgVC viewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchReadMsg:(id)sender
{
    if( _qryUserMsgListSrv.msgs.count == 0 )
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时无用户消息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        return;
    }
    
    msgListVC *vc = [msgListVC viewController];
    vc.msgs = _qryUserMsgListSrv.msgs;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchLogout:(id)sender
{
    __weak homeVC *weakSelf = self;
    logoutService *srv = [[logoutService alloc] init];
    srv.logoutBlock = ^(NSInteger code, NSString *data){
        [indicatorView dismissAtView:[UIApplication sharedApplication].keyWindow];
        if( [dataHelper helper].loginViewController ){
            [[dataHelper helper].loginViewController prepareLoginAgain];
        }
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [indicatorView showMessage:@"正在注销，请稍候..." atView:[UIApplication sharedApplication].keyWindow];
    [srv request];
}

- (void)loadFavorites
{
    NSDateComponents *components = [Utility currentDateComponents];
    NSString *year = [NSString stringWithFormat:@"%ld", components.year];
    NSString *month = [NSString stringWithFormat:@"%02ld", components.month];
    [indicatorView showOnlyIndicatorAtView:_rightTableView];
    _favoriteSrv.year = year;
    _favoriteSrv.month = month;
    [_favoriteSrv request];
}

@end
