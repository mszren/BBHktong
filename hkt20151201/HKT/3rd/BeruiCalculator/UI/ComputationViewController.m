//
//  ComputationViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/4.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ComputationViewController.h"
#import "ChooseMenuBtn.h"
#import "XYPieChart.h"
#import "CalculatorViewController.h"
#import "ShareTemplate.h"
#import "WYYControl.h"
#import "ComputationView.h"
#import "InterestPrincipalView.h"

#import "MonthPaymentDetailViewController.h"

@interface ComputationViewController ()<UIScrollViewDelegate,XYPieChartDelegate,XYPieChartDataSource>
{
    float payment;// 首付金额
    float businessLoan; // 商贷
    float fundLoan; // 公积金贷
    

    float months;// 总月数

    NSString *labelNLLz;
    float _row;
    float _publicRow;
    float dengebenxiMonthPay; //等额本息月供
    
    float XYJ1;
    float XYJALL;
    
    float dengebenxiRateSum;
    float XZLX1;
    float dengebenxiSumRate; // 等额本息利息总和
    
    float JYJ;
    float JYJ1;
    
    float dengebenjinMonthPay; // 等额本金月供
    
    float JZLX;
    float JZLX1;
    float dengebenjinSumRate;   // 等额本金利息总和
    
    NSTimer* _paymentTimer;

    int shateBtnIndex;
}

@property(strong,nonatomic)NSMutableArray* dataArr;// 圆饼图分割部分
@property(strong,nonatomic)NSArray* colors; // 颜色
@property(strong,nonatomic)NSMutableArray* benxiDetailArr;
@property(strong,nonatomic)NSMutableArray* benjinDetailArr;

@property(strong,nonatomic)ComputationView* computationView;
@property(strong,nonatomic)ComputationView* interestView;
@property(strong,nonatomic)ChooseMenuBtn* chooseBtn;
@property(strong,nonatomic)XYPieChart* principalPie;
@property(strong,nonatomic)XYPieChart* interestPie;// 等额本息

@property(strong,nonatomic)UILabel* percentageLabel;
@property(strong,nonatomic)UILabel* interPercentLabel;
@property(strong,nonatomic)UIButton* shareBtn;
@property(strong,nonatomic)UIScrollView* computationScr;
@property(strong,nonatomic)UIScrollView* principalScrollView;// 等额本金
@property(strong,nonatomic)UIScrollView* interestScrollView;// 等额本息;

@end

@implementation ComputationViewController
-(instancetype)initWithTotalMoney:(NSString *)totalMoney loanMoney:(NSString *)loanMoney rate:(NSString *)businessRate paymentMoney:(NSInteger)paymentMoney years:(NSInteger)businessYears
{
    self = [super init];
    if (self) {
        _totalMoney = totalMoney;
        _businessLoanMoney = loanMoney;
        _businessRate = businessRate;
        _paymentMoney = paymentMoney;
        _businessYears = businessYears;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMainView];
    [self createPie];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavgationBarButttonAndLabelTitle:@"计算结果"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareBtn];
}


-(void)createMainView
{
    [self.view addSubview:self.chooseBtn];
    [self.view addSubview:self.computationScr];
    
    [_computationScr addSubview:self.principalScrollView];
    [_computationScr addSubview:self.interestScrollView];
    
    [_principalScrollView addSubview:self.computationView];
    [_interestScrollView addSubview:self.interestView];
    if (!self.paymentMoney > 0) {
        _computationView.paymentLabel.hidden = NO;
    }

}

-(void)createPie
{
    [self readyData];
    _dataArr = [[NSMutableArray alloc]init];
    _colors = [NSArray arrayWithObjects:[UIColor colorWithHex:0xeb7bb6],[UIColor colorWithHex:0x00a1d9],[UIColor colorWithHex: 0xf3d03b] ,nil];
    [self.computationView.pieView addSubview:self.principalPie];
    [self.interestView.pieView addSubview:self.interestPie];
    
    [self.principalPie addSubview:self.percentageLabel];
    [self.interestPie addSubview:self.interPercentLabel];
}

