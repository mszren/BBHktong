//
//  CalculatorViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/2.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "CalculatorViewController.h"
#import "HTTPRequest+Calculator.h"
#import "AFNetworkReachabilityManager.h"
#import "Popover.h"
#import "ChooseMenuBtn.h"

#import "BusinessLoanView.h"
#import "ProvidentFundLoanView.h"
#import "CombinationLoanView.h"
#import "NewHouseView.h"
#import "SecondHandHouseView.h"

#import "WYYControl.h"
#import "DownPaymentScaleViewController.h"
#import "RateViewController.h"
#import "CalculatorDetailViewController.h"
#import "ComputationViewController.h"
#import "TimeChooseViewController.h"
#import "UIActionSheet+Blocks.h"
#import "CalculatorDataModel.h"

#import "NewHouseResultViewController.h"
#import "ResoldHouseResultViewController.h"
#import "peopleViewController.h"
//#import "ResoldHouseResultModel.h"

@interface CalculatorViewController ()<UIScrollViewDelegate,BusinessViewDelegate,UITextFieldDelegate,DownPaymentDelegate,TimeChooseDelegate,ProvidentFundLoanDelegate,CombinViewDelegate,RateChooseDelegate,UIViewControllerPreviewingDelegate>
{
    ChooseMenuBtn* _chooseBtn;

    NSString* _downPayment; // 首付金额
    NSString* _fundPayment; // 公积金首付
    NSString* _totalMoney;// 房屋总价
    
    float _businessScaleIndex;// 比例
    float _fundScaleIndex;
    
    NSInteger _businessTimeIndex; //按揭年数
    NSInteger _funTimeIndex;
    NSInteger _comBusineeTimeIndex;
    NSInteger _comFundTimeIndex;
    
    NSInteger _rateIndex;// 利率
    
    NSInteger _newHouseActionIndex;
    NSInteger _resoldHouseActionIndex;
    NSInteger _resoldHouseTermIndex;
}

@property(strong,nonatomic)UIScrollView* scrollView;
@property(strong,nonatomic)UIButton* backButton;
@property(strong,nonatomic)BusinessLoanView* businessView;
@property(strong,nonatomic)ProvidentFundLoanView* fundLoanView;
@property(strong,nonatomic)CombinationLoanView* combLoanView;

@property(strong,nonatomic)NewHouseView* newhouseView;
@property(strong,nonatomic)SecondHandHouseView* secondView;

@property(strong,nonatomic)UIView* taxesView;
@property(strong,nonatomic)ChooseMenuBtn* chooseBtn;

@property(strong,nonatomic)NSMutableArray* businessRateArr;
@property(strong,nonatomic)NSMutableArray* fundRateArr;

@property(strong,nonatomic)NSMutableArray* dataSource;
@property(strong,nonatomic)NSArray* houseTypeArray;
@property(strong,nonatomic)NSArray* typeArray;


@end

@implementation CalculatorViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint) point
//{
//    if ([self.presentedViewController isKindOfClass:[CalculatorViewController class]]) {
//        return nil;
//    }
//    CalculatorViewController *sec = [[CalculatorViewController alloc] init];
//    return sec;
//}
//
//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
//    
//    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"click");
//    }];
//    // add them to an arrary
//    //想要显示多个就定义多个 UIPreviewAction
//    NSArray *actions = @[action1];
//    // and return them (return the array of actions instead to see all items ungrouped)
//    return actions;
//}
//- (void)previewContext:(id<UIViewControllerPreviewing>)context commitViewController:(UIViewController*)vc
//{
//    [self showViewController:vc sender:self];
//}

//-(void)check3DTouch
//{
//    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
//    {
//        [self registerForPreviewingWithDelegate:self sourceView:self.view];
//         NSLog(@"3D Touch  可用!");
//    }
//    else
//    {
//        NSLog(@"3D Touch 无效");
//    }
//}

- (void)viewDidLoad {
    
//    [self check3DTouch];
    [super viewDidLoad];
    [self initArrays];
    [self  requestCalculatorData];
    [self createMainView];
    [self setNavgationBarButttonAndLabelTitle:@"房贷计算器"];
}

