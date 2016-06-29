//
//  MyWalletRewardDetailTableViewCell.h
//  HKT
//
//  Created by Ting on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletRewardDetailTableViewCell : UITableViewCell

@property (nonatomic , retain)IBOutlet UILabel *lblTitle;
@property (nonatomic , retain)IBOutlet UILabel *lblTime;
@property (nonatomic , retain)IBOutlet UILabel *lblMoney;
@property (nonatomic , retain)IBOutlet UILabel *lblText;

-(void)isTopCell:(BOOL)isTopCell;


@end
