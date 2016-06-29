//
//  TingDropDownTableViewCell.m
//  FSDropDownMenu
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 chx. All rights reserved.
//

#import "TingDropDownTableViewCell.h"

@interface TingDropDownTableViewCell()

@property (nonatomic,weak)IBOutlet UIImageView *selectedImgView;

@end

@implementation TingDropDownTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)setSelectedSytle:(BOOL)selected{
    if(selected){
        _selectedImgView.hidden = NO;
    }else{
        _selectedImgView.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
