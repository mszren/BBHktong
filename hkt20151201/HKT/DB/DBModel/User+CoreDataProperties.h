//
//  User+CoreDataProperties.h
//  HKT
//
//  Created by Ting on 15/11/11.
//  Copyright © 2015年 百瑞. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *loginName;
@property (nullable, nonatomic, retain) NSString *trueName;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *headImgUrl;
@property (nullable, nonatomic, retain) NSDate *createTime;
//@property (nullable, nonatomic, retain) NSNumber *isLogin;

@end

NS_ASSUME_NONNULL_END
