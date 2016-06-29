//
//  User.m
//  HKT
//
//  Created by Ting on 15/11/11.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "User.h"

@implementation User

// Insert code here to add functionality to your managed object subclass


-(id)init
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:CoreDatatableName inManagedObjectContext:globalManagedObjectContext_util];
    self= [super initWithEntity:entity insertIntoManagedObjectContext:nil];
    
    if (self) {
        self.loginName      = @"";
        self.trueName       = @"";
        self.password       = @"";
        self.headImgUrl     = @"";
        self.createTime     = [NSDate date];
    }
    
    return  self;
}

//得到所有用户 (按更新事件排列前5个)
+ (NSArray *)getHistoryUser{
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO];
    NSArray *array = [NSManagedObject getTable_sync:CoreDatatableName actions:^(NSFetchRequest *request)
     {
         [request setFetchLimit:5];
         [request  setSortDescriptors:[NSArray arrayWithObject:sort]];
         
     }];
    
    return array;
}

-(void)deleUserWithLoginName:(NSString *)loginNameFrom{
    
    NSPredicate *p =[NSPredicate predicateWithFormat:@"loginName=%@",loginNameFrom];
    NSArray *array = [NSManagedObject getTable_sync:CoreDatatableName predicate:p];
    [NSManagedObject deleteObjects_sync:array];
}

//添加新用户,如果有则更新数据,如果不存在,则添加
-(void)addLoginUserSelf{
    
    User *user = [User findUserWithLoginName:self.loginName];
    
    NSDictionary *dic = @{@"loginName":self.loginName,
                          @"trueName":self.trueName,
                          @"password":self.password,
                          @"headImgUrl":self.headImgUrl,
                          @"createTime":self.createTime,
                          @"createTime":self.createTime};
    //如果有,则update
    if (user) {
        user.loginName = self.loginName;
        user.trueName = self.trueName;
        user.password = self.password;
        user.headImgUrl = self.headImgUrl;
        [NSManagedObject updateObject_sync:user params:dic];
    }else {
        [NSManagedObject addObject_sync:dic toTable:CoreDatatableName];
    }
}

//通过登录名找用户实体
+(User *)findUserWithLoginName:(NSString *)loginNameFrom{
    User *user;
    NSPredicate *p =[NSPredicate predicateWithFormat:@"loginName=%@",loginNameFrom];
    user = [[NSManagedObject getTable_sync:CoreDatatableName predicate:p]firstObject];
    return user;
}

//更新用户头像地址
+(void)updateHeadImgWithLoginName:(NSString *)loginNameFrom HeadImgUrl:(NSString *)headImgUrlFrom{
    User *user = [User findUserWithLoginName:loginNameFrom];
    user.headImgUrl = headImgUrlFrom;
    [user addLoginUserSelf];
}

@end