-(void)initArrays
{
    _dataSource = [[NSMutableArray alloc]init];
    _businessRateArr = [[NSMutableArray alloc]init];
    _fundRateArr = [[NSMutableArray alloc]init];
    _businessRateArr = [[NSMutableArray alloc]init];
    _fundRateArr = [[NSMutableArray alloc]init];
    _houseTypeArray= @[@"普通住宅",@"非普通住宅",@"经济适用房"];
    _typeArray = @[@"普通住宅",@"非普通住宅"];
}

-(void)createMainView
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.businessView];
    [self.scrollView addSubview:self.fundLoanView];
    
    UIScrollView* combScr = [[UIScrollView alloc]initWithFrame:CGRectMake(kDeviceWidth*2, 0, kDeviceWidth, KDeviceHeight-51)];
    combScr.contentSize = CGSizeMake(0,600);

    combScr.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:combScr];
    [combScr addSubview:self.combLoanView];
    
    UIScrollView* taxScro = [[UIScrollView alloc]initWithFrame:CGRectMake(kDeviceWidth*3, 0, kDeviceWidth, KDeviceHeight-51)];
    taxScro.contentSize = CGSizeMake(0, 700);

    taxScro.showsVerticalScrollIndicator = NO;
    [_scrollView addSubview:taxScro];
    [taxScro addSubview:self.taxesView];
    
    [self.view addSubview:self.chooseBtn];
}

-(void)requestCalculatorData
{
    [HTTPRequest requestWithCalculator:^(BOOL ok, NSString *message, NSDictionary *data) {
        if (ok) {
            NSArray* businessArr = data[@"business"];
            for (NSDictionary* businessDic in businessArr) {
                CalculatorDataModel* model = [CalculatorDataModel new];
                [model setValuesForKeysWithDictionary:businessDic];
                [_businessRateArr addObject:model];
            }
            NSArray* fundArr = data[@"public"];
            for (NSDictionary* publicDic in fundArr) {
                CalculatorDataModel* model = [CalculatorDataModel new];
                [model setValuesForKeysWithDictionary:publicDic];
                [_fundRateArr addObject:model];
            }
        }else{
            NSLog(@" 获取利率信息失败");
        }
    }];
}

#pragma mark  Button Actions

-(void)chooseBtnClick:(UIButton*)btn
{
    for (int i=0 ; i< 4; i ++) {
        UIButton* button = (UIButton*)[self.view viewWithTag:1000 + i];
        button.selected = NO;
    }
    btn.selected = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    long tag = btn.tag - 1000;
    _chooseBtn.rollLabel.frame = CGRectMake(btn.frame.origin.x,48, kDeviceWidth/4, 2);
    _scrollView.contentOffset = CGPointMake(kDeviceWidth*tag, 0);
    [UIView commitAnimations];
}


-(void)segmentClick:(id)sender{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            [_secondView removeFromSuperview];
            [_taxesView addSubview:_newhouseView];
        }
            break;
        case 1:
        {
            [_newhouseView removeFromSuperview];
            [_taxesView addSubview:_secondView];
            break;
        }
            
        default:
            break;
    }
}

// 首付比例
-(void)paymentScaleAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    float scaleIndex = 0;
    if (btn.tag == 8000) {
        if (_businessScaleIndex == 0) {
            scaleIndex = 3;
        }else{
            NSString* index = [NSString stringWithFormat:@"%.0f",_businessScaleIndex*10];
            if ([index integerValue]%10 != 0) {
                scaleIndex = 10;
            }else{
                scaleIndex = _businessScaleIndex;
            }
        }
        DownPaymentScaleViewController * payment = [[DownPaymentScaleViewController alloc]initWithPaymentMoney:_downPayment totalMoeny:_businessView.totalPriceField.text scale:scaleIndex btnTag:8000];
        payment.delegate = self;
        [self.navigationController pushViewController:payment animated:YES];
    }else if (btn.tag == 8001){
        if (_fundScaleIndex == 0) {
             scaleIndex = 3;
        }else{
            NSString* index = [NSString stringWithFormat:@"%.0f",_fundScaleIndex*10];
            if ([index integerValue]%10 != 0) {
                scaleIndex = 10;
            }else{
                scaleIndex = _fundScaleIndex;
            }
        }
        DownPaymentScaleViewController * payment = [[DownPaymentScaleViewController alloc]initWithPaymentMoney:_downPayment totalMoeny:_fundLoanView.totalPriceField.text scale:scaleIndex btnTag:8001];
        payment.delegate = self;
        [self.navigationController pushViewController:payment animated:YES];
    }
}

