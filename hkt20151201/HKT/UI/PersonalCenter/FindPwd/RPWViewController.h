//
//  RPWViewController.h
//  HKT
//
//  Created by app on 15-5-28.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "realizeViewController.h"
#import "UserManager.h"
#import "HTTPRequest+Login.h"
#import "HTTPRequest+person.h"
#import "MBProgressHUD+MJ.h"

@interface RPWViewController : BaseViewController

@property (nonatomic, copy) void (^finishBlock)(NSString *userName,NSString *password);

@end
