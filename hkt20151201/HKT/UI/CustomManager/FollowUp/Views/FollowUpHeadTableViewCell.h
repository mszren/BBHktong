//
//  FollowUpHeadTableViewCell.h
//  HKT
//
//  Created by Ting on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowUpHeadTableViewCell : UITableViewCell

-(void)setSelectedSytle:(BOOL)selected;

@property (nonatomic,weak)IBOutlet UIButton *selectedButton;
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;

@end