// 按揭年数
-(void)mortGageYearsAction:(id)sender
{
    UIButton* yearBtn = (UIButton*)sender;
     TimeChooseViewController* time = [[TimeChooseViewController alloc]init];
    time.delegate = self;
    if (yearBtn.tag == 7000) {
        time.btnTag = 7000;
        if (_businessTimeIndex == 0) {
            time.index = 20;
        }else{
            time.index = _businessTimeIndex;
        }
        [self.navigationController pushViewController:time animated:YES];
    }else if (yearBtn.tag == 7001){
        time.btnTag = 7001;
        if (_funTimeIndex == 0) {
            time.index = 20;
        }else{
            time.index = _funTimeIndex;
        }
        time.btnTag = 7001;
        [self.navigationController pushViewController:time animated:YES];
    }else if (yearBtn.tag == 7002){
        time.btnTag = 7002;

        if (_comBusineeTimeIndex == 0) {
            time.index = 20;
        }else{
            time.index = _comBusineeTimeIndex;
        }
        [self.navigationController pushViewController:time animated:YES];
    }else if (yearBtn.tag == 7003){
        time.btnTag = 7003;
        if (_comFundTimeIndex == 0) {
            time.index = 20;
        }else{
            time.index = _comFundTimeIndex;
        }
        [self.navigationController pushViewController:time animated:YES];
    }
}

// 利率
-(void)rateAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (btn.tag == 3000) {
        RateViewController* rate = [[RateViewController alloc]initWithRateArray:_businessRateArr rateIndex:_rateIndex btnTag:3000];
        rate.delegate = self;
        [self.navigationController pushViewController:rate animated:YES];
    }else if (btn.tag == 3001){
        
        RateViewController* rate = [[RateViewController alloc]initWithRateArray:_fundRateArr rateIndex:_rateIndex btnTag:3001];
        rate.delegate = self;
        [self.navigationController pushViewController:rate animated:YES];
    }else if (btn.tag == 3002){
        
        RateViewController* rate = [[RateViewController alloc]initWithRateArray:_businessRateArr rateIndex:_rateIndex btnTag:3002];
        rate.delegate = self;
        [self.navigationController pushViewController:rate animated:YES];
    }else if (btn.tag == 3003){
        RateViewController* rate = [[RateViewController alloc]initWithRateArray:_fundRateArr rateIndex:_rateIndex btnTag:3003];
        rate.delegate = self;
        [self.navigationController pushViewController:rate animated:YES];
    }
}

// 贷款计算方式
-(void)loanExplainAction
{
    CalculatorDetailViewController* detail = [CalculatorDetailViewController new];
    [self.navigationController pushViewController:detail animated:YES];
}

