//
//  cells.m
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "cells.h"


@implementation cbHeaderView

@end



@implementation accountCell

@end


@implementation outerSumaryCell

@end



@implementation innerSumaryCell

@end


@interface cbCell ()
{
}

@end


@implementation cbCell


+ (CGFloat)heightForRowsCount:(NSInteger)count
{
    return COMPANY_ROW_HEIGHT * count;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self ){
        ;
    }
    return self;
}

- (void)awakeFromNib
{
    ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row < self.items.count - 2 ){
        return COMPANY_ROW_HEIGHT;
    }
    else{
        return 2 * COMPANY_ROW_HEIGHT;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *backgroundColor1 = [UIColor colorWithRed:254.00/255.00 green:246.00/255.00 blue:238.00/255.00 alpha:1];
    UIColor *backgroundColor2 = [UIColor colorWithRed:255.00/255.00 green:221.00/255.00 blue:187.00/255.00 alpha:1];
    UIColor *backgroundColor = backgroundColor1;
    if( indexPath.row % 2 == 1 ){
        backgroundColor = backgroundColor2;
    }
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    if( indexPath.row < self.items.count - 2 ){
        accountCell *cell = (accountCell*)[tableView dequeueReusableCellWithIdentifier:@"accountCell"];
        if( !cell ){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:5];
            [cell.accountButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
        }
        cell.backgroundColor = backgroundColor;
        if( self.forBank ){
            cell.firstLabel.text = [item objectForKey:@"org_sname"];
        }
        else{
            cell.firstLabel.text = [item objectForKey:@"bank_sname"];
        }
        NSString *lastBalance = [item objectForKey:@"last_balance"];
        NSString *debit = [item objectForKey:@"debit_amount"];
        NSString *credit = [item objectForKey:@"debit_amount"];
        NSString *balance = [item objectForKey:@"balance"];
        cell.typeLabel.text = [item objectForKey:@"currency_code"];
        cell.lastBalanceLabel.text = [NSString stringWithFormat:@"%.02f", lastBalance.floatValue];
        cell.debitLabel.text = [NSString stringWithFormat:@"%.02f", debit.floatValue];
        cell.creditLabel.text = [NSString stringWithFormat:@"%.02f", credit.floatValue];
        cell.balanceLabe.text= [NSString stringWithFormat:@"%.02f", balance.floatValue];
        [cell.accountButton setTitle:[item objectForKey:@"bank_account"] forState:UIControlStateNormal];
        return cell;
    }
    else{
        NSDictionary *rmbItem = [self.items objectAtIndex:self.items.count - 2];
        NSDictionary *usdItem = self.items.lastObject;
        innerSumaryCell *cell = (innerSumaryCell*)[tableView dequeueReusableCellWithIdentifier:@"innerSumaryCell"];
        if( !cell ){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:6];
        }
        cell.background1.backgroundColor = backgroundColor;
        cell.background2.backgroundColor = backgroundColor == backgroundColor1 ? backgroundColor2 : backgroundColor1;
        cell.rmbLastBalanceLabel.text = [rmbItem objectForKey:@"last_balance"];
        cell.rmbDebitLabel.text = [rmbItem objectForKey:@"debit_amount"];
        cell.rmbCreditLabel.text = [rmbItem objectForKey:@"credit_amount"];
        cell.rmbBalanceLabe.text = [rmbItem objectForKey:@"balance"];
        cell.usdLastBalanceLabel.text = [usdItem objectForKey:@"last_balance"];
        cell.usdDebitLabel.text = [usdItem objectForKey:@"debit_amount"];
        cell.usdCreditLabel.text = [usdItem objectForKey:@"credit_amount"];
        cell.usdBalanceLabe.text = [usdItem objectForKey:@"balance"];
        return cell;
    }
}

- (void)onTouchAccount:(id)sender
{
    if( self.target && self.action ){
        [self.target performSelector:self.action withObject:nil];
    }
}

@end
