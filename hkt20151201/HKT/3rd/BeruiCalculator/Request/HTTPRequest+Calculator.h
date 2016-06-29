//
//  HTTPRequest+Calculator.h
//  HKT
//
//  Created by app on 15/9/22.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (Calculator)

//计算器
+ (void)requestWithCalculator: (void (^)(BOOL ok, NSString *message, NSDictionary *data))completeBlock;


@end
