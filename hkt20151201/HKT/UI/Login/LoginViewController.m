//
//  LoginViewController.m
//  LKT
//
//  Created by Ting on 15/10/7.
//  Copyright © 2015年 Ting. All rights reserved.
//

#import "LoginViewController.h"
#import "PureColorToImage.h"
#import "HTTPRequest+Login.h"
#import "User.h"
#import "HistoryUserView.h"
#import "UIImageView+WebCache.h"
#import "APService.h"
#import "UserManager.h"
#import "peopleViewController.h"
#import "SetWebViewController.h"
#import "CalculatorViewController.h"
#import "RPWViewController.h"
#import "registerViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,HistoryUserViewDelegate>{
    
    UserManager *userManager;
    NSArray * arrayForUserHistory;
    NSUserDefaults *userDefaults;
}

@property (nonatomic,weak) IBOutlet UITextField *userNameText;
@property (nonatomic,weak) IBOutlet UITextField *pwdText;
@property (nonatomic,weak) IBOutlet UIView *loginView;

@property (nonatomic,weak) IBOutlet UIImageView *headImgView;

@property (nonatomic,weak) IBOutlet UIButton *loginBtn;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *historyViewHeight;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollViewForHistory;
@property (nonatomic,weak) IBOutlet UIButton *btnWtihHistoryUser;


@property (nonatomic,weak) IBOutlet NSLayoutConstraint *headImgViewTop;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *loginViewTop;

//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,retain) UIButton *registerBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userManager = [UserManager shareUserManager];
    [self readyView];
    [self loginDefaultAccount];
}

-(void)loginDefaultAccount{
    
    NSString *loginName = [userDefaults objectForKey:@"defaultText1"];
    NSString *pwd = [userDefaults objectForKey:@"defaultText2"];
    
    if(loginName && pwd){
        [self loginWith:loginName andPwd:pwd];
    }
}

-(void)readyView{
    
    [self setupNaviagionBar];
    UIImage *imgBtn = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonNormalColor] andWidth:10.0f andHeight:10.0f];
    UIImage *imgBtnHigh = [PureColorToImage imageWithColor:[UIColor colorWithHex:blueButtonHeighColor] andWidth:10.0f andHeight:10.0f];
    [_loginBtn setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:imgBtnHigh forState:UIControlStateHighlighted];
    _loginBtn.clipsToBounds = YES;
    _loginBtn.layer.cornerRadius = 4.0;
    
    [_pwdText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _historyViewHeight.constant = 0;
    _headImgView.clipsToBounds = YES;
    _headImgView.layer.cornerRadius = 33.0f;
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //为了适应iPhone4&4S的小屏幕...
    if(iPhone4){
        _headImgViewTop.constant = _headImgViewTop.constant -10;
        _loginViewTop.constant = _loginViewTop.constant -20;
        
    }
    
}

-(void)reloadHistoryUser{
    
    [_scrollViewForHistory.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    arrayForUserHistory = [User getHistoryUser];
    
    float left = (kDeviceWidth - arrayForUserHistory.count*95)/2;
    if(left<0){
        left = 0;
    }
    
    for (int i=0; i<arrayForUserHistory.count; i++) {
        User *user = arrayForUserHistory[i];
        HistoryUserView *view = [[[NSBundle mainBundle]loadNibNamed:@"HistoryUserView" owner:self options:nil]lastObject];
        view.delegate = self;
        view.lblName.text = user.loginName;
        view.frame = CGRectMake(left, 0, 95, 76);
        view.tag = i;
        [view.imgViewForHead sd_setImageWithURL:[NSURL URLWithString:user.headImgUrl] placeholderImage:[UIImage imageNamed:@"login_head"]];
        [_scrollViewForHistory addSubview:view];
        left = left +95;
    }
    
    _scrollViewForHistory.contentSize = CGSizeMake(left, 76);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self actionWithMenu:NO animated:NO];
}

#pragma mark - UIButton actions

-(IBAction)acitonWithShowHistoryUser{
    
    _btnWtihHistoryUser.selected =! _btnWtihHistoryUser.selected;
    
    [self actionWithMenu: _btnWtihHistoryUser.selected animated:YES];
    
}

-(void)actionWithMenu:(BOOL)isOpen animated:(BOOL)animated{
    
    if(isOpen){
        [self.view endEditing:YES];
    }
    
    _btnWtihHistoryUser.selected = isOpen;
    
    NSTimeInterval time = animated?0.5:0;
    
    [UIView transitionWithView:self.loginView duration:time options:0 animations:^{
        if(isOpen){
            [self reloadHistoryUser];
            self.historyViewHeight.constant = 76.0f;
        }else {
            self.historyViewHeight.constant = 0.0f;
        }
        [self.loginView layoutIfNeeded];
    }completion:nil];
    
}

