//
//  opinionViewController.m
//  HKT
//
//  Created by app on 15-6-5.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "opinionViewController.h"
#import "UserManager.h"

@interface opinionViewController ()<UIScrollViewDelegate>
{
    UILabel *labelUP;
    UILabel *labelCount;
    UITextField *textField;
    UITextView *textView;
    int _temp;
    UIButton *btn;
    UserManager *singleOpinion;
}
@property(nonatomic,strong)UIButton *leftButton;

@end

@implementation opinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    singleOpinion = [UserManager shareUserManager];
    self.title = @"意见反馈";
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];

    //输入
    UIView *opinionView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenSize.width, 200)];
    opinionView.backgroundColor = [UIColor whiteColor];
    opinionView.userInteractionEnabled = YES;
    [self.view addSubview:opinionView];
    
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor darkGrayColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    [opinionView addSubview:textView];
    
    
    labelUP = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 200, 30)];
    labelUP.enabled = NO;
    labelUP.text = @"请填写您的宝贵意见";
    labelUP.alpha = 0.5;
    labelUP.font = [UIFont systemFontOfSize:16];
    labelUP.textColor =[UIColor blueColor];
    [textView addSubview:labelUP];
    
    //字数
    labelCount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenSize.width - 45, 170, 40, 20)];
    //[labelCount setHidden:YES];
    labelCount.enabled = NO;
    labelCount.text = @"100";
    labelCount.font = [UIFont systemFontOfSize:13];
    labelCount.textColor = [UIColor darkGrayColor];
    [opinionView addSubview:labelCount];
    
    
    //联系方式
    
    UIView *feildView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, ScreenSize.width, 50)];
    feildView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:feildView];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, ScreenSize.width-20, 40)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textColor = [UIColor darkGrayColor];
    textField.text = singleOpinion.admin_mobile;
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = self;
    [feildView addSubview:textField];
    
    
    //提交
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 295, ScreenSize.width - 30, 50);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_disable"] forState:UIControlStateNormal];
    [btn setTitle:@"提    交" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick)
  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

-(void)btnClick
{
    if ([textView.text length] == 0) {
        [self makeToast:@"请输入您的意见" duration:1];
    }else if([textField.text length] == 0){
        [self makeToast:@"请输入手机号码" duration:1];
    }else{
        [self opinionWithPhone:textField.text andContent:textView.text andFrom:@"apple"];
    }
}

-(void)opinionWithPhone:(NSString *)phone andContent:(NSString *)content andFrom:(NSString *)From{
    
    [HTTPRequest opinionWithPhone:phone Content:content From:From completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        
        if(ok){
            [self makeToast:@"提交成功" duration:1];
            
            //            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self makeToast:message duration:1];
            
            //            [MBProgressHUD showError:message];
            
        }
        
    }];
    
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"建立连接");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textViewDidChange:(UITextView *)textView1
{
    if ([textView1.text length] == 0) {
        [labelUP setHidden:NO];
        btn.userInteractionEnabled = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
    }else{
        [labelUP setHidden:YES];
        btn.userInteractionEnabled = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];

    }
    
    if (textView1.text.length <= 100) {
        labelCount.text = [NSString stringWithFormat:@"%lu",100 - (unsigned long)textView1.text.length];
    }else{
        NSRange rg = {0,100};
        textView.text = [textView1.text substringWithRange:rg];
        NSLog(@"textView.text ==== %@",textView.text);
        labelCount.text = @"0";
    
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    _temp = 0;
    return YES;
}

- (BOOL)textView:(UITextView *)atextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *new = [atextView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 100-[new length];
    if(res >= 0){
        return YES;
    }else{

        return NO;
    }
}

-(void)btnLeftClick{
    
    if ([textView.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您确定要放弃编辑吗？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
        alert1.tag = 111;
        alert1.delegate = self;
        [alert1 show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



//-(void)btnLeftClick
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
        [self makeToast:@"手机号最大字数为11位" duration:1];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _temp = 10;
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
