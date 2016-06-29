//
//  ReviseCipher.m
//  HKT
//
//  Created by app on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "ReviseCipher.h"

@interface ReviseCipher ()
{
    UserManager *singleRC;
}
@end

@implementation ReviseCipher

- (void)viewDidLoad {
    [super viewDidLoad];
    singleRC = [UserManager shareUserManager];
    UILabel *labelHKT = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 30, 5, 60, 30)];
    labelHKT.textAlignment = NSTextAlignmentCenter;
    labelHKT.text = @"修改密码";
    labelHKT.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelHKT;
    
    //左按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    //背景
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 15, [[UIScreen mainScreen] bounds].size.width, 132)];
    viewBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewBg];
    
   NSArray *arr = @[@"请输入旧密码",@"6-16位数字或字母组合密码",@"确认新密码"];
    for (int i = 0; i < 3; i ++) {
     UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 14 + 44 * i,ScreenSize.width - 20 , 18)];
        textField.secureTextEntry = YES;
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [UIColor blackColor];
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.placeholder = [arr objectAtIndex:i];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.tag = 100 + i;
        textField.delegate = self;
        [viewBg addSubview:textField];
        
        if (i != 2) {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 44 * i + 44, ScreenSize.width - 15, 0.5)];
            labelLine.backgroundColor = [UIColor lightGrayColor];
            labelLine.alpha = 0.5;
            [viewBg addSubview:labelLine];
        }
    }
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.layer.masksToBounds = YES;
    btnSubmit.layer.cornerRadius = 6;
    btnSubmit.frame = CGRectMake(15, 162, [[UIScreen mainScreen] bounds].size.width - 30, 44);
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateHighlighted];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(btnSubmit)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
    
}


-(void)btnSubmit{
    UITextField *textOld = (UITextField *)[self.view viewWithTag:100];
    UITextField *textNew = (UITextField *)[self.view viewWithTag:101];
    UITextField *textYes = (UITextField *)[self.view viewWithTag:102];
    if ([textOld.text isEqualToString: textNew.text]) {
        [self makeToast:@"旧密码不可与新密码一致" duration:1];
        return;
    }
    if (textNew.text.length >= 6) {
        if ([textNew.text isEqualToString:textYes.text]) {
            [self forgetWithAdminID:singleRC.admin_id adminOldpw:textOld.text adminPw:textNew.text];
        }else{
            [self makeToast:@"两次密码不一致" duration:1];
            
        }
    }else{
        [self makeToast:@"密码数不得少于6位或大于16位" duration:1];
    }

}

-(void)forgetWithAdminID:(NSString *)adminID
              adminOldpw:(NSString *)adminOldpw
                 adminPw:(NSString *)adminPw{
    [HTTPRequest forgetWithAdminID:adminID adminOldpw:adminOldpw adminPw:adminPw completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [self makeToast:message duration:1.0];

        if(ok){

            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:@"defaultText2"];
            [def setObject:adminPw forKey:@"defaultText2"];
            [def synchronize];
            singleRC.admin_pw = adminPw;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
        }

    }];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag == 100) {
        res = 11 - [new length];
    }else if(textField.tag == 101){
        res = 16 - [new length];
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


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"])  //按会车可以改变
//    {
//        return YES;
//    }
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//        if ([toBeString length] > 16) { //如果输入框内容大于16则弹出警告
//            textField.text = [toBeString substringToIndex:16];
//            [self makeToast:@"密码最大字数为16位" duration:1];
//
////            [MBProgressHUD showError:@"密码最大字数为16位"];
//            return NO;
//        }
//
//    return YES;
//    
//    
//}

-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
