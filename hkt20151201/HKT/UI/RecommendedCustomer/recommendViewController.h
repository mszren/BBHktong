//
//  recommendViewController.h
//  HKT
//
//  Created by app on 15-6-23.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "HKTModel.h"
#import "UserManager.h"
#import "ManagerViewController.h"
#import "HKTCellTableViewCell.h"
#import "MJRefresh.h"
#import "HTTPRequest+recommend.h"
#import "BaseViewController.h"

//4.遵循代理协议
@interface recommendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HKTCellTableViewDelegate>

@end
