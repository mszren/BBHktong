//
//  RPWViewController.m
//  HKT
//
//  Created by app on 15-5-28.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "RPWViewController.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"

@interface RPWViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    UILabel *labelVerifyLine;
    NSTimer *timer;
    NSString * strTime ;
    int temp;
    dispatch_source_t _timer;
    UIImageView *image;
    UserManager *singlePw;
}

@property (nonatomic,retain)UIButton *btnVerify;
@property(nonatomic,strong)UIButton *leftButton;
@end

@implementation RPWViewController

@synthesize btnVerify;


- (void)viewDidLoad {
    [super viewDidLoad];
    singlePw = [UserManager shareUserManager];
    self.title = @"忘记密码";
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    //背景
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenSize.width, 176)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBgView];
    [whiteBgView addSubview:self.btnVerify];
    
    
    
    NSArray *arrName = @[@"手机号码",@"短信验证码",@"6-16位数字或字母组合密码",@"确认新密码"];
    for (int i = 0; i < 4; i ++) {
        UITextField *textFeildAll = [[UITextField alloc] initWithFrame:CGRectMake(15, 44 * i, 200, 44)];
        textFeildAll.keyboardType = UIKeyboardTypeNumberPad;
        textFeildAll.tag = 300 + i;
        textFeildAll.font = [UIFont systemFontOfSize:16];
        textFeildAll.placeholder = [arrName objectAtIndex:i];
        textFeildAll.delegate = self;
        [whiteBgView addSubview:textFeildAll];
        if (i == 2|| i == 3) {
            textFeildAll.keyboardType = UIKeyboardTypeASCIICapable;
            textFeildAll.secureTextEntry = YES;
        }
        
        if (i != 4) {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 43.5 * i, ScreenSize.width - 15, 0.5)];
            labelLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
            [whiteBgView addSubview:labelLine];
        }
        
    }
    
    
    //提交
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(15, 206, ScreenSize.width - 30, 44);
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateHighlighted];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.layer.cornerRadius = 6;
    [btnSubmit addTarget:self action:@selector(btnSubmit)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
    UIButton *btnRealize = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRealize.frame = CGRectMake(100, [[UIScreen mainScreen] bounds].size.height - 110, [[UIScreen mainScreen] bounds].size.width - 200, 30);
    [btnRealize setTitle:@"了解汇客通" forState:UIControlStateNormal];
    btnRealize.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRealize setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnRealize addTarget:self action:@selector(btnRealize) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRealize];
}

-(UIButton *)btnVerify{
    if(!btnVerify){
        btnVerify = [UIButton buttonWithType:UIButtonTypeCustom];
        btnVerify.frame = CGRectMake(ScreenSize.width - 105, 44, 90, 44);
        [btnVerify setTitleColor:[UIColor colorWithHex:0x58b6ee]  forState:UIControlStateNormal];
        [btnVerify setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btnVerify.titleLabel.font = [UIFont systemFontOfSize:16];
        btnVerify.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btnVerify addTarget:self action:@selector(btnVerifyClick)
            forControlEvents:UIControlEventTouchUpInside];
        labelVerifyLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 1, 20)];
        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
        labelVerifyLine.alpha = 0.5;
        [btnVerify addSubview:labelVerifyLine];
    }
    return btnVerify;
}

-(void)btnSubmit
{
    UITextField *textFieldPhone = (UITextField *)[self.view viewWithTag:300];
    UITextField *textFieldVerify = (UITextField *)[self.view viewWithTag:301];
    UITextField *textFieldPassWord = (UITextField *)[self.view viewWithTag:302];
    UITextField *textFieldRePassWord = (UITextField *)[self.view viewWithTag:303];
    
    if ( [textFieldPassWord.text length] < 6 || [textFieldPassWord.text length] > 16) {
        [self makeToast:@"密码不得少于6位数或大于16位" duration:1.0];
        return;
        
    }else if(![textFieldPassWord.text isEqualToString:textFieldRePassWord.text]){
        [self makeToast:@"两次密码不一致" duration:1.0];
        return;
    }
    
    [self rpwWithPhone:textFieldPhone.text password:textFieldPassWord.text verifyCode:textFieldVerify.text];
    
}

-(void)rpwWithPhone:(NSString *)phone password:(NSString *)password verifyCode:(NSString *)verifyCode
{
    [self showHUDSimple];
    [HTTPRequest rpwWithPhone:phone password:password verifyCode:verifyCode completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [self hideHUD];
        if(ok){
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de removeObjectForKey:@"defaultText1"];
            [de setObject:phone forKey:@"defaultText1"];
            [de synchronize];
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:@"defaultText2"];
            [def setObject:password forKey:@"defaultText2"];
            [def synchronize];
            singlePw.number = @"1";
            
            [self makeToast:message duration:1.0];
            [self.navigationController popViewControllerAnimated:NO];
            self.finishBlock(phone,password);
        }else{
            [self makeToast:message duration:1.0];
        }
    }];
}

-(void)buttonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)btnVerifyClick
{
    UITextField *textFieldPhone = (UITextField *)[self.view viewWithTag:300];
    if ([textFieldPhone.text isEqualToString:@""]) {
        [self makeToast:@"请输入号码" duration:1.0];
    } else{
        //上传号码
        [btnVerify setTitle:@"正在发送" forState:UIControlStateNormal];
        [self verifyPhone:textFieldPhone.text];
    }
}

-(void)verifyPhone:(NSString *)phoneNumber{
    [HTTPRequest verifyWithPhone:phoneNumber completeBlock:^(BOOL ok, NSString *message) {
        if(ok){
            __block int timeout=59; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [btnVerify setEnabled:YES];
                        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];

                });
                }else{
                    //    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [btnVerify setEnabled:NO];
                        labelVerifyLine.backgroundColor = [UIColor lightGrayColor];
                        //设置界面的按钮显示 根据自己需求设置
                        [btnVerify setTitle:[NSString stringWithFormat:@"%@秒后重试",strTime] forState:UIControlStateDisabled];

                        
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
            
        }else{
            [btnVerify setEnabled:YES];
            [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self makeToast:message duration:1];
            
        }
        
    }];
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField;{
    
    if (textField.tag == 300 || textField.tag == 301 ) {
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
    
    temp = textField.tag;
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag == 300) {
        res = 11 - [new length];
    }else if(textField.tag == 301)
    {
        res = 6 - [new length];
    }else{
        res = 16 - [new length];
    }
    
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        
        return NO;
    }
}

-(void)btnRealize{
    realizeViewController *realize = [[realizeViewController alloc] init];
    [self.navigationController pushViewController:realize animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
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