//  计算
-(void)submitAction:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    switch (btn.tag) {
        case 2000:
        {
            if (!_businessView.totalPriceField.text.length > 0 || !_businessView.loanPriceField.text.length > 0) {
                [self showAlertView];
            }else if ([_businessView.loanPriceField.text floatValue] > [_businessView.totalPriceField.text floatValue]){
                [self makeToast:@"不合法的贷款金额"];
            }else{
                if (_businessTimeIndex == 0) {
                    _businessTimeIndex= 20;
                }
                ComputationViewController* result = [[ComputationViewController alloc]initWithTotalMoney:_businessView.totalPriceField.text loanMoney:_businessView.loanPriceField.text rate: _businessView.rateField.text paymentMoney:[_businessView.totalPriceField.text floatValue]*_businessScaleIndex*0.1 years:_businessTimeIndex];
                [self.navigationController pushViewController:result animated:YES];

            }
        
        }
            break;
        case 2001:
        {
            if (!_fundLoanView.totalPriceField.text.length > 0 || !_fundLoanView.loanPriceField.text.length > 0) {
                [self showAlertView];
            }else if ([_fundLoanView.loanPriceField.text floatValue] > [_fundLoanView.totalPriceField.text floatValue]){
                [self makeToast:@"不合法的贷款金额"];
            } else{
                if (_funTimeIndex == 0) {
                    _funTimeIndex= 20;
                }
                ComputationViewController* result = [[ComputationViewController alloc]initWithTotalMoney:_fundLoanView.totalPriceField.text loanMoney:_fundLoanView.loanPriceField.text rate: _fundLoanView.rateField.text paymentMoney:[_fundLoanView.totalPriceField.text floatValue]*_fundScaleIndex*0.1 years:_funTimeIndex];
                [self.navigationController pushViewController:result animated:YES];
            }
            break;
        }
        case 2002:
        {
            if (!_combLoanView.businessField.text.length > 0 || !_combLoanView.fundField.text.length > 0) {
            
                [self showAlertView];
            }else{
                ComputationViewController* computation = [[ComputationViewController alloc]init];
                computation.businessLoanMoney = _combLoanView.businessField.text;
                computation.fundLoanMoney = _combLoanView.fundField.text;
                
                computation.businessRate = _combLoanView.businessRateField.text;
                computation.fundRate = _combLoanView.fundRateField.text;
                if (_comBusineeTimeIndex == 0) {
                    _comBusineeTimeIndex = 20;
                }
                computation.businessYears = _comBusineeTimeIndex;
                
                if (_comFundTimeIndex == 0) {
                    _comFundTimeIndex = 20;
                }
                computation.fundYears = _comFundTimeIndex;
                [self.navigationController pushViewController:computation animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

-(void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写完整贷款金额" delegate:nil cancelButtonTitle:@"好的，我知道了" otherButtonTitles: nil];
    [alert show];
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/kDeviceWidth;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    _chooseBtn.rollLabel.frame = CGRectMake(kDeviceWidth/3*page, 48, kDeviceWidth/3, 2);
    [self chooseBtnClick:(UIButton*)[self.view viewWithTag:1000 + page]];
    [UIView commitAnimations];
}


#pragma mark DownPaymentDelegate

-(void)downScale:(NSInteger)scale btnTag:(NSInteger)tag
{
    if (tag == 8000) {
    _downPayment = [NSString stringWithFormat:@"%.0f",[_businessView.totalPriceField.text floatValue]*scale*0.1];
    _businessView.paymentScaleLabel.text = [NSString stringWithFormat:@"%ld成(%@万元)",(long)scale,_downPayment];
    _businessView.loanPriceField.text = [NSString stringWithFormat:@"%.0f",[_businessView.totalPriceField.text floatValue]-[_downPayment floatValue]];
    _businessScaleIndex = scale;

    }else if (tag == 8001){
    _fundPayment = [NSString stringWithFormat:@"%.0f",[_fundLoanView.totalPriceField.text floatValue]*scale*0.1];
    _fundLoanView.paymentScaleLabel.text = [NSString stringWithFormat:@"%ld成(%@万元)",(long)scale,_fundPayment];
    _fundLoanView.loanPriceField.text  = [NSString stringWithFormat:@"%.0f",[_fundLoanView.totalPriceField.text floatValue]-[_fundPayment floatValue]];
    _fundScaleIndex = scale;
    }
}

// 时间比例选择 界面返回
-(void)transmitTimeIndex:(NSInteger)index btnTag:(NSInteger)btnTag
{
    NSString* timeStr = [NSString stringWithFormat:@"%ld年(%ld期)",(long)index,12*index];
    if (btnTag == 7000) {
        _businessView.yearsLabel.text = timeStr;
        _businessTimeIndex = index;
    }else if (btnTag == 7001){
        _fundLoanView.yearsLabel.text = timeStr;
        _funTimeIndex = index;
    }else if (btnTag == 7002){
        _combLoanView.businessYearLabel.text = timeStr;
        _comBusineeTimeIndex = index;
    }else if (btnTag == 7003){
        _combLoanView.fundYearLabel.text = timeStr;
        _comFundTimeIndex = index;
    }
}

// 首付比例，返回贷款金额
-(void)downPaymentMoney:(NSString *)paymentMoney btnTag:(NSInteger)tag
{
    if (tag == 8000 ) {
        if (_businessView.totalPriceField.text.length <=0) {
            _businessView.paymentScaleLabel.text = [NSString stringWithFormat:@"%@万元",paymentMoney];
        }else{
            _businessView.loanPriceField.text = [NSString stringWithFormat:@"%.0f",[_businessView.totalPriceField.text floatValue]-[paymentMoney floatValue]];
            _businessView.paymentScaleLabel.text = [NSString stringWithFormat:@"%.1f成(%@万元)",[paymentMoney floatValue]/[_businessView.totalPriceField.text floatValue]*10 ,paymentMoney];
            _businessScaleIndex = [paymentMoney floatValue]/[_businessView.totalPriceField.text floatValue]*10;
        }
    }else if (tag == 8001){
        _fundLoanView.paymentScaleLabel.text = [NSString stringWithFormat:@"%.1f成(%@万元)",[paymentMoney floatValue]/[_fundLoanView.totalPriceField.text floatValue]*10 ,paymentMoney];
        _fundLoanView.loanPriceField.text = [NSString stringWithFormat:@"%.0f",[_fundLoanView.totalPriceField.text floatValue]-[paymentMoney floatValue]];
        _fundScaleIndex = [paymentMoney floatValue]/[_fundLoanView.totalPriceField.text floatValue]*10;
    }
}


-(void)rateArray:(NSArray *)rateArray rateIndex:(NSInteger)index btnTag:(NSInteger)btnTag
{
    _rateIndex = index;
    CalculatorDataModel* model = rateArray[index];
    switch (btnTag) {
        case 3000:
        {
            _businessView.rateNameLabel.text = model.rateStr;
            _businessView.rateField.text = [NSString stringWithFormat:@"%@",model.rate];
            break;
        }
        case 3001:
        {
            _fundLoanView.rateNameLabel.text = model.rateStr;
            _fundLoanView.rateField.text = [NSString stringWithFormat:@"%@",model.rate];
            break;
        }
        case 3002:
        {
            _combLoanView.rateNameLabel.text = model.rateStr;
            _combLoanView.businessRateField.text = [NSString stringWithFormat:@"%@",model.rate];
            break;
        }
        case 3003:
        {
            _combLoanView.fundRateNameLabel.text = model.rateStr;
            _combLoanView.fundRateField.text = [NSString stringWithFormat:@"%@",model.rate];
            break;
        }
        default:
            break;
    };
}

#pragma  mark TextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 5)
        return NO;
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:_businessView.totalPriceField]) {
        if (_businessScaleIndex == 0) {
            _businessScaleIndex = 3;
        }
        _businessView.paymentScaleLabel.text =  [NSString stringWithFormat:@"%ld成(%.1f万元)",(long)_businessScaleIndex,[temp floatValue]*_businessScaleIndex*0.1];
        _businessView.loanPriceField.text = [NSString stringWithFormat:@"%.1f",[temp floatValue]*(1 - _businessScaleIndex*0.1)];
        
    }else if ([textField isEqual:_fundLoanView.totalPriceField]){
        if (_fundScaleIndex == 0) {
            _fundScaleIndex = 3;
        }
        _fundLoanView.paymentScaleLabel.text =  [NSString stringWithFormat:@"%ld成(%.1f万元)",(long)_fundScaleIndex,[temp floatValue]*_fundScaleIndex*0.1];
        _fundLoanView.loanPriceField.text = [NSString stringWithFormat:@"%.1f",[temp floatValue]*(1 - _fundScaleIndex*0.1)];
    }else if ([textField isEqual:_businessView.loanPriceField]){
        if (_businessScaleIndex == 0) {
            _businessScaleIndex = 3;
        }
        // add or delete * 10  比例乘10
        _businessView.paymentScaleLabel.text = [NSString stringWithFormat:@"%.1f成(%.0f万元)",[temp floatValue]/[_businessView.totalPriceField.text floatValue]*10,[_businessView.totalPriceField.text floatValue]-[temp floatValue]];
        if ([temp floatValue] > [_businessView.totalPriceField.text floatValue]) {
            [self makeToast:@"不合法的贷款金额"];
        }
    }else if ([textField isEqual:_fundLoanView.loanPriceField]){
        if (_fundScaleIndex == 0) {
            _fundScaleIndex = 3;
        }
        _fundLoanView.paymentScaleLabel.text = [NSString stringWithFormat:@"%.1f成(%.0f万元)",[temp floatValue]/[_fundLoanView.totalPriceField.text floatValue]*10,[_fundLoanView.totalPriceField.text floatValue]-[temp floatValue]];
        if ([temp floatValue] > [_fundLoanView.totalPriceField.text floatValue]) {
            [self makeToast:@"不合法的贷款金额"];
        }
    }
    return YES;
}


#pragma mark 税费计算

-(void)houseTypeClick:(UIButton*)houseTypeBtn
{
    switch (houseTypeBtn.tag) {
        case 6000:
        {
            [_newhouseView.priceField resignFirstResponder];
            [_newhouseView.sizeField resignFirstResponder];
            [UIActionSheet showInView:self.view withTitle:@"房屋类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_typeArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                _newHouseActionIndex = buttonIndex;
                // add  crash
                if (buttonIndex == actionSheet.cancelButtonIndex) {
                    return ;
                }
                _newhouseView.houseNameLabel.text = _typeArray[_newHouseActionIndex];
            }];
            break;
        }
        case 6001:
        {
            [_secondView.priceField resignFirstResponder];
            [_secondView.sizeField resignFirstResponder];
            [UIActionSheet showInView:self.view withTitle:@"房屋类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_houseTypeArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                _resoldHouseActionIndex = buttonIndex;
                if (buttonIndex == actionSheet.cancelButtonIndex) {
                    return ;
                }
                _secondView.houseNameLabel.text = _houseTypeArray[_resoldHouseActionIndex];
                if (_resoldHouseActionIndex == 2) {
                    _secondView.houseTermViewHeight.constant = 0.0f;
                    _secondView.houseTermNameLabel.hidden = YES;
                    _secondView.houseTermTitleLabel.hidden = YES;
                    _secondView.headLineLabel.hidden = YES;
                }else{
                    _secondView.houseTermViewHeight.constant = 51.0f;
                    _secondView.houseTermNameLabel.hidden = NO;
                    _secondView.houseTermTitleLabel.hidden = NO;
                    _secondView.headLineLabel.hidden = NO;
                }
            }];
            break;
        }
        default:
            break;
    }
}

