//
//  MyWalletModel.m
//  HKT
//
//  Created by Ting on 15/9/18.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "MyWalletModel.h"

@implementation MyWalletModel

-(id)init
{
    self = [super init];
    if (self) {
        _isBindBank = NO;
        _cashOuted = 0;
        _nowFund = 0;

    }
    return self;
}

@end
