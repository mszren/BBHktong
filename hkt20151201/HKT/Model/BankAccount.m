//
//  BankAccount.m
//  HKT
//
//  Created by Ting on 15/9/18.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "BankAccount.h"

@implementation BankAccount

-(id)init
{
    self = [super init];
    if (self) {
        _accountType = 0;
        _ownerName = @"";
        _accountName =@"";
    }
    return self;
}

@end
