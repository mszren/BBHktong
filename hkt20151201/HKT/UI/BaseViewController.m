//
//  BaseViewController.m
//  iHouPopStarIos
//
//  Created by xdyang on 14-1-16.
//  Copyright (c) 2014年 xdyang. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "UIImage+Color.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#import "MobClick.h"
#import "CalculatorViewController.h"
#import "WYYControl.h"
@interface BaseViewController ()

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, assign) BOOL canResponseToUIScreenEdgePanGesture;
@property (nonatomic, weak) UINavigationController *theNavigationController;

@end

@implementation BaseViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"dealloc %@", NSStringFromClass(self.class));
}

#pragma mark - UIViewController life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [self myViewBackgroundColor];
    
    self.theNavigationController = self.navigationController;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"show %@", NSStringFromClass(self.class));
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    
    self.canResponseToUIScreenEdgePanGesture = YES;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.canResponseToUIScreenEdgePanGesture = NO;
        // 做1s的延迟，保证页面切换的动画完成后才能进行下一次页面切换
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.canResponseToUIScreenEdgePanGesture = YES;
        });
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self myStatusBarStyle];
}

- (UIStatusBarStyle )myStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIColor *)myNavigationBarColor {
    return [UIColor colorWithHex:0xf6f6f6];
}

