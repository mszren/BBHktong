//
//  AdViewController.h
//  HKT
//
//  Created by app on 15/11/12.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//1block
typedef void (^SkipLoginStatus)(NSString *);

@interface AdViewController : BaseViewController

//2block
@property(nonatomic,copy)SkipLoginStatus SkipStatus;

@end
