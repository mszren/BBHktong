//
//  WithdrawHistoryTableViewCell.h
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawHistoryTableViewCell : UITableViewCell

@property (nonatomic , retain)IBOutlet UILabel *lblTime;
@property (nonatomic , retain)IBOutlet UILabel *lblMoney;
@property (nonatomic , retain)IBOutlet UILabel *lblText;

@property (nonatomic , retain)IBOutlet UIImageView *helpIcon;

-(void)needHelp:(BOOL)isNeedHelp;

@end
