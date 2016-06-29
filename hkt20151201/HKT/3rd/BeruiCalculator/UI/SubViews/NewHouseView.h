//
//  NewHouseView.h
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewHouseView : UIView
@property (weak, nonatomic) IBOutlet UITextField *sizeField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;

@property (weak, nonatomic) IBOutlet UIButton *houseChooseBtn;

@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *singleHouseBtn;

@property (weak, nonatomic) IBOutlet UIButton *calculatorBtn;

@property (weak, nonatomic) IBOutlet UIButton *loanExplainBtn;

@end
