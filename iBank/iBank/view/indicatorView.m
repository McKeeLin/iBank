//
//  indicationView.m
//  OA2
//
//  Created by game-netease on 15/4/29.
//  Copyright (c) 2015年 game-netease. All rights reserved.
//

#import "indicatorView.h"

@implementation indicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)view
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"indicatorView" owner:nil options:nil];
    if( views.count > 0 ){
        indicatorView *view = (indicatorView*)views.firstObject;
        return view;
    }
    return nil;
}

+ (void)showOnlyIndicatorAtView:(UIView *)view
{
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat aivWidth = 20;
    CGFloat aivHeight = 20;
    CGFloat viewWidth = view.bounds.size.width;
    CGFloat viewHeight = view.bounds.size.height;
    aiv.frame = CGRectMake((viewWidth-aivWidth)/2, (viewHeight-aivHeight)/2, aivWidth, aivHeight);
    aiv.tag = 60160101;
    [view addSubview:aiv];
    [aiv startAnimating];
}

+ (void)dismissOnlyIndicatorAtView:(UIView *)view
{
    UIView *aiv = [view viewWithTag:60160101];
    [aiv removeFromSuperview];
}

+ (void)showMessage:(NSString *)message atView:(UIView *)view
{
    indicatorView *aiv = [indicatorView view];
    aiv.label.text = message;
    aiv.tag = 60160102;
    aiv.frame = view.bounds;
    [aiv.aiv startAnimating];
    [view addSubview:aiv];
}

+ (void)dismissAtView:(UIView *)view
{
    UIView *aiv = [view viewWithTag:60160102];
    if( [aiv isKindOfClass:[indicatorView class]] ){
        [aiv removeFromSuperview];
    }
}

- (void)showAtView:(UIView*)view
{
    self.frame = view.bounds;
    self.label.hidden = YES;
    _aiv.center = self.center;
    [view addSubview:self];
    [_aiv startAnimating];
}

- (void)showAtMainWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showAtView:window];
}

- (void)dismiss
{
    [self.aiv stopAnimating];
    if( self.superview )
    {
        [self removeFromSuperview];
    }
}

@end
