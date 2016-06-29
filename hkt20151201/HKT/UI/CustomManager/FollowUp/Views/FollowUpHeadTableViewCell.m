//
//  FollowUpHeadTableViewCell.m
//  HKT
//
//  Created by Ting on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "FollowUpHeadTableViewCell.h"

@implementation FollowUpHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)setSelectedSytle:(BOOL)selected{
    [self.selectedButton setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
