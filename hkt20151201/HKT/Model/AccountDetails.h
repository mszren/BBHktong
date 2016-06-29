//
//  AccountDetails.h
//  HKT
//
//  Created by Ting on 15/11/18.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountDetails : NSObject


@property (nonatomic,copy)NSString *reward_list_id;
@property (nonatomic,copy)NSString *reward_list_atime;
@property (nonatomic,copy)NSString *reward_value;
//@property (nonatomic,copy)NSString *reward_status;
@property (nonatomic,copy)NSString *reward_text;
@property (nonatomic,assign)long reward_status_color;
@property (nonatomic,copy)NSString *reward_status_text;


@end
