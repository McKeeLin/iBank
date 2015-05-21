//
//  aboutVC.m
//  iBank
//
//  Created by McKee on 15/4/26.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "aboutVC.h"
#import "dataHelper.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

@interface aboutVC ()
{
    IBOutlet UILabel *_label1;
    IBOutlet UILabel *_label2;
    IBOutlet UILabel *_label3;
    IBOutlet UILabel *_label4;
    IBOutlet UILabel *_label5;
    IBOutlet UILabel *_label6;
    IBOutlet UIImageView *_logo2;
}

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
    if( [dataHelper helper].sessionid.length > 0 ){
        self.navigationController.navigationBarHidden = YES;
    }
    else{
        self.navigationController.navigationBarHidden = NO;
        self.title = @"关于";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onTouchBack:)];
    }
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    _label1.text = [NSString stringWithFormat:@"Ntrualbit iBankBiz %ld （%@）", [Utility currentDateComponents].year, version];
    UIImage *logo2Img = [dataHelper helper].logo2Img;
    if( logo2Img ){
        _logo2.image = logo2Img;
    }
    _logo2.layer.masksToBounds = YES;
    _logo2.layer.contentsGravity = kCAGravityResizeAspect;
    _label6.text = [NSString stringWithFormat:@"S/N: %@", [dataHelper helper].sn];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect logo2Frame = _logo2.frame;
    CGFloat height = logo2Frame.size.height;
    CGFloat width = (_logo2.image.size.width / _logo2.image.size.height) * height;
    logo2Frame.size = CGSizeMake(width, height);
    _logo2.frame = logo2Frame;
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

- (void)onTouchBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
