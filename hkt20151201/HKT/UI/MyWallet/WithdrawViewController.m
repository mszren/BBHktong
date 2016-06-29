//
//  WithdrawViewController.m
//  HKT
//
//  Created by Ting on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "WithdrawViewController.h"
#import "UIColor+Hex.h"
#import "HTTPRequest+MyWallet.h"
#import "UserManager.h"
#import "PasswordView.h"
#import "FindPasswordViewController.h"
#import "PureColorToImage.h"

@interface WithdrawViewController ()<UITextFieldDelegate>{
    
    NSNumber *allMoney;
    
}

@property (nonatomic, strong) PasswordView *passwordView;
@property (nonatomic,weak)IBOutlet UILabel *lblAllMoney;
@property (nonatomic,weak)IBOutlet UITextField *txfMoney;
@property (nonatomic,weak)IBOutlet UIView *viewName;
@property (nonatomic,weak)IBOutlet UIButton *btnSubmit;

//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation WithdrawViewController


-(instancetype)initWithAllMoney:(NSNumber *)money{
    
    self = [super init];
    if(self){
        
        allMoney = money;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"withdrawing_cash"];
    
    [self readyView];
    // Do any additional setup after loading the view from its nib.
}

-(void)readyView{
    
    [_txfMoney addTarget:self action:@selector(checkMoney) forControlEvents:UIControlEventEditingChanged];
    _btnSubmit.enabled =NO;
    
    _viewName.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
    _viewName.layer.borderWidth = 1.0;
    
    UIImage *imgBtn = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonNormalColor] andWidth:90.0f andHeight:90.0f];
    UIImage *imgBtnHigh = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonHeighColor] andWidth:90.0f andHeight:90.0f];
    UIImage *imgBtnDisabled = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonDisableColor] andWidth:90.0f andHeight:90.0f];
    
    [_btnSubmit setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:imgBtnHigh forState:UIControlStateHighlighted];
    [_btnSubmit setBackgroundImage:imgBtnDisabled forState:UIControlStateDisabled];
    
    _btnSubmit.layer.cornerRadius = 5.0f;
    _btnSubmit.clipsToBounds = YES;
    
    _lblAllMoney.text = [NSString stringWithFormat:@"本次最多可提现%.2f元",[allMoney floatValue]];
    
    [self setupNaviagionBar];
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
}

#pragma mark - UIButton actions

- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionWithSubmit{
    
    [self.view endEditing:YES];
    
    if(_txfMoney.text.length == 0 || ![GlobalFunction isMoneyWithStr:_txfMoney.text] || [_txfMoney.text floatValue] > [allMoney floatValue]){
        
        [self makeToast:@"请输入正确的金额" duration:1.0];

    }else {
        
        [self.passwordView showPassWordView];
        __weak __typeof(self)weakSelf = self;
        
        [_passwordView setFinishEdit:^(NSString *password , PasswordView *passwordViewBlock) {
            //显示转圈等待
            [passwordViewBlock showWatting];
            
            NSNumber *moneyNub = [NSNumber numberWithFloat:[weakSelf.txfMoney.text floatValue]];
            
            [HTTPRequest withdrawWithAdminId:[UserManager shareUserManager].admin_id money:moneyNub password:password completeBlock:^(BOOL ok, NSString *message) {
                if(ok){
                   
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"accountValueChange" object:nil];
                    
                    //accountValueChange
                    
                    [passwordViewBlock showSuccess];
                    [weakSelf performSelector:@selector(backButtonClicked) withObject:nil afterDelay:2.5f];
                    
                }else {
                    [passwordViewBlock hiddenWattingAndTryAgain];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:message
                                                                       delegate:weakSelf
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"重试",@"忘记密码",nil];
                    [alertView show];                }
            }];
        }];
    }
}

-(void)checkMoney{
    
    if(_txfMoney.text.length == 0 || ![GlobalFunction isMoneyWithStr:_txfMoney.text] || [_txfMoney.text floatValue] > [allMoney floatValue]){
        
        _btnSubmit.enabled = NO;
        
    }else {
        
        _btnSubmit.enabled = YES;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //重试
    if (buttonIndex ==0) {
        //忘记密码
    }else if (buttonIndex ==1){
        [self.passwordView removeFromSuperview];
        self.passwordView=nil;
        FindPasswordViewController *vc = [FindPasswordViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"我要提现";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(PasswordView *)passwordView{
    if(!_passwordView){
        _passwordView = [[[NSBundle mainBundle]loadNibNamed:@"PasswordView" owner:self options:nil]lastObject];
        _passwordView.successTips = @"提现成功";
        
        __weak __typeof(self)weakSelf = self;
        
        [_passwordView setForgetPassword:^{
            FindPasswordViewController *vc = [FindPasswordViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _passwordView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
