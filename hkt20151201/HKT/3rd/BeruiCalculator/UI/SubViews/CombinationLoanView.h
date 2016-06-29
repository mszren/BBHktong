//
//  CombinationLoanView.h
//  HKT
//
//  Created by iOS2 on 15/11/2.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CombinViewDelegate<NSObject>

-(void)paymentScaleAction:(id)sender;

-(void)mortGageYearsAction:(id)sender;

-(void)rateAction:(id)sender;

-(void)loanExplainAction;

-(void)submitAction:(id)sender;

@end

@interface CombinationLoanView : UIView

@property (weak, nonatomic) IBOutlet UITextField *businessField;

@property (weak, nonatomic) IBOutlet UILabel *businessYearLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateNumLabel;

@property (weak, nonatomic) IBOutlet UITextField *fundField;

@property (weak, nonatomic) IBOutlet UILabel *fundYearLabel;

@property (weak, nonatomic) IBOutlet UILabel *fundRateNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fundRateNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *calculatorBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UITextField *businessRateField;
@property (weak, nonatomic) IBOutlet UITextField *fundRateField;

@property(assign,nonatomic)id<CombinViewDelegate>delegate;
@end
