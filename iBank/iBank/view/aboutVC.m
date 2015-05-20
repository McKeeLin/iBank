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
    }
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    _label1.text = [NSString stringWithFormat:@"Ntrualbit iBankBiz %ld （%@）", [Utility currentDateComponents].year, version];
    _logo2.layer.contentsGravity = kCAGravityResizeAspect;
    UIImage *logo2Img = [dataHelper helper].logo2Img;
    if( logo2Img ){
        _logo2.image = logo2Img;
//        CGRect logo2Frame = _logo2.frame;
//        logo2Frame.size = logo2Img.size;
//        _logo2.frame = logo2Frame;
//        CGRect label6Frame = _label6.frame;
//        label6Frame.origin.y = _logo2.frame.origin.y + _logo2.frame.size.height + 15;
//        _label6.frame = label6Frame;
    }
    _label6.text = [NSString stringWithFormat:@"S/N: %@", [dataHelper helper].sn];
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
