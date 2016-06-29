//
//  registerViewController.m
//  HKT
//
//  Created by app on 15-5-27.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "registerViewController.h"
#import "STAlertView.h"

#define a [[UIScreen mainScreen] bounds]

@interface registerViewController ()

@property (nonatomic,retain)UIButton *btnVerify;
@property(nonatomic,strong)UIButton *leftButton;

@end

@implementation registerViewController
{
    NSArray *arrURLNeed;
    UIButton *btnYZ;
    NSString * strTime ;
    int _tmp;
    UIImageView *image;
    UserManager *singleRgst;
    dispatch_source_t _timer;
    UILabel *labelVerifyLine;
}

@synthesize btnVerify;
- (void)viewDidLoad {
    [super viewDidLoad];
    strTime = [[NSString alloc] init];
    arrURLNeed = [[NSArray alloc] init];
    arrURLNeed = @[@"admin_truename",@"admin_pw",@"admin_mobile",@"house_name"];
    singleRgst = [UserManager shareUserManager];
    NSLog(@"%f",a.size.width);
    
    self.title = @"注册";
    
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];

    [self CreatRegister];
}

//注册主页面
-(void)CreatRegister
{
    NSArray *arrImage = @[@"register_user",@"register_yzm",@"register_password"];
    NSArray *arrPlaceholder = @[@"请输入您的手机号",@"请输入验证码",@"请输入6-16位数字或字母的密码"];
    UIImageView *imageViewWhite = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 132)];
    imageViewWhite.userInteractionEnabled = YES;
    imageViewWhite.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageViewWhite];
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageAll = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8 + 44 * i, 28, 28)];
        imageAll.image = [UIImage imageNamed:[arrImage objectAtIndex:i]];
        [imageViewWhite addSubview:imageAll];
        
        UITextField *textFieldAll = [[UITextField alloc] initWithFrame:CGRectMake(58, 8 + 44 * i, 200, 28)];
        textFieldAll.tag = 200 + i;
        textFieldAll.delegate = self;
        textFieldAll.placeholder = [arrPlaceholder objectAtIndex:i];
        textFieldAll.font = [UIFont systemFontOfSize:16];
       textFieldAll.keyboardType = UIKeyboardTypeNumberPad;
        textFieldAll.frame = CGRectMake(48, 8 + 44 * i, [[arrPlaceholder objectAtIndex:i] length] * 16, 28);
        if (i == 2) {
            textFieldAll.secureTextEntry = YES;
            textFieldAll.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        [imageViewWhite addSubview:textFieldAll];
        
        if (i != 2) {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 44 * i + 44, ScreenSize.width - 15,0.5)];
            labelLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
            [imageViewWhite addSubview:labelLine];
        }
    }
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 162, a.size.width - 30, 44);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6;
    [btn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateHighlighted];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonRegist)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.btnVerify];
    
}

-(void)buttonLeftClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UIButton *)btnVerify{
    if(!btnVerify){
        btnVerify = [UIButton buttonWithType:UIButtonTypeCustom];
        btnVerify.frame = CGRectMake(ScreenSize.width - 100, 15 + 44 + 8, 90, 28);
        [btnVerify setTitleColor:[UIColor colorWithHex:0x58b6ee]  forState:UIControlStateNormal];
        [btnVerify setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btnVerify.titleLabel.font = [UIFont systemFontOfSize:16];
        btnVerify.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btnVerify addTarget:self action:@selector(btnVerifyClick)
            forControlEvents:UIControlEventTouchUpInside];
        labelVerifyLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 1, 20)];
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
        [self verifyPhone:textPhone.text];
    }
}

-(void)buttonRegist
{
    NSArray *arrTips = @[@"请输入手机号码",@"请输入验证码",@"请输入密码"];
    for (int j = 0; j < 3; j ++)
    {
        UITextField *textFieldRegist = (UITextField *)[self.view viewWithTag:200 + j];
        if (textFieldRegist.text.length == 0) {
            [self makeToast:[arrTips objectAtIndex:j] duration:1];
            return;
        }
    }
    
    
    UITextField *textFieldVirify = (UITextField *)[self.view viewWithTag:201];
    UITextField *textFieldPW = (UITextField *)[self.view viewWithTag:202];
    
    if ([textFieldPW.text length] < 6 || [textFieldPW.text length] > 16) {
        
        [self makeToast:@"密码数不得少于6位或大于16位" duration:1];
        
    }
    else
    {
        UITextField *textCipher = (UITextField *)[self.view viewWithTag:202];
        UITextField *textPhone = (UITextField *)[self.view viewWithTag:200];
//        if ([memoryPhone isEqualToString:textPhone.text]) {
            [self registerTextTureName:@"" andTextPhone:textPhone.text andTextCipher:textCipher.text andTextHouseName:@"" andVerifyCode:textFieldVirify.text];
//        }else{
//            
//            [self makeToast:@"手机号错误" duration:1];
//        }
    }

}

