//
//  LoanScaleTableViewCell.h
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanScaleTableViewCell : UITableViewCell
{
    BOOL  m_checked;
}

- (void)setChecked:(BOOL)checked;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end
