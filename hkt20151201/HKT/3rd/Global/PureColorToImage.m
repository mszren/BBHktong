//
//  PureColorToImage.m
//  hfwzone
//
//  Created by star on 14-7-25.
//  Copyright (c) 2014年 hfw.kunwang. All rights reserved.
//

#import "PureColorToImage.h"

@implementation PureColorToImage

+ (UIImage *)imageWithColor:(UIColor *)color andWidth:(CGFloat)width andHeight:(CGFloat)height {
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
