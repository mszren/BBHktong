//
//  PasswordViewController.m
//  HKT
//
//  Created by app on 15/10/27.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "PasswordViewController.h"
#import "IQKeyboardManager.h"


@interface PasswordViewController ()<UITextViewDelegate>
{
    UITextView *TV;
}
@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *labelHKT = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, 60, 30)];
    labelHKT.text = @"意见反馈";
    labelHKT.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelHKT;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"01"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];

    TV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 350)];
    TV.keyboardType = UIKeyboardTypeNamePhonePad;
    TV.backgroundColor = [UIColor clearColor];
    TV.delegate = self;
    TV.hidden = YES;
    [TV becomeFirstResponder];
    [self.view addSubview:TV];
    //label宽
    int labelWidth = ([[UIScreen mainScreen] bounds].size.width - 40 - 15 * 5) / 6;
    for (int i = 0; i < 6; i ++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20 + (labelWidth + 15) * i, 40, labelWidth, 40)];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tag = 100 + i;
        textField.secureTextEntry = YES;
        textField.userInteractionEnabled = NO;
        textField.backgroundColor = [UIColor greenColor];
        [self.view addSubview:textField];
//        UILabel *labelPassWord = [[UILabel alloc] initWithFrame:CGRectMake(20 + (labelWidth + 15) * i, 40, labelWidth, 40)];
//        labelPassWord.textAlignment = NSTextAlignmentCenter;
//        labelPassWord.tag = 100 + i;
//        labelPassWord.backgroundColor = [UIColor greenColor];
//        [self.view addSubview:labelPassWord];
    }
 
}

- (BOOL)textView:(UITextView *)atextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *new = [atextView.text stringByReplacingCharactersInRange:range withString:text];
    //长度为六是请求数据
    if ([new length] == 6) {
        
    }
    //删除制空
    UITextField *textFieldAll = (UITextField *)[self.view viewWithTag:100 + [new length] - 1];
    if (new.length == 0) {
        UITextField *textFieldNull = (UITextField *)[self.view viewWithTag:100];
        textFieldNull.text = @"";
    }else {
        textFieldAll.text =  [new substringFromIndex:new.length - 1];
        for (int j = [new length]; j < 6; j ++) {
            UITextField *textFieldAllDelete = (UITextField *)[self.view viewWithTag:100 + j];
            textFieldAllDelete.text = @"";
        }
    }
    
    //限制字数
    NSInteger res = 6 -[new length];
        if(res >= 0){
            return YES;
        }
        else{
            NSRange rg = {0,[text length]+res};
            if (rg.length>0) {
                NSString *s = [text substringWithRange:rg];
                [atextView setText:[atextView.text stringByReplacingCharactersInRange:range withString:s]];
            }
    
            return NO;
        }
}

-(void)btnLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
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