-(void)registerTextTureName:(NSString *)textTureName andTextPhone:(NSString *)textPhone andTextCipher:(NSString *)textCipher andTextHouseName:(NSString *)textHouseName andVerifyCode:(NSString *)verifyCode{
    
    [self showHUDSimple];
    [HTTPRequest registerWithTextTureName:textTureName TextPhone:textPhone TextCipher:textCipher TextHouseName:textHouseName andVerifyCode:verifyCode  completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [self hideHUD];
        if(ok){
            NSLog(@"成功data == %@",data);
            UITextField *textField1 = (UITextField *)[self.view viewWithTag:200];
            UITextField *textField2 = (UITextField *)[self.view viewWithTag:202];
            
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de removeObjectForKey:@"defaultText1"];
            [de setObject:textField1.text forKey:@"defaultText1"];
            [de synchronize];
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:@"defaultText2"];
            [def setObject:textField2.text forKey:@"defaultText2"];
            [def synchronize];
            singleRgst.number = @"1";
            
            [STAlertView showTitle:@"注册成功!" message:data[@"rewardMoney"] hideDelay:2.0];
            [self.navigationController popViewControllerAnimated:NO];
            self.finishBlock(textField1.text,textField2.text);
        }else{
            [self makeToast:message duration:1];
            
        }
        
    }];
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
                        labelVerifyLine.backgroundColor = [UIColor colorWithHex:0x58b6ee];
                        [btnVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag == 200) {
        res = 11 - [new length];
    }else if(textField.tag == 201)
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



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableString *toBeString = [NSMutableString stringWithFormat:@"%@",textField.text];
    if (textField.tag == 200) {
        if ([textField.text length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            [self makeToast:@"手机号的最大位数为11位" duration:1];
            
        }
    }else if (textField.tag == 201) {
        
        if ([textField.text length] > 6) {
            textField.text = [toBeString substringToIndex:6];
            [self makeToast:@"验证码的最大位数为6位" duration:1];
            
        }
    }else if (textField.tag == 202) {
        
        if ([textField.text length] > 16) {
            textField.text = [toBeString substringToIndex:16];
            [self makeToast:@"密码的最大位数为16位" duration:1];
            
        }
    }
    
    [textField resignFirstResponder];
    
    if (textField.tag == 200||textField.tag == 201) {
        NSString *validRegEx =@"^[0-9]*$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:textField.text];
        
        if (myStringMatchesRegEx){
            
            
        }
        else
            
        {
            [self makeToast:@"只能输入数字" duration:1];
            
            //            [MBProgressHUD showError:@"只能输入数字"];
            textField.text = @"";
            
        }
    }
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//    {
//        return YES;
//    }
//
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//
//    if (textField.tag == 204)  //判断是否时我们想要限定的那个输入框
//    {
//        if ([toBeString length] > 8) { //如果输入框内容大于20则弹出警告
//            textField.text = [toBeString substringToIndex:8];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"姓名最大字数为8位" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//    }else if (textField.tag == 202){
//
//        if ([toBeString length] > 16) { //如果输入框内容大于20则弹出警告
//            textField.text = [toBeString substringToIndex:16];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"密码最大字数为16位" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//
//    }else if (textField.tag == 200){
//
//        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
//            textField.text = [toBeString substringToIndex:11];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"手机号的最大字数为11位" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//
//    }else if (textField.tag == 201){
//
//        if ([toBeString length] > 6) { //如果输入框内容大于20则弹出警告
//            textField.text = [toBeString substringToIndex:6];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"验证码的最大字数为6位" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//
//    }else if (textField.tag == 203){
//
//        if ([toBeString length] > 20) { //如果输入框内容大于20则弹出警告
//            textField.text = [toBeString substringToIndex:20];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"楼盘名称最大字数为20位" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return NO;
//        }
//
//    }
//
//
//
//    return YES;
//
//}


//
//- (void)registerForKeyboardNotifications
//{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
//}

//- (void)keyboardWillShow:(NSNotification*)notify
//{
//    NSDictionary *info = [notify userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//
//    //    NSLog(@"keyBoard:%f", [[UIScreen mainScreen] bounds].size.height - (keyboardSize.height + _tmp * 40 + 40 + 64));
//    //    NSLog(@"____~~~~~~%d",_tmp);
//
//    if (keyboardSize.height + _tmp * 40 + 80 + 69 > [[UIScreen mainScreen] bounds].size.height) {
//        [UIView animateWithDuration:0.25
//                         animations:^{
//
//                             self.view.frame = CGRectMake(0 , [[UIScreen mainScreen] bounds].size.height - keyboardSize.height - _tmp * 40 - 154, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//
//                         }];
//
//    }
//}
//
//- (void)keyboardWillHidden:(NSNotification*)notify
//{
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         self.view.frame = CGRectMake(0, 65, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//                     }];
//}
//


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
