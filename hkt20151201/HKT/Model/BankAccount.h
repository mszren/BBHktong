//
//  BankAccount.h
//  HKT
//
//  Created by Ting on 15/9/18.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, AccountType) {
    AlipayType            =1,
    WecharType            =2
};

@interface BankAccount : NSObject

@property (nonatomic,assign)AccountType accountType;
@property (nonatomic,copy) NSString * ownerName;
@property (nonatomic,copy) NSString * accountName;  //账号
@property (nonatomic,copy) NSString * bankId;
//@property (nonatomic,copy) NSString * accountPass;


@end
