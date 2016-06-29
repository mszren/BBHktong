//
//  HTTPRequest+Login.m
//  HKT
//
//  Created by Ting on 15/9/15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+Login.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (Login)

// 登录
+ (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock
{
    
     NSParameterAssert(phone.length > 0);
     NSParameterAssert(password.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/login"];
    
    NSDictionary *parameters = @{@"admin_name" : phone,
                                 @"admin_pw" : password};
    
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
            
            completeBlock(YES, message, data);
        }];
}


//注册
+(void)registerWithTextTureName:(NSString *)textTureName TextPhone:(NSString *)textPhone TextCipher:(NSString *)textCipher TextHouseName:(NSString *)textHouseName andVerifyCode:(NSString *)verifyCode completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock
{
    NSParameterAssert(textPhone.length > 0);
    NSParameterAssert(textCipher.length > 0);
    NSParameterAssert(verifyCode.length > 0);
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/register"];
    
    NSDictionary *parameters = @{@"admin_mobile" : textPhone,
                                 @"admin_pw":textCipher,
                                 @"verify_code":verifyCode};
    
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
            
            completeBlock(YES, message, data);
        }];
}

//短信验证
+(void)verifyWithPhone:(NSString *)phone completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
//    NSParameterAssert(phone.length > 0);
    NSString *url = [NSString stringWithFormat:@"%@index.php/Other/VerifyCode/send",kBasePort]; 
    
    NSDictionary *parameters = @{@"admin_mobile" : phone};
    
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
            
            completeBlock(YES, message);
        }];

}


@end
