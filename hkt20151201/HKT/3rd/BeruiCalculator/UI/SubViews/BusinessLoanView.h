//
//  BusinessLoanView.h
//  HKT
//
//  Created by iOS2 on 15/11/2.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BusinessViewDelegate<NSObject>

-(void)paymentScaleAction:(id)sender;

-(void)mortGageYearsAction:(id)sender;

-(void)rateAction:(id)sender;

-(void)loanExplainAction;

-(void)submitAction:(id)sender;

@end

@interface BusinessLoanView : UIView<BusinessViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *totalPriceField;

@property (weak, nonatomic) IBOutlet UILabel *paymentScaleLabel;

@property (weak, nonatomic) IBOutlet UITextField *loanPriceField;

@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *paymentScaleBtn;

@property (weak, nonatomic) IBOutlet UIButton *yearsBtn;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet UIButton *calculatorBtn;
@property (weak, nonatomic) IBOutlet UITextField *rateField;

@property(assign,nonatomic)id<BusinessViewDelegate>delegate;

@end
