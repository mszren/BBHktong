/*****************************************************************************
 文件名称 :
 版权声明 : Copyright (C), 2010-2013 Easier Digital Tech. Co., Ltd.
 文件描述 : 全局函数
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalFunction : NSObject

//
/******************************************************************************
 函数名称 : + (NSData *)compressData:(NSData *)uncompressedData
 函数描述 : 压缩NSData数据
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : N/A
 ******************************************************************************/
+ (NSData *)compressData:(NSData*)uncompressedData;

/******************************************************************************
 函数名称 : + (NSData *)decompressData:(NSData *)compressedData
 函数描述 : 解压缩NSData
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : N/A
 ******************************************************************************/
+ (NSData *)decompressData:(NSData *)compressedData;

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

+ (NSString *)generateUUID;

/**
 *  在屏幕上显示toast  by xdyang
 *
 *  @param message  显示的信息
 *  @param duration 显示的时间
 *  @param scale    在整个屏幕的位置, 从上到下 (0.0 - 1.0)
 */
+ (void)makeToast:(NSString *)message duration:(float)duration HeightScale:(float)scale;
+ (void)makeAttributedToast:(NSAttributedString *)message duration:(float)duration HeightScale:(float)scale;
//
//+ (void)addLeftBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item;
//
//+ (void)addRightBarButtonItem:(UIViewController *)vc item:(UIBarButtonItem *)item;
//
//+ (void)addRightBarButtonItem:(UIViewController *)vc items:(NSArray *)items;

////自定义导航栏－标题
//+ (UILabel *) custNavigationTitle:(NSString *)title;
//+ (UILabel *)custNavigationTitle:(NSString *)title andColor:(UIColor *)color;

////自定义导航栏－标题
//+ (UILabel *)custNavigationAttributeTitle:(NSString *)title;
////自定义导航栏－标题
//+ (UILabel *) custNavigationWithRect:(CGRect)rect title:(NSString *)title;
//
//+ (UIImage *)imageTensile:(UIImage *)image withEdgeInset:(UIEdgeInsets )edgeInsets;
//
////判断手机号 add by Ting
+ (BOOL) isPhoneId:(NSString *)string;
//+ (void )drawDottedLine:(UIImageView *)img;
+ (UIImage *)imageWithView:(UIView *)view;
//
//+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//
//+ (NSDictionary *)getIPAddresses;

+ (BOOL)isfloatString:(NSString *)string;

+ (BOOL)isIntString:(NSString *)string;

+ (BOOL)isMoneyWithStr:(NSString *)string;

@end
