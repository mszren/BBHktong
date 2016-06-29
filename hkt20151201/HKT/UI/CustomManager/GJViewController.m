//
//  GJViewController.m
//  HKT
//
//  Created by app on 15-7-3.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "GJViewController.h"
#import "STAlertView.h"

@interface GJViewController ()
{
    UserManager *singleGJ;
    UILabel *labelName;
    UILabel *labelThinktext;
    NSString *strState;
    NSString *contentText;
    UITextView *textView;
    UILabel *labelUP;
    NSString *customer_id;
    UIAlertView  *alert;
    UIButton *leftButton;
    UIButton *rightButton;
}
@end

@implementation GJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户跟进";
    
    customer_id = [[NSString alloc] init];
    contentText = [[NSString alloc] init];
    contentText = @"";
    strState = [[NSString alloc] init];
    strState = @"";
    singleGJ = [UserManager shareUserManager];
    
    leftButton = [self getBackButton];
    [leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    //右按钮
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44, 44);

    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self addRightBarButtonItem:rightBarButtonItem];

    labelName = [[UILabel alloc] init];
    labelName.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:labelName];
    
    labelThinktext = [[UILabel alloc] init];
    labelThinktext.font = [UIFont systemFontOfSize:15];
    labelThinktext.textAlignment = NSTextAlignmentCenter;
    labelThinktext.layer.masksToBounds = YES;
    labelThinktext.layer.cornerRadius = 4;
    [self.view addSubview:labelThinktext];
    
    UIImageView *imageViewGJ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 100)];
    imageViewGJ.backgroundColor = [UIColor whiteColor];
    imageViewGJ.userInteractionEnabled = YES;
    
    UILabel *labelImage = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 20)];
    labelImage.text = @"跟进状态";
    labelImage.font = [UIFont systemFontOfSize:16];
    [imageViewGJ addSubview:labelImage];
    NSArray *arrState = @[@"到访",@"认筹",@"认购"];
    for (int i = 0; i < 3; i ++) {
        UIButton * btnState = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnState.frame = CGRectMake(self.view.frame.size.width / 2 - 20 - 75 + i * 70, 30, 50, 50);
        btnState.layer.masksToBounds = YES;
        btnState.layer.cornerRadius = 25;
        [btnState setTitle:[arrState objectAtIndex:i] forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1]];
        [btnState setTintColor:[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1]];
        [btnState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnState setBackgroundImage:[UIImage imageNamed:@"001(1)"] forState:UIControlStateSelected];
        [btnState addTarget:self action:@selector(btnStateClick:) forControlEvents:UIControlEventTouchUpInside];
        btnState.tag = 133 + i;
        [imageViewGJ addSubview:btnState];
    }
    
    
    UIImageView *imageViewContent = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 75)];
    imageViewContent.backgroundColor = [UIColor whiteColor];
    imageViewContent.userInteractionEnabled = YES;
    
    UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 20)];
    labelContent.text = @"跟进内容";
    labelContent.font = [UIFont systemFontOfSize:14];
    [imageViewContent addSubview:labelContent];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(70, 0, self.view.frame.size.width-75, 70)];
    textView.font = [UIFont systemFontOfSize:14];
    textView.delegate = self;
    
    labelUP = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 200, 30)];
    labelUP.enabled = NO;
    labelUP.text = @"请输入跟进内容";
    labelUP.font = [UIFont systemFontOfSize:14];
    labelUP.textColor =[UIColor darkGrayColor];
    
    [textView addSubview:labelUP];
    [imageViewContent addSubview:textView];
    [self.view addSubview:imageViewContent];
    [self.view addSubview:imageViewGJ];
    [self loadURL];
}


-(void)loadURL
{

    [self GJWithAdminID:singleGJ.admin_id  CustomerID:[singleGJ.tvArr objectAtIndex:singleGJ.btnTag - 155]];
}