-(void)readyData
{
    _benjinDetailArr = [[NSMutableArray alloc]init];
    _benxiDetailArr = [[NSMutableArray alloc]init];
    _row = self.businessYears*12; // 贷款年数
    _publicRow = self.fundYears*12;
    businessLoan = [self.businessLoanMoney floatValue];
    fundLoan = [self.fundLoanMoney floatValue];// 贷款
    
    float monthRate = [self.businessRate floatValue]/100/12;// 商贷利率
    float monthRate1 = [self.fundRate floatValue]/100/12;// 公积金贷利率
    
    NSLog(@"%f++++%f+++++%f+++++%f",_row,_publicRow,businessLoan,fundLoan);
    
    //等额本息每月还款额
    dengebenxiMonthPay = (businessLoan * monthRate * pow(1 + monthRate, _row)) / (pow(1 + monthRate, _row)-1);
    // 等额本息利息总和
    dengebenxiRateSum = ((businessLoan * monthRate * pow(1 + monthRate, _row)) / (pow(1 + monthRate, _row)-1))*_row - businessLoan;
    
    
    // 组合贷
    if ( monthRate1 != 0) {
        XYJ1 = (fundLoan * monthRate1 * pow(1 + monthRate1, _row)) / (pow(1 + monthRate1, _row)-1);
        XZLX1 = ((fundLoan * monthRate1 * pow(1 + monthRate1, _row)) / (pow(1 + monthRate1, _row)-1))*_row - fundLoan;
    }
    dengebenxiMonthPay = dengebenxiMonthPay + XYJ1; // 月供
    dengebenxiSumRate = dengebenxiRateSum + XZLX1; // 利息总和
    
    NSLog(@"%f-----%f----%f---%f",businessLoan,monthRate,_row,monthRate1);
    NSLog(@"%f----%f------%f-----%f",dengebenxiMonthPay,dengebenxiRateSum,XYJALL,dengebenxiSumRate);
    
    float sum = 0;
    float ALL = 0; // 已归还本金累计额
    float Add = 0;
    
    float sum1 = 0;
    float ALL1 = 0;
    float Add1 = 0;
    for (int i = 0; i < _row ; i ++) {
        ALL = businessLoan/_row * i;
        sum = businessLoan/_row + (businessLoan - ALL) * monthRate;
        Add += sum;
        
        ALL1 = fundLoan/_row * i;
        sum1 = fundLoan/_row + (fundLoan - ALL1) * monthRate1;
        Add1 += sum1;
        
        NSString *str = [NSString stringWithFormat:@"%.0f",(sum + sum1)*10000];
        [_benjinDetailArr addObject:str];
        
        NSString* benxiStr = [NSString stringWithFormat:@"%.0f",dengebenxiMonthPay*10000];
        [_benxiDetailArr addObject:benxiStr];
    }

    JZLX = Add - businessLoan;
    JYJ = Add / _row;
    
    JZLX1 = Add1 - fundLoan;
    JYJ1 = Add1 / _row;
    
    dengebenjinSumRate = JZLX1+JZLX;
    dengebenjinMonthPay = JYJ1+JYJ;
    
    NSLog(@"%f+++++++%f++++++%f+++++%f++++%f++++%f",JZLX,JYJ,JZLX1,JYJ1,dengebenjinSumRate,dengebenjinMonthPay);
    [self loadData];
    [self adjustSize];
}

-(void)adjustSize
{
    if ( payment== 0) {
        _computationView.paymentH.constant = 0.0f;
        _computationView.paymentNameH.constant = 0.0f;
        _computationView.paymentUnitH.constant = 0.0f;
        _computationView.paymenyImageH.constant = 0.0f;
        _computationView.lineLabelH.constant = 0.0f;
        
        _interestView.paymentH.constant = 0.0f;
        _interestView.paymentNameH.constant = 0.0f;
        _interestView.paymentUnitH.constant = 0.0f;
        _interestView.paymenyImageH.constant = 0.0f;
        _interestView.lineLabelH.constant = 0.0f;
    }
}

