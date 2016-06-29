//
//  GrabCustomerModel.h
//  HKT
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrabCustomerModel : NSObject

@property (nonatomic,copy)NSString *customer_id;
@property (nonatomic,copy)NSString *customer_name;
@property (nonatomic,copy)NSString *customer_tel;
@property (nonatomic,copy)NSString *push_atime;
@property (nonatomic,copy)NSString *push_id;
@property (nonatomic,assign)NSInteger sec;

@end
