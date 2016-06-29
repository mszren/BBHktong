//
//  HTTPRequest+recommend.m
//  HKT
//
//  Created by app on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+recommend.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"
#import "HKTModel.h"

@implementation HTTPRequest (recommend)

+(void)recommandWithAdminId:(NSString *)adminID andType:(NSString *)type andLastID:(NSString *)lastID andPageNums:(NSString *)pageNums completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *array))completeBlock{
    
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(type.length > 0);
    NSParameterAssert(lastID.length > 0);
    NSParameterAssert(pageNums.length > 0);

    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/recommCustomerList"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"type" : type,
                                 @"lastId":lastID,
                                 @"pageNums":pageNums};
    
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
            
            NSMutableArray *arrayForHKTModel = [NSMutableArray new];
            
            NSArray *pageList = [data objectForKey:@"pageList"];
            for (NSDictionary *subDict  in pageList) {
    
                HKTModel *model = [[HKTModel alloc] init];
                model.customer_name = [subDict objectForKey:@"customer_name"];
                model.customer_tel = [subDict objectForKey:@"customer_tel"];
                model.statusText = [subDict objectForKey:@"statusText"];
                model.house_name = [subDict objectForKey:@"house_name"];
                model.customer_id = [subDict objectForKey:@"customer_id"];
                model.push_id = [subDict objectForKey:@"push_id"];
                model.overdue = [subDict objectForKey:@"overdue"];
                NSString *str = [[NSString alloc] init];
                for (NSDictionary *subSDict in subDict[@"areaList"]) {
                    str =  [str stringByAppendingString:[subSDict objectForKey:@"customerarea_name"]];
                    str = [str stringByAppendingString:@"、"];
                }
                if (str.length > 0) {
                    model.areaList = [str substringToIndex:str.length - 1];
                }else
                {
                    model.areaList = @"";
                }
                
                NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[subDict[@"push_atime"] intValue]];
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"YYYY-MM-dd  HH:mm:ss"];
                NSString *regStr = [df stringFromDate:dt];
                model.push_atime = regStr;

                [arrayForHKTModel addObject:model];
            }
            
            
            
            completeBlock(YES, message, [arrayForHKTModel copy]);
        }];

}


//跳转
+(void)recommandMoveWithAdminId:(NSString *)adminID andStatus:(NSString *)status andCustomID:(NSString *)customID andPushID:(NSString *)pushID completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    NSParameterAssert(adminID.length > 0);
//    NSParameterAssert(status.length > 0);
    NSParameterAssert(customID.length > 0);
    NSParameterAssert(pushID.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/changeCustomerStatus"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"status" : status,
                                 @"customer_id":customID,
                                 @"push_id":pushID};
    
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
