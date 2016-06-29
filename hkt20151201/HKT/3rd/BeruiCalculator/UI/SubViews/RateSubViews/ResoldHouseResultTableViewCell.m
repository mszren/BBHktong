//
//  ResoldHouseResultTableViewCell.m
//  HKT
//
//  Created by Ting on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ResoldHouseResultTableViewCell.h"

@implementation ResoldHouseResultTableViewCell

- (void)awakeFromNib {
    
    _colorView.layer.cornerRadius = 4.0f;
    _colorView.clipsToBounds = YES;
    
    _priceLbl.textColor = [UIColor colorWithHex:0x58b6ee];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
