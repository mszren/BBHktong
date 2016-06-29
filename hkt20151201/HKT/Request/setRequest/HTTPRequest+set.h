//
//  HTTPRequest+set.h
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (set)

// 意见反馈
+ (void)opinionWithPhone:(NSString *)phone
              Content:(NSString *)content
               From:(NSString *)from
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

@end
