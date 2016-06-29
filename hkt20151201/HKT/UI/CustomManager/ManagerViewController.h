//
//  ManagerViewController.h
//  HKT
//
//  Created by app on 15-6-3.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "managerModel.h"
#import "managerCell.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "recommendViewController.h"
#import "BaseViewController.h"

@interface ManagerViewController : BaseViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end
