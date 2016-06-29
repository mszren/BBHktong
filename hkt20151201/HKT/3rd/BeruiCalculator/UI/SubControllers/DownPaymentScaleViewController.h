//
//  DownPaymentScaleViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//


@protocol DownPaymentDelegate <NSObject>

-(void)downPaymentMoney:(NSString *)paymentMoney btnTag:(NSInteger)tag;

-(void)downScale:(NSInteger)scale btnTag:(NSInteger)tag;

@end

#import "BaseViewController.h"

@interface DownPaymentScaleViewController : BaseViewController

@property(weak,nonatomic)id<DownPaymentDelegate>delegate;
@property(assign,nonatomic)NSInteger btnTag;

-(id)initWithPaymentMoney:(NSString*)paymentMoney totalMoeny:(NSString *)totalMoeny scale:(NSInteger)scale btnTag:(NSInteger)tag;

@end
