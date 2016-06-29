//
//  detailModel.h
//  HKT
//
//  Created by app on 15-7-1.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject

@property(nonatomic,copy)NSString *note_atime;
@property(nonatomic,copy)NSString *note_content;
@property(nonatomic,strong)NSArray *note_pics;
@property(nonatomic,copy)NSString *noteTypeText;

@end
