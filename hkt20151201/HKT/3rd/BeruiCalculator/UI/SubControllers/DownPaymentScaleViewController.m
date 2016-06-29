//
//  DownPaymentScaleViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "DownPaymentScaleViewController.h"
#import "PaymentFooterView.h"
#import "WYYControl.h"
#import "LoanScaleTableViewCell.h"

@interface DownPaymentScaleViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray* _dataSource;
    NSMutableArray* _contacts;
    NSString* _text;
    
    NSString* _payment;
    NSString* _totalMoney;
    NSInteger _index;
}

@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;
@property(strong,nonatomic)PaymentFooterView* footerView;
@end

@implementation DownPaymentScaleViewController

-(id)initWithPaymentMoney:(NSString*)paymentMoney totalMoeny:(NSString *)totalMoeny scale:(NSInteger)scale btnTag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        _payment = paymentMoney;
        _totalMoney = totalMoeny;
        _index = scale;
        _btnTag= tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataSource = @[@"一成",@"二成",@"三成",@"四成",@"五成",@"六成",@"七成",@"八成",@"九成"];
    [self setNavgationBarButttonAndLabelTitle:@"首付比例"];
}


#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"LoanScaleTableViewCell";
    LoanScaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil]lastObject];
    }
    cell.titleLabel.text = _dataSource[indexPath.row];
    
    if(indexPath.row == _index-1){
        [cell setChecked:NO];
    }else {
        [cell setChecked:YES];
    }
    return cell;
}

#pragma  mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger selectRow = indexPath.row + 1;
    
    [_delegate downScale:selectRow btnTag:_btnTag];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ButtonActions 

-(void)sureBtnClick
{
    if ([_totalMoney floatValue] > 0) {
        if (_footerView.moneyField.text.length <=0) {
            [self makeToast:@"请输入自定义首付金额"];
        }else if ([_footerView.moneyField.text floatValue] > [_totalMoney floatValue]){
            [self makeToast:@"您输入的首付金额大于房款总价"];
        }else{
            [_delegate downPaymentMoney:_footerView.moneyField.text btnTag:_btnTag];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (_footerView.moneyField.text.length <= 0) {
            [self makeToast:@"请输入自定义首付金额"];
        }else{
            [_delegate downPaymentMoney:_footerView.moneyField.text btnTag:_btnTag];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma  mark TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 5)
        return NO;
    return YES;
}

-(PaymentFooterView*)footerView
{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle]loadNibNamed:@"PaymentFooterView" owner:self options:nil]lastObject];
        _footerView.frame = CGRectMake(0, 0, kDeviceWidth, 50);
        [_footerView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



@end
