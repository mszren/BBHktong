//
//  RateViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

@protocol RateChooseDelegate <NSObject>

-(void)rateArray:(NSArray*)rateArray rateIndex:(NSInteger)index btnTag:(NSInteger)btnTag;

@end

#import "BaseViewController.h"

@interface RateViewController : BaseViewController


@property(weak,nonatomic)id<RateChooseDelegate>delegate;


-(id)initWithRateArray:(NSArray*)rateArray rateIndex:(NSInteger)index btnTag:(NSInteger)btnTag;
@end
