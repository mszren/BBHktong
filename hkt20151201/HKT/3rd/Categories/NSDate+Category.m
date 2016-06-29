//
//  NSDate+Category.m
//  VeryZhun
//
//  Created by chunxi on 15/7/14.
//  Copyright (c) 2015年 listener~. All rights reserved.
//

#import "NSDate+Category.h"

#define PER_DAY  86400 // 24 * 3600
#define D_WEEK	604800 // 7 * 86400

#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

@implementation NSDate (Category)

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format{
    return [date stringWithFormat:format];
}

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format {
    return [self dateWithString:string timeZone:[NSTimeZone localTimeZone] format:format];
}

+ (NSDate *)dateWithString:(NSString *)string timeZone:(NSTimeZone *)timeZone format:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = timeZone;
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

- (NSDate*) previousDay{
    return [self dateByAddingTimeInterval:-86400];
}
- (NSDate*) nextDay{
    return [self dateByAddingTimeInterval: 86400];
}

- (NSDate*) previousWeek{
    return [self dateByAddingTimeInterval:-(86400*7)];
}
- (NSDate*) nextWeek{
    return [self dateByAddingTimeInterval:+(86400*7)];
}

- (NSDate*) previousMonth{
   return [self previousMonth:1];
}

- (NSDate*) nextMonth{
    return [self nextMonth:1];
}


- (BOOL)isToday{
  return [self isEqualToDateIgnoringTime:[NSDate date]];
}
- (BOOL)isThisWeek{
  return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isThisMonth{
    return  [self isSameMonthAsDate:[NSDate date]];
}

- (NSDate*) startOfWeek {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [gregorianCalendar components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    
    return [gregorianCalendar dateFromComponents:components];
}

- (NSDate*) endOfWeek {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [gregorianCalendar components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    [components setDay:([components day] + (7 - [components weekday]))];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [gregorianCalendar dateFromComponents:components];
}


- (NSDate *)localDate{
    
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: self];
    
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

#pragma mark - String Property

- (NSString *) stringWithFormat:(NSString *)format{
    NSDateFormatter *formatter =  [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSDate*) previousMonth:(NSUInteger) monthsToMove {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    NSInteger dayInMonth = [components day];
    
    // Update the components, initially setting the day in month to 0
    NSInteger newMonth = ([components month] - monthsToMove);
    [components setDay:1];
    [components setMonth:newMonth];
    
    // Determine the valid day range for that month
    NSDate* workingDate = [gregorianCalendar dateFromComponents:components];
    NSRange dayRange = [gregorianCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:workingDate];
    
    // Set the day clamping to the maximum number of days in that month
    [components setDay:MIN(dayInMonth, dayRange.length)];
    
    return [gregorianCalendar dateFromComponents:components];
}

- (NSDate*) nextMonth:(NSUInteger) monthsToMove {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    NSInteger dayInMonth = [components day];
    
    // Update the components, initially setting the day in month to 0
    NSInteger newMonth = ([components month] + monthsToMove);
    [components setDay:1];
    [components setMonth:newMonth];
    
    // Determine the valid day range for that month
    NSDate* workingDate = [gregorianCalendar dateFromComponents:components];
    NSRange dayRange = [gregorianCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:workingDate];
    
    // Set the day clamping to the maximum number of days in that month
    [components setDay:MIN(dayInMonth, dayRange.length)];
    
    return [gregorianCalendar dateFromComponents:components];
}


- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    if (components1.weekOfYear != components2.weekOfYear) return NO;
   // VZLog(@"我的时间：%@ --- 当前时间：%@",self,aDate);
    return (fabs([self timeIntervalSinceDate:aDate]) < 86400*7);
}

- (BOOL)isSameMonthAsDate:(NSDate *)aDate{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}
@end
