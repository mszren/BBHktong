//
//  PaymentFooterView.h
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentFooterView : UIView

@property (weak, nonatomic) IBOutlet UITextField *moneyField;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UILabel *foreLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end
