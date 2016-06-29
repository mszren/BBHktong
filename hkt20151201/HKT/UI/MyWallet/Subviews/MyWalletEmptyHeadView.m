//
//  MyWalletEmptyHeadView.m
//  HKT
//
//  Created by Ting on 15/11/16.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "MyWalletEmptyHeadView.h"
#import "PureColorToImage.h"

@interface MyWalletEmptyHeadView (){
    
}

@property (nonatomic,weak)IBOutlet UIButton *submitBtn;

@end

@implementation MyWalletEmptyHeadView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIImage *imgBtn = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonNormalColor] andWidth:10.0f andHeight:10.0f];
    UIImage *imgBtnHigh = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonHeighColor] andWidth:10.0f andHeight:10.0f];
    
    [_submitBtn setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:imgBtnHigh forState:UIControlStateHighlighted];
    
    _submitBtn.layer.cornerRadius = 5.0f;
    _submitBtn.clipsToBounds = YES;
    
}

-(IBAction)actionWithGotoAddAccount{
    if ([_delegate respondsToSelector:@selector(actionWithGotoAddAccount)]) {
        [_delegate actionWithGotoAddAccount];
    }
}

@end
