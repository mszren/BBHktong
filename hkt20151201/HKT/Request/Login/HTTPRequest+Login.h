//
//  HTTPRequest+Login.h
//  HKT
//
//  Created by Ting on 15/9/15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (Login)

// 登录
+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;


//注册
+(void)registerWithTextTureName:(NSString *)textTureName TextPhone:(NSString *)textPhone TextCipher:(NSString *)textCipher TextHouseName:(NSString *)textHouseName andVerifyCode:(NSString *)verifyCode completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock;

//短信验证
+(void)verifyWithPhone:(NSString *)phone completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;

@end
