//
//  NSDate+Category.h
//  VeryZhun
//
//  Created by chunxi on 15/7/14.
//  Copyright (c) 2015年 listener~. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

/**
 *  根据日期返回字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/**
 *  根据字符串返回日期
 */
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)string timeZone:(NSTimeZone *)timeZone format:(NSString *)format;

- (NSDate*) previousDay;
- (NSDate*) nextDay;

- (NSDate*) previousWeek;
- (NSDate*) nextWeek;

- (NSDate*) previousMonth;
- (NSDate*) nextMonth;

- (BOOL) isToday;
- (BOOL) isThisWeek;
- (BOOL) isThisMonth;

- (NSDate*) startOfWeek;
- (NSDate*) endOfWeek;

- (NSDate *)localDate;
@end
