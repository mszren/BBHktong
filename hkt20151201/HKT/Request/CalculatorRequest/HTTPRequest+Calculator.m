//
//  HTTPRequest+Calculator.m
//  HKT
//
//  Created by app on 15/9/22.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+Calculator.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (Calculator)

+ (void)requestWithCalculator:(void (^)(BOOL ok, NSString *message, NSDictionary *data))completeBlock{

    NSString *url = [NSString stringWithFormat:@"%@index.php/Other/Moneyrate/ratelist",kBasePort];
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:nil
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            
            if (code != 1) {
                completeBlock(NO, message, nil);
                return;
            }
            
            completeBlock(YES, message, data);
        }];

}

@end
