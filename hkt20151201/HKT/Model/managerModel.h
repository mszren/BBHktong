//
//  managerModel.h
//  HKT
//
//  Created by app on 15-6-26.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface managerModel : NSObject
//客户ID
@property(nonatomic,copy)NSString *customer_id;
//客户姓名
@property(nonatomic,copy)NSString *customer_name;
//客户跟进状态（展示）
@property(nonatomic,copy)NSString *followText;
//客户意向等级（展示)
@property(nonatomic,copy)NSString *thinkText;
//第几次跟进（展示）
@property(nonatomic,copy)NSString *noteNums;
//客户最后一次跟进的时间戳
@property(nonatomic,copy)NSString *push_last_uptime;
//最后一次跟进记录（展示）
@property(nonatomic,copy)NSString *noteText;
//最后一次跟进类型
@property(nonatomic,copy)NSString *noteTypeText;

@property(nonatomic,copy)NSString *developer_id;
//电话
@property(nonatomic,copy)NSString *PhoneStr;
@end
