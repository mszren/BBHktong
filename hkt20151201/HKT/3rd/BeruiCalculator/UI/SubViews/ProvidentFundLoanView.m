//
//  ProvidentFundLoanView.m
//  HKT
//
//  Created by iOS2 on 15/11/2.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ProvidentFundLoanView.h"

@implementation ProvidentFundLoanView

-(void)awakeFromNib
{
    NSArray* businessFields = @[_totalPriceField,_loanPriceField,_rateField];
    for (UITextField* textField in businessFields) {
        textField.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        textField.textColor = [UIColor colorWithHex:0x58b6ee];
        textField.layer.cornerRadius = 5;
    }
    _rateField.text = @"3.25";
    _totalPriceField.text = @"100";
    _loanPriceField.text = @"70";
    
    _calculatorBtn.layer.cornerRadius = 5;
    _calculatorBtn.layer.masksToBounds = YES;
}


- (IBAction)paymentScaleAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(paymentScaleAction:)]) {
        [_delegate paymentScaleAction:sender];
    }
}

- (IBAction)mortGageYearsAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(mortGageYearsAction:)]) {
        [_delegate mortGageYearsAction:sender];
    }
}

-(IBAction)rateAction:(id)sender{
    
    if ([_delegate respondsToSelector:@selector(rateAction:)]) {
        [_delegate rateAction:sender];
    }
}



-(IBAction)submitAction:(id)sender{
    
    if ([_delegate respondsToSelector:@selector(submitAction:)]) {
        [_delegate  submitAction:(id)sender];
    }
}

-(IBAction)loanExplainAction{
    if ([_delegate respondsToSelector:@selector(loanExplainAction)]) {
        [_delegate loanExplainAction];
    }
}

@end
