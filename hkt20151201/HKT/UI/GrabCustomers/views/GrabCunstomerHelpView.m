//
//  GrabCunstomerHelpView.m
//  HKT
//
//  Created by Ting on 15/11/20.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "GrabCunstomerHelpView.h"


@interface GrabCunstomerHelpView (){
  
}

@property (nonatomic,weak) IBOutlet UIView *backgroundView;
@property (nonatomic,weak) IBOutlet UIView *contentView;

@end

@implementation GrabCunstomerHelpView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmis)];
    [self.backgroundView addGestureRecognizer:tap];
    self.backgroundView.userInteractionEnabled = YES;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.clipsToBounds = YES;
    
    [self bringSubviewToFront:self.contentView];

}

-(void)show{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];
    self.frame = topView.bounds;
    [topView addSubview:self];

}


-(void)dissmis{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
