//
//  TingLineViewV.m
//  hfwzone
//
//  Created by Ting on 15/3/2.
//  Copyright (c) 2015年 hfw.kunwang. All rights reserved.
//

#import "TingLineViewV.h"
#import "UIColor+Hex.h"

@implementation TingLineViewV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[UIColor colorWithHex:0xcccccc];
    NSArray *selfConstraints= self.constraints;
    for(NSLayoutConstraint *cons in selfConstraints){
        if(cons.firstAttribute == NSLayoutAttributeWidth){
            cons.constant=0.5;
        }
    }

}

@end
