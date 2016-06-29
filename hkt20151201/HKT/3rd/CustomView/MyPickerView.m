//
//  MyPickerView.m
//  jiuhaoHealth
//
//  Created by xiaoquan on 13-11-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//


#import "MyPickerView.h"
#import "UIView+Size.h"
#import "UIColor+Hex.h"

#import <QuartzCore/QuartzCore.h>
static CGFloat kTransitionDuration = 0.2;

@interface MyPickerView ()
{
    UIWindow *window;
}
@end

@implementation MyPickerView
@synthesize titleString			= _titleString;
@synthesize cancel				= _cancel;
@synthesize dataBlock	= _dataBlock;
- (id)init
{
    self = [super init];
    
    if (self) {
        // Custom initialization
        [self showContextView];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title pickerType:(PickerType)picker contextData:(NSDictionary *)dic cancelBlock:(CancelBlock)cancel selectDataBlock:(SelectBlock)data
{
    self = [super init];
    
    if (self) {
        
        // Custom initialization
        self.data = dic;
        self.type = picker;
        self.cancel				= cancel;
        self.dataBlock	= data;
        self.titleString		= title;
        self.contextHeight = 255;
        
        window = [UIApplication sharedApplication].keyWindow;
        
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        [self showNavView];
    }
    
    return self;
}

-(void)setContextHeight:(CGFloat)contextHeight
{
    _contextHeight = contextHeight;
    self.frame = CGRectMake(0, window.frame.size.height - _contextHeight, window.frame.size.width, _contextHeight);
}

/**
 *    设置标题
 *    @param title 标题的内容
 */
- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    if (_titleLabel) {
        _titleLabel.text = titleString;
    }
}
/**
 *   设定内容 子类实现
 */
- (void)showContextView
{
    
}

/**
 *   设定内容
 */
- (void)showNavView
{
    
    self.frame = CGRectMake(0, window.frame.size.height - _contextHeight, window.frame.size.width, _contextHeight);
    
    
    navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    navBarView.backgroundColor = [UIColor colorWithHex:0x2ca7f1];
    //    navBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image_navbar_bg.png"]];//COLOR_RGB(46, 45, 43);//
    [self insertSubview:navBarView atIndex:0];
    //Do any additional setup after loading the view.
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navBarView.width - 100) / 2, 5, 100, 30)];
    _titleLabel.backgroundColor		= [UIColor clearColor];
    _titleLabel.textAlignment		= NSTextAlignmentCenter;
    _titleLabel.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
    _titleLabel.textColor			= [UIColor whiteColor];
    _titleLabel.font				= [UIFont systemFontOfSize:16.0f];
    _titleLabel.text				= self.titleString;
    [navBarView addSubview:_titleLabel];
    // 关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10, 5, 44, 30);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //	[closeBtn setBackgroundImage:[[UIImage imageNamed:@"buttonbg_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:closeBtn];
    
    // 确定
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(navBarView.width-44-10, 5, 44, 30);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //	[okBtn setBackgroundImage:[[UIImage imageNamed:@"buttonbg_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:okBtn];
    
    [self addSubview:navBarView];
    
    [self showContextView];
    
}

- (void)closeBtnDone:(id)sender
{
    [self cancelPressed];
    [self dismiss:YES];
}

- (void)okBtnDone:(id)sender
{
    [self okPressed];
    if (self.dataBlock) {
        self.dataBlock(selectData);
    }
    [self dismiss:YES];
    
}

//取消按钮点击
- (void)cancelPressed
{
}

//确定按钮点击
- (void)okPressed
{
}


- (void)postDismissCleanup
{
    [bgView removeFromSuperview];
    [self removeFromSuperview];
}

/**
 *    关闭弹出框
 *    @param animated 是否显示动画
 */
- (void)dismiss:(BOOL)animated
{
    if (self.cancel) {
        self.cancel(animated);
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration / 2];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.transform = CGAffineTransformTranslate([self transformForOrientation], 0, self.height);
        bgView.alpha	= 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI * 1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI / 2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

/*
 *   功能：显示弹出框
 *   @param animated 是否显示动画
 */
- (void)show:(BOOL)animated
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self transformForOrientation];
    
    bgView = [[UIView alloc] initWithFrame:window.frame];
    bgView.backgroundColor	= [UIColor blackColor];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (animated) {
        bgView.alpha = 0.0f;
    } else {
        bgView.alpha = 0.5f;
    }
    bgView.userInteractionEnabled = YES;
    [window addSubview:bgView];
    [window addSubview:self];
    if (animated) {
        // 弹出动画
        self.transform = CGAffineTransformTranslate([self transformForOrientation], 0, self.height);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration / 1.5];
        self.transform = CGAffineTransformTranslate([self transformForOrientation], 0, 0);
        bgView.alpha		= 0.5f;
        [UIView commitAnimations];
        
    }
    
    
}

- (void)dealloc
{}

@end