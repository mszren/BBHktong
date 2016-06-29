//
//  registerViewController.h
//  HKT
//
//  Created by app on 15-5-27.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UserManager.h"
#import "HTTPRequest+Login.h"
#import "BaseViewController.h"
@interface registerViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic, copy) void (^finishBlock)(NSString *userName,NSString *password);

@end
