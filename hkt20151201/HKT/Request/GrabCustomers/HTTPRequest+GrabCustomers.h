//
//  HTTPRequest+GrabCustomers.h
//  HKT
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"
@class GrabCustomerModel;

@interface HTTPRequest (GrabCustomers)

+(void)customerListWithAdminId:(NSString *)adminID
                        lastID:(NSString *)lastID
                 completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *array))completeBlock;

//抢客户
+(void)grabCustomerWithAdminId:(NSString *)adminID
                        Status:(NSString *)status
                        Custom:(GrabCustomerModel *)model
                 completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

@end
