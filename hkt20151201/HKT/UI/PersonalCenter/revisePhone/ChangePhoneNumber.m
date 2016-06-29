//
//  ChangePhoneNumber.m
//  HKT
//
//  Created by app on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "ChangePhoneNumber.h"
#import "HTTPRequest+person.h"

@interface ChangePhoneNumber ()
{
    UserManager *singleChange;
    UITextField * texTField;
    dispatch_source_t _timer;
    NSString * strTime ;

}
@property(nonatomic,strong)UIButton *leftButton;
@property (nonatomic,retain)UIButton *btnVerify;
@property(nonatomic,strong)UIButton *btmSubmit;

@end

@implementation ChangePhoneNumber
@synthesize btnVerify;

- (void)viewDidLoad {
    [super viewDidLoad];
    singleChange = [UserManager shareUserManager];
    
    //导航栏
    self.title = @"修改手机号码";
    strTime = [[NSString alloc] init];

    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenSize.width - 30, 44)];
    labelPhone.text = [NSString stringWithFormat:@"请输入%@收到的手机验证码",singleChange.admin_mobile];
    labelPhone.font = [UIFont systemFontOfSize:14];
    labelPhone.textColor = [UIColor colorWithHex:0x666666];
    [self.view addSubview:labelPhone];
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenSize.width, 44)];
    viewBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBg];
    
    texTField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0,ScreenSize.width - 120 , 44)];
    texTField.textColor = [UIColor colorWithHex:0x999999];
    texTField.placeholder = @"短信验证码";
    texTField.keyboardType = UIKeyboardTypeNumberPad;
    texTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    texTField.delegate = self;
    [viewBg addSubview:texTField];
    [viewBg addSubview:self.btnVerify];
    
    _btmSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btmSubmit.frame = CGRectMake(15, 103, ScreenSize.width - 30, 44);
    _btmSubmit.layer.masksToBounds = YES;
    _btmSubmit.layer.cornerRadius = 6;
    [_btmSubmit setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [_btmSubmit setBackgroundImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateHighlighted];
    [_btmSubmit setTitle:@"下一步" forState:UIControlStateNormal];
    [_btmSubmit addTarget:self action:@selector(buttonSubmit)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btmSubmit];
    
}

-(UIButton *)btnVerify{
    if(!btnVerify){
        btnVerify = [UIButton buttonWithType:UIButtonTypeCustom];
        btnVerify.frame = CGRectMake(ScreenSize.width - 100, 0, 90, 44);
        [btnVerify setTitleColor:[UIColor colorWithHex:0x58b6ee]  forState:UIControlStateNormal];
        [btnVerify setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btnVerify.titleLabel.font = [UIFont systemFontOfSize:16];
        btnVerify.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btnVerify addTarget:self action:@selector(btnVerifyClick)
            forControlEvents:UIControlEventTouchUpInside];
        UILabel *labelVerifyLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 1, 20)];
        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
        labelVerifyLine.alpha = 0.5;
        [btnVerify addSubview:labelVerifyLine];
    }
    return btnVerify;
}

-(void)btnVerifyClick
{
        [btnVerify setTitle:[NSString stringWithFormat:@"正在请求"] forState:UIControlStateNormal];
        //上传
        [self verifyPhone:singleChange.admin_mobile];
}

//短信验证
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
                        [btnVerify setEnabled:YES];
                        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
                    });
                }else{
                    //    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [btnVerify setEnabled:NO];
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




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 6) { //如果输入框内容大于6则弹出警告
        textField.text = [toBeString substringToIndex:6];
        
        [self makeToast:@"验证码最多为6位" duration:1];
        
        return NO;
    }
    
    return YES;
    
}

-(void)buttonLeftClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)buttonSubmit{
    if ([texTField.text length] == 0) {
        [self makeToast:@"请输入验证码" duration:1];
        return;
    }
    [self checkOldPhone:singleChange.admin_mobile andVerifyCode:texTField.text];

}

-(void)checkOldPhone:(NSString *)oldPhone andVerifyCode:(NSString *)verifyCode
{
    [self showHUDSimple];
    [HTTPRequest checkOldPhoneNub:oldPhone verifyCode:verifyCode completeBlock:^(BOOL ok, NSString *message) {
        [self hideHUD];
        if(ok){
            NewPhoneViewController *vc = [NewPhoneViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self makeToast:message duration:1.0];
        }
    }];
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
