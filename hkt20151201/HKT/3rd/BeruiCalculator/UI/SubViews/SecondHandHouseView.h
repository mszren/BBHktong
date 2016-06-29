//
//  SecondHandHouseView.h
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondHandHouseView : UIView

@property (weak, nonatomic) IBOutlet UITextField *sizeField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;

@property (weak, nonatomic) IBOutlet UIButton *houseChooseBtn;

@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *calculatorBtn;
@property (weak, nonatomic) IBOutlet UIButton *sumPriceBtn;

@property (weak, nonatomic) IBOutlet UIButton *singlePriceBtn;

@property (weak, nonatomic) IBOutlet UIButton *firstBuyBtn;

@property (weak, nonatomic) IBOutlet UIButton *singleHouseBtn;

@property (weak, nonatomic) IBOutlet UIView *HousePrimePrice;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primePriceHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (weak, nonatomic) IBOutlet UITextField *primePriceTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *primePirceNameHeight;


@property (weak, nonatomic) IBOutlet UIView *houseTermView;
@property (weak, nonatomic) IBOutlet UILabel *houseTermNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *houseTermChooseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseTermViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *houseTermTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *footLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *headLineLabel;

@end
