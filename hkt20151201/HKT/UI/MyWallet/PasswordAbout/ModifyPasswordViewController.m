//
//  ModifyPasswordViewController.m
//  HKT
//
//  Created by Ting on 15/11/16.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "UIView+Size.h"
#import "UserManager.h"
#import "PureColorToImage.h"
#import "HTTPRequest+Login.h"
#import "HTTPRequest+MyWallet.h"

@interface ModifyPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
}

@property (nonatomic,weak)IBOutlet UITableView *myTableView;

@property (nonatomic, strong) UIView *viewForFoot;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UITextField *txtOldPassword;
@property (nonatomic, strong) UITextField *txtNewPassword;
@property (nonatomic, strong) UITextField *txtNewPasswordRepeat;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviagionBar];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.tableFooterView = self.viewForFoot;
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

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
        [cell addSubview:self.txtOldPassword];
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
    
    if(!_txtOldPassword.text.length>0){
        [self makeToast:@"请输入原密码"];
    }else if (_txtNewPassword.text.length != 6 || ![GlobalFunction isIntString:_txtNewPassword.text]){
        [self makeToast:@"请输入6位数字提现密码!" duration:1.0];
    }else if(![_txtNewPassword.text isEqualToString:_txtNewPasswordRepeat.text]){
        [self makeToast:@"两次输入的密码不一样"];
    }else if([_txtOldPassword.text isEqualToString:_txtNewPassword.text]){
        [self makeToast:@"新密码不能与旧密码相同"];
    }else{
        
        [self showHUDSimple];
        
        [HTTPRequest modifyPasswordWithAdminId:[UserManager shareUserManager].admin_id oldPassword:_txtOldPassword.text newPassword:_txtNewPassword.text completeBlock:^(BOOL ok, NSString *message) {
            [self hideHUD];
            if(ok){
                [self makeToast:@"提现密码修改成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self makeToast:message];
            }
        }];
    }
}


#pragma mark --getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"修改提现密码";
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

- (UITextField *)txtOldPassword{
    if(!_txtOldPassword){
        _txtOldPassword = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth - 30 , 44)];
        _txtOldPassword.font = [UIFont systemFontOfSize:16.0f];
        _txtOldPassword.textColor = [UIColor darkGrayColor];
        _txtOldPassword.keyboardType = UIKeyboardTypeNumberPad;
        _txtOldPassword.returnKeyType = UIReturnKeyNext;
        _txtOldPassword.placeholder = @"请输入旧密码";
        _txtOldPassword.secureTextEntry = YES;
        _txtOldPassword.keyboardType = UIKeyboardTypeNumberPad;
        _txtOldPassword.delegate = self;
        _txtOldPassword.clearsOnBeginEditing = YES;
    }
    return _txtOldPassword;
}

- (UITextField *)txtNewPassword{
    if(!_txtNewPassword){
        _txtNewPassword = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth - 30, 44)];
        _txtNewPassword.font = [UIFont systemFontOfSize:16.0f];
        _txtNewPassword.textColor = [UIColor darkGrayColor];
        _txtNewPassword.returnKeyType = UIReturnKeyNext;
        _txtNewPassword.placeholder = @"请输入6位数数字提现密码";
        _txtNewPassword.secureTextEntry = YES;
        _txtNewPassword.keyboardType = UIKeyboardTypeNumberPad;
        _txtNewPassword.delegate = self;
        _txtNewPassword.clearsOnBeginEditing = YES;
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
        _txtNewPasswordRepeat.clearsOnBeginEditing = YES;
    }
    return _txtNewPasswordRepeat;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _txtOldPassword){
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
