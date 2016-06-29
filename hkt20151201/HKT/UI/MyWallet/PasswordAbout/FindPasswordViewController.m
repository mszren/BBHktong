//
//  PasswordManageViewController.m
//  HKT
//
//  Created by Ting on 15/11/16.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "UIView+Size.h"
#import "UserManager.h"
#import "PureColorToImage.h"
#import "HTTPRequest+Login.h"
#import "HTTPRequest+MyWallet.h"

@interface FindPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UILabel *labelVerifyLine;
}

@property (nonatomic,weak)IBOutlet UITableView *myTableView;

@property (nonatomic, strong) UIView *viewForHead;
@property (nonatomic, strong) UIView *viewForFoot;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UITextField *txtForSms;
@property (nonatomic, strong) UITextField *txtNewPassword;
@property (nonatomic, strong) UITextField *txtNewPasswordRepeat;

@property (nonatomic, strong) UIButton *btnVerify;



@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviagionBar];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.tableHeaderView = self.viewForHead;
    self.myTableView.tableFooterView = self.viewForFoot;
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForUITableViewCell = @"identifierForUITableViewCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForUITableViewCell];
    // 不重用
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0){
        [cell addSubview:self.txtForSms];
        [cell addSubview:self.btnVerify];
    }else if (indexPath.row == 1){
        [cell addSubview:self.txtNewPassword];
    }else if (indexPath.row == 2){
        [cell addSubview:self.txtNewPasswordRepeat];
    }
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)actionWithSubmit{
    
    if(!_txtForSms.text.length>0){
        [self makeToast:@"请输入验证码"];
    }else if (_txtNewPassword.text.length != 6 || ![GlobalFunction isIntString:_txtNewPassword.text]){
        [self makeToast:@"请输入6位数字提现密码!" duration:1.0];
    }else if(![_txtNewPassword.text isEqualToString:_txtNewPasswordRepeat.text]){
        [self makeToast:@"两次输入的密码不一样"];
    }else{
        
        [self showHUDSimple];
        [HTTPRequest findPasswordWithAdmin_mobile:[UserManager shareUserManager].admin_mobile verify_code:_txtForSms.text newPassword:_txtNewPassword.text completeBlock:
         ^(BOOL ok, NSString *message) {
             [self hideHUD];
             if(ok){
                 [self makeToast:@"提现密码找回成功!"];
                 [self.navigationController popViewControllerAnimated:YES];
             }else{
                 [self makeToast:message];
             }
         }];
    }
}

-(void)btnVerifyClick{
    [HTTPRequest verifyWithPhone:[UserManager shareUserManager].admin_mobile completeBlock:^(BOOL ok, NSString *message) {
        if(ok){
            __block int timeout=59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
                        //设置界面的按钮显示 根据自己需求设置
                        [_btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [_btnVerify setEnabled:YES];
                        
                    });
                }else{
                    //    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    NSString * strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        labelVerifyLine.backgroundColor = [UIColor lightGrayColor];
                        [_btnVerify setEnabled:NO];
                        //设置界面的按钮显示 根据自己需求设置
                        [_btnVerify setTitle:[NSString stringWithFormat:@"%@秒后重试",strTime] forState:UIControlStateDisabled];
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        }else{
            [_btnVerify setEnabled:YES];
            [_btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self makeToast:message duration:1];
        }
    }];
}

#pragma mark --getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"找回提现密码";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIView *)viewForHead{
    if(!_viewForHead){
        _viewForHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kDeviceWidth-30, 44)];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.textColor = [UIColor lightGrayColor];
        
        NSString *headString =  [NSString stringWithFormat:@"您正在为账号%@找回提现密码",[UserManager shareUserManager].admin_mobile];
        NSMutableAttributedString *attrubutedStr = [[NSMutableAttributedString alloc]initWithString:headString];
        [attrubutedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:blueButtonNormalColor] range:[headString rangeOfString:[UserManager shareUserManager].admin_mobile]];
        lbl.attributedText = attrubutedStr;
        
        [_viewForHead addSubview:lbl];
    }
    return _viewForHead;
}

