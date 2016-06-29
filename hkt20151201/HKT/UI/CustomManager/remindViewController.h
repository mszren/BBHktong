//
//  remindViewController.h
//  HKT
//
//  Created by app on 15-7-3.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RBCustomDatePickerView.h"
#import "ASIFormDataRequest.h"
#import "ZCActionOnCalendar.h"
#import "UserManager.h"
#import "BaseViewController.h"
#import "CustomDetailViewController.h"
#import "CustomPickerView.h"

@interface remindViewController : BaseViewController<UITextViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>

@property(nonatomic,copy)NSString *customId;

@end
