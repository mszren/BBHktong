//
//  Tax.h
//  HKT
//
//  Created by Ting on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tax : NSObject

@property (nonatomic,assign)long taxColor;          //税颜色
@property (nonatomic,copy)NSString *taxName;        //税名字
@property (nonatomic,assign)float taxPrice;         //税价格

@end