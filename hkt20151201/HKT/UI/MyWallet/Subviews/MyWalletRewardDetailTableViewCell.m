//
//  MyWalletRewardDetailTableViewCell.m
//  HKT
//
//  Created by Ting on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "MyWalletRewardDetailTableViewCell.h"
#import "UIColor+Hex.h"

@interface MyWalletRewardDetailTableViewCell (){
    
    
    
}

@property (nonatomic,retain)IBOutlet UIView * roundView;
@property (nonatomic,retain)IBOutlet UIView * topLineView;
@property (nonatomic,retain)IBOutlet UIView * lineView;
@property (nonatomic,retain)IBOutlet UIImageView * imgForBg;

@end

@implementation MyWalletRewardDetailTableViewCell


- (void)awakeFromNib {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.roundView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.roundView.clipsToBounds = YES;
    self.roundView.layer.cornerRadius = 4.0f;
    
    _lineView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    
    _topLineView.backgroundColor = [UIColor colorWithHex:0xcccccc];
   
    UIImage *img = [UIImage imageNamed:@"wallet_bg_dialogue"];
   _imgForBg.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 15, 10)];

    // Initialization code
}

-(void)isTopCell:(BOOL)isTopCell{

    if(isTopCell){
    
        _topLineView.hidden =YES;
    }else {
        _topLineView.hidden = NO;
    
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
