//
//  UserManager.m
//  HKT
//
//  Created by app on 15-6-4.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager


-(id)init
{
    self = [super init];
    if (self) {
        _admin_hid = [[NSString alloc] init];
        _admin_mobile = [[NSString alloc] init];
        _admin_truename = [[NSString alloc] init];
        _admin_name = [[NSString alloc] init];
        _admin_pw = [[NSString alloc] init];
        _admin_attr = [[NSString alloc] init];
        _text = [[NSString alloc] init];
        _text1 = [[NSString alloc] init];
        _text2 = [[NSString alloc] init];
        _labelNLLz = [[NSString alloc] init];
         _labelNLLz1 = [[NSString alloc] init];
        _admin_id = [[NSString alloc] init];
        _CycleScollviewText = [[NSString alloc] init];
        _urlArr = [[NSMutableArray alloc] init];
        _tvArr = [[NSMutableArray alloc] init];
        _number = [[NSString alloc] init];
        _urlTitleArr = [[NSMutableArray alloc] init];
        _customer_name = [[NSString alloc] init];
        _editionUrlStr = [[NSString alloc] init];
        _userHeaderImg = [[NSString alloc] init];
    }
    return self;
}


+(UserManager *)shareUserManager
{
    static UserManager *shareUserManager = nil;
    if (shareUserManager == nil) {
        shareUserManager = [[UserManager alloc] init];
        
    }
    return shareUserManager;
}
@end