// 新房计算器
-(void)newHouseBtnClick
{
    if (_newhouseView.sizeField.text.length == 0) {
        [self makeToast:@"请输入房屋面积"];
    }else if (_newhouseView.priceField.text.length == 0){
        [self makeToast:@"请输入房屋单价"];
    }else{
        NewHouseResultModel * model = [NewHouseResultModel new];
        model.houseType = _newHouseActionIndex;
        model.houseArea = [_newhouseView.sizeField.text floatValue];
        
        if (_newhouseView.singleHouseBtn.selected) {
            model.isOnlyHouse = YES;
        }else{
            model.isOnlyHouse = NO;
        }
        NSLog(@"-----%lu",_newHouseActionIndex);
        model.houseUnitPrice = [_newhouseView.priceField.text floatValue];
        NewHouseResultViewController* newHouse = [[NewHouseResultViewController alloc]initWithNewHouseResultModel:model];
        [self.navigationController pushViewController:newHouse animated: YES];
    }
}

-(void)secondHouseBtnClick
{
    if (_secondView.sizeField.text.length == 0) {
        [self makeToast:@"请输入房屋面积"];
    }else if (_secondView.priceField.text.length == 0){
        [self makeToast:@"请输入房屋单价"];
    }else{
        ResoldHouseResultModel* model = [ResoldHouseResultModel new];
        
//        买家首次购买
        if (_secondView.firstBuyBtn.selected) {
            model.isFirstBuy = YES;
        }else{
            model.isFirstBuy = NO;
        }
//        卖家唯一住房
        if (_secondView.singleHouseBtn.selected ) {
            model.isSellOnlyHouse = YES;
        }else{
            model.isSellOnlyHouse = NO;
        }
        NSLog(@"打印BOOL型数据%@",model.isFirstBuy?@"YES":@"NO");
        NSLog(@"打印BOOL型数据%@",model.isSellOnlyHouse?@"YES":@"NO");
        
//        房屋类型
        model.houseType = _resoldHouseActionIndex;
        
//        房产年限
        model.time = _resoldHouseTermIndex;
        model.houseArea = [_secondView.sizeField.text floatValue];
//        房屋单价
        model.houseUnitPrice = [_secondView.priceField.text floatValue];
        
//       房屋原价
        if (_secondView.primePriceTextField.text.length > 0) {
            model.originalPrice = [_secondView.primePriceTextField.text floatValue]*10000;
        }
     
        ResoldHouseResultViewController* resoldHouse = [[ResoldHouseResultViewController alloc]initWithResoldHouseResultModel:model];
        [self.navigationController pushViewController:resoldHouse animated:YES];
    }
}

