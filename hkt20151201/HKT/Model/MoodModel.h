//
//  MoodModel.h
//  HKT
//
//  Created by Ting on 15/9/22.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoodModel : NSObject

@property (nonatomic,copy) NSString * key;
@property (nonatomic,copy) NSString * iconUrl;
@property (nonatomic,copy) NSString * feeling;
@property (nonatomic,copy) NSString * said;
@property (nonatomic,copy) NSString * shareContent;

@end
