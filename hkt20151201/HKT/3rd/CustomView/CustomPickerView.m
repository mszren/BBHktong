//
//  CustomDatePicker.m
//  jiuhaoHealth
//
//  Created by xiaoquan on 13-11-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "CustomPickerView.h"
#import "UIView+Size.h"

@interface CustomPickerView ()
{
    NSMutableDictionary *result;
}

@end

@implementation CustomPickerView
@synthesize picker,pickerView;

- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

//其它
- (void)nomalPickerShow
{
    /* 选择器 */
    UIPickerView *pickerView_ = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, navBarView.height, self.width, self.contextHeight)];
    pickerView_.delegate = self;
    pickerView_.dataSource = self;
    pickerView_.showsSelectionIndicator = YES;
    [self addSubview:pickerView_];
    
    self.pickerView = pickerView_;
    
    if (self.data) {
        id ob = [self.data objectForKey:@"data"];
        if ([ob isKindOfClass:[NSArray class]]) {
            NSMutableArray * dataArray = [[NSMutableArray alloc] initWithArray:[self.data objectForKey:@"data"]];
            
            dataDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dataArray,@"compt", nil];
        }if ([ob isKindOfClass:[NSDictionary class]]) {
            dataDic = [[NSMutableDictionary alloc] initWithDictionary:[self.data objectForKey:@"data"]];
        }
        
    }else{
        dataDic = [[NSMutableDictionary alloc] init];
    }
    
    result = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (dataDic) {
        NSArray *keys = [dataDic allKeys];
        for (NSString *key in keys) {
            NSArray *arr = [dataDic objectForKey:key];
            if (arr && [arr count]>0) {
                [result setObject:[arr objectAtIndex:0] forKey:key];
            }
        }
    }
    
}

//日期

- (void)datePickerShow
{
    //初始日期选择控件
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, navBarView.height, self.width, self.height)];
    datePicker.calendar = [NSCalendar currentCalendar];
    //日期模式
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    //    //定义最小日期
    //    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    //    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *minDate = [formatter_minDate dateFromString:@"2004-01-01"];
    //    formatter_minDate = nil;
    //    //最大日期是今天
    //    NSDate *maxDate = [NSDate date];
    //
    //    [dataPicker setMinimumDate:minDate];
    //    [dataPicker setMaximumDate:maxDate];
    [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePicker];
    [datePicker setDate:[NSDate date]];
    
    picker = datePicker;
}

/**
 *   设定内容 子类实现
 */
- (void)showContextView
{
    if (self.type == KDatePicker) {
        [self datePickerShow];
    }else if(self.type == KOtherPicker){
        [self nomalPickerShow];
    }else if (self.type == kTimePicker){
        [self timePicker];
    }else if (self.type == KDateAndTimePicker){
        [self showDateAndTime];
    }
}

-(void)showDateAndTime{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, navBarView.height, self.width, self.height)];
    datePicker.calendar = [NSCalendar currentCalendar];
    //日期模式
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePicker];
    [datePicker setDate:[NSDate date]];
    picker = datePicker;
}


-(void)timePicker
{
    //初始日期选择控件
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, navBarView.height, self.width, self.height)];
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    //日期模式
    [datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:datePicker];
    [datePicker setDate:[NSDate date]];
    picker = datePicker;
    
}
//datapicker值攺变事件
- (void) dataValueChanged:(UIDatePicker *)sender
{
    
    
}

//取消按钮点击
- (void)cancelPressed
{
}

//设置选择的结果
- (void)resetBackData
{
    NSMutableString *resultstring = [[NSMutableString alloc] init];
    if (result) {
        NSArray *keys = [result allKeys];
        int index = 0;
        for (NSString *key in keys) {
            NSString *str = [result objectForKey:key];
            [resultstring appendString:str];
            if (([keys count]-1)!=index) {
                [resultstring appendString:@" "];
            }
            
            index ++;
            
        }
    }
    selectData = [NSDictionary dictionaryWithObject:resultstring forKey:@"date"];
    //        NSLog(@"职位选择了------------%@",resultstring);
    
}

//确定按钮点击
- (void)okPressed
{
    if (self.type == KDatePicker) {
        UIDatePicker *_datePicker = (UIDatePicker *)picker;
        
        if (_datePicker) {
            NSDate *date_one = _datePicker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:date_one];
            selectData = [NSDictionary dictionaryWithObject:dateString forKey:@"date"];
        }
    }else if(self.type == KOtherPicker){
        [self resetBackData];
    }
    else if (self.type == kTimePicker)
    {
        UIDatePicker *_datePicker = (UIDatePicker *)picker;
        if (_datePicker) {
            NSDate *date_one = _datePicker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *dateString = [formatter stringFromDate:date_one];
            selectData = [NSDictionary dictionaryWithObject:dateString forKey:@"date"];
        }
    }else if (self.type == KDateAndTimePicker)
    {
        UIDatePicker *_datePicker = (UIDatePicker *)picker;
        if (_datePicker) {
            NSDate *date_one = _datePicker.date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate:date_one];
            selectData = [NSDictionary dictionaryWithObject:dateString forKey:@"date"];
        }
    }

    
    
    
}

- (void)dealloc
{}



#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [[dataDic allKeys] count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *arr = [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:component]];
    if (arr) {
        return [arr count];
    }else{
        return 0;
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *arr = [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:component]];
    if (arr) {
        return [arr objectAtIndex:row];
    }else{
        return 0;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (!result) {
        result = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [result removeObjectForKey:[[dataDic allKeys] objectAtIndex:component]];
    
    NSArray *arr = [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:component]];
    if (arr) {
        
        NSString * str = [arr objectAtIndex:row];
        [result setObject:str forKey:[[dataDic allKeys] objectAtIndex:component]];
    }
    
    
    
    [self resetBackData];
    
}

- (UIView *)pickerView:(UIPickerView *)myPickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [myPickerView rowSizeForComponent:component].width-12, [myPickerView rowSizeForComponent:component].height)];
    
    [label setText:[[self.data objectForKey:@"data"] objectAtIndex:row]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:18.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}

@end