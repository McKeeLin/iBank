//
//  cells.h
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define COMPANY_ROW_HEIGHT      47

#define ROW_COLOR_1             [UIColor colorWithRed:254.00/255.00 green:246.00/255.00 blue:238.00/255.00 alpha:1]
#define ROW_COLOR_2             [UIColor colorWithRed:255.00/255.00 green:227.00/255.00 blue:187.00/255.00 alpha:1]

@interface cbHeaderView : UIView

@property IBOutlet UILabel *firstLabel;

@property IBOutlet UILabel *secondLabel;

@end


@interface accountCell : UITableViewCell

@property IBOutlet UILabel *firstLabel;

@property IBOutlet UILabel *typeLabel;

@property IBOutlet UILabel *lastBalanceLabel;

@property IBOutlet UILabel *debitLabel;

@property IBOutlet UILabel *creditLabel;

@property IBOutlet UILabel *balanceLabe;

@property IBOutlet UIButton *accountButton;

@end




@interface outerSumaryCell : UITableViewCell

@property IBOutlet UILabel *rmbLabel;

@property IBOutlet UILabel *rmbLastBalanceLabel;

@property IBOutlet UILabel *rmbDebitLabel;

@property IBOutlet UILabel *rmbCreditLabel;

@property IBOutlet UILabel *rmbBalanceLabe;

@property IBOutlet UILabel *usdLabel;

@property IBOutlet UILabel *usdLastBalanceLabel;

@property IBOutlet UILabel *usdDebitLabel;

@property IBOutlet UILabel *usdCreditLabel;

@property IBOutlet UILabel *usdBalanceLabe;

@property IBOutlet UIView *container1;

@property IBOutlet UIView *container2;

@end


@interface innerSumaryCell : UITableViewCell

@property IBOutlet UILabel *rmbLabel;

@property IBOutlet UILabel *rmbLastBalanceLabel;

@property IBOutlet UILabel *rmbDebitLabel;

@property IBOutlet UILabel *rmbCreditLabel;

@property IBOutlet UILabel *rmbBalanceLabe;

@property IBOutlet UILabel *usdLabel;

@property IBOutlet UILabel *usdLastBalanceLabel;

@property IBOutlet UILabel *usdDebitLabel;

@property IBOutlet UILabel *usdCreditLabel;

@property IBOutlet UILabel *usdBalanceLabe;

@property IBOutlet UIView *background1;

@property IBOutlet UIView *background2;

@end


@interface cbCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property IBOutlet UILabel *label;

@property IBOutlet UITableView *tableview;

@property NSArray *items;

@property id target;

@property SEL  action;

@property BOOL forBank;

@property UIColor *color1;

@property UIColor *color2;

@property NSInteger startIndex;

+ (CGFloat)heightForRowsCount:(NSInteger)count;

@end
