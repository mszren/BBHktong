//
//  ComputationView.m
//  HKT
//
//  Created by iOS2 on 15/11/4.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ComputationView.h"

@implementation ComputationView

-(void)awakeFromNib
{
    _mainScrollView.contentSize = CGSizeMake(kDeviceWidth, 500);
    _mainScrollView.pagingEnabled = NO;
    _mainScrollView.bounces = NO;
    
    _paymentImage.backgroundColor = [UIColor colorWithHex:0xeb7bb6];
    _paymentImage.layer.cornerRadius = 3;
    
    _loanImage.backgroundColor = [UIColor colorWithHex:0x00a1d9];
    _loanImage.layer.cornerRadius = 3;
    
    _rateImagew.backgroundColor = [UIColor colorWithHex:0xf2d03b];
    _rateImagew.layer.cornerRadius = 3;
    
    NSArray* labelArray = @[_paymentLabel,_loanLabel,_rateLabel,_sumLabel,_detailLabel];
    for (UILabel* label in labelArray) {
        label.textColor = [UIColor colorWithHex:0x58b6ee];
    }
    _yuegongLabel.textColor = [UIColor colorWithRed:198/255.0 green:35/255.0 blue:82/255.0 alpha:1];
    
    
}


@end
