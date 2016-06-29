//
//  ceshiView.h
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyWalletHeaderViewDelegate <NSObject>

-(void)actionWithWithdraw;
-(void)actionWithGotoWithdrawHistory;

@end

@interface MyWalletHeaderView : UIView

@property(nonatomic,weak)IBOutlet UILabel *lblAllMoney;
@property(nonatomic,weak)IBOutlet UILabel *lblWithdrawMoney;
@property(nonatomic,weak)IBOutlet UILabel *lblWithdraw;

@property(nonatomic,assign)id<MyWalletHeaderViewDelegate>delegate;

-(void)setFreeze:(BOOL)isFreeze;

@end
