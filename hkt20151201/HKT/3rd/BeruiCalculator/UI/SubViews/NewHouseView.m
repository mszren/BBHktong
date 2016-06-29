//
//  NewHouseView.m
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "NewHouseView.h"

@implementation NewHouseView

-(void)awakeFromNib{

    NSArray* textFields = @[_sizeField,_priceField];
    for (UITextField* textField in textFields) {
        textField.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        textField.textColor = [UIColor colorWithHex:0x58b6ee];
        textField.layer.cornerRadius = 5;
    }
    
    _calculatorBtn.layer.cornerRadius = 5;
    _calculatorBtn.layer.masksToBounds = YES;

    _singleHouseBtn.selected = YES;
    [_singleHouseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton*)btn
{
    btn.selected = !btn.selected;
}

@end
