//
//  HTTPRequest+Login.m
//  HKT
//
//  Created by Ting on 15/9/15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+Punch.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"
#import "MoodModel.h"

@implementation HTTPRequest (Punch)


+ (void)getMoodListWithAdminId:(NSString *)admin_id
                 completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForMoodList))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/reportPage"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id};
    
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
            
            NSMutableArray * array = [NSMutableArray new];
            for (NSDictionary *dic in data[@"feeling"]) {
                MoodModel *moodModel = [MoodModel new];
                moodModel.key = dic[@"key"];
                moodModel.iconUrl = dic[@"icon"];
                moodModel.feeling = dic[@"feeling"];
                moodModel.said = dic[@"said"];
                moodModel.shareContent = dic[@"share"];
                
                [array addObject:moodModel];
            }
            
            completeBlock(YES, message, [array copy]);
        }];
}

+ (void)addMoodListWithAdminId:(NSString *)admin_id
                       moodKey:(NSString *)moodKey
                 completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(moodKey.length > 0);
    
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/addReport"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id,
                                 @"status"   : moodKey
                                 };
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            
            if (code != 1) {
                completeBlock(NO, message);
                return;
            }
            
            BOOL isSucceed = [data[@"result"]boolValue];
            
            completeBlock(isSucceed, data[@"rewardMoney"]);
        }];
    
    
    
}

@end
