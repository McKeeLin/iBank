//
//  TextFieldEx.m
//  iBank
//
//  Created by McKee on 15/5/5.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "TextFieldEx.h"

@implementation TextFieldEx

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 3);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 3);
}


- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 3);
}




@end
