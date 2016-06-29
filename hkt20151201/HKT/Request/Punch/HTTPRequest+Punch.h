//
//  HTTPRequest+Login.h
//  HKT
//
//  Created by Ting on 15/9/15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"


@interface HTTPRequest (Punch)

// 读取签到图片
+ (void)getMoodListWithAdminId:(NSString *)admin_id
         completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForMoodList))completeBlock;

// 添加签到
+ (void)addMoodListWithAdminId:(NSString *)admin_id
                       moodKey:(NSString *)moodKey
                 completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;


@end