-(IBAction)actionWithLogin{
    
    if(_userNameText.text.length == 0){
        [self makeToast:@"请输入手机号码"];
        return;
    }
    
    if (_pwdText.text.length == 0){
        [self makeToast:@"请输入密码"];
        return;
    }
    
    if(![GlobalFunction isPhoneId:_userNameText.text]){
        [self makeToast:@"请输入正确的手机号码"];
        return;
    }
    
    [self loginWith:_userNameText.text andPwd:_pwdText.text];
    
}

-(void)loginWith:(NSString *)loginName andPwd:(NSString *)pwd{
    
    [self showHUDSimple];
    
    [self showHUDWithLabel:@"登录中..."];
    [HTTPRequest loginWithPhone:loginName password:pwd completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [self hideHUD];
        if(ok){
            
            //jpush别名
            [APService setAlias:[data objectForKey:@"app_push_alias"] callbackSelector:nil object:nil];
            
            //填充单例
            NSString *admin_mobile = [data objectForKey:@"admin_mobile"];
            NSString *admin_hid = [data objectForKey:@"admin_hid"];
            NSString *admin_truename = [data objectForKey:@"admin_truename"];
            NSString *admin_attr = [NSString stringWithFormat:@"%@",[data objectForKey:@"admin_attr"]];
            NSString *admin_id = [data objectForKey:@"admin_id"];
            userManager.admin_id = admin_id;
            userManager.userHeaderImg = [data objectForKey:@"admin_head_img"];
            userManager.admin_name = [NSString stringWithFormat:@"%@",[data objectForKey:@"admin_name"]];
            userManager.admin_mobile = admin_mobile;
            userManager.admin_hid = admin_hid;
            userManager.admin_truename = admin_truename;
            userManager.admin_attr = admin_attr;
            userManager.admin_pw = pwd;
            //添加到数据库
            User *user = [User new];
            user.loginName = data[@"admin_mobile"];
            user.trueName = data[@"admin_truename"];
            user.password = pwd;
            user.headImgUrl = data[@"admin_head_img"];
            [user addLoginUserSelf];
            //
            
            //保存账号密码
            [userDefaults setObject:loginName forKey:@"defaultText1"];
            [userDefaults setObject:pwd forKey:@"defaultText2"];
            
            
            peopleViewController *peopleVC = [[peopleViewController alloc] init];
            [self.navigationController pushViewController:peopleVC animated:YES];
            
            
        }else {
            [self makeToast:message duration:1];
        }
    }];
    
}

//了解
-(IBAction)actionWithRealizeClick{
    //    SetWebViewController *vc = [[SetWebViewController alloc]initWithURLStr:@"http://www.baidu.com"];
    //    [self.navigationController pushViewController:vc animated:YES];
    realizeViewController *real = [[realizeViewController alloc] init];
    [self.navigationController pushViewController:real animated:YES];
}

//计算器
-(IBAction)actionWithGotoCalculator{
    CalculatorViewController* vc = [[CalculatorViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//忘记密码
-(IBAction)actionWithFindPwd{
    RPWViewController *vc = [[RPWViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setFinishBlock:^(NSString *userName, NSString *pwd) {
        [self loginWith:userName andPwd:pwd];
    }];
}

//注册
-(void)actionWithRegister{
    registerViewController *registerVC = [[registerViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC setFinishBlock:^(NSString *userName, NSString *pwd) {
        [self loginWith:userName andPwd:pwd];
    }];
}

-(IBAction)actionWithSecure:(UIButton *)btn{
    
    [_pwdText resignFirstResponder];
    
    btn.selected =!btn.selected;
    if(btn.selected){
        _pwdText.secureTextEntry = NO;
    }else {
        _pwdText.secureTextEntry = YES;
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _userNameText){
        [_pwdText becomeFirstResponder];
    }else {
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    
    if(textField == _userNameText){
        [_headImgView setImage:[UIImage imageNamed:@"login_head"]];
    }
    
    if (textField.text.length > 16)
    {
        textField.text = [textField.text substringToIndex:16];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _userNameText){
        User *user = [User findUserWithLoginName:textField.text];
        if(user){
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:user.headImgUrl] placeholderImage:[UIImage imageNamed:@"login_head"]];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self actionWithMenu:NO animated:YES];
    return YES;
}

#pragma mark - HistoryUserViewDelegate

-(void)historyUseViewDeleteAtIndex:(NSUInteger)index{
    User *user = arrayForUserHistory[index];
    [user deleUserWithLoginName:user.loginName];
    [self reloadHistoryUser];
}

-(void)historyUseViewChooseAtIndex:(NSUInteger)index{
    User *user = arrayForUserHistory[index];
    self.userNameText.text  = user.loginName;
    self.pwdText.text       = user.password;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:user.headImgUrl] placeholderImage:[UIImage imageNamed:@"login_head"]];
    [self loginWith:user.loginName andPwd:user.password];
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.registerBtn]];
}

#pragma mark getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"登录";
    }
    return _titleLabel;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(actionWithRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
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
