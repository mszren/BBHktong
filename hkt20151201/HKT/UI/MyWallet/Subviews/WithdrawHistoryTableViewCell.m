//
//  WithdrawHistoryTableViewCell.m
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "WithdrawHistoryTableViewCell.h"

@implementation WithdrawHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)needHelp:(BOOL)isNeedHelp{
    
    if(isNeedHelp){
        _helpIcon.hidden = NO;
    }else {
        _helpIcon.hidden = YES;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
