//
//  ChooseMenuBtn.m
//  LKT
//
//  Created by iOS2 on 15/10/8.
//  Copyright (c) 2015年 wyy. All rights reserved.
//

#import "ChooseMenuBtn.h"
#import "WYYControl.h"

#define CHOOSEBTN_HEIGHT 50
#define BTN_TAG 1000
#define MainColor [UIColor colorWithRed:92/255.0 green:183/255.0 blue:237/255.0 alpha:1]

@implementation ChooseMenuBtn


-(instancetype)initWithFrame:(CGRect)frame andNameArr:(NSArray*)array  andTarget:(id)target andAction:(SEL)action
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSArray* arr = [[NSArray alloc]init];
        arr = array;
        for (int i=0; i < array.count; i ++) {
            _chooseBtn = [WYYControl createButtonWithFrame:CGRectMake(kDeviceWidth/array.count*i, 0, kDeviceWidth/array.count, CHOOSEBTN_HEIGHT) ImageName:nil Target:target Action:action Title:arr[i]];
            
            [_chooseBtn setTitle:arr[i] forState:UIControlStateNormal];
            _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_chooseBtn setTitleColor:MainColor forState:UIControlStateSelected];
            _chooseBtn.tag = BTN_TAG + i;
    
            if (i == 0) {
                _chooseBtn.selected = YES;
            }
            [self addSubview:_chooseBtn];
            
        }
        //   下方分割线
        UILabel* footLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CHOOSEBTN_HEIGHT-1, kDeviceWidth, 0.5)];
        footLineLabel.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        [self addSubview:footLineLabel];
        
 
//        CGFloat width = 10;
    
        _rollLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CHOOSEBTN_HEIGHT-2, kDeviceWidth/array.count, 2)];
        _rollLabel.backgroundColor = MainColor;
        [self addSubview:_rollLabel];
        

    }
    return self;
}

@end