- (UIView *)viewForFoot{
    if(!_viewForFoot){
        _viewForFoot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 74)];
        UIButton *submitBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(15, 15, kDeviceWidth-30, 44);
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitle:@"提   交" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(actionWithSubmit) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.clipsToBounds = YES;
        submitBtn.layer.cornerRadius = 5.0f;
        [_viewForFoot addSubview:submitBtn];
        
        UIImage *imgBtn = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonNormalColor] andWidth:10.0f andHeight:10.0f];
        UIImage *imgBtnHigh = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonHeighColor] andWidth:10.0f andHeight:10.0f];
        [submitBtn setBackgroundImage:imgBtn forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:imgBtnHigh forState:UIControlStateHighlighted];
        
    }
    return _viewForFoot;
}

- (UITextField *)txtForSms{
    if(!_txtForSms){
        _txtForSms = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth - 30 - 120, 44)];
        _txtForSms.font = [UIFont systemFontOfSize:16.0f];
        _txtForSms.textColor = [UIColor darkGrayColor];
        _txtForSms.keyboardType = UIKeyboardTypeNumberPad;
        _txtForSms.returnKeyType = UIReturnKeyNext;
        _txtForSms.placeholder = @"短信验证码";
        _txtForSms.delegate = self;
    }
    return _txtForSms;
}

-(UIButton *)btnVerify{
    if(!_btnVerify){
        _btnVerify = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnVerify.frame = CGRectMake(kDeviceWidth - 105, 0, 90, 44);
        [_btnVerify setTitleColor:[UIColor colorWithHex:0x58b6ee]  forState:UIControlStateNormal];
        [_btnVerify setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _btnVerify.titleLabel.font = [UIFont systemFontOfSize:16];
        _btnVerify.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_btnVerify addTarget:self action:@selector(btnVerifyClick)
             forControlEvents:UIControlEventTouchUpInside];
        labelVerifyLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 1, 20)];
        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
        labelVerifyLine.alpha = 0.5;
        [_btnVerify addSubview:labelVerifyLine];
    }
    return _btnVerify;
}

- (UITextField *)txtNewPassword{
    if(!_txtNewPassword){
        _txtNewPassword = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth - 30 , 44)];
        _txtNewPassword.font = [UIFont systemFontOfSize:16.0f];
        _txtNewPassword.textColor = [UIColor darkGrayColor];
        _txtNewPassword.returnKeyType = UIReturnKeyNext;
        _txtNewPassword.placeholder = @"请输入6位数数字提现密码";
        _txtNewPassword.secureTextEntry = YES;
        _txtNewPassword.keyboardType = UIKeyboardTypeNumberPad;
        _txtNewPassword.delegate = self;
    }
    return _txtNewPassword;
}

- (UITextField *)txtNewPasswordRepeat{
    if(!_txtNewPasswordRepeat){
        _txtNewPasswordRepeat = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth - 30 , 44)];
        _txtNewPasswordRepeat.font = [UIFont systemFontOfSize:16.0f];
        _txtNewPasswordRepeat.textColor = [UIColor darkGrayColor];
        _txtNewPasswordRepeat.returnKeyType = UIReturnKeyDone;
        _txtNewPasswordRepeat.placeholder = @"请重复输入6位数数字提现密码";
        _txtNewPasswordRepeat.secureTextEntry = YES;
        _txtNewPasswordRepeat.keyboardType = UIKeyboardTypeNumberPad;
        _txtNewPasswordRepeat.delegate = self;
    }
    return _txtNewPasswordRepeat;
}



#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _txtForSms){
        [_txtNewPassword becomeFirstResponder];
    }else if(textField == _txtNewPassword){
        [_txtNewPasswordRepeat becomeFirstResponder];
    }else if(textField == _txtNewPasswordRepeat){
        [_txtNewPasswordRepeat resignFirstResponder];
    }
    
    return YES;
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
