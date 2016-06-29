//
//  HTTPRequest+AD.m
//  HKT
//
//  Created by Ting on 15/11/20.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+AD.h"
#import "HTTPRequest+Private.h"

@implementation HTTPRequest (AD)

+(void)getAdImageUrlCompleteBlock:(void (^)(BOOL ok, NSString *message, NSURL *url))completeBlock{
    
    NSString *size;
    
    if (iPhone4){
        size = @"640_960";
    }else if (iPhone5){
        size = @"640_1136";
    }else if (iPhone6){
        size = @"750_1334";
    }else if (iPhone6P){
        size = @"1242_2208";
    }
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/getAdv"];
    
    NSDictionary *parameters = @{@"appName" :   @"hkt",
                                 @"advType" :   @"ydy",
                                 @"advSize" :   size
                                 };
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
              timeout:4.0f
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            if (code != 1) {
                completeBlock(NO, message, nil);
                return;
            }
            
            NSURL *imgUrl = [NSURL URLWithString:data[@"imgAddress"]];            
            completeBlock(YES, message,imgUrl);
        }];
}

@end
