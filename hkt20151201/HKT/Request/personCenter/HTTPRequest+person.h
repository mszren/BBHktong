//
//  HTTPRequest+person.h
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (person)


//用户center
+ (void)centerWithAdminName:(NSString *)adminName
              adminPw:(NSString *)adminPw
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//忘记密码
+ (void)rpwWithPhone:(NSString *)phone
              password:(NSString *)password
         verifyCode:(NSString *)verifyCode
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//修改密码
+ (void)forgetWithAdminID:(NSString *)adminID
             adminOldpw:(NSString *)adminOldpw
            adminPw:(NSString *)adminPw
       completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//验证老手机号
+(void)checkOldPhoneNub:(NSString *)phoneNub
             verifyCode:(NSString *)verifyCode
          completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;


//修改手机
+ (void)changeWithPhone:(NSString *)phone
                adminID:(NSString *)adminID
             verifyCode:(NSString *)verifyCode
          completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

@end
