//
//  managerCell.h
//  HKT
//
//  Created by app on 15-6-26.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "managerModel.h"

//1.制定协议方法
@protocol managerCellTableViewDelegate <NSObject>

-(void)managerBtnClick:(UIButton *)managerBtnClick;

@end

@interface managerCell : UITableViewCell

//2 代理指针
@property(nonatomic,assign)id<managerCellTableViewDelegate>delegate;
@property(nonatomic,retain)UIButton *detailBtn;
@property(nonatomic,retain)UIButton *followBtn;

@property(nonatomic,retain)managerModel *model;
@property(nonatomic,retain)UILabel *thinkText;

@end
