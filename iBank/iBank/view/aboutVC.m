//
//  aboutVC.m
//  iBank
//
//  Created by McKee on 15/4/26.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "aboutVC.h"

@interface aboutVC ()

@end

@implementation aboutVC

+ (instancetype)viewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    aboutVC * vc = [storyBoard  instantiateViewControllerWithIdentifier:@"aboutVC"];
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

@end
