//
//  UpdatePhotoView.m
//  HKT
//
//  Created by iOS2 on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "UpdatePhotoView.h"

@implementation UpdatePhotoView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}
@end
