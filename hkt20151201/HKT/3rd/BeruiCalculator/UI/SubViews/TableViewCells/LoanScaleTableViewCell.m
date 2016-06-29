//
//  LoanScaleTableViewCell.m
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "LoanScaleTableViewCell.h"

@implementation LoanScaleTableViewCell

- (void)awakeFromNib {
    
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    // Initialization code
}

-(void)setChecked:(BOOL)checked
{

    if (checked) {
        _selectImageView.image = [UIImage imageNamed:@""];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }else{
        _selectImageView.image = [UIImage imageNamed:@"icon_right"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    m_checked = checked;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
