//
//  ChooseMenuBtn.h
//  LKT
//
//  Created by iOS2 on 15/10/8.
//  Copyright (c) 2015年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMenuBtn : UIView

@property(strong,nonatomic)UIButton* chooseBtn;
@property(strong,nonatomic)UILabel* rollLabel;
@property(strong,nonatomic)NSArray* array;
@property(strong,nonatomic)id target;

-(instancetype)initWithFrame:(CGRect)frame andNameArr:(NSArray*)array andTarget:(id)target andAction:(SEL)action;

@end
