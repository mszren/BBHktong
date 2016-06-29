//
//  ViewController.m
//  HKT
//
//  Created by app on 15-5-26.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "LoginViewControllerOld.h"
#import "peopleViewController.h"
#import "registerViewController.h"
#import "HTTPRequest+Login.h"
#import "RPWViewController.h"
#import "personViewController.h"
#import "UserManager.h"

#import "realizeViewController.h"
#import "PunchViewController.h"
#import "MyWalletViewController.h"
#import "CalculatorViewController.h"

#import "User.h"


#define TrueHeight [UIScreen mainScreen].bounds.size.width * 145 / 360

@interface LoginViewControllerOld ()<ASIHTTPRequestDelegate>

@end

@implementation LoginViewControllerOld
{
    UITextField *textField1;
    UITextField *textField2;
    UIButton *load;
    UserManager *Single;
    UIImageView *image;
}

-(void) viewWillAppear:(BOOL)animated {
    //重新进来变回来
    [load setBackgroundImage:[UIImage imageNamed:@"header_bg"] forState:UIControlStateNormal];
    [load setTitle:@"登录" forState:UIControlStateNormal];

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *strTextField2 = [def stringForKey: @"defaultText2"];
    textField2.text = strTextField2;
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *strTextField = [de stringForKey: @"defaultText1"];
    textField1.text = strTextField;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *labelHKT = [[UILabel alloc] initWithFrame:CGRectMake(ScreenSize.width/2 - 120, 5, 60, 30)];
    labelHKT.text = @"登录";
    labelHKT.font = [UIFont boldSystemFontOfSize:18];
    labelHKT.textAlignment = NSTextAlignmentCenter;
    labelHKT.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelHKT;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    Single = [UserManager shareUserManager];
    [self CreatBgImage];
    
}

