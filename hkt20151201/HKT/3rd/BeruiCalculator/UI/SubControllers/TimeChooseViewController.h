//
//  TimeChooseViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/5.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "BaseViewController.h"


@protocol TimeChooseDelegate <NSObject>

-(void)transmitTimeIndex:(NSInteger)index btnTag:(NSInteger)btnTag;

@end
@interface TimeChooseViewController : BaseViewController

@property(weak,nonatomic)id<TimeChooseDelegate>delegate;

@property(assign,nonatomic)NSInteger index; // 上级页面传递回来的时间index
@property(assign,nonatomic)NSInteger btnTag;


@end
