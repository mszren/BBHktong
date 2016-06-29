//
//  MyPickerView.h
//  jiuhaoHealth
//
//  Created by xiaoquan on 13-11-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PickerType{
    KDatePicker = 0,
    KOtherPicker = 1,
    kTimePicker = 2,
    KDateAndTimePicker = 3
}PickerType;

typedef void (^ CancelBlock)(BOOL animated);
typedef void (^ SelectBlock)(NSDictionary* dic);

/**
 *    自定义的日期选择
 *    @author xiaoquan
 */
@interface MyPickerView : UIView
{
    UILabel *_titleLabel;
	UIView	*bgView;
    
    UIView *navBarView;
    
    NSDictionary *selectData;
    
    
}
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, assign) PickerType type;

@property (nonatomic, assign) CGFloat contextHeight;

/**
 *    title
 */
@property (nonatomic, strong) NSString *titleString;

/**
 *    cancel block
 */
@property (nonatomic, strong) CancelBlock cancel;

/**
 *    select date block
 */
@property (nonatomic, strong) SelectBlock dataBlock;

/**
 *    init
 *    @returns self
 */
- (id)init;

/**
 *    init method
 *    @param title title
 *    @param cancel cancel block
 *    @returns self
 */
- (id)initWithTitle:(NSString *)title pickerType:(PickerType)type contextData:(NSDictionary *)dic cancelBlock:(CancelBlock)cancel selectDataBlock:(SelectBlock)data;

/**
 *    关闭对话框
 *    @param animated 动画
 */
- (void)dismiss:(BOOL)animated;

/**
 *    显示对话框
 *    @param animated 动画
 */
- (void)show:(BOOL)animated;

/**
 *    取消按钮点击
 */
- (void)cancelPressed;

/**
 *    确定按钮点击
 */
- (void)okPressed;

/**
 *    对话框内容展示
 */
- (void)showContextView;
/**
 *    对话框导航
 */
- (void)showNavView;

@end