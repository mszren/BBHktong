//
//  HTTPRequest+Login.h
//  HKT
//
//  Created by Ting on 15/9/15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"
@class MyWalletModel;
@class BankAccount;

@interface HTTPRequest (MyWallet)

//得到钱包详细
+ (void)getMyWalletWithAdminId:(NSString *)admin_id
         completeBlock:(void (^)(BOOL ok, NSString *message, MyWalletModel *myWalletModel))completeBlock;

//账目明细
+ (void)getMyWalletDetailWithAdminId:(NSString *)admin_id
                           andLastId:(NSString *)lastId
                 completeBlock:(void (^)(BOOL ok, NSString *message, NSArray * arrayForWalletDetailList))completeBlock;

//提现历史
+ (void)withdrawHistoryWithAdminId:(NSString *)admin_id
                         andLastId:(NSString *)lastId
                         andStatus:(NSInteger)status
                     completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForHistoryList))completeBlock;

//提现
+ (void)withdrawWithAdminId:(NSString *)admin_id
                    money:(NSNumber *)money
                    password:(NSString *)password
                    completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;

//删除收款账号
+ (void)deleteAccountWithAdminId:(NSString *)admin_id
                        accountId:(NSString *)accountId
                        password:(NSString *)password
                 completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;

//添加收款账号
+ (void)addAccountWithAdminId:(NSString *)admin_id
                    bankAccount:(BankAccount *)bankAccount
                        password:(NSString *)password
                   completeBlock:(void (^)(BOOL ok, NSString *message,BankAccount *bankAccount))completeBlock;

//我的账号
+ (void)getAccountListWithAdminId:(NSString *)admin_id
                    completeBlock:(void (^)(BOOL ok, NSString *message, NSArray *arrayForAccount))completeBlock;

//修改提现密码
+ (void)modifyPasswordWithAdminId:(NSString *)admin_id
                        oldPassword:(NSString *)oldPassword
                        newPassword:(NSString *)newPassword
                    completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;

//找回提现密码
+ (void)findPasswordWithAdmin_mobile:(NSString *)admin_mobile
                         verify_code:(NSString *)verify_code
                         newPassword:(NSString *)newPassword
                  completeBlock:(void (^)(BOOL ok, NSString *message))completeBlock;

@end