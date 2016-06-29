//
//  MyWalletModel.h
//  HKT
//
//  Created by Ting on 15/9/18.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankAccount.h"

@interface MyWalletModel : NSObject


@property (nonatomic,assign) BOOL isBindBank;       //是否绑定了银行卡 true=已绑定 false=未绑定
@property (nonatomic,retain) NSNumber *cashOuted;   //已提
@property (nonatomic,retain) NSNumber *nowFund;     //现有

@property (nonatomic,assign) BOOL isFreeze;

@end


