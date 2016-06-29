//
//  CombinationLoanView.m
//  HKT
//
//  Created by iOS2 on 15/11/2.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "CombinationLoanView.h"

@implementation CombinationLoanView

-(void)awakeFromNib
{
    NSArray* combTextFields = @[_businessField,_fundField,_businessRateField,_fundRateField];
//    NSArray* values = @[@"4.9",@"3.25",@"",@"70",@"70"];
    for (UITextField* textField in combTextFields) {
        textField.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        textField.textColor = [UIColor colorWithHex:0x58b6ee];
        textField.layer.cornerRadius = 5;
    }
    _businessRateField.text = @"4.9";
    _fundRateField.text = @"3.25";
    _businessField.text = @"70";
    _fundField.text = @"70";
    
    _lineLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    _calculatorBtn.layer.cornerRadius = 5;
    _calculatorBtn.layer.masksToBounds = YES;
}


-(IBAction)mortGageYearsAction:(id)sender {
    
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
