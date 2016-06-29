//
//  AddAccountViewController.m
//  HKT
//
//  Created by Ting on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "AddAccountViewController.h"
#import "UIColor+Hex.h"
#import "HTTPRequest+MyWallet.h"
#import "UserManager.h"
#import "BankAccount.h"
#import "SetWebViewController.h"
#import "PureColorToImage.h"

@interface AddAccountViewController ()

@property (nonatomic,weak)IBOutlet UITextField *txfAccount;
@property (nonatomic,weak)IBOutlet UITextField *txfName;

//@property (nonatomic,weak)IBOutlet UIView *viewAccount;
//@property (nonatomic,weak)IBOutlet UIView *viewName;
//@property (nonatomic,weak)IBOutlet UIView *viewPwd;
//@property (nonatomic,weak)IBOutlet UIView *viewRpwd;

@property (nonatomic,weak)IBOutlet UIButton *btnSubmit;

@property (nonatomic,weak)IBOutlet UIButton *btnAlipay;
@property (nonatomic,weak)IBOutlet UIButton *btnWeChat;
//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;


@property (nonatomic, strong)IBOutlet UITextField *txfPwd;
@property (nonatomic, strong)IBOutlet UITextField *txfRpwd;

@end

@implementation AddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"bind_account"];

    [self readyView];
    // Do any additional setup after loading the view from its nib.
}

-(void)readyView{

    UIImage *imgBtn = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonNormalColor] andWidth:90.0f andHeight:90.0f];
    UIImage *imgBtnHigh = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonHeighColor] andWidth:90.0f andHeight:90.0f];
    UIImage *imgBtnDisabled = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonDisableColor] andWidth:90.0f andHeight:90.0f];
    
    [_btnSubmit setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:imgBtnHigh forState:UIControlStateHighlighted];
    [_btnSubmit setBackgroundImage:imgBtnDisabled forState:UIControlStateDisabled];
    _btnSubmit.clipsToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5.0f;
 
    _btnAlipay.selected =YES;
    
    [self setupNaviagionBar];
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
}

#pragma mark - UIButton actions

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)actionWithSubmit{
    
    if(_txfAccount.text.length == 0){
        [self makeToast:@"请输入账户名称!" duration:1.0];
        return;
    }else if (_txfName.text.length == 0){
        [self makeToast:@"请输入姓名!" duration:1.0];
        return;
    }else if (_txfPwd.text.length != 6 || ![GlobalFunction isIntString:_txfPwd.text]){
        [self makeToast:@"请输入6位数字提现密码!" duration:1.0];
        return;
    }else if (![_txfPwd.text isEqualToString:_txfRpwd.text]){
        [self makeToast:@"两次输入的提现密码不一致!" duration:1.0];
        return;
    }
    
    BankAccount *bankAccount = [BankAccount new];
    bankAccount.ownerName = _txfName.text;
    bankAccount.accountName = _txfAccount.text;
    bankAccount.accountType = _btnAlipay.selected? AlipayType : WecharType;
    
    [self showHUDSimple];
    [HTTPRequest addAccountWithAdminId:[UserManager shareUserManager].admin_id bankAccount:bankAccount password:_txfPwd.text completeBlock:^(BOOL ok, NSString *message, BankAccount *bankAccount) {
        [self hideHUD];
        
        if(ok){
            [MobClick event:@"bind_click"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"accountValueChange" object:nil];
            [self makeToast:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [self makeToast:message duration:1.0];
        }
    }];
}

-(IBAction)actionWithChooseType:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
        {
            _btnAlipay.selected =YES;
            _btnWeChat.selected =NO;
            _txfAccount.placeholder = @"请输入您的支付宝账户名称";
        }
            break;
        case 1:
        {
            _btnAlipay.selected =NO;
            _btnWeChat.selected =YES;
            _txfAccount.placeholder = @"请输入您的微信账户名称";
        }
            break;
            
        default:
            break;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( (textField == _txfPwd || textField == _txfRpwd) && string.length>0 ) {
        if (textField.text.length > 5)
            return NO;
    }
    
    return YES;
}

#pragma mark getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"绑定提现账户";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton =[self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
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
