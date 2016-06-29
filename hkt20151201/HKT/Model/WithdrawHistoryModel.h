//
//  WithdrawHistoryModel.h
//  HKT
//
//  Created by Ting on 15/9/22.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WithdrawStatus) {
    Withdrawing                 =0,
    WithdrawFinish              =1,
    WithdrawFaild               =2
};

@interface WithdrawHistoryModel : NSObject

@property (nonatomic,copy) NSString * timeStr;
@property (nonatomic,copy) NSString * money;
@property (nonatomic,copy) NSString * ststusTxt;
@property (nonatomic,copy) NSString * remark;
@property (nonatomic,copy) NSString * cashout_id;
@property (nonatomic,assign) WithdrawStatus  status;

@end
