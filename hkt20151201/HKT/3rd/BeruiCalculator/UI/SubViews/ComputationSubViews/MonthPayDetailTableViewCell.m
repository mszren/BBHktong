//
//  MonthPayDetailTableViewCell.m
//  HKT
//
//  Created by iOS2 on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "MonthPayDetailTableViewCell.h"


#define width kDeviceWidth/5
@implementation MonthPayDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, width, 20)];
//        _monthLabel.textAlignment = NSTextAlignmentCenter;
//        _monthLabel.textColor = [UIColor darkGrayColor];
//        _monthLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_monthLabel];
        
        _monthPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(width,5 , width, 20)];
//        _monthPayLabel.textAlignment = NSTextAlignmentCenter;
//        _monthPayLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_monthPayLabel];
        
        _principal = [[UILabel alloc]initWithFrame:CGRectMake(width*2,5, width, 20)];
//        _principal.textAlignment = NSTextAlignmentCenter;
//        _principal.textColor = [UIColor darkGrayColor];
//        _principal.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_principal];
        
        _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3,5, width, 20)];
//        _rateLabel.textAlignment = NSTextAlignmentCenter;
//        _rateLabel.textColor = [UIColor darkGrayColor];
//        _rateLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_rateLabel];
        
        _restMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*4, 5, width, 20)];
//        _restMoneyLabel.textAlignment = NSTextAlignmentCenter;
//        _restMoneyLabel.textColor = [UIColor darkGrayColor];
//        _restMoneyLabel.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_restMoneyLabel];
        NSArray* labelTitles = @[_monthLabel,_monthPayLabel,_principal,_rateLabel,_restMoneyLabel];
        for (UILabel*  label in labelTitles) {
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:13];
            [self addSubview:label];
        }
        _monthPayLabel.textColor = [UIColor colorWithHex:0x58b6ee];
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
