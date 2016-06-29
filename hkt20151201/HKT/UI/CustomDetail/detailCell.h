//
//  detailCell.h
//  HKT
//
//  Created by app on 15-7-1.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"


@interface detailCell : UITableViewCell

@property(nonatomic,retain)detailModel *model;
@property(nonatomic,strong)UIImageView *imageViewTime;


@end
