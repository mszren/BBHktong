//
//  HTTPRequest+recommend.h
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (recommend)

+(void)recommandWithAdminId:(NSString *)adminID andType:(NSString *)type andLastID:(NSString *)lastID andPageNums:(NSString *)pageNums completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *array))completeBlock;

//跳转
+(void)recommandMoveWithAdminId:(NSString *)adminID andStatus:(NSString *)status andCustomID:(NSString *)customID andPushID:(NSString *)pushID completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

@end
