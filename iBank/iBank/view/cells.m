//
//  cells.m
//  iBank
//
//  Created by McKee on 15/5/3.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "cells.h"
#import "detailVC.h"


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
    UIColor *backgroundColor1 = ROW_COLOR_1;
    UIColor *backgroundColor2 = ROW_COLOR_2;
    UIColor *backgroundColor = backgroundColor1;
    if( (indexPath.row + _startIndex) % 2 == 1 ){
        backgroundColor = backgroundColor2;
    }
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    if( indexPath.row < self.items.count - 2 ){
        accountCell *cell = (accountCell*)[tableView dequeueReusableCellWithIdentifier:@"accountCell"];
        if( !cell ){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"cells" owner:nil options:nil] objectAtIndex:5];
            [cell.accountButton addTarget:self action:@selector(onTouchAccount:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.backgroundColor = backgroundColor;
        if( self.forBank ){
            cell.firstLabel.text = [item objectForKey:@"org"];
        }
        else{
            cell.firstLabel.text = [item objectForKey:@"bank"];
        }
        NSString *lastBalance = [item objectForKey:@"lastb"];
        NSString *debit = [item objectForKey:@"debit"];
        NSString *credit = [item objectForKey:@"credit"];
        NSString *balance = [item objectForKey:@"thisb"];
        cell.typeLabel.text = [item objectForKey:@"ccode"];
        cell.lastBalanceLabel.text = [NSString stringWithFormat:@"%.02f", lastBalance.floatValue];
        cell.debitLabel.text = [NSString stringWithFormat:@"%.02f", debit.floatValue];
        cell.creditLabel.text = [NSString stringWithFormat:@"%.02f", credit.floatValue];
        cell.balanceLabe.text= [NSString stringWithFormat:@"%.02f", balance.floatValue];
        cell.backgroundColor = backgroundColor;
        cell.accountButton.tag = indexPath.row;
        [cell.accountButton setTitle:[item objectForKey:@"acct"] forState:UIControlStateNormal];
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
        cell.rmbLastBalanceLabel.text = [rmbItem objectForKey:@"lastb"];
        cell.rmbDebitLabel.text = [rmbItem objectForKey:@"debit"];
        cell.rmbCreditLabel.text = [rmbItem objectForKey:@"credit"];
        cell.rmbBalanceLabe.text = [rmbItem objectForKey:@"thisb"];
        cell.usdLastBalanceLabel.text = [usdItem objectForKey:@"lastb"];
        cell.usdDebitLabel.text = [usdItem objectForKey:@"debit"];
        cell.usdCreditLabel.text = [usdItem objectForKey:@"credit"];
        cell.usdBalanceLabe.text = [usdItem objectForKey:@"thisb"];
        return cell;
    }
}

- (void)onTouchAccount:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSDictionary *item = [_items objectAtIndex:button.tag];
    if( self.target && self.action ){
        [self.target performSelector:self.action withObject:item];
    }
}

@end
