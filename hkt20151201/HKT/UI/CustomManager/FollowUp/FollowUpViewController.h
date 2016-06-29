//
//  FollowUpViewController.h
//  HKT
//
//  Created by Ting on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "BaseViewController.h"

@interface FollowUpViewControllerModel : NSObject

@property (nonatomic,copy)NSString *customer_name;
@property (nonatomic,copy)NSString *followText;
@property (nonatomic,copy)NSString *customer_id;

@end


@interface FollowUpViewController : BaseViewController

@property(retain,nonatomic)NSMutableArray* imageArr; // 上传图片数组
-(instancetype)initWithModel:(FollowUpViewControllerModel *)model;

@end

