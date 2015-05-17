//
//  MsgObj.h
//  iBank
//
//  Created by McKee on 15/5/16.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UserObj : NSObject

@property NSString *name;

@property UIImage *image;

@property int userId;

@property BOOL selected;

@end


@interface MsgObj : NSObject

@property int msgId;

@property int type;

@property int state;

@property NSString *sender;

@property int senderId;

@property NSString *title;

@property NSString *time;

@property NSString *content;

@end