- (UIColor *)myViewBackgroundColor {
    return [UIColor colorWithHex:0xf0f2f5];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass(self.class)];
    
    self.canResponseToUIScreenEdgePanGesture = NO;
    
    /* By xianli, 2015/2/8 13:14
     * 这段代码是用来解决导航条问题的核心。
     * 由于整个工程中有的ViewController显示导航栏，有的ViewController不显示，造成在这两种VC中切换页面会产生各种页面上的问题。
     * 之前的解决方式是在各个VC的viewWillAppear和viewWillDisappear中设置导航栏显示或隐藏，但是总是这个页面好了那个页面又出了问题，根本原因在于没有把
     * UINavigationController的机制弄清楚。
     * 我们需要的是把页面切换过程中的所有情况分析清楚，然后得出一个通用的处理算法可以满足所有的情况，并集成到ViewController的基类中。下面是解决方法的分析。
     *
     * 首先考虑一个问题，在两个VC切换的过程中，必然会触发一个VC的viewWillAppear和另外一个页面的viewWillDisappear，那么我们在调用处理算法的时候只能选择这两个方法
     * 的其中之一，否则会造成混乱。这里我选择使用viewWillDisappear，目的是为了把viewWillAppear留给导航栏栈底的VC，类似链表的head。
     * 接着是如何在viewWillDisappear中处理问题。假设有三个VC，VC0, VC1和VC2，我们使用VC1的角度观察各种情况：
     * 1. VC1 -> VC2 在这种情况下可以细分为4中情况 a.VC1和VC2都显示导航栏；b.VC1和VC2都不显示导航栏；c.VC1显示，VC2不显示导航栏；d.VC1不显示，VC2显示导航栏。
     * 2. VC1 -> VC0 在这种情况下也可以细分为4中情况 a.VC1和VC0都显示导航栏；b.VC1和VC0都不显示导航栏；c.VC1显示，VC0不显示导航栏；d.VC1不显示，VC0显示导航栏。
     * 由此可见在页面切换的过程中，对于导航栏的处理需要考虑到一共有8中状态。
     * 对于情况a和b，由于VC1和VC2（或者VC1和VC0）的状态相同，在这种情况下不需要做操作，所以这两种情况可以合并。
     * 对于情况c，可以在VC1的viewWillAppear中调用 [self.navigationController setNavigationBarHidden:YES animated:animated];
     * 对于情况d，可以在VC1的viewWillAppear中调用 [self.navigationController setNavigationBarHidden:NO animated:animated];
     * 最终我们发现，对于1和2两种情况，其实没有不同，都是以调用 setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
     * 所以把上面的8种情况归纳为3中：A.VC1和VC2都显示或都不显示导航栏；B.VC1显示，VC2不显示导航栏；C.VC1不显示，VC2显示导航栏。
     * 到此我们的问题转换成了一个新的问题，如何得知VC1和VC2的是否要显示导航栏。
     * 当程序进入viewWillDisappear的时候，self.navigationController.topViewController已经不是self了，而是将要显示的VC。以VC1和VC2为例，此时导航栏的显示状态
     * 是VC1的，VC2的显示状态未知，只能通过自定义的ViewController的成员变量判断。因此在BaseViewController中增加了wantToHideNavigationBar这个BOOL值，并默认为
     * NO，如果某个VC需要隐藏导航栏就在其viewDidLoad方法中设置wantToHideNavigationBar = YES。
     * 最后，需要考虑的是在项目中有些VC不属于BaseViewController的子类，在这种情况下需要独立区分。例如MWPhotoBrowser和MyFriendsViewController的来回切换。
     */
    
    if (![self.theNavigationController.topViewController isKindOfClass:[BaseViewController class]]) {
        return;
    }
    
    BOOL navigationBarWillHide = ((BaseViewController *)self.theNavigationController.topViewController).wantToHideNavigationBar;
    BOOL navigationBarIsHide = self.wantToHideNavigationBar;
    
    if (navigationBarWillHide == navigationBarIsHide) {
        return;
    }
    else if (navigationBarIsHide && !navigationBarWillHide) {
        [self.theNavigationController setNavigationBarHidden:NO animated:animated];
    }
    else {
        [self.theNavigationController setNavigationBarHidden:YES animated:animated];
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //    NSLog(@"self.canResponseToUIScreenEdgePanGesture is: %@", self.canResponseToUIScreenEdgePanGesture ? @"YES" : @"NO");
    if (!self.canResponseToUIScreenEdgePanGesture) {
        return NO;
    }
    
    if ([gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class]) {
        if (self == self.navigationController.viewControllers.firstObject) {
            return NO;
        }
        
        if (self != self.navigationController.topViewController) {
            return NO;
        }
        
        return YES;
    }
    else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) otherGestureRecognizer {
    
    //    NSLog(@"self.canResponseToUIScreenEdgePanGesture is: %@", self.canResponseToUIScreenEdgePanGesture ? @"YES" : @"NO");
    if (!self.canResponseToUIScreenEdgePanGesture) {
        return NO;
    }
    
    if ([otherGestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - HUD

- (void)showHUDSimple {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
}

- (void)showHUDWithLabel:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDWithDetailsLabel:(NSString *)tips andDetail:(NSString *)detailTips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [self.view  addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    _HUD.detailsLabelText = detailTips;
    _HUD.square = YES;
    [_HUD show:YES];
}

- (void)showHUDWithLabelDeterminate:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [self.view addSubview:_HUD];
    _HUD.mode = MBProgressHUDModeDeterminate;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDWithLabelAnnularDeterminate:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.mode = MBProgressHUDModeAnnularDeterminate;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDWithLabelDeterminateHorizontalBar {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    _HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
}

- (void)showHUDWithCustomView:(UIView *)view andTips:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    
    [self.view addSubview:_HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    _HUD.customView = view;
    //[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)showHUDInView:(UIView *)view andTips:(NSString *)tips {
    if (_HUD) {
        [_HUD removeFromSuperview];
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:view.window ? view.window : view];
    
    [view addSubview:_HUD];
    
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = tips;
    [_HUD show:YES];
}

- (void)setHUDProgress:(float)progress {
    if (_HUD) {
        _HUD.progress = progress;
    }
}

- (void)hideHUD {
    [_HUD hide:YES];
    _HUD = nil;
}

#pragma mark - Toast

- (void)makeToast:(NSString *)message {
    [self makeToast:message duration:1];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration {
    if (message.length > 0) {
        UIWindow *toastDisplaywindow = [AppDelegate sharedInstance].window;
        for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
            if (![[testWindow class] isEqual:[UIWindow class]]) {
                toastDisplaywindow = testWindow;
                break;
            }
        }
        
        [toastDisplaywindow makeToast:message duration:duration HeightScale:0.5];
    }
}

#pragma mark - UINavigationItem

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    }
    else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -16;
    }
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)item {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        negativeSpacer.width = -5;
    }
    else {
        // Load resources for iOS 7 or later
        negativeSpacer.width = -15;
    }
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
}

-(UIButton *)getBackButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    return button;
}

-(void)setNavgationBarButttonAndLabelTitle:(NSString*)title
{
    UIButton* backBtn = [WYYControl createButtonWithFrame:CGRectMake(0, 0, 44, 44) ImageName:@"top_goback_left" Target:self Action:@selector(backBtnClick) Title:nil];
    [backBtn setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:backBtn]];
    
    UILabel* titleLabel = [WYYControl createLabelWithFrame:CGRectMake(kDeviceWidth/2-40, 5, 80, 80) Font:17 Text:title textColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
