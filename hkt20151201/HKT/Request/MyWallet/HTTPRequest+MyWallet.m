//
//  HTTPRequest+Login.m
//  HKT
//
//  Created by Ting on 15/9/15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+MyWallet.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"
#import "MyWalletModel.h"
#import "WithdrawHistoryModel.h"
#import "AccountDetails.h"

@implementation HTTPRequest (Login)


+ (void)getMyWalletWithAdminId:(NSString *)admin_id
                 completeBlock:(void (^)(BOOL ok, NSString *message, MyWalletModel *myWalletModel))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/myWallet"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id};
    
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
            
            MyWalletModel *myWalletModel = [MyWalletModel new];
            myWalletModel.isBindBank = [data[@"bindBank"] boolValue];
            myWalletModel.cashOuted = data[@"cashOuted"];
            myWalletModel.nowFund = data[@"nowFund"];
            myWalletModel.isFreeze = [data[@"freeze"] boolValue];
            
            completeBlock(YES, message, myWalletModel);
        }];
}

+ (void)getMyWalletDetailWithAdminId:(NSString *)admin_id
                           andLastId:(NSString *)lastId
                       completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForWalletDetailList))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(lastId.length > 0);
    
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/accountDetails"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id,
                                 @"lastId" : lastId,
                                 @"pageNums" : @(HTTPPageSize)
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
            
            
            NSMutableArray *arrayForReturn = [NSMutableArray new];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSArray *arrayData = data[@"pageList"];
            for (NSDictionary *dic in arrayData) {
                
                AccountDetails *accountDetails = [AccountDetails new];
                accountDetails.reward_list_id = dic[@"reward_list_id"];
                accountDetails.reward_value = dic[@"reward_value"];
                accountDetails.reward_text = dic[@"reward_text"];
                
                NSString *str = dic[@"reward_status_color"];
                
                //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
                unsigned long red = strtoul([str UTF8String],0,16);
                //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
                // red = strtoul([@"0x6587" UTF8String],0,0);
                
                accountDetails.reward_status_color = red;
                accountDetails.reward_status_text = dic[@"reward_status_text"];
                
                NSInteger second =  [dic[@"reward_list_atime"] integerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
                accountDetails.reward_list_atime = [dateFormatter stringFromDate:date];
                
                [arrayForReturn addObject:accountDetails];
            }
            
            
            completeBlock(YES, message, [arrayForReturn copy]);
        }];
}

//提现历史
+ (void)withdrawHistoryWithAdminId:(NSString *)admin_id
                         andLastId:(NSString *)lastId
                         andStatus:(NSInteger)status
                     completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForHistoryList))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(lastId.length > 0);
    
    
    //提现状态  1=申请中 2=成功 3=失败（注意这里与下面不同，多了1） 0 =全部
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/cashoutDetails"];
    

    
    NSDictionary *parameters = @{@"admin_id" : admin_id,
                                 @"lastId" : lastId,
                                 @"pageNums" : @(HTTPPageSize),
                                 @"status"  : @(status)
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
            
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSMutableArray *arrayForWithdrawHistory = [NSMutableArray new];
            NSArray *arrayData = data[@"pageList"];
            for (NSDictionary *dic in arrayData) {
                WithdrawHistoryModel *model = [WithdrawHistoryModel new];
                
                NSInteger second =  [dic[@"cashout_time"] integerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
                
                model.timeStr = [dateFormatter stringFromDate:date];
                model.money = [NSString stringWithFormat:@"-%@",dic[@"cashout_money"]];
                model.ststusTxt = dic[@"cashout_status_text"];
                model.remark = dic[@"cashout_error_remark"];
                model.status = [dic[@"cashout_status"] intValue];
                model.cashout_id = dic[@"cashout_id"];
                
                [arrayForWithdrawHistory addObject:model];
            }
            
            completeBlock(YES, message, [arrayForWithdrawHistory copy]);
        }];
    
}


+ (void)withdrawWithAdminId:(NSString *)admin_id
                      money:(NSNumber *)money
                   password:(NSString *)password
              completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(password.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/cashout"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id,
                                 @"money" : money,
                                 @"accountPass":password
                                 };
    
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
            
            completeBlock([data[@"result"] boolValue], message);
        }];
}



+ (void)deleteAccountWithAdminId:(NSString *)admin_id
                       accountId:(NSString *)accountId
                        password:(NSString *)password
                   completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(accountId.length > 0);
    NSParameterAssert(password.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/delAccount"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id,
                                 @"bankId" : accountId,
                                 @"accountPass":password
                                 };
    
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
            
            completeBlock([data[@"result"] boolValue], message);
        }];
}

//添加收款账号
+ (void)addAccountWithAdminId:(NSString *)admin_id
                  bankAccount:(BankAccount *)bankAccount
                     password:(NSString *)password
                completeBlock:(void (^)(BOOL ok, NSString *message,BankAccount *bankAccount))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(bankAccount.ownerName > 0);
    NSParameterAssert(bankAccount.accountName > 0);
    NSParameterAssert(password > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V1/bindAccount"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id,
                                 @"account" : bankAccount.accountName,
                                 @"accountName" : bankAccount.ownerName,
                                 @"accountPass" : password,
                                 @"accountType" : @(bankAccount.accountType),
                                 };
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            
            if (code != 1) {
                completeBlock(NO, message,nil);
                return;
            }
            
            BankAccount *theNewbankAccount = [BankAccount new];
            
            theNewbankAccount.accountType = [(data[@"type"]) integerValue];
            theNewbankAccount.ownerName = data[@"accountName"];
            theNewbankAccount.accountName = data[@"account"];
            theNewbankAccount.bankId = data[@"bankId"];
            
            completeBlock(YES, message ,theNewbankAccount);
        }];
}

+ (void)getAccountListWithAdminId:(NSString *)admin_id
                    completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForAccount))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/myPayAccount"];
    
    NSDictionary *parameters = @{@"admin_id" : admin_id};
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            
            if (code != 1) {
                completeBlock(NO, message,nil);
                return;
            }
            
            BankAccount *theNewbankAccount = [BankAccount new];
            theNewbankAccount.ownerName = data[@"accountName"];
            if(theNewbankAccount.ownerName.length>0){
                theNewbankAccount.accountType = [(data[@"type"]) integerValue];
                theNewbankAccount.ownerName = data[@"accountName"];
                theNewbankAccount.accountName = data[@"account"];
                theNewbankAccount.bankId = data[@"bankId"];
                completeBlock(YES, message ,@[theNewbankAccount]);
            }else {
                completeBlock(YES, message ,@[]);
            }
            
        }];
}

//修改提现密码
+ (void)modifyPasswordWithAdminId:(NSString *)admin_id
                oldPassword:(NSString *)oldPassword
                newPassword:(NSString *)newPassword
              completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
    
    NSParameterAssert(admin_id.length > 0);
    NSParameterAssert(oldPassword.length > 0);
    NSParameterAssert(newPassword.length > 0);
    
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/updatePayPwByAdminId"];
    
    NSDictionary *parameters = @{@"admin_id"    :   admin_id,
                                 @"pay_oldpw"   :   oldPassword,
                                 @"pay_newpw"   :   newPassword
                                 };
    
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
            
            completeBlock([data[@"result"] boolValue], message);
        }];
}

//找回提现密码
+ (void)findPasswordWithAdmin_mobile:(NSString *)admin_mobile
                verify_code:(NSString *)verify_code
                newPassword:(NSString *)newPassword
              completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock{
    
    NSParameterAssert(admin_mobile.length > 0);
    NSParameterAssert(verify_code.length > 0);
    NSParameterAssert(newPassword.length > 0);
 
    NSString *url = [HTTPRequestPrivateBaseURL() stringByAppendingString:@"/V2/findPayPw"];
    
    NSDictionary *parameters = @{@"admin_mobile"    :   admin_mobile,
                                 @"verify_code"     :   verify_code,
                                 @"pay_newpw"       :   newPassword
                                 };
    
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
            
            completeBlock([data[@"result"] boolValue], message);
        }];
}

@end
