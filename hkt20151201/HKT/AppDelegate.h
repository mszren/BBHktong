//
//  AppDelegate.h
//  HKT
//
//  Created by app on 15-5-26.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

#import "APService.h"
#import "recommendViewController.h"
#import "MBProgressHUD+MJ.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedInstance;

@end