- (void)setupLabel:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *numLabel = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [numLabel.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        if (numLabel == _computationView.rateLabel ||numLabel == _computationView.sumLabel||numLabel==_interestView.rateLabel || numLabel == _interestView.sumLabel) {
            numLabel.text = [NSString stringWithFormat:@"%.2f", value];
        }else if (numLabel == _computationView.paymentLabel||numLabel == _computationView.loanLabel||numLabel == _computationView.yuegongLabel||numLabel==_interestView.paymentLabel||numLabel==_interestView.loanLabel||numLabel ==_interestView.yuegongLabel){
            numLabel.text = [NSString stringWithFormat:@"%.0f",value];
        }
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        numLabel.text = [NSString stringWithFormat:@"%.1f", resValue];
    }
    flag++;
}


-(void)loadData
{
    if (self.paymentMoney == 0) {
        payment = [_totalMoney floatValue]*0.3;
    }else{
        payment = self.paymentMoney;
    }
    [self setNumberTextOfLabel:_computationView.paymentLabel WithAnimationForValueContent:payment];
    [self setNumberTextOfLabel:_computationView.loanLabel WithAnimationForValueContent:businessLoan+fundLoan];
    [self setNumberTextOfLabel:_computationView.rateLabel WithAnimationForValueContent:dengebenxiSumRate];
    [self setNumberTextOfLabel:_computationView.sumLabel WithAnimationForValueContent:businessLoan+fundLoan+dengebenxiSumRate];
    [self setNumberTextOfLabel:_computationView.yuegongLabel WithAnimationForValueContent:dengebenxiMonthPay*10000];
    _interestView.yuegongNameLabel.text = @"首月月供";
}

- (void)setNumberTextOfLabel:(UILabel *)numLabel WithAnimationForValueContent:(CGFloat)value
{
    CGFloat lastValue = 0.0;
    CGFloat delta = value - lastValue;
    if (delta == 0) return;
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : numLabel,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        if (numLabel == _computationView.paymentLabel) {
            _paymentTimer = timer;
        }
    }
}


#pragma mark ButtonActions

-(void)chooseBtnClick:(UIButton*)btn
{
    for (int i=0 ; i< 2; i ++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:1000 + i];
        button.selected = NO;
    }
    btn.selected = YES;
    long int tag = btn.tag - 1000;
    [UIView animateWithDuration:0.2 animations:^{
        _chooseBtn.rollLabel.frame = CGRectMake(btn.frame.origin.x,48, kDeviceWidth/2, 2);
        _computationScr.contentOffset = CGPointMake(kDeviceWidth*tag, 0);
    }];
    [self setNumberTextOfLabel:_interestView.paymentLabel WithAnimationForValueContent:payment];
    [self setNumberTextOfLabel:_interestView.loanLabel WithAnimationForValueContent:businessLoan+fundLoan];
    [self setNumberTextOfLabel:_interestView.rateLabel WithAnimationForValueContent:dengebenjinSumRate];
    [self setNumberTextOfLabel:_interestView.sumLabel WithAnimationForValueContent:businessLoan+fundLoan+dengebenjinSumRate];
    [self setNumberTextOfLabel:_interestView.yuegongLabel WithAnimationForValueContent:[_benjinDetailArr[0] floatValue]];
}

