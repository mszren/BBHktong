//
//  User.h
//  HKT
//
//  Created by Ting on 15/11/11.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (NSArray *)getHistoryUser;
- (void)deleUserWithLoginName:(NSString *)loginNameFrom;
- (void)addLoginUserSelf;
+ (User *)findUserWithLoginName:(NSString *)loginNameFrom;
+ (void)updateHeadImgWithLoginName:(NSString *)loginNameFrom HeadImgUrl:(NSString *)headImgUrlFrom;
@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
