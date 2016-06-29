//
//  PunchViewController.h
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class iCarousel;

@interface PunchViewController : BaseViewController

@property (nonatomic, strong) IBOutlet iCarousel *icarousel;

@property (nonatomic,weak)IBOutlet UIButton *btnSubmit;

@end
