//
//  MonthPaymentDetailViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "MonthPaymentDetailViewController.h"
#import "WYYControl.h"
#import "MonthPayDetailTableViewCell.h"

#define imageName @"imageName"
#define valueKey @"title"
@interface MonthPaymentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tableView;
    NSMutableArray* _dataSource;
    
    NSTimer* _sumRateTimer;
    NSArray* _titleArray;
}

@property(strong,nonatomic)UIView* tableViewHeaderView;
@end

@implementation MonthPaymentDetailViewController

-(id)initWithSumMoney:(float)sumMoney month:(float)months loanMoney:(float)loanMoney monthPay:(float)monthPay sumRate:(float)sumRate detailArr:(NSArray *)detailArr
{
    self = [super init];
    if (self) {
        _sumMoney = sumMoney;
        _months = months;
        _loanMoney = loanMoney;
        _monthPay = monthPay;
        _sumRate = sumRate;
        _detailArr = detailArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutSubViews];
    [self createMiddleView];
    [self loadData];
    [self setNavgationBarButttonAndLabelTitle:@"计算结果"];
}

-(void)layoutSubViews
{
    _titleArray = @[_sumMoneyLabel,_monthsLabel,_loanSumMoneyLabel,_monthLoanLabel,_sumRateLabel];
    for (UILabel* titleLabel in _titleArray) {
        titleLabel.textColor = [UIColor colorWithHex:0x58b6ee];
    }
    _lineView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
}

-(void)loadData
{
    [self setNumberTextOfLabel:_sumMoneyLabel WithAnimationForValueContent:self.sumMoney];
    [self setNumberTextOfLabel:_monthsLabel WithAnimationForValueContent:self.months];
    [self setNumberTextOfLabel:_loanSumMoneyLabel WithAnimationForValueContent:self.loanMoney];
    [self setNumberTextOfLabel:_monthLoanLabel WithAnimationForValueContent:self.monthPay];
    [self setNumberTextOfLabel:_sumRateLabel WithAnimationForValueContent:self.sumRate];
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
        _sumRateTimer = timer;
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
        if (numLabel == _monthsLabel||numLabel ==_loanSumMoneyLabel||numLabel == _monthLoanLabel) {
            numLabel.text = [NSString stringWithFormat:@"%.0f",value];
        }else{
            numLabel.text = [NSString stringWithFormat:@"%.2f", value];
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

-(void)createMiddleView
{
    NSArray* titleArr = @[@"月份",@"月供",@"本金",@"利息",@"剩余贷款"];
    for (int i=0; i < 5; i ++) {
        UILabel* titleLabel = [WYYControl createLabelWithFrame:CGRectMake(kDeviceWidth/5*i, 175, kDeviceWidth/5-1, 30) Font:16 Text:titleArr[i] textColor:[UIColor darkGrayColor]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLabel];
        
        UILabel* lineLabel = [WYYControl createLabelWithFrame:CGRectMake(kDeviceWidth/5*i, 180, 1, 20) Font:15 Text:nil textColor:nil];
        lineLabel.backgroundColor = [UIColor colorWithHex:0xe6e6e6];
        [self.view addSubview:lineLabel];
    }
    UILabel* footLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 205, kDeviceWidth, 1)];
    footLineLabel.backgroundColor = [UIColor colorWithHex:0xe6e6e6];
    [self.view addSubview:footLineLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 206, kDeviceWidth, KDeviceHeight-275) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.tableViewHeaderView;
    [_tableView registerClass:[MonthPayDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailArr.count/12;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    MonthPayDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MonthPayDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.monthLabel.text = [NSString stringWithFormat:@"%ld月",indexPath.row+1];
    cell.monthPayLabel.text = [NSString stringWithFormat:@"%@元",[self.detailArr objectAtIndex:indexPath.section*12+indexPath.row]];
    cell.principal.text = [NSString stringWithFormat:@"%.0f元",(self.loanMoney/self.months)*10000];
    cell.rateLabel.text = [NSString stringWithFormat:@"%.0f元", [cell.monthPayLabel.text floatValue]-[cell.principal.text floatValue]];
    
//    float num = 0.0;
//    for (int i=0; i < indexPath.section*12+indexPath.row; i ++) {
////        num =[[self.detailArr objectAtIndex:indexPath.section*12+indexPath.row] floatValue];
//        num = [self.detailArr[i] floatValue];
//        num += num;
////        num = num + nu
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.restMoneyLabel.text = [NSString stringWithFormat:@"%.0f元",self.sumMoney*10000 - self.monthPay*(indexPath.section*12+indexPath.row)];
    
    return cell;
}
#pragma  mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 24)];
    _tableViewHeaderView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    UILabel* titleLabel = [WYYControl createLabelWithFrame:CGRectMake(15, 2, 120, 20) Font:16 Text:[NSString stringWithFormat:@"第%ld年",section+1] textColor:[UIColor darkGrayColor]];
    [_tableViewHeaderView addSubview:titleLabel];
    return self.tableViewHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
