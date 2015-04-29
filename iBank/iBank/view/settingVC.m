//
//  settingVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "settingVC.h"

@implementation serverCell

@end

@implementation loginCell

@end


@interface settingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
}

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
            loginCell *cll = cells.lastObject;
            cll.backgroundColor = [UIColor clearColor];
            [cll.logoutButton addTarget:self action:@selector(onTouchLogout:) forControlEvents:UIControlEventTouchUpInside];
            return cll;
        }
    }
    else{
        return cell;
    }
}

- (void)onTouchLogout:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onTouchTest:(id)sender
{
    ;
}

@end
