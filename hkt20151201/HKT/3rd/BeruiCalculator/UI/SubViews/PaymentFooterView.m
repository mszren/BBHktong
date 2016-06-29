//
//  PaymentFooterView.m
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "PaymentFooterView.h"

@implementation PaymentFooterView

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    
    _moneyField.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _sureBtn.layer.cornerRadius =5;
    _sureBtn.layer.masksToBounds = YES;

    _moneyField.textColor = [UIColor colorWithRed:85/255.0 green:177/255.0 blue:233/255.0 alpha:1];
    _moneyField.layer.cornerRadius = 5.0f;
    
    _headImageView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    
}

@end
