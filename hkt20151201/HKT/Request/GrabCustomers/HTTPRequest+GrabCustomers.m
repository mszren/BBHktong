//
//  HTTPRequest+GrabCustomers.m
//  HKT
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+GrabCustomers.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"
#import "GrabCustomerModel.h"

@implementation HTTPRequest (GrabCustomers)

+(void)customerListWithAdminId:(NSString *)adminID
                        lastID:(NSString *)lastID
                 completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *array))completeBlock{
    
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(lastID.length > 0);

    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/customerAgainst"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"lastId":lastID,
                                 @"pageNums":@(HTTPPageSize)};
    
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
                
                GrabCustomerModel *model = [GrabCustomerModel new];
                model.customer_id = subDict[@"customer_id"];
                model.customer_name = subDict[@"customer_name"];
                model.customer_tel = subDict[@"customer_tel"];
                model.push_id = subDict[@"push_id"];
                model.sec = [(subDict[@"sec"])integerValue];
                
                NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[subDict[@"push_atime"] intValue]];
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"YYYY-MM-dd  HH:mm:ss"];
                model.push_atime = [df stringFromDate:dt];
                
                [arrayForHKTModel addObject:model];
            }
            
            completeBlock(YES, message, [arrayForHKTModel copy]);
        }];
}


+(void)grabCustomerWithAdminId:(NSString *)adminID
                        Status:(NSString *)status
                        Custom:(GrabCustomerModel *)model
                 completeBlock:(void (^)(BOOL ok, NSString *message, NSDictionary *dic))completeBlock{
    
    //状态值 1=无效 2=有效 3=无意向 4=与案场冲突
    
    NSParameterAssert(adminID.length > 0);
    NSParameterAssert(model.customer_id.length > 0);
    NSParameterAssert(model.push_id.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/changeCustomerStatus"];
    
    NSDictionary *parameters = @{@"admin_id" : adminID,
                                 @"status" : status,
                                 @"customer_id":model.customer_id,
                                 @"push_id":model.push_id};
    
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
