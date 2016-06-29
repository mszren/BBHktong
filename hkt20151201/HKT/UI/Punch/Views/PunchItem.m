//
//  PunchItem.m
//  HKT
//
//  Created by Ting on 15/11/23.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "PunchItem.h"

@interface PunchItem ()

@property (nonatomic,weak)IBOutlet UIView *blueRoundView;
@property (nonatomic,weak)IBOutlet UIView *contentView;

@end

@implementation PunchItem



-(void)awakeFromNib{
    [super awakeFromNib];
    _blueRoundView.layer.cornerRadius = 3.0f;
    _contentView.layer.cornerRadius = 5.0f;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
