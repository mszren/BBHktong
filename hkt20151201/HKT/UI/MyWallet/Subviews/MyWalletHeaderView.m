//
//  ceshiView.m
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "MyWalletHeaderView.h"
#import "UIColor+Hex.h"

@implementation MyWalletHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lblWithdraw.clipsToBounds = YES;
    self.lblWithdraw.layer.cornerRadius =4.0f;
    self.lblWithdraw.backgroundColor = [UIColor colorWithHex:blueButtonNormalColor];
}

-(IBAction)actionWithWithdrawHistoryClick{

    if([_delegate respondsToSelector:@selector(actionWithGotoWithdrawHistory)]){
        
        [_delegate actionWithGotoWithdrawHistory];
    }
}

-(IBAction)actionWithWithdrawClick{

    if([_delegate respondsToSelector:@selector(actionWithWithdraw)]){
    
        [_delegate actionWithWithdraw];
    }
}

-(void)setFreeze:(BOOL)isFreeze{

    if (isFreeze){
        self.lblWithdraw.backgroundColor = [UIColor colorWithHex:0Xe1e4e9];
    }else {
        self.lblWithdraw.backgroundColor = [UIColor colorWithHex:blueButtonNormalColor];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
