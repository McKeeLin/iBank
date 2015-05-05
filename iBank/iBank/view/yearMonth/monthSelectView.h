//
//  monthSelectView.h
//  SRMonthPickerExample
//
//  Created by 林景隆 on 10/27/14.
//  Copyright (c) 2014 Simon Rice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MONTH_SELECT_VIEW_BLOCK)(NSInteger year, NSInteger month);

@interface monthSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property UIToolbar *toolBar;

@property UIPickerView *yearView;

@property UICollectionView *monthsView;

@property NSInteger selectedYear;

@property NSInteger selectedMonth;

@property (strong) MONTH_SELECT_VIEW_BLOCK block;

@end
