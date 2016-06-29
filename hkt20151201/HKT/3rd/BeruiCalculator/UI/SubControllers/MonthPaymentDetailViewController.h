//
//  MonthPaymentDetailViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "BaseViewController.h"

@interface MonthPaymentDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;

@property (weak, nonatomic) IBOutlet UILabel *loanSumMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthLoanLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumRateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;



@property(assign,nonatomic)float benjin;
@property(assign,nonatomic)float yuegong;
@property(assign,nonatomic)float rate;

@property(assign,nonatomic)float sumMoney;
@property(assign,nonatomic)float months;
@property(assign,nonatomic)float loanMoney;
@property(assign,nonatomic)float monthPay;
@property(assign,nonatomic)float sumRate;

@property(retain,nonatomic)NSArray* detailArr;;

-(id)initWithSumMoney:(float)sumMoney month:(float)months loanMoney:(float)loanMoney monthPay:(float)monthPay sumRate:(float)sumRate detailArr:(NSArray*)detailArr;;

@end
