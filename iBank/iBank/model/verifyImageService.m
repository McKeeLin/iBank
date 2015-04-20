//
//  verifyImageService.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "verifyImageService.h"
#import "Utility.h"

@implementation verifyImageService

- (instancetype)init
{
    self = [super init];
    if( self ){
        self.url = @"http://222.49.117.9/ibankbizdev/index.php/ibankbiz/auth/api?ws=1";
        self.soapAction = @"urn:AuthControllerwsdl/reqVerifyMsg";
        self.soapBody = @"<reqVerifyMsg xmlns=\"urn:AuthControllerwsdl\"></reqVerifyMsg>";
    }
    return self;
}

- (void)parseResult:(NSString*)result
{
    UIImage *image;
    NSString *error;
    NSString *code = 0;
    if( result ){
        NSDictionary *res = [Utility dictionaryWithJsonString:result];
        code = [res objectForKey:@"result"];
        NSString *dataString = [res objectForKey:@"data"];
        if( code && dataString.length > 0 ){
            if( [code isEqualToString:@"0"] ){
                error = dataString;
            }
            else{
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                image = [UIImage imageWithData:imageData];
            }
        }
    }
    
    if( self.getImageBlock ){
        self.getImageBlock( image, code, error );
    }
}

- (void)onError:(NSString *)error
{
    if( self.getImageBlock ){
        self.getImageBlock( nil, @"0", error);
    }
}

@end
