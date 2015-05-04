//
//  monthSelectView.m
//  SRMonthPickerExample
//
//  Created by 林景隆 on 10/27/14.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import "monthSelectView.h"
#import <QuartzCore/QuartzCore.h>

@interface monthSelectView()
{
    UIView *topLine;
    UIView *bottomLine;
    UIView *middleLine;
    int maxYear;
    int minYear;
    UIColor *blueTextColor;
    UIColor *grayTextColor;
    UIColor *grayTextColor2;
    UIColor *grayLineColor;
}
@end

@implementation monthSelectView
@synthesize toolBar;
@synthesize yearView;
@synthesize monthsView;
@synthesize block;
@synthesize selectedMonth;
@synthesize selectedYear;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self ){
        selectedYear = -1;
        selectedMonth = -1;
        blueTextColor = [UIColor colorWithRed:87.00/255.00 green:127.00/255.00 blue:186.00/255.00 alpha:1];
        grayTextColor = [UIColor colorWithRed:183.00/255.00 green:183.00/255.00 blue:183.00/255.00 alpha:1];
        grayLineColor = [UIColor colorWithRed:120.00/255.00 green:127.00/255.00 blue:140.00/255.00 alpha:1];
    }
    return self;
}

- (void)onTouchOK:(id)sender
{
    if( block ){
        block( selectedYear, selectedMonth );
    }
}

- (void)onTouchClear:(id)sender
{
    if( block ){
        block( 0, 0 );
    }
}

- (void)onTouchCancel:(id)sender
{
    if( block ){
        block( -1, -1 );
    }
}

