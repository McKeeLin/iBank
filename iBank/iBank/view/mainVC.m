//
//  mainVC.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "mainVC.h"
#import "homeVC.h"
#import "companyVC.h"
#import "bankVC.h"
#import "settingVC.h"
#import "aboutVC.h"

@interface mainVC ()

@end

@implementation mainVC

+ (instancetype)viewController
{
    mainVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainVC"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.pageControl.showVerticalDivider = NO;
    self.pageControl.backgroundColor = [UIColor colorWithRed:85.00/255 green:85.00/255 blue:85.00/255 alpha:1.0];
    self.pageControl.type = HMSegmentedControlTypeImages;
    self.pageControl.segmentEdgeInset = UIEdgeInsetsZero;
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.pageControl.sectionImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"动态-标准状态"], [UIImage imageNamed:@"公司-标准状态"], [UIImage imageNamed:@"银行-标准状态"], [UIImage imageNamed:@"设置-标准状态"], [UIImage imageNamed:@"关于-标准状态"], nil];
    self.pageControl.sectionSelectedImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"动态-经过，选中状态"], [UIImage imageNamed:@"公司-经过，选中状态"], [UIImage imageNamed:@"银行-经过，选中状态"], [UIImage imageNamed:@"设置-经过，选中状态"], [UIImage imageNamed:@"关于-经过，选中状态"], nil];
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:0];
    [pages addObject:[homeVC viewController]];
    [pages addObject:[companyVC viewController]];
    [pages addObject:[bankVC viewController]];
    [pages addObject:[settingVC viewController]];
    [pages addObject:[aboutVC viewController]];
    [self setPages:pages];
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

@end
