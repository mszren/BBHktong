//
//  ComputationViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/4.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "BaseViewController.h"

@interface ComputationViewController : BaseViewController

@property(strong,nonatomic)NSString* totalMoney;// 房屋总价

@property(strong,nonatomic)NSString* fundLoanMoney;// 公积金贷款金额
@property(assign,nonatomic)NSString* businessLoanMoney;// 商业贷款金额

@property(strong,nonatomic)NSString* businessRate; // 利率
@property(strong,nonatomic)NSString* fundRate; // 商贷利率

@property(assign,nonatomic)NSInteger fundYears;// 公积金贷年数
@property(assign,nonatomic)NSInteger businessYears;// 商贷年数

@property(assign,nonatomic)NSInteger paymentMoney; // 首付金额

-(instancetype)initWithTotalMoney:(NSString*)totalMoney loanMoney:(NSString*)loanMoney rate:(NSString*)businessRate paymentMoney:(NSInteger)paymentMoney years:(NSInteger)businessYears;
@end