- (void)layoutSubviews
{
    if( !topLine ){
        topLine = [[UIView alloc] initWithFrame:CGRectZero];
        topLine.backgroundColor = grayLineColor;
        [self addSubview:topLine];
    }
    
    if( !bottomLine ){
        bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        bottomLine.backgroundColor = grayLineColor;
        [self addSubview:bottomLine];
    }
    
    if( !middleLine ){
        middleLine = [[UIView alloc] initWithFrame:CGRectZero];
        middleLine.backgroundColor = grayLineColor;
        [self addSubview:middleLine];
    }
    
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHieght = self.bounds.size.height;
    CGFloat toolBarHeight = 40;
    CGFloat margin = 2;
    CGFloat monthCellWith = 40;
    CGFloat monthCellHeight = 40;
    topLine.frame = CGRectMake(margin, 0, viewWidth-2*margin, 1);
    bottomLine.frame = CGRectMake(margin, viewHieght-toolBarHeight, viewWidth-2*margin, 1);
    middleLine.frame = CGRectMake((viewWidth-1)/3, margin, 1, viewHieght-2*margin-toolBarHeight);
    
    CGFloat yearViewHeight = viewHieght-toolBarHeight-2*margin-2;
    if( !yearView ){
        maxYear = 2114;
        minYear = 1914;
        self.backgroundColor = [UIColor whiteColor];
        yearView = [[UIPickerView alloc] initWithFrame:CGRectMake(margin, 1, middleLine.frame.origin.x-2*margin, yearViewHeight)];
        yearView.delegate = self;
        yearView.dataSource = self;
        yearView.showsSelectionIndicator = YES;
        [self addSubview:yearView];
    }
    yearView.frame = CGRectMake(margin, 1, middleLine.frame.origin.x-2*margin, yearViewHeight);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [dateComponent year];
    if( selectedYear == -1 ){
        selectedYear = year;
    }
    if( selectedMonth == -1 ){
        selectedMonth = [dateComponent month];
    }
    [yearView selectRow:selectedYear-minYear inComponent:0 animated:NO];
    
    CGFloat spacing = 10;
    CGFloat monthViewWidth = monthCellWith*4 + spacing * 3;
    CGFloat monthViewHeight = monthCellHeight * 3 + spacing *2;
    CGFloat monthViewLeft = (middleLine.frame.origin.x + 1) + (viewWidth - (middleLine.frame.origin.x + 1) - monthViewWidth )/2;
    CGFloat monthViewTop = (topLine.frame.origin.y+1) + (viewHieght - toolBarHeight - (topLine.frame.origin.y+1) - monthViewHeight )/2;
    if( !monthsView ){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(monthCellWith, monthCellHeight);
        flowLayout.minimumInteritemSpacing = spacing;
        flowLayout.minimumLineSpacing = spacing;
        monthsView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        monthsView.backgroundColor = [UIColor whiteColor];
        monthsView.delegate = self;
        monthsView.dataSource = self;
        [monthsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"selectMonthVC_cell"];
        [self addSubview:monthsView];
    }
    monthsView.frame = CGRectMake(monthViewLeft, monthViewTop, monthViewWidth, monthViewHeight);
    /*
    [monthsView selectItemAtIndexPath:[NSIndexPath indexPathForItem:dateComponent.month-1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    */
    
    NSString *ok = NSLocalizedString(@"Confirm", nil);
    NSString *clear = NSLocalizedString(@"Clear", nil);
    NSString *cancel = NSLocalizedString(@"CANCEL", nil);
    /*
     if( !toolBar ){
     toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
     [self addSubview:toolBar];
     }
     toolBar.frame = CGRectMake(0, viewHieght-toolBarHeight, viewWidth, toolBarHeight);
     
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:ok style:UIBarButtonItemStylePlain target:self action:@selector(onTouchOK:)];
    [items addObject:okItem];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:clear style:UIBarButtonItemStylePlain target:self action:@selector(onTouchClear:)];
    [items addObject:clearItem];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:cancel style:UIBarButtonItemStylePlain target:self action:@selector(onTouchCancel:)];
    [items addObject:cancelItem];
    toolBar.items = items;
    */
    
    CGFloat buttonWidth = (viewWidth - 1 - 1) / 3;
    CGRect buttonFrame = CGRectMake(0, viewHieght-toolBarHeight, buttonWidth, toolBarHeight);
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = buttonFrame;
    okButton.backgroundColor = [UIColor clearColor];
    okButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:25];
    okButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [okButton setTitle:ok forState:UIControlStateNormal];
    [okButton setTitleColor:blueTextColor forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(onTouchOK:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okButton];
    
    CGRect buttonSeperatorFrame = CGRectMake(buttonFrame.origin.x+buttonWidth, buttonFrame.origin.y+2, 1, buttonFrame.size.height-4);
    UIView *buttonSeperator1 = [[UIView alloc] initWithFrame:buttonSeperatorFrame];
    buttonSeperator1.backgroundColor = grayLineColor;
    [self addSubview:buttonSeperator1];
    
    buttonFrame = CGRectOffset(buttonFrame, buttonWidth+1, 0);
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = buttonFrame;
    clearButton.backgroundColor = [UIColor clearColor];
    clearButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:25];
    clearButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clearButton setTitle:clear forState:UIControlStateNormal];
    [clearButton setTitleColor:blueTextColor forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(onTouchClear:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
    
    buttonSeperatorFrame = CGRectOffset(buttonSeperatorFrame, buttonWidth, 0);
    UIView *buttonSeperator2 = [[UIView alloc] initWithFrame:buttonSeperatorFrame];
    buttonSeperator2.backgroundColor = grayLineColor;
    [self addSubview:buttonSeperator2];
    
    buttonFrame = CGRectOffset(buttonFrame, buttonWidth+1, 0);
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = buttonFrame;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:25];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton setTitle:cancel forState:UIControlStateNormal];
    [cancelButton setTitleColor:blueTextColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onTouchCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return maxYear-minYear+1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return yearView.frame.size.height/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return yearView.frame.size.width;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", (long)minYear + row];
}

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [NSString stringWithFormat:@"%ld", (long)minYear + row];
    NSRange range = NSMakeRange(0, title.length);
    UIColor *color = [UIColor colorWithRed:87.00/255.00 green:127.00/255.00 blue:186.00/255.0 alpha:1.0];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return attr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedYear = minYear + row;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"selectMonthVC_cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Id forIndexPath:indexPath];
    NSString *title = [NSString stringWithFormat:@"%02ld", (long)(indexPath.item+1)];
    if( cell.contentView ){
        UILabel *label = (UILabel*)[cell.contentView viewWithTag:1701];
        if( !label )
        {
            label = [[UILabel alloc] initWithFrame:cell.bounds];
            label.tag = 1701;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = grayTextColor2;
            label.layer.cornerRadius = cell.bounds.size.width/2;
            label.layer.borderWidth = 1.0;
            label.layer.borderColor = grayTextColor.CGColor;
            label.layer.masksToBounds = YES;
            [cell.contentView addSubview:label];
        }
        label.text = title;
        if( indexPath.item == selectedMonth - 1 ){
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = blueTextColor;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedMonth = indexPath.item + 1;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:1701];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = blueTextColor;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:1701];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = grayTextColor2;
}

@end
