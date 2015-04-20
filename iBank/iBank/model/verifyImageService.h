//
//  verifyImageService.h
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "wbConn.h"

typedef void(^GET_VERIFY_IMAGE_BLOCK) (UIImage *image, NSString *code, NSString *error);

@interface verifyImageService : wbConn

@property (strong) GET_VERIFY_IMAGE_BLOCK getImageBlock;

@end
