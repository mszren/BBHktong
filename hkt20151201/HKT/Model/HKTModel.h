//
//  HKTModel.h
//  HKT
//
//  Created by app on 15-6-23.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKTModel : NSObject

//张三
@property(nonatomic,copy)NSString *customer_name;
//电话
@property(nonatomic,copy)NSString *customer_tel;
//是否过期
@property(nonatomic,retain)NSString *statusText;
//推送时间戳
@property(nonatomic,copy)NSString *push_atime;
//感兴趣的区域数目
@property(nonatomic,copy)NSString *customer_position;
//感兴趣的楼盘
@property(nonatomic,copy)NSString *house_name;
//感兴趣的区域
@property(nonatomic,copy)NSString *areaList;
//btn状态
@property(nonatomic,retain)NSString *overdue;
//客户id
@property(nonatomic,retain)NSString *customer_id;
//推送id
@property(nonatomic,retain)NSString *push_id;

@end