-(void)CreatBgImage
{
    UIView *viewHeadBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, TrueHeight)];
    viewHeadBg.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    [self.view addSubview:viewHeadBg];

    UIView *viewDown = [[UIView alloc] initWithFrame:CGRectMake(0, TrueHeight + 35 + 5 + 40 + 20 , ScreenSize.width, ScreenSize.height - (TrueHeight + 35 + 5 + 40 + 64))];
    viewDown.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    [self.view addSubview:viewDown];
    
    //设置用户名图片
    UIImageView *imagerigister = [[UIImageView alloc] initWithFrame:CGRectMake(20, TrueHeight + 10, 30, 27)];
    imagerigister.image = [UIImage imageNamed:@"user"];
    [self.view addSubview:imagerigister];
    
    //设置输入用户名
    textField1 = [[UITextField alloc] initWithFrame:CGRectMake(70, TrueHeight + 5, 200, 40)];
    textField1.borderStyle = UITextBorderStyleNone;
    textField1.keyboardType = UIKeyboardTypeNumberPad;
    textField1.textAlignment = UITextAlignmentLeft;   //内容对齐方式
    textField1.placeholder = @"请输入手机号码";
    textField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField1.tag = 330;
    textField1.delegate = self;
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *strTextField = [de stringForKey: @"defaultText1"];
    textField1.text = strTextField;
    
    UIButton *btnDet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDet.frame = CGRectMake(ScreenSize.width - 35, TrueHeight + 10, 20, 20);
    [btnDet addTarget:self action:@selector(btnDet) forControlEvents:UIControlEventTouchUpInside];
    [btnDet setBackgroundImage:[UIImage imageNamed:@"det.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:btnDet];
    
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(5, TrueHeight + 35 + 9, self.view.frame.size.width - 10, 0.5)];
    labelLine.backgroundColor = [UIColor grayColor];
    labelLine.alpha = 0.6;
    [self.view addSubview:labelLine];
    
    //设置密码图片
    UIImageView *imagepassword = [[UIImageView alloc] initWithFrame:CGRectMake(20, TrueHeight + 60, 30, 27)];
    imagepassword.image = [UIImage imageNamed:@"password"];
    [self.view addSubview:imagepassword];
    
    //设置密码暗文
    textField2 = [[UITextField alloc] initWithFrame:CGRectMake(70, TrueHeight + 55, 200, 40)];
    textField2.borderStyle = UITextBorderStyleNone;
    textField2.placeholder = @"请输入密码";
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *strTextField2 = [def stringForKey: @"defaultText2"];
    textField2.text = strTextField2;
    textField2.tag = 331;
    textField2.leftViewMode = UITextFieldViewModeAlways;
    textField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField2.keyboardType = UIKeyboardTypeNamePhonePad;
    textField2.secureTextEntry = YES;
    textField2.delegate = self;
    
    //显示密码
    UIButton *btnEye = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnEye.frame = CGRectMake(self.view.frame.size.width - 35, TrueHeight + 60, 40, 40);
    [btnEye addTarget:self action:@selector(btnEye:) forControlEvents:UIControlEventTouchUpInside];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    image.image = [UIImage imageNamed:@"eye.jpg"];
    [btnEye addSubview:image];
    [self.view addSubview:btnEye];
    
    //设置登陆按钮
    load = [UIButton buttonWithType:UIButtonTypeCustom];
    load.frame = CGRectMake(30, 20, ScreenSize.width - 60, 50);
    load.layer.masksToBounds = YES;
    load.layer.cornerRadius = 8;
    [load setBackgroundImage:[UIImage imageNamed:@"header_bg"] forState:UIControlStateNormal];
    [load setTitle:@"登录" forState:UIControlStateNormal];
    [load addTarget:self action:@selector(buttonClick:)
   forControlEvents:UIControlEventTouchUpInside];
    [viewDown addSubview:load];
    
    //忘记密码
    UIButton *changePD = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changePD.frame = CGRectMake(ScreenSize.width - 110, 90, 80, 20);
    [changePD setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [changePD setTitleColor:[UIColor colorWithRed:14/255.0f green:141/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    changePD.titleLabel.font = [UIFont systemFontOfSize:16];
    [changePD addTarget:self action:@selector(button2Click:)
       forControlEvents:UIControlEventTouchUpInside];
    [viewDown addSubview:changePD];
    
    
    //房贷image
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 2  - 130 + 4 , ScreenSize.height - (TrueHeight + 35 + 5 + 40 + 64) - 58 - 10, 15, 15)];
    imageV.image = [UIImage imageNamed:@"jsq"];
    [viewDown addSubview:imageV];
    
    //房贷计算器
    UIButton *FD = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    FD.frame = CGRectMake(ScreenSize.width / 2  - 110 , ScreenSize.height - (TrueHeight + 35 + 5 + 40 + 64) - 60 - 10 , 80, 20);
    [FD setTitle:@"房贷计算器" forState:UIControlStateNormal];
    [FD addTarget:self action:@selector(FDClick) forControlEvents:UIControlEventTouchUpInside];
    [FD setTitleColor:[UIColor colorWithRed:14/255.0f green:141/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    FD.titleLabel.font = [UIFont systemFontOfSize:15];
    [viewDown addSubview:FD];
    
    UIImageView *imageRealize = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width/2 + 30, ScreenSize.height - (TrueHeight + 35 + 5 + 40 + 64) - 60 + 2 - 10, 15, 15)];
    imageRealize.image = [UIImage imageNamed:@"telephone"];
    [viewDown addSubview:imageRealize];
    
    //了解汇客通
    UIButton *btnRealize = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRealize.frame = CGRectMake(ScreenSize.width/2 + 50 - 4, ScreenSize.height - (TrueHeight + 35 + 5 + 40 + 64) - 60 - 10  , 150, 20);
    [btnRealize setTitle:@"了解汇客通" forState:UIControlStateNormal];
    btnRealize.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnRealize addTarget:self action:@selector(realizeClick) forControlEvents:UIControlEventTouchUpInside];
    [btnRealize setTitleColor:[UIColor colorWithRed:14/255.0f green:141/255.0f blue:219/255.0f alpha:1] forState:UIControlStateNormal];
    [viewDown addSubview:btnRealize];
    
    if ([textField1.text isEqualToString:@""]||[textField2.text isEqualToString:@""]) {
    }else{
        
        if ([Single.number isEqualToString:@"0"]) {
            
        }else{
            
            [self login:strTextField andPwd:strTextField2];
        }
    }
    [self.view addSubview:textField1];
    [self.view addSubview:textField2];
}


