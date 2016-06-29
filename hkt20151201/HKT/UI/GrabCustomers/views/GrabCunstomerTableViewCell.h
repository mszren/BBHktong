//
//  GrabCunstomerTableViewCell.h
//  HKT
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GrabCustomerModel;


@protocol GrabCunstomerTableViewCellDelegate <NSObject>

-(void)actionWithPhoneCall:(UIButton *)btn;

-(void)actionWithGrabCunstomer:(UIButton *)btn;

@end

@interface GrabCunstomerTableViewCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UILabel *lblForName;
@property (nonatomic,weak)IBOutlet UIButton *btnForPhoneNum;
@property (nonatomic,weak)IBOutlet UIButton *btnForGrab;
@property (nonatomic,weak)IBOutlet UILabel *lblForHour;
@property (nonatomic,weak)IBOutlet UILabel *lblForMins;
@property (nonatomic,weak)IBOutlet UILabel *lblForSec;

@property (nonatomic,assign)id<GrabCunstomerTableViewCellDelegate>delegate;

@property (nonatomic,retain)GrabCustomerModel *model;

@end