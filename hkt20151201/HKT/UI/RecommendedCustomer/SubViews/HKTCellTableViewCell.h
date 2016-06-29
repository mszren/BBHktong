//
//  HKTCellTableViewCell.h
//  HKT
//
//  Created by app on 15-6-23.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "HKTModel.h"
#import "UserManager.h"
//1.制定协议方法
@protocol HKTCellTableViewDelegate <NSObject>

-(void)HKTCellBtnClick:(UIButton *)HKTCellBtn;

@end

@interface HKTCellTableViewCell : UITableViewCell<ASIHTTPRequestDelegate>

@property(nonatomic,retain)HKTModel *model;
//2 代理指针
@property(nonatomic,assign)id<HKTCellTableViewDelegate>delegate;

@property(nonatomic,retain)UIButton *HKTCellBtn;

@end
