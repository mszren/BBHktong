//
//  SecondHandHouseView.m
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "SecondHandHouseView.h"

@implementation SecondHandHouseView

-(void)awakeFromNib
{
    _calculatorBtn.layer.cornerRadius = 5;
    _calculatorBtn.layer.masksToBounds = YES;
    
    NSArray* textFieldArray = @[_sizeField,_priceField,_primePriceTextField];
    for (UITextField* textField in textFieldArray) {
        textField.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        textField.textColor = [UIColor colorWithHex:0x58b6ee];
        textField.layer.cornerRadius = 3;
    }
    _sumPriceBtn.selected = YES;
    _firstBuyBtn.selected = YES;
    _singleHouseBtn.selected = YES;
    _houseTermView.backgroundColor = [UIColor whiteColor];
    [self adjustSize];
}

- (IBAction)btnAction:(id)sender {
    
    UIButton* btn = (UIButton*)sender;
    if (btn.selected) {
            btn.selected = !btn.selected;
    }else if (!btn.selected){
           btn.selected = !btn.selected;
    }
}

- (IBAction)priceBtnClick:(id)sender {
    UIButton* btn = (UIButton*)sender;

    if (_sumPriceBtn == nil){
        btn.selected = YES;
        _sumPriceBtn = btn;
    }
    else if (_sumPriceBtn !=nil && _sumPriceBtn == btn){
        btn.selected = YES;
    }
    else if (_sumPriceBtn!= btn && _sumPriceBtn!=nil){
        _sumPriceBtn.selected = NO;
        btn.selected = YES;
        _sumPriceBtn = btn;
    }
    if (_singlePriceBtn.selected) {
        _primePriceHeight.constant = 50.0f;
        _textFieldHeight.constant=30.0f;
        _labelHeight.constant = 18.0f;
        _lineLabelHeight.constant = 1.0f;
        _primePirceNameHeight.constant = 18.0f;
    }else if (_sumPriceBtn.selected){
        [self adjustSize];
    }
}

-(void)adjustSize
{
    _primePriceHeight.constant = 0.0f;
    _textFieldHeight.constant = 0.0f;
    _labelHeight.constant = 0.0f;
    _lineLabelHeight.constant = 0.0f;
    _primePirceNameHeight.constant = 0.0f;
}

@end
