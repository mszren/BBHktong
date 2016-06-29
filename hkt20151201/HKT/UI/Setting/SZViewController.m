//
//  SZViewController.m
//  HKT
//
//  Created by app on 15-6-4.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "SZViewController.h"
#import "ReviseCipher.h"
#import "ourCompanyViewController.h"
#import "opinionViewController.h"
#import "ShareTemplate.h"
#import "realizeViewController.h"
#import "SetWebViewController.h"

@interface SZViewController ()
{
    UserManager *singleSZ;
    UIScrollView *sc;
}
@property(nonatomic,strong)UIButton *leftButton;

@end

@implementation SZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    singleSZ = [UserManager shareUserManager];
    UILabel *labelHKT = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 30, 5, 60, 30)];
    labelHKT.textAlignment = NSTextAlignmentCenter;
    labelHKT.text = @"设置";
    labelHKT.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelHKT;
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    //背景
    sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sc.backgroundColor = [UIColor colorWithRed:240/255.0f green:242/255.0f blue:245/255.0f alpha:1];
    sc.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sc];
    
    
    UIView *pushviewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenSize.width, 44)];
    pushviewBg.backgroundColor = [UIColor whiteColor];
    [sc addSubview:pushviewBg];
    
    //消息推送
    UIImageView *pushImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    pushImage.image = [UIImage imageNamed:@"set_icon1"];
    [pushviewBg addSubview:pushImage];
    
    UILabel *pushLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 20)];
    pushLabel.text = @"消息通知设置";
    [pushviewBg addSubview:pushLabel];
    
    UISwitch *st = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70, 7, 70, 30)];
    //拉缩
    st.transform = CGAffineTransformMakeScale( 1.00, 0.90);
    st.onTintColor = [UIColor colorWithHex:0x70da65];
    st.on = YES;
    [st addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pushviewBg addSubview: st];
    int y = 0;
    NSArray *arrName = @[@"登录密码",@"关于我们",@"了解汇客通",@"使用帮助",@"意见反馈",@"告诉好友",@"给我打分"];
    NSArray *arrP = @[@"set_icon2",@"set_icon3",@"set_icon4",@"set_icon5",@"set_icon6",@"set_icon7",@"set_icon8"];
    for (int i = 0; i < 7; i ++) {
        
       
        if (i == 1||i == 3 || i == 4) {
            y = y + 1;
        }
        NSLog(@"y ==== %d",y);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 59 + 44 * i + 15 * y,  ScreenSize.width, 45);
        
        btn.tag = 250 + i;
        [btn setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gray2"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnALLClick:) forControlEvents:UIControlEventTouchUpInside];
        [sc addSubview:btn];
        
        
        if (i == 0 || i == 2 ||i == 5|| i == 6 ) {
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(60, 44 * (1 + i)+ 15 * (y+1), ScreenSize.width - 60, 0.5)];
            labelLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
            [sc addSubview:labelLine];
        }
        
        UIImageView *imageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width - 30, 14, 8, 16)];
        imageArrow.image = [UIImage imageNamed:@"arrow"];
        [btn addSubview:imageArrow];
        
        
        UIImageView *imageAll = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 26, 26)];
        imageAll.image = [UIImage imageNamed:[arrP objectAtIndex:i]];
        [btn addSubview:imageAll];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 200, 20)];
        labelName.text = [NSString stringWithFormat:@"%@",[arrName objectAtIndex:i]];
        [btn addSubview:labelName];
    }
    
    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnExit.frame = CGRectMake(0, 430, ScreenSize.width, 44);
    [btnExit setTitle:@"退    出" forState:UIControlStateNormal];
    [btnExit setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
    [btnExit setBackgroundImage:[UIImage imageNamed:@"gray2"] forState:UIControlStateHighlighted];
    [btnExit addTarget:self action:@selector(btnExitClick) forControlEvents:UIControlEventTouchUpInside];
    [btnExit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sc addSubview:btnExit];
    
    if (ScreenSize.height < 560) {
        sc.contentSize = CGSizeMake(0, 580);
    }
    
}

-(void)btnExitClick{
    NSArray *arr =  self.navigationController.viewControllers;
    //通过数组取到第一个视图控制器
    UIViewController *vc = [arr objectAtIndex:0];
    //直接返回到第二个视图控制器（会把其他对象从栈容器中移除，每个引用计数-1）
    [self.navigationController popToViewController:vc animated:NO];
    singleSZ.number = @"0";
}

-(void)switchValueChanged:(UISwitch *)Switch {
    
    if (Switch.on == 1) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
}

-(void)btnALLClick:(UIButton *)btn
{
    if (btn.tag == 250) {
        ReviseCipher *rpw = [[ReviseCipher alloc] init];
        [self.navigationController pushViewController:rpw animated:YES];
        
    }else if(btn.tag == 251){
        ourCompanyViewController *OC = [[ourCompanyViewController alloc] init];
        [self.navigationController pushViewController:OC animated:YES];
        
    }else if(btn.tag == 254){
        opinionViewController *OVC = [[opinionViewController alloc] init];
        [self.navigationController pushViewController:OVC animated:YES];
        
    }else if(btn.tag == 255){
        
        ShareModel *shareModel = [ShareModel new];
        shareModel.shareTitle = @"汇客通，让卖房更轻松,快来下载吧";
        shareModel.shareContent = @"告诉你个增加卖房销量的好东西，安装汇客通，卖房赚钱就是这么轻松";
        shareModel.shareImageURL =nil;
//        NSString *url =[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",AppStoreID];
        shareModel.shareWebURL = @"http://app.berui.com/hkt";
        ShareTemplate  *shareTemplate = [ShareTemplate new];
        [shareTemplate actionWithShare:self WithSinaModel:shareModel andMessageTypeIsImage:NO];
        
    }else if(btn.tag == 256){
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",AppStoreID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];        
    }else if(btn.tag == 253){
            SetWebViewController *vc = [[SetWebViewController alloc]initWithURLStr:[NSString stringWithFormat:@"%@index.php/Hkt/V1/help",kBasePort]];
            [self.navigationController pushViewController:vc animated:YES];
    }else{
        realizeViewController *real = [[realizeViewController alloc] init];
        [self.navigationController pushViewController:real animated:YES];
    }
}

-(void)buttonLeftClick
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
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
