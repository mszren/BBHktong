//
//  HTTPRequest+manager.h
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (manager)

//查看
+(void)findWithCustomerID:(NSString *)customerID completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;


//跟进 客户详情 二合一
+ (void)GJWithAdminID:(NSString *)adminID
              CustomerID:(NSString *)customerID
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;


+(void)GJWithAdminID:(NSString *)adminID
            followID:(NSString *)followID
            customID:(NSString *)customID
             content:(NSString *)content
                type:(NSString *)type
                pics:(NSArray *)pics
       completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//跟进保存
+(void)GJWithAdminID:(NSString *)adminID followID:(NSString *)followID customID:(NSString *)customID content:(NSString *)content completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;


//管理首页
+(void)ManagerWithKeywords:(NSString *)keywords followID:(NSString *)followID thinkID:(NSString *)thinkID adminID:(NSString *)adminID lastID:(NSString *)lastID pageNums:(NSString *)pageNums  completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//客户意向
+ (void)thinkWithAdminID:(NSString *)adminID
           CustomerID:(NSString *)customerID
            thinkID:(NSString *)thinkID
        completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//客户列表配置
+(void)CustomConfig : (void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

@end