-(void)shareClick:(UIButton*)btn
{
    [MobClick event:@"loan_calculate_share"];
    ShareModel *shareModel = [ShareModel new];
    shareModel.shareTitle = @"汇客通";
    if (shateBtnIndex == 0) {
        shareModel.shareContent = [NSString stringWithFormat:@"总房款%@万元，首付%.0f万元，贷款%.0f万，分期%.0f年，月供%.0f元",self.totalMoney,[self.totalMoney floatValue]-businessLoan,businessLoan+fundLoan,_row/12,[_benxiDetailArr[0] floatValue]];
    }else if (shateBtnIndex == 1){
        shareModel.shareContent = [NSString stringWithFormat:@"总房款%@万元，首付%.0f万元，贷款%.0f万，分期%.0f年，尾月供%@元",self.totalMoney,[self.totalMoney floatValue]-businessLoan,businessLoan+fundLoan,_row,
                                   [_benjinDetailArr lastObject] ];
    }
    shareModel.shareImageURL =nil;
    
    shareModel.shareImage =[GlobalFunction imageWithView:self.view];
    shareModel.shareWebURL = @"";
    
    ShareTemplate  *shareTemplate = [ShareTemplate new];
    [shareTemplate actionWithShare:self WithSinaModel:shareModel andMessageTypeIsImage:YES];
}

-(void)tapAction:(UITapGestureRecognizer*)tap
{
    MonthPaymentDetailViewController* detail = [[MonthPaymentDetailViewController alloc]initWithSumMoney:businessLoan+fundLoan+dengebenxiSumRate month:_row loanMoney:businessLoan+fundLoan monthPay:dengebenxiMonthPay*10000 sumRate:dengebenxiSumRate detailArr:_benxiDetailArr];
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)tapAction1:(UIGestureRecognizer*)tap
{
    MonthPaymentDetailViewController* detail = [[MonthPaymentDetailViewController alloc]initWithSumMoney:businessLoan+fundLoan+dengebenjinSumRate month:_row loanMoney:businessLoan+fundLoan monthPay:dengebenjinMonthPay*10000 sumRate:dengebenjinSumRate detailArr:_benjinDetailArr];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/kDeviceWidth;
    shateBtnIndex = page;
    [UIView animateWithDuration:0.2 animations:^{
        _chooseBtn.rollLabel.frame = CGRectMake(kDeviceWidth/2*page, 48, kDeviceWidth/2, 2);
        [self chooseBtnClick:(UIButton*)[self.view viewWithTag:1000 + page]];
    }];
}

#pragma mark - XYPieChartDataSource

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return _dataArr.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[_dataArr objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [_colors objectAtIndex:(index % _colors.count)];
}

#pragma mark Setter getter

-(UIScrollView*)computationScr
{
    if (!_computationScr) {
        _computationScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,51, kDeviceWidth, KDeviceHeight -51)];
        _computationScr.contentSize = CGSizeMake(kDeviceWidth*2,0);
        _computationScr.showsHorizontalScrollIndicator = NO;
        _computationScr.showsVerticalScrollIndicator = NO;
        _computationScr.pagingEnabled = YES;
        _computationScr.bounces = NO;
        _computationScr.delegate = self;
    }
    return _computationScr;
}

-(UIScrollView*)principalScrollView
{
    if (!_principalScrollView) {
        _principalScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-51)];
        _principalScrollView.contentSize = CGSizeMake(0, 600);
        _principalScrollView.showsVerticalScrollIndicator = NO;
    }
    return _principalScrollView;
}

-(UIScrollView*)interestScrollView
{
    if (!_interestScrollView) {
        _interestScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, KDeviceHeight-51)];
        _interestScrollView.contentSize = CGSizeMake(0, 600);
        _interestScrollView.showsVerticalScrollIndicator = NO;
    }
    return _interestScrollView;
}

-(ChooseMenuBtn*)chooseBtn
{
    if (!_chooseBtn) {
        NSArray* btnNames = @[@"等额本息",@"等额本金"];
        _chooseBtn = [[ChooseMenuBtn alloc]initWithFrame:CGRectMake(0, 0, KDeviceHeight, 40)andNameArr:btnNames andTarget:self andAction:@selector(chooseBtnClick:)];
    }
    return _chooseBtn;
}

