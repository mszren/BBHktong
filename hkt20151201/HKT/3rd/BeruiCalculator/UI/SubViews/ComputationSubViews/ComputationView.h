//
//  ComputationView.h
//  HKT
//
//  Created by iOS2 on 15/11/4.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComputationView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImage;

@property (weak, nonatomic) IBOutlet UIImageView *loanImage;


@property (weak, nonatomic) IBOutlet UIImageView *rateImagew;

@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;

@property (weak, nonatomic) IBOutlet UILabel *loanLabel;


@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@property (weak, nonatomic) IBOutlet UIView *pieView;
@property (weak, nonatomic) IBOutlet UILabel *yuegongLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuegongNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentNuitLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymenyImageH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentNameH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentUnitH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLabelH;




@end
