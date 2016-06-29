//
//  UserManager.h
//  HKT
//
//  Created by app on 15-6-4.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

@property(nonatomic,copy)NSString *admin_name;
@property(nonatomic,copy)NSString *admin_pw;
@property(nonatomic,copy)NSString *admin_hid;
@property(nonatomic,copy)NSString *admin_mobile;
@property(nonatomic,copy)NSString *admin_truename;
@property(nonatomic,copy)NSString *admin_attr;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *text1;
@property(nonatomic,copy)NSString *text2;
@property(nonatomic,copy)NSString *labelNLLz;
@property(nonatomic,copy)NSString *labelNLLz1;
@property(nonatomic,assign)NSInteger _row;
@property(nonatomic,copy)NSString *admin_id;
@property(nonatomic,copy)NSMutableArray *urlArr;
@property(nonatomic,copy)NSMutableArray *tvArr;
@property(nonatomic,assign)NSInteger btnTag;
@property(nonatomic,copy)NSString *CycleScollviewText;
@property(nonatomic,copy)NSString *number;
@property(nonatomic,assign)NSInteger _urlPage;
@property(nonatomic,copy)NSString *customer_name;
@property(nonatomic,copy)NSString *editionUrlStr;
@property(nonatomic,copy)NSString *userHeaderImg;

//轮播图
@property(nonatomic,copy)NSMutableArray *urlTitleArr;
+(UserManager *)shareUserManager;
@end
