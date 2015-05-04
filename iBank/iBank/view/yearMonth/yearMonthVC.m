//
//  yearMonthVC.m
//  SRMonthPickerExample
//
//  Created by 林景隆 on 10/27/14.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "yearMonthVC.h"
#import "monthSelectView.h"
#import "UIImage+ImageEffects.h"

@interface yearMonthVC ()
{
    monthSelectView *msv;
    UIImageView *maskView;
}

@end

@implementation yearMonthVC
@synthesize backImage;
@synthesize block;
@synthesize selectedYear;
@synthesize selectedMonth;

- (id)init
{
    self = [super init];
    if( self ){
        selectedYear = -1;
        selectedMonth = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if( !msv ){
        CGFloat height = 202;
        CGFloat viewWidth = self.view.bounds.size.width;
        CGFloat viewHeight =self.view.bounds.size.height;
        if( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ){
            self.view.backgroundColor = [UIColor clearColor];
            maskView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            maskView.userInteractionEnabled = YES;
            maskView.backgroundColor = [UIColor clearColor];
            maskView.image = [self.backImage applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
            [self.view addSubview:maskView];
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMaskView:)];
            [maskView addGestureRecognizer:tgr];
            msv = [[monthSelectView alloc] initWithFrame:CGRectMake(0, viewHeight-height, viewWidth, height)];
            msv.selectedYear = selectedYear;
            msv.selectedMonth = selectedMonth;
            [self.view addSubview:msv];
            __weak YEAR_MONTH_VC_BLOCK weakBlock = self.block;
            __weak UIViewController *weakSelf = self;
            msv.block = ^(NSInteger year, NSInteger month){
                if( weakBlock ){
                    weakBlock( year, month);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
        }
        else{
            msv = [[monthSelectView alloc] initWithFrame:self.view.bounds];
            msv = [[monthSelectView alloc] initWithFrame:CGRectMake(0, viewHeight-height, viewWidth, height)];
            msv.selectedYear = selectedYear;
            msv.selectedMonth = selectedMonth;
            [self.view addSubview:msv];
            __weak YEAR_MONTH_VC_BLOCK weakBlock = self.block;
            __weak UIViewController *weakSelf = self;
            msv.block = ^(NSInteger year, NSInteger month){
                if( weakBlock ){
                    weakBlock( year, month);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            };
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onTapMaskView:(UITapGestureRecognizer*)tgr
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (UIImage*)screenShotImage
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
