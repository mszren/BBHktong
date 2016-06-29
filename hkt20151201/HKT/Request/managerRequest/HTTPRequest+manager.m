//
//  HTTPRequest+manager.m
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+manager.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (manager)

//查看
+(void)findWithCustomerID:(NSString *)customerID completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    NSParameterAssert(customerID.length > 0);
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/customerBasicInfo"];
    NSDictionary *parameters = @{@"customer_id" : customerID};
    
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

//跟进
+ (void)GJWithAdminID:(NSString *)adminID
              CustomerID:(NSString *)customerID
         completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock
{
    
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(customerID.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/customerInfo"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"customer_id" : customerID};
    
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

//保存跟进
+(void)GJWithAdminID:(NSString *)adminID
            followID:(NSString *)followID
            customID:(NSString *)customID
             content:(NSString *)content
                type:(NSString *)type
                pics:(NSArray *)pics
       completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock
{
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(customID.length > 0);
    NSParameterAssert(type.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/setCustomerFollow"];
    
    NSMutableArray *images = [NSMutableArray new];
    for (UIImage *image in pics) {
        NSData *data = UIImageJPEGRepresentation(image , 0.5);
        NSString *picStream = [data base64EncodedStringWithSeparateLines:NO];
        [images addObject:picStream];
    }

    NSDictionary *parameters = @{@"admin_id"    : adminID,
                                 @"follow_id"   : followID,
                                 @"customer_id" : customID,
                                 @"content"     : content,
                                 @"type"        : type,
                                 @"pics"        : [images copy]
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

//管理首页
+(void)ManagerWithKeywords:(NSString *)keywords followID:(NSString *)followID thinkID:(NSString *)thinkID adminID:(NSString *)adminID lastID:(NSString *)lastID pageNums:(NSString *)pageNums  completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{

//    NSParameterAssert(searchID.length > 0);
//    NSParameterAssert(followID.length > 0);
//    NSParameterAssert(thinkID.length > 0);
//    NSParameterAssert(sourceID.length > 0);
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(lastID.length > 0);
    NSParameterAssert(pageNums.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/customerList"];
    
    NSDictionary *parameters = @{@"keywords" : keywords,
                                 @"followid" : followID,
                                 @"thinkid":thinkID,
                                 @"admin_id":adminID,
                                 @"lastId":lastID,
                                 @"pageNums":pageNums
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

//客户意向
+ (void)thinkWithAdminID:(NSString *)adminID
              CustomerID:(NSString *)customerID
                 thinkID:(NSString *)thinkID
           completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{

    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(customerID.length > 0);
    NSParameterAssert(thinkID.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/setCustomerThink"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"customer_id" : customerID,
                                @"think_id" : thinkID
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


+ (void)CustomConfig:(void (^)(BOOL ok, NSString *message, NSDictionary *data))completeBlock{
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/customerConfig"];

    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:nil
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
