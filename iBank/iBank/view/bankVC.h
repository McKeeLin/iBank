//
//  bankVC.h
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseVC.h"

@class bankObj;
@class bankOrgObj;

@interface baAccountCell : UITableViewCell

@property IBOutlet UIButton *accountButton;

@property IBOutlet UILabel *currencyTypeLabel;

@property IBOutlet UILabel *lastBalanceLabel;

@property IBOutlet UILabel *debitLabel;

@property IBOutlet UILabel *creditLabel;

@property IBOutlet UILabel *balanceLabel;

@property IBOutlet UILabel *descLabel;

@end


@interface baInerSummaryCell : UITableViewCell

@property IBOutlet UILabel *rmbAccountLabel;

@property IBOutlet UILabel *rmbLastBalanceLabel;

@property IBOutlet UILabel *rmbDebitLabel;

@property IBOutlet UILabel *rmbCreditLabel;

@property IBOutlet UILabel *rmbBalanceLabel;

@property IBOutlet UILabel *usdAccountLabel;

@property IBOutlet UILabel *usdLastBalanceLabel;

@property IBOutlet UILabel *usdDebitLabel;

@property IBOutlet UILabel *usdCreditLabel;

@property IBOutlet UILabel *usdBalanceLabel;

@property IBOutlet UIView *colorView1;

@property IBOutlet UIView *colorView2;

@end


@interface baInserSummaryCell1 : UITableViewCell

@property IBOutlet UILabel *accountLabel;

@property IBOutlet UILabel *lastBalanceLabel;

@property IBOutlet UILabel *debitLabel;

@property IBOutlet UILabel *creditLabel;

@property IBOutlet UILabel *balanceLabel;

@property IBOutlet UILabel *currencyTypeLabel;

@property IBOutlet UIView *colorView;

@end



@interface baOrgCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property IBOutlet UILabel *orgLabel;

@property IBOutlet UITableView *accountTableView;

@property int startIndex;

@property bankOrgObj *org;

@property (weak) id target;

@property SEL action;

@end


@interface bankCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

@property IBOutlet UILabel *bankLabel;

@property IBOutlet UITableView *orgTableView;

@property int startIndex;

@property bankObj *bank;

@property (weak) id target;

@property SEL action;

@end





@interface bankVC : baseVC

+ (instancetype)viewController;

@end