-(UIButton*)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [_shareBtn setImage:[UIImage imageNamed:@"nav_btn_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

-(UILabel*)percentageLabel
{
    if (!_percentageLabel) {
        _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,  50, 100, 100)];
        _percentageLabel.backgroundColor = [UIColor whiteColor];
        _percentageLabel.layer.cornerRadius = 50;
        _percentageLabel.clipsToBounds =TRUE;
        NSString* moneyStr = [NSString stringWithFormat:@"%.0f",dengebenxiMonthPay*10000];
        NSMutableAttributedString* num = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"月供%@",moneyStr]];
        [num addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:198/255.0 green:35/255.0 blue:82/255.0 alpha:1] range:NSMakeRange(2, moneyStr.length)];
        _percentageLabel.attributedText = num;
        _percentageLabel.font = [UIFont systemFontOfSize:15];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _percentageLabel;
}

-(UILabel*)interPercentLabel
{
    if (!_interPercentLabel) {
        _interPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,  50, 100, 100)];
        _interPercentLabel.backgroundColor = [UIColor whiteColor];
        _interPercentLabel.layer.cornerRadius = 50;
        _interPercentLabel.clipsToBounds =TRUE;
        _interPercentLabel.numberOfLines = 0;
        _interPercentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        NSString* moneyStr = [NSString stringWithFormat:@"%.0f",[_benjinDetailArr[0] floatValue]];
        NSMutableAttributedString* num = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"首月月供%@",moneyStr]];
        [num addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:198/255.0 green:35/255.0 blue:82/255.0 alpha:1] range:NSMakeRange(4, moneyStr.length)];
        _interPercentLabel.attributedText = num;
        _interPercentLabel.font = [UIFont systemFontOfSize:15];
        _interPercentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _interPercentLabel;
}

-(XYPieChart*)principalPie
{
    if (!_principalPie) {
        _principalPie = [[XYPieChart alloc]initWithFrame:CGRectMake(kDeviceWidth/2-100, 15, 200, 200)];
        [self changeObjects];
        [_dataArr addObject: [NSNumber numberWithInt:(int)dengebenxiSumRate]];
        [_principalPie setDataSource:self];
        [_principalPie setStartPieAngle:M_PI_2];
        [_principalPie setAnimationSpeed:1.5];
        [_principalPie reloadData];
    }
    return _principalPie;
}

-(XYPieChart*)interestPie
{
    if (!_interestPie) {
        _interestPie = [[XYPieChart alloc]initWithFrame:CGRectMake(kDeviceWidth/2-100, 15, 200, 200)];
        [self changeObjects];
        [_dataArr addObject: [NSNumber numberWithInt:(int)dengebenjinSumRate]];
        [_interestPie setDataSource:self];
        [_interestPie setStartPieAngle:M_PI_2];
        [_interestPie setAnimationSpeed:1.0];
        [_interestPie reloadData];
    }
    return _interestPie;
}

-(ComputationView*)computationView
{
    if (!_computationView) {
        _computationView = [[[NSBundle mainBundle] loadNibNamed:@"ComputationView" owner:self options:nil]lastObject];
        _computationView.frame = CGRectMake(0,0, kDeviceWidth, 500);
        [_computationView.detailLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
    }
    return _computationView;
}

-(ComputationView*)interestView
{
    if (!_interestView) {
        _interestView= [[[NSBundle mainBundle] loadNibNamed:@"ComputationView" owner:self options:nil]lastObject];
        _interestView.frame = CGRectMake(0,0, kDeviceWidth, 500);
        [_interestView.detailLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1:)]];
    }
    return _interestView;
}

-(void)changeObjects
{
    [_dataArr removeAllObjects];
    if (self.paymentMoney == 0) {
        payment = [_totalMoney floatValue]*0.3;
    }else{
        payment = self.paymentMoney;
    }
    [_dataArr addObject: [NSNumber numberWithInt:payment]];
    [_dataArr addObject: [NSNumber numberWithInt:businessLoan+fundLoan]];
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
