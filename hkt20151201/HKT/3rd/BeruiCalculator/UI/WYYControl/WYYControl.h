//
//  WYYontrol.h
//  Device
//
//  Created by YueYun on 15-4-19.
//  Copyright (c) 2015年 YueYun. All rights reserved.

#import <Foundation/Foundation.h>

@interface WYYControl : NSObject
#pragma mark --判断设备型号
//+(NSString *)platformString;
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text textColor:(UIColor*)color;

#pragma mark --创建View
+(UIView*)viewWithFrame:(CGRect)frame;

#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;

#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;

+(UIButton*)createButtonWithFrame:(CGRect)frame normalImage:(NSString *)normalImage  selectImage:(NSString*)selectImage Target:(id)target Action:(SEL)action Title:(NSString *)title;


+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftView:(UILabel*)label  Font:(float)font;

+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;

#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;

#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFram:(CGRect)frame;

#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;

#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;

#pragma mark --判断导航的高度64or44
+(float)isIOS7;


+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

+ (NSString *)addOneByIntegerString:(NSString *)integerString;


@end
