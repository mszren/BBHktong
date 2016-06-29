//
//  HistoryUserView.m
//  HKT
//
//  Created by Ting on 15/11/12.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HistoryUserView.h"

@implementation HistoryUserView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _imgViewForHead.clipsToBounds = YES;
    _imgViewForHead.layer.cornerRadius =22.0f;
    
//    _closeBtn.backgroundColor = [UIColor colorWithHex:0x000000];
//    _closeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    _closeBtn.layer.borderWidth = 1.0f;
//    _closeBtn.layer.cornerRadius = 10.0f;
//    [_closeBtn.layer setShadowPath:[[UIBezierPath
//                                     bezierPathWithRect:_closeBtn.bounds] CGPath]];
    _closeBtn.hidden = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionWithChoose)];
    tap.cancelsTouchesInView = YES;
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTouch:)];
    longTap.minimumPressDuration =1.0f;
    [self addGestureRecognizer:longTap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCloseBtn)
                                                 name:@"showCloseBtn"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenCloseBtn)
                                                 name:@"hiddenCloseBtn"
                                               object:nil];
}

-(void)hiddenCloseBtn{
    _closeBtn.hidden = YES;
}

-(void)showCloseBtn{
    _closeBtn.hidden = NO;
}

-(void)longTouch:(UILongPressGestureRecognizer *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCloseBtn" object:nil];
}

-(IBAction)actionWithDelete{
    if([_delegate respondsToSelector:@selector(historyUseViewDeleteAtIndex:)]){
        [_delegate historyUseViewDeleteAtIndex:self.tag];
    }
}

-(void)actionWithChoose{
    if([_delegate respondsToSelector:@selector(historyUseViewChooseAtIndex:)]){
        [_delegate historyUseViewChooseAtIndex:self.tag];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
