//
//  PureColorToImage.h
//  hfwzone
//
//  Created by star on 14-7-25.
//  Copyright (c) 2014年 hfw.kunwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PureColorToImage : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color andWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
