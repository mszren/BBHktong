//
//  HTTPRequest+main1.m
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+main.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (main)

+ (void)mainWithAdminID:(NSString *)adminID
             pageNumber:(NSString *)pageNumber
          completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(pageNumber.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/index"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"pageNums" : pageNumber};
    
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

+ (void)buttonWithAdminID:(NSString *)adminID
            completeBlock:(void (^)(BOOL ok, NSString *message,  BOOL isAddReport , BOOL isSeeRecom,NSString *adminAttr))completeBlock{
    
    NSParameterAssert(adminID.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/indexBottom"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID};
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            
            if (code != 1) {
                completeBlock(NO, message, NO,NO,nil);
                return;
            }
            
            BOOL isAddReport = [data[@"addReport"]boolValue];
            BOOL isSeeRecom = [data[@"seeRecom"]boolValue];
            NSString *adminAttr = data[@"adminAttr"];
            completeBlock(YES, message, isAddReport , isSeeRecom,adminAttr);
        }];
    
    
}




@end
