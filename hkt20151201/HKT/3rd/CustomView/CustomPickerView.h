//
//  CustomDatePicker.h
//  jiuhaoHealth
//
//  Created by xiaoquan on 13-11-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPickerView.h"
/**
 *    自定义的日期选择
 *    @author xiaoquan
 */
@interface CustomPickerView : MyPickerView<UIPickerViewDelegate,UIPickerViewDataSource>
{

    UIDatePicker *picker;
    UIView *pickerView;
    
    NSMutableDictionary *dataDic;
    
}

@property (nonatomic, strong) UIDatePicker *picker;;
@property (nonatomic, strong) UIView *pickerView;

@end