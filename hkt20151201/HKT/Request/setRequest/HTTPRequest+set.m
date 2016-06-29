//
//  HTTPRequest+set.m
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+set.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (set)

// 登录
+(void)opinionWithPhone:(NSString *)phone
              Content:(NSString *)content
                From:(NSString *)from completeBlock:(void (^)(BOOL, NSString *, NSDictionary *))completeBlock
{
    
    NSParameterAssert(phone.length > 0);
    NSParameterAssert(content.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/feedback"];
    
    NSDictionary *parameters = @{@"feedback_phone" : phone,
                                 @"feedback_content" : content,
                                 @"feedback_from":from
                                 };
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
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
