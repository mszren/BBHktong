//
//  NewPhoneViewController.m
//  HKT
//
//  Created by app on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "NewPhoneViewController.h"
#import "personViewController.h"
#import "UserManager.h"
#import "HTTPRequest+person.h"

@interface NewPhoneViewController ()
{
    UITextField *textfieldPhone;
    UITextField * texTFieldCode;
    UserManager *singleNP;
    dispatch_source_t _timer;
    NSString * strTime ;
    UILabel *labelVerifyLine;
}
@property(nonatomic,strong)UIButton *leftButton;
@property (nonatomic,retain)UIButton *btnVerify;
@property(nonatomic,strong)UIButton *btmSubmit;

@end

@implementation NewPhoneViewController
@synthesize btnVerify;

- (void)viewDidLoad {
    [super viewDidLoad];
    singleNP = [UserManager shareUserManager];
    self.title = @"确认手机号码";
    strTime = [[NSString alloc] init];

    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];

//    
//    //右按钮
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    rightButton.frame = CGRectMake(0, 0, 44, 44);
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    [self addRightBarButtonItem:rightBarButtonItem];

    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenSize.width, 44)];
    viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTop];
    
    textfieldPhone = [[UITextField alloc] initWithFrame:CGRectMake(15, 0,ScreenSize.width - 120 , 44)];
    textfieldPhone.placeholder = @"请输入新的手机号码";
    textfieldPhone.textColor = [UIColor colorWithHex:0x999999];
    textfieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    textfieldPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfieldPhone.delegate = self;
    [viewTop addSubview:textfieldPhone];
    
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 74, ScreenSize.width, 44)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBottom];
    [viewBottom addSubview:self.btnVerify];
    
    texTFieldCode = [[UITextField alloc] initWithFrame:CGRectMake(15, 0,ScreenSize.width - 120 , 44)];
    texTFieldCode.placeholder = @"短信验证码";
    texTFieldCode.textColor = [UIColor colorWithHex:0x999999];
    texTFieldCode.keyboardType = UIKeyboardTypeNumberPad;
    texTFieldCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    texTFieldCode.delegate = self;
    [viewBottom addSubview:texTFieldCode];
    
    _btmSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btmSubmit.frame = CGRectMake(15, 133, ScreenSize.width - 30, 44);
    _btmSubmit.layer.masksToBounds = YES;
    _btmSubmit.layer.cornerRadius = 6;
    [_btmSubmit setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [_btmSubmit setBackgroundImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateHighlighted];
    [_btmSubmit setTitle:@"确认" forState:UIControlStateNormal];
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
        labelVerifyLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 1, 20)];
        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
        labelVerifyLine.alpha = 0.5;
        [btnVerify addSubview:labelVerifyLine];
    }
    return btnVerify;
}

-(void)btnVerifyClick
{
    UITextField *textPhone = (UITextField *)[self.view viewWithTag:200];
    if ([textPhone.text  isEqual: @""]) {
        [self makeToast:@"请输入手机号" duration:1];
    }else{
        
        [btnVerify setTitle:[NSString stringWithFormat:@"正在请求"] forState:UIControlStateNormal];
        //上传
        [self verifyPhone:textfieldPhone.text];
    }
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
                        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
                        [btnVerify setEnabled:YES];
                        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
                    });
                }else{
                    //    int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        labelVerifyLine.backgroundColor = [UIColor lightGrayColor];
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableString *toBeString = [NSMutableString stringWithFormat:@"%@",textField.text];
    if (textField == textfieldPhone) {
        if ([textField.text length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            [self makeToast:@"手机号最多为11位" duration:1];

        }else if([textField.text length] < 11){
            [self makeToast:@"手机号为11位" duration:1];

        }
    }else if (textField == texTFieldCode) {
        if ([textField.text length] > 6) {
            textField.text = [toBeString substringToIndex:6];
            [self makeToast:@"验证码最多为6位" duration:1];
 
        }else if([textField.text length] < 4){
            [self makeToast:@"验证码最少为4位" duration:1];

        }
    }
}


-(void)buttonLeftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonSubmit{
    if ([texTFieldCode.text length] == 0) {
        [self makeToast:@"请输入验证码" duration:1];
        return;
    }
    
    if (textfieldPhone.text.length != 11) {
        [self makeToast:@"手机号为11位" duration:1];
        return;
    }
    
    [self changeWithPhone:textfieldPhone.text adminID:singleNP.admin_id verifyCode:texTFieldCode.text];
    
}

-(void)changeWithPhone:(NSString *)phone1
               adminID:(NSString *)adminID
            verifyCode:(NSString *)verifyCode

{
    
    [self showHUDSimple];
    [HTTPRequest changeWithPhone:phone1 adminID:adminID verifyCode:verifyCode completeBlock:^(BOOL ok, NSString *message, NSDictionary *dic) {
        [self hideHUD];
        if (ok) {
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de removeObjectForKey:@"defaultText1"];
            [de setObject:phone1 forKey:@"defaultText1"];
            [de synchronize];
            singleNP.admin_mobile = phone1;
            
            [self makeToast:@"修改成功" duration:1];
            
            NSArray *arr =  self.navigationController.viewControllers;
            //通过数组取到第一个视图控制器
            UIViewController *vc = [arr objectAtIndex:arr.count - 3];
            //直接返回到第二个视图控制器（会把其他对象从栈容器中移除，每个引用计数-1）
            [self.navigationController popToViewController:vc animated:NO];
        }else{
            [self makeToast:message duration:1];
        }
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
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