//房屋年限
-(void)secondHouseTermBtnClick
{
    NSArray* houseTimeArray = @[@"不满两年",@"两到五年",@"五年以上"];
    [_secondView.priceField resignFirstResponder];
    [_secondView.sizeField resignFirstResponder];
    [UIActionSheet showInView:self.view withTitle:@"房产年限" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:houseTimeArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        _resoldHouseTermIndex = buttonIndex;
        // add  crash
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            return ;
        }
        _secondView.houseTermNameLabel.text = houseTimeArray[_resoldHouseTermIndex];
        
    }];

}

-(UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,51, kDeviceWidth, KDeviceHeight -51)];
        _scrollView.contentSize = CGSizeMake(kDeviceWidth*4,0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(BusinessLoanView*)businessView
{
    if (!_businessView) {
        _businessView = [[[NSBundle mainBundle]loadNibNamed:@"BusinessLoanView" owner:self options:nil]lastObject];
        _businessView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-51);
        _businessView.delegate = self;
    }
    return _businessView;
}

-(ProvidentFundLoanView*)fundLoanView
{
    if (!_fundLoanView) {
        
        _fundLoanView = [[[NSBundle mainBundle] loadNibNamed:@"ProvidentFundLoanView" owner:self options:nil]lastObject];
        _fundLoanView.frame = CGRectMake(kDeviceWidth, 0, kDeviceWidth, KDeviceHeight-51);
        _fundLoanView.delegate = self;
    }
    return _fundLoanView;
}

