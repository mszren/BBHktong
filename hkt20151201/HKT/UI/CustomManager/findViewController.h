//
//  findViewController.h
//  HKT
//
//  Created by app on 15-7-2.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "MBProgressHUD+MJ.h"
#import "HTTPRequest+manager.h"
#import "BaseViewController.h"

@interface findViewController : BaseViewController<UIScrollViewDelegate>

@property(nonatomic,copy)NSString *customId;
@end
