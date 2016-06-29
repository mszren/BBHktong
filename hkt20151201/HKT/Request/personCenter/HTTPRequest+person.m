//
//  HTTPRequest+person.m
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+person.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (person)


//用户center
+ (void)centerWithAdminName:(NSString *)adminName
                    adminPw:(NSString *)adminPw
              completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    NSParameterAssert(adminName.length > 0);
    NSParameterAssert(adminPw.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/login"];
    
    NSDictionary *parameters = @{@"admin_name" : adminName,
                                 @"admin_pw" : adminPw};
    
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




+ (void)rpwWithPhone:(NSString *)phone
            password:(NSString *)password
          verifyCode:(NSString *)verifyCode
       completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock
{
    
    NSParameterAssert(phone.length > 0);
    NSParameterAssert(password.length > 0);
    NSParameterAssert(verifyCode.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/changePassword"];
    
    NSDictionary *parameters = @{@"admin_mobile" : phone,
                                 @"admin_pw" : password,
                                 @"verify_code" :verifyCode};
    
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

//修改密码
+ (void)forgetWithAdminID:(NSString *)adminID
               adminOldpw:(NSString *)adminOldpw
                  adminPw:(NSString *)adminPw
            completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/changePasswordByAdminId"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"admin_oldpw" : adminOldpw,
                                 @"admin_pw" : adminPw
                                 };
    
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

+(void)checkOldPhoneNub:(NSString *)phoneNub
             verifyCode:(NSString *)verifyCode
          completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
    
    NSParameterAssert(phoneNub.length > 0);
    NSParameterAssert(verifyCode.length > 0);
    
    NSString *url = [NSString stringWithFormat:@"%@index.php/Other/VerifyCode/isTrue",kBasePort];
    
    NSDictionary *parameters = @{@"admin_mobile" : phoneNub,
                                 @"verify_code" : verifyCode};
    
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

//修改手机号
+ (void)changeWithPhone:(NSString *)phone
                adminID:(NSString *)adminID
             verifyCode:(NSString *)verifyCode
          completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    
    NSParameterAssert(phone.length > 0);
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(verifyCode.length > 0);

    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/changeMobile"];
    
    NSDictionary *parameters = @{@"nowphone" : phone,
                                 @"admin_id" : adminID,
                                 @"verify_code" :verifyCode
                                 };
    
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



@end
