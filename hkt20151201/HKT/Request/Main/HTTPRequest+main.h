//
//  HTTPRequest+main1.h
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (main)

//首页
+ (void)mainWithAdminID:(NSString *)adminID
              pageNumber:(NSString *)pageNumber
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

+ (void)buttonWithAdminID:(NSString *)adminID
          completeBlock:(void (^)(BOOL ok, NSString *message,  BOOL isAddReport , BOOL isSeeRecom, NSString *adminAttr))completeBlock;

@end
