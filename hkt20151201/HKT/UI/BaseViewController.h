//
//  BaseViewController.h
//
//  description:所有ViewController的基类,所有的ViewController从此集成
//  Created by xdyang on 14-1-16.
//  Copyright (c) 2014年 xdyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UIGestureRecognizerDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, assign) BOOL wantToHideNavigationBar;

- (UIStatusBarStyle)myStatusBarStyle;
- (UIColor *)myNavigationBarColor;
- (UIColor *)myViewBackgroundColor;
//18655102426
#pragma mark - HUD
- (void)showHUDSimple;
- (void)showHUDWithLabel:(NSString *)tips ;
- (void)showHUDWithDetailsLabel:(NSString *)tips andDetail:(NSString *)detailTips;
- (void)showHUDWithLabelDeterminate:(NSString *)tips;
- (void)showHUDWithLabelAnnularDeterminate:(NSString *)tips;
- (void)showHUDWithLabelDeterminateHorizontalBar;
- (void)showHUDWithCustomView:(UIView *)view andTips:(NSString *)tips;
- (void)showHUDInView:(UIView *)view andTips:(NSString *)tips;
- (void)setHUDProgress:(float)progress;
- (void)hideHUD;

#pragma mark - Toast
- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration;

#pragma mark - UINavigationItem
- (void)addLeftBarButtonItem:(UIBarButtonItem *)item;
- (void)addRightBarButtonItem:(UIBarButtonItem *)item;

-(void)setNavgationBarButttonAndLabelTitle:(NSString*)title;

-(UIButton *)getBackButton;
@end
