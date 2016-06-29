//
//  identificationViewController.h
//  HKT
//
//  Created by app on 15-6-19.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "UserManager.h"
#import "Popover.h"
#import "BaseViewController.h"

@interface identificationViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate>

@end
