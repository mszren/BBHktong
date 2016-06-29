//
//  CalculatorDetailViewController.m
//  HKT
//
//  Created by app on 15/9/24.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "CalculatorDetailViewController.h"
#import "CoreLabel.h"
#define Size [[UIScreen mainScreen] bounds].size
@interface CalculatorDetailViewController ()
{
    UIScrollView *sc;
}
@end

@implementation CalculatorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgationBarButttonAndLabelTitle:@"还款说明"];
    //背景
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    sc.showsVerticalScrollIndicator = NO;
    sc.bounces = NO;
    [self.view addSubview:sc];
    
    UIView *viewUp = [[UIView alloc] initWithFrame:CGRectMake(10, 10, Size.width - 20, 400)];
    viewUp.backgroundColor = [UIColor whiteColor];
    viewUp.layer.masksToBounds = YES;
    viewUp.layer.cornerRadius = 4;
    viewUp.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    viewUp.layer.borderWidth = 0.4;
    [sc addSubview:viewUp];
    
    UILabel *labelInterect = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Size.width-50, 30)];
    labelInterect.text = @"等额本息还款";
    labelInterect.font = [UIFont systemFontOfSize:16];
    labelInterect.textAlignment = NSTextAlignmentLeft;
    [viewUp addSubview:labelInterect];
    
  // add by wyy
    UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    [viewUp addSubview:lineLabel];
    
    CoreLabel *labelInterectDirect = [[CoreLabel alloc] init];
    labelInterectDirect.font = [UIFont systemFontOfSize:15];
    labelInterectDirect.cl_verticalAlignment=CoreLabelVerticalAlignmentMiddle;
    labelInterectDirect.cl_lineSpacing = 5;
    labelInterectDirect.text = @"说明：等额本息还款法，即借款人每月按相等的金额偿还贷款本息，其中每月贷款利息按月初剩余贷款本金计算并等额本息还款法逐月结清。由于每月的还款额相等，因此，在贷款初期每月的还款中，剔除按月结清的利息贷款后，所还的贷款本金就较少，而在贷款后期因贷款本金不断减少，每月的还款额中贷款利息也不断减少，每月所还的贷款本金就较多。这种还款方式，实际占用银行贷款的数量更多，占用的时间更长，同时它还便于借款人合理安排每月的生活和进行理财（如以租养房等），对于精通投资，理财的人来说，是最好的选择。";
    CGSize trueSizeInterectDirect = [labelInterectDirect.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(Size.width - 40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    labelInterectDirect.frame = CGRectMake(15, 44, Size.width - 50, trueSizeInterectDirect.height);
    labelInterectDirect.textColor = [UIColor darkGrayColor];
    [labelInterectDirect addAttr:CoreLabelAttrColor value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [labelInterectDirect addAttr:CoreLabelAttrFont value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,3)];
    [labelInterectDirect updateLabelStyle];
    [viewUp addSubview:labelInterectDirect];
    
    CoreLabel *labelCalculatorInterect = [[CoreLabel alloc] init];
    labelCalculatorInterect.font = [UIFont systemFontOfSize:15];
    labelCalculatorInterect.cl_verticalAlignment=CoreLabelVerticalAlignmentMiddle;
    labelCalculatorInterect.cl_lineSpacing = 5;
    labelCalculatorInterect.text = @"计算公式：每月还款额=[贷款本金×月利率×（1+月利率）^还款总期数] ÷ [（1+月利率）^还款总期数-1]";
    CGSize trueSizeCalculatorInterect = [labelCalculatorInterect.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(Size.width - 40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    labelCalculatorInterect.frame = CGRectMake(15, 44 + trueSizeInterectDirect.height + 10, Size.width - 50, trueSizeCalculatorInterect.height);
    labelCalculatorInterect.textColor = [UIColor darkGrayColor];
    [labelCalculatorInterect addAttr:CoreLabelAttrColor value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [labelCalculatorInterect addAttr:CoreLabelAttrFont value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,5)];
    [labelCalculatorInterect updateLabelStyle];
    [viewUp addSubview:labelCalculatorInterect];
    
    viewUp.frame = CGRectMake(10, 10, Size.width - 20, 40 + trueSizeInterectDirect.height + trueSizeCalculatorInterect.height + 30);
 
    UIView *viewDown = [[UIView alloc] initWithFrame:CGRectMake(10, 40 + trueSizeInterectDirect.height + trueSizeCalculatorInterect.height + 30 + 30, Size.width - 20, 300)];
    viewDown.backgroundColor = [UIColor whiteColor];
    viewDown.layer.masksToBounds = YES;
    viewDown.layer.cornerRadius = 4;
    viewDown.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    viewDown.layer.borderWidth = 0.4;
    [sc addSubview:viewDown];
    
    UILabel *labelEqule = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Size.width-50, 30)];
    labelEqule.text = @"等额本金还款";
    labelEqule.font = [UIFont systemFontOfSize:16];
    labelEqule.textAlignment = NSTextAlignmentLeft;
    [viewDown addSubview:labelEqule];
    
    // add by wyy
    UILabel* lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kDeviceWidth, 1)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    [viewDown addSubview:lineLabel1];
    
    CoreLabel *labelEquleDirect = [[CoreLabel alloc] init];
    labelEquleDirect.font = [UIFont systemFontOfSize:15];
    labelEquleDirect.cl_verticalAlignment=CoreLabelVerticalAlignmentMiddle;
    labelEquleDirect.cl_lineSpacing = 5;
    labelEquleDirect.text = @"说明：所谓等额本金还款，贷款人将本金分摊到每个月内，同时付清上一交易日至本次还款日之间的利息。这种还款方式相对等额本息而言，总的利息支出较低，但是前期支付的本金和利息较多，还款负担逐月递减。等额本金还款法是一种计算非常简便，实用性很强的一种还款方式。基本算法原理是在还款期内按期等额归还贷款本金，并同时还清当期未归还的本金所产生的利息。方式可以是按月还款和按季还款。";
    CGSize trueSizeEquleDirect = [labelEquleDirect.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(Size.width - 40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    labelEquleDirect.frame = CGRectMake(15, 44, Size.width - 50, trueSizeEquleDirect.height);
    labelEquleDirect.textColor = [UIColor darkGrayColor];
    [labelEquleDirect addAttr:CoreLabelAttrColor value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [labelEquleDirect addAttr:CoreLabelAttrFont value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,3)];
    [labelEquleDirect updateLabelStyle];
    [viewDown addSubview:labelEquleDirect];
    
    CoreLabel *labelCalculatorEqule = [[CoreLabel alloc] init];
    labelCalculatorEqule.font = [UIFont systemFontOfSize:15];
    labelCalculatorEqule.cl_verticalAlignment=CoreLabelVerticalAlignmentMiddle;
    labelCalculatorEqule.cl_lineSpacing = 5;
    labelCalculatorEqule.text = @"计算公式：每季还款额=贷款本金÷贷款期季数+（本金-已归还本金累计额）×季利率";
    CGSize trueSizeCalculatorEqule = [labelCalculatorEqule.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(Size.width - 40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    labelCalculatorEqule.frame = CGRectMake(15, 44 + trueSizeEquleDirect.height + 10, Size.width - 50, trueSizeCalculatorEqule.height);
    labelCalculatorEqule.textColor = [UIColor darkGrayColor];
    [labelCalculatorEqule addAttr:CoreLabelAttrColor value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [labelCalculatorEqule addAttr:CoreLabelAttrFont value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,5)];
    [labelCalculatorEqule updateLabelStyle];
    [viewDown addSubview:labelCalculatorEqule];
    
    viewDown.frame = CGRectMake(10, 40 + trueSizeInterectDirect.height + trueSizeCalculatorInterect.height + 30 + 30, Size.width - 20, 40 + trueSizeEquleDirect.height + trueSizeCalculatorEqule.height + 30);
    
    sc.contentSize = CGSizeMake(0, 40 + trueSizeInterectDirect.height + trueSizeCalculatorInterect.height + 30 + 30 + 40 + trueSizeEquleDirect.height + trueSizeCalculatorEqule.height + 30 + 100);
}

-(void)buttonLeftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
