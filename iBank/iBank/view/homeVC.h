//
//  homeVC.h
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseVC.h"

@interface homeItem : NSObject

@property NSString *title;

@property NSString *value;

@end


@interface homeCurrency : NSObject

@property NSString *code;

@property NSString *symbol;

@property CGFloat balance;

@end


@interface homeBank : NSObject

@property CGFloat rmb;

@property CGFloat dollar;

@property NSString *name;

@property NSString *Id;

@property NSMutableArray *currentcies;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end


@interface homeOrg: NSObject

@property CGFloat rmb;

@property CGFloat dollar;

@property NSString *name;

@property NSString *Id;

@property NSMutableArray *banks;

@property NSMutableArray *items;

@property NSMutableArray *currentcies;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)addBank:(homeBank*)bank;

- (void)add:(NSDictionary*)dict;

@end


@interface favoriteCell : UITableViewCell

@property IBOutlet UILabel *bankLabel;

@property IBOutlet UIButton *accountButton;

@property IBOutlet UILabel *balanceLabel;


@end


@interface homeVC : baseVC

+ (instancetype)viewController;

- (void)loadFavorites;

@end