-(void)login:(NSString *)loginName andPwd:(NSString*)pwd{
    [load setTitle:@"加载中..." forState:UIControlStateNormal];
    [load setBackgroundImage:[UIImage imageNamed:@"reg-pre"] forState:UIControlStateNormal];
    [HTTPRequest loginWithPhone:loginName password:pwd completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(ok){
            //填充单例
            Single.admin_pw = pwd;
            Single.admin_attr  = [data objectForKey:@"adminAttr"];
            //
            
            //保存账号密码
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de removeObjectForKey:@"defaultText1"];
            [de setObject:textField1.text forKey:@"defaultText1"];
            [de synchronize];
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:@"defaultText2"];
            [def setObject:textField2.text forKey:@"defaultText2"];
            [def synchronize];
            textField1.text =loginName;
            textField2.text =pwd;
           //
            
            
            //jpush别名
            [APService setAlias:[data objectForKey:@"app_push_alias"] callbackSelector:nil object:nil];
            
            NSString *admin_mobile = [data objectForKey:@"admin_mobile"];
            // NSString *admin_head_img = [data objectForKey:@"admin_head_img"];
            NSString *admin_hid = [data objectForKey:@"admin_hid"];
            NSString *admin_truename = [data objectForKey:@"admin_truename"];
            NSString *admin_attr = [NSString stringWithFormat:@"%@",[data objectForKey:@"admin_attr"]];
            NSString *admin_id = [data objectForKey:@"admin_id"];
            Single.admin_id = admin_id;
            Single.userHeaderImg = [data objectForKey:@"admin_head_img"];
            Single.admin_name = [NSString stringWithFormat:@"%@",[data objectForKey:@"admin_name"]];
            Single.admin_mobile = admin_mobile;
            Single.admin_hid = admin_hid;
            Single.admin_truename = admin_truename;
            Single.admin_attr = admin_attr;
            //

            //添加到数据库
            User *user = [User new];
            user.loginName = data[@"admin_mobile"];
            user.trueName = data[@"admin_truename"];
            user.password = textField2.text;
            user.headImgUrl = data[@"admin_head_img"];
            [user addLoginUserSelf];
            //
            
            peopleViewController *peopleVC = [[peopleViewController alloc] init];
     
            [self.navigationController pushViewController:peopleVC animated:YES];
        }else {
            [load setBackgroundImage:[UIImage imageNamed:@"header_bg"] forState:UIControlStateNormal];
            [load setTitle:@"登录" forState:UIControlStateNormal];
            [self makeToast:message duration:1];
        }
    }];
}

-(void)realizeClick{
    realizeViewController *realizeVC = [[realizeViewController alloc] init];
    [self.navigationController pushViewController:realizeVC animated:YES];

}


#pragma  mark wyy 修改
-(void)FDClick{    
    CalculatorViewController* vc = [[CalculatorViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)button2Click:(UIButton *)btn
{
    RPWViewController *vc = [[RPWViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setFinishBlock:^(NSString *userName, NSString *pwd) {
        [self login:userName andPwd:pwd];
    }];
    
}


-(void)buttonClick:(UIButton *)btn
{
    //上传用户名和密码
    if ([textField1.text  isEqual: @""]) {
        [self makeToast:@"请输入手机号" duration:1];
    }else if([textField2.text  isEqual: @""])
    {
        [self makeToast:@"请输入密码" duration:1];
    }else{
        
        [self login:textField1.text andPwd:textField2.text];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    
        if (textField == textField1) {
        NSString *validRegEx =@"^[0-9]*$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:textField.text];
        
        if (myStringMatchesRegEx){
            
        }
        else
        {
            [self makeToast:@"只能输入数字" duration:1];
            textField.text = @"";
        }
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField1 == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
           // textField.text = [toBeString substringToIndex:11];
            [self makeToast:@"手机号最大字数为11位" duration:1];
            return NO;
        }
    }else{
        
        if ([toBeString length] > 16) { //如果输入框内容大于20则弹出警告
//            textField.text = [toBeString substringToIndex:16];

            [self makeToast:@"密码最大字数为16位" duration:1];
            return NO;
        }
        
    }
    return YES;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)btnDet
{
    textField1.text = @"";
}

-(void)btnEye:(UIButton *)btnN
{
    textField2.secureTextEntry = !textField2.secureTextEntry;
    [textField2 resignFirstResponder];
    if (textField2.secureTextEntry == YES) {
        image.image = [UIImage imageNamed:@"eye.jpg"];
    }else{
        image.image = [UIImage imageNamed:@"eye2.jpg"];
    }
}

-(void)buttonRightClick{
    //注册
    registerViewController *registerVC = [[registerViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC setFinishBlock:^(NSString *userName, NSString *pwd) {
        [self login:userName andPwd:pwd];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
