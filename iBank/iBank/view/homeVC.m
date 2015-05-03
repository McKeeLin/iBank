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
#import "Utility.h"
#import "homeCell.h"

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
        _Id = [dict objectForKey:@"bank_id"];
        _name = [dict objectForKey:@"bank_sname"];
        _rmb = 0.00;
        _dollar = 0.00;
        NSString *balance = [dict objectForKey:@"balance"];
        NSString *code = [dict objectForKey:@"currency_code"];
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
        _Id = [dict objectForKey:@"organ_id"];
        _name = [dict objectForKey:@"org_sname"];
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
    NSMutableArray *_orgs;
    NSArray *_favoriteAccounts;
}

@property NSMutableArray *orgs;
@property NSArray *favoriteAccounts;
@property UITableView *rightTableView;
@property IBOutlet UILabel *userInfoLabel;
@property IBOutlet UILabel *dayInfoLabel;

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
    // Do any additional setup after loading the view.
    _orgs = [[NSMutableArray alloc] initWithCapacity:0];
    __weak homeVC *weakSelf = self;
    _balanceSrv = [[qryOrgBankBalanceService alloc] init];
    _balanceSrv.qryOrgBankBalanceBlock = ^(int code, id data){
        if( code == 1 ){
            [weakSelf.orgs removeAllObjects];
            NSArray *items = (NSArray*)data;
            for( NSDictionary *item in items ){
                NSString *orgId = [item objectForKey:@"organ_id"];
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
            ;
        }
    };
    
    _favoriteSrv = [[qryMyFavoriteService alloc] init];
    _favoriteSrv.qryMyFavoriteBlock = ^(int code, id data){
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
            NSDictionary *info = (NSDictionary*)data;
            weakSelf.userInfoLabel.text = [NSString stringWithFormat:@"您好！%@", [info objectForKey:@"real_name"]];
        }
        else{
            ;
        }
    };

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
    df.dateFormat = @"今天是：yyyy年MM月dd日EEEE";
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
    NSLog(@"%@", components);
    NSString *year = [NSString stringWithFormat:@"%ld", components.year];
    NSString *month = [NSString stringWithFormat:@"%02ld", components.month];
    _balanceSrv.year = year;
    _balanceSrv.month = month;
    [_balanceSrv request];
    
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
            rmbItem.value = [NSString stringWithFormat:@"￥ %.2f", bank.rmb];
            [org.items addObject:rmbItem];
            if( bank.dollar > 0 ){
                homeItem *dollarItem = [[homeItem alloc] init];
                dollarItem.title = rmbItem.title;
                dollarItem.value = [NSString stringWithFormat:@"$ %.2f", bank.dollar];
                [org.items addObject:dollarItem];
            }
        }
        
        if( org.dollar > 0 ){
            homeItem *orgDollarItem = [[homeItem alloc] init];
            orgDollarItem.title = @"";
            orgDollarItem.value = [NSString stringWithFormat:@"$ %.2f", org.dollar];
            [org.items insertObject:orgDollarItem atIndex:0];
        }
        homeItem *orgRmbItem = [[homeItem alloc] init];
        orgRmbItem.title = org.name;
        orgRmbItem.value = [NSString stringWithFormat:@"￥ %.2f", org.rmb];
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
        cell.titleLabel.text = [NSString stringWithFormat:@"%@：", item.title];
        cell.valueLabel.text = [NSString stringWithFormat:@"%@：", item.value];
        if( indexPath.row == 0 ){
            cell.titleLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
            cell.valueLabel.font = [UIFont fontWithName:@"微软雅黑" size:30];
        }
        else{
            cell.titleLabel.font = [UIFont fontWithName:@"微软雅黑" size:25];
            cell.valueLabel.font = [UIFont fontWithName:@"微软雅黑" size:25];
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
        cell.bankLabel.text = [NSString stringWithFormat:@"%@：", [info objectForKey:@"bank_sname"]];
        cell.accountLabel.text = [info objectForKey:@"bank_account"];
        cell.balanceLabel.text = [NSString stringWithFormat:@"%@ %@",[info objectForKey:@"currency_symbol"], [info objectForKey:@"balance"]];
        return cell;
    }
}

@end
