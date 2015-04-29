//
//  indicationView.h
//  OA2
//
//  Created by game-netease on 15/4/29.
//  Copyright (c) 2015年 game-netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface indicatorView : UIView

@property IBOutlet UIActivityIndicatorView *aiv;

@property IBOutlet UILabel *label;

+ (instancetype)view;

+ (void)showOnlyIndicatorAtView:(UIView*)view;

+ (void)dismissOnlyIndicatorAtView:(UIView*)view;

- (void)showAtMainWindow;

- (void)showAtView:(UIView*)view;

- (void)dismiss;


@end