-(void)GJWithAdminID:(NSString *)adminID
          CustomerID:(NSString *)customerID{
    [HTTPRequest GJWithAdminID:adminID CustomerID:customerID completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(ok){

            NSDictionary *customerInfo = [data objectForKey:@"customerInfo"];
            customer_id = [customerInfo objectForKey:@"customer_id"];
            labelName.text = customerInfo[@"customer_name"];
            labelName.frame = CGRectMake(5, 10, [labelName.text length] * 16, 20);
            labelThinktext.textColor = [UIColor whiteColor];
            labelThinktext.frame = CGRectMake([labelName.text length] * 16 + 15, 10, 70, 20);

            
            if ([customerInfo[@"followText"] isEqualToString:@"已到访"]) {
                labelThinktext.backgroundColor = [UIColor colorWithRed:127/255.0f green:195/255.0f blue:103/255.0f alpha:1];
                labelThinktext.text = @"已到访";
            }else if([customerInfo[@"followText"] isEqualToString:@"认筹"]){
                labelThinktext.backgroundColor = [UIColor colorWithRed:0/255.0f green:185/255.0f blue:237/255.0f alpha:1];
                UIButton *btnUnCome = (UIButton *)[self.view viewWithTag:133];
                btnUnCome.userInteractionEnabled=NO;
                UIButton *btnUnFrom = (UIButton *)[self.view viewWithTag:134];
                btnUnFrom.userInteractionEnabled=NO;
                labelThinktext.text = @"认筹";
            }else if([customerInfo[@"followText"] isEqualToString:@"认购"]){
                labelThinktext.backgroundColor = [UIColor colorWithRed:0/255.0f green:154/255.0f blue:219/255.0f alpha:1];
                UIButton *btnUnCome = (UIButton *)[self.view viewWithTag:133];
                btnUnCome.userInteractionEnabled=NO;
                UIButton *btnUnFrom = (UIButton *)[self.view viewWithTag:134];
                btnUnFrom.userInteractionEnabled=NO;
                UIButton *btnBuy = (UIButton *)[self.view viewWithTag:135];
                btnBuy.userInteractionEnabled=NO;
                labelThinktext.text = @"认购";
            }else{
                labelThinktext.backgroundColor = [UIColor colorWithRed:241/255.0f green:187/255.0f blue:16/255.0f alpha:1];
                labelThinktext.text = @"未到访";
            }
            [labelThinktext setTextAlignment:NSTextAlignmentCenter];

            
        }else{
            [self makeToast:message duration:1];

//            [MBProgressHUD showError:message];

        }
        
    }];

}



#pragma mark  - 认筹、到访点击

-(void)btnStateClick:(UIButton *)btnStateClick
{
    UIButton *btnSelect1 = (UIButton *)[self.view viewWithTag:133];
    UIButton *btnSelect2 = (UIButton *)[self.view viewWithTag:134];
    UIButton *btnSelect3 = (UIButton *)[self.view viewWithTag:135];
    if (btnStateClick.tag == 133) {
        labelThinktext.backgroundColor = [UIColor colorWithRed:127/255.0f green:195/255.0f blue:103/255.0f alpha:1];
        labelThinktext.text = @"已到访";
        btnSelect1.selected = YES;
        btnSelect2.selected = NO;
        btnSelect3.selected = NO;
        strState = @"4";
       // strState = btnSelect1.titleLabel.text;
    }else  if (btnStateClick.tag == 134) {
        labelThinktext.backgroundColor = [UIColor colorWithRed:0/255.0f green:185/255.0f blue:237/255.0f alpha:1];
        labelThinktext.text = @"认筹";
        btnSelect2.selected = YES;
        btnSelect1.selected = NO;
        btnSelect3.selected = NO;
        strState = @"9";
       // strState = btnSelect2.titleLabel.text;
    }else{
        labelThinktext.backgroundColor = [UIColor colorWithRed:0/255.0f green:154/255.0f blue:219/255.0f alpha:1];
        
        labelThinktext.text = @"认购";
        btnSelect3.selected = YES;
        btnSelect1.selected = NO;
        btnSelect2.selected = NO;
        strState = @"7";
      //  strState = btnSelect3.titleLabel.text;
    }
    
    NSLog(@"strState == %@",strState);

}



-(void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text length] == 0) {
        [labelUP setHidden:NO];
    }else{
        [labelUP setHidden:YES];
        }

///////////textView.text
    
    contentText = textView.text;
}


#pragma mark  - 返回、保存


-(void)buttonLeftClick{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

-(void)buttonRightClick
{
    if ([strState isEqualToString:@""]) {
        [self makeToast:@"至少输入一个状态" duration:1];
//        [MBProgressHUD showError:@"至少输入一个状态"];
        }else{
            rightButton.userInteractionEnabled = NO;
    [self GJWithAdminID:singleGJ.admin_id followID:strState customID:customer_id content:contentText];
    
    }
    
}

-(void)GJWithAdminID:(NSString *)adminID followID:(NSString *)followID customID:(NSString *)customID content:(NSString *)content{
    [HTTPRequest GJWithAdminID:adminID followID:followID customID:customID content:content completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        
        if(ok){

            if ([data[@"rewardMoney"] length] == 0) {
                
            }else{
            [STAlertView showTitle:@"跟进成功!" message:data[@"rewardMoney"] hideDelay:2.0];
            }
            [self.navigationController popViewControllerAnimated:YES];
//            rightButton.userInteractionEnabled = YES;
        }else{
//            [MBProgressHUD showError:message];
            [self makeToast:message duration:1];
            rightButton.userInteractionEnabled = YES;
        }
        
    }];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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