-(CombinationLoanView*)combLoanView
{
    if (!_combLoanView) {
        _combLoanView = [[[NSBundle mainBundle] loadNibNamed:@"CombinationLoanView" owner:self options:nil]lastObject];
        _combLoanView.frame = CGRectMake(0, 0, kDeviceWidth, 600);
        _combLoanView.delegate = self;
    }
    return _combLoanView;
}

-(UIView*)taxesView
{
    if (!_taxesView) {
        _taxesView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 600)];
        _taxesView.backgroundColor = [UIColor whiteColor];
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"新房",@"二手房",nil];
        UISegmentedControl *segmentedTemp = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        segmentedTemp.frame = CGRectMake(20, 20, kDeviceWidth-40, 40);
        segmentedTemp.selectedSegmentIndex = 0;
        segmentedTemp.tintColor = [UIColor colorWithRed:92/255.0 green:183/255.0 blue:237/255.0 alpha:1];
        [segmentedTemp addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        [_taxesView addSubview:segmentedTemp];
        
        _newhouseView = [[[NSBundle mainBundle] loadNibNamed:@"NewHouseView" owner:self options:nil]lastObject];
        _newhouseView.frame = CGRectMake(0, 60, kDeviceWidth, 260);
        [_newhouseView.calculatorBtn addTarget:self action:@selector(newHouseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_newhouseView.houseChooseBtn addTarget:self action:@selector(houseTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_taxesView addSubview:_newhouseView];
        
        _secondView = [[[NSBundle mainBundle]loadNibNamed:@"SecondHandHouseView" owner:self options:nil]lastObject];
        [_secondView.calculatorBtn addTarget:self action:@selector(secondHouseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _secondView.frame = CGRectMake(0, 60, kDeviceWidth, 400);

        [_secondView.houseChooseBtn addTarget:self action:@selector(houseTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_secondView.houseTermChooseBtn addTarget:self action:@selector(secondHouseTermBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _taxesView;
}

-(ChooseMenuBtn*)chooseBtn
{
    if (!_chooseBtn) {
        NSArray* btnNames = @[@"商业贷",@"公积金贷",@"组合贷",@"税费计算"];
        _chooseBtn = [[ChooseMenuBtn alloc]initWithFrame:CGRectMake(0, 0, KDeviceHeight, 40)andNameArr:btnNames andTarget:self andAction:@selector(chooseBtnClick:)];
    }
    return _chooseBtn;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
