//
//  peopleViewController.m
//  HKT
//
//  Created by app on 15-5-27.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "peopleViewController.h"
#import "CalculatorViewController.h"
#import "personViewController.h"
#import "ManagerViewController.h"
#import "SZViewController.h"
#import "ASIFormDataRequest.h"
#import "MyWalletViewController.h"
#import "UserManager.h"
#import "GrabCustomersViewController.h"
#import "SDCycleScrollView.h"
#import "PunchViewController.h"
#import "VIBannerScrollView.h"
#import "SetWebViewController.h"
#import "AdModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Size.h"

#define  imageHeightSize [[UIScreen mainScreen] bounds].size.width * 144 / 320
#define  btnSize [[UIScreen mainScreen] bounds].size.width / 3
#define btnImageSize [[UIScreen mainScreen] bounds].size.width * 44 / 320

@interface peopleViewController ()<UIScrollViewDelegate,VIBannerScrollViewDelegate>
{
    
    UserManager *singlePeople;
    UIScrollView *sc;
    
    VIBannerScrollView *VIBanner;
    NSMutableArray *_dataImageArr;
    
    UIImageView *redRecommand;
    UIImageView *redPunsh;
}
@end

@implementation peopleViewController

// add by wyy
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self buttonWithAdminID:singlePeople.admin_id];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

// add by wyy 3D Touch
-(void)add3DTouchNOtification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchChange:) name:@"3DTouch" object:nil];
}

-(void)touchChange:(NSNotification*)notify
{
    NSString* notiStr = [notify object];
    if ([notiStr isEqualToString:@".Third"]) {
        CalculatorViewController* calculator = [[CalculatorViewController alloc]init];
        [self.navigationController pushViewController:calculator animated:YES];
    }else if ([notiStr isEqualToString:@".First"]){
        GrabCustomersViewController *vc = [GrabCustomersViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([notiStr isEqualToString:@".Second"]){
        ManagerViewController* manager = [[ManagerViewController alloc]init];
        [self.navigationController pushViewController:manager animated:YES];
    }
}

-(void)addTapGesture
{
    UISwipeGestureRecognizer* tapGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLeftClick)];
    tapGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:tapGesture];
}

/***************  add by wyy   ***************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self add3DTouchNOtification];
    
    [self addTapGesture];
    //初始化
    singlePeople = [UserManager shareUserManager];
    _dataImageArr = [[NSMutableArray alloc] init];
    
    redRecommand = [[UIImageView alloc] init];
    redRecommand.backgroundColor = [UIColor redColor];
    redRecommand.layer.masksToBounds = YES;
    redRecommand.layer.cornerRadius = 4;
    
    redPunsh = [[UIImageView alloc] init];
    redPunsh.backgroundColor = [UIColor redColor];
    redPunsh.layer.masksToBounds = YES;
    redPunsh.layer.cornerRadius = 4;
    
    sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sc.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sc];
    
    self.title = @"汇客通";
    
    //左按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"install"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    [self CreatAd];
    [self CreatAllBtn];
    [self changePage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePage:) name:@"changePage" object:nil];
    [self mainWithAdminID:singlePeople.admin_id andPageNumber:@"2"];
    
}

- (void)changePage:(NSNotification*)noti
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    [de removeObjectForKey:@"Pagename"];
    // 接收发送消息的一方附带的参数
    NSString *strPageName = [noti object];
    GrabCustomersViewController *vc = [GrabCustomersViewController new];
    if (strPageName.length != 0) {
         [self.navigationController pushViewController:vc animated:YES];
        }
   
}

-(void)changePage{
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *Pagename = [de stringForKey: @"Pagename"];
    GrabCustomersViewController *vc = [GrabCustomersViewController new];
    if (Pagename.length != 0) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)CreatAd{
    VIBanner = [[VIBannerScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, imageHeightSize)];
    VIBanner.autoScrollTimeInterval = 3;
    VIBanner.delegate = self;
    [self.view addSubview:VIBanner];
}

-(void)CreatAllBtn{
    NSArray *ArrName = @[@"抢客户",@"客户管理",@"签到",@"计算器",@"钱包",@"个人资料",@"",@"",@""];
    
    NSArray *arr = @[@"home_nav_menu1",@"home_nav_menu2",@"home_nav_menu3",@"home_nav_menu4",@"home_nav_menu5",@"home_nav_menu6",@"home_nav_menu_more",@"",@""];
    
    int y = 0;
    
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 3; j ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = 100 + y;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.frame = CGRectMake(btnSize * j,imageHeightSize + btnSize * i, btnSize, btnSize);
            [btn setTitle:[ArrName objectAtIndex:y] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"gray2"] forState:UIControlStateHighlighted];
            [sc addSubview:btn];
            
            UIImageView *imageViewAll = [[UIImageView alloc] initWithFrame:CGRectMake((btnSize - btnImageSize) / 2, (btnSize - btnImageSize) / 2 - 10, btnImageSize, btnImageSize)];
            imageViewAll.image = [UIImage imageNamed:[arr objectAtIndex:y]];
            [btn addSubview:imageViewAll];
            
            btn.titleEdgeInsets = UIEdgeInsetsMake((btnSize - btnImageSize) / 2 + 30, 0, 0, 0);
            
            
            
            UILabel *labelVerticalLine = [[UILabel alloc] initWithFrame:CGRectMake(btnSize - 0.5, 0, 0.5, btnSize)];
            labelVerticalLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
            [btn addSubview:labelVerticalLine];
            
            UILabel *labelHorizontalLine = [[UILabel alloc] initWithFrame:CGRectMake(0, btnSize - 0.5, btnSize, 0.5)];
            labelHorizontalLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
            [btn addSubview:labelHorizontalLine];
            
            if (y == 0) {
                redRecommand.hidden = YES;
                redRecommand.frame = CGRectMake((btnSize - btnImageSize) / 2 + btnImageSize + 2, (btnSize - btnImageSize) / 2 - 10 - 2, 8, 8);
                [btn addSubview:redRecommand];
            }else if(y == 2){
                redPunsh.hidden = YES;
                redPunsh.frame = CGRectMake((btnSize - btnImageSize) / 2 + btnImageSize + 2, (btnSize - btnImageSize) / 2 - 10 - 2, 8, 8);
                [btn addSubview:redPunsh];
            }
            
            y = y + 1;
            if (y == 9 || y == 7 || y == 8) {
                btn.userInteractionEnabled = NO;
            }
            
        }
        
    }
    
    if (ScreenSize.height < imageHeightSize + 64+ btnSize * 3 + 50) {
        sc.contentSize = CGSizeMake(0, imageHeightSize + 64 + btnSize * 3  + 50);
    }
    
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 100) {
        if ([singlePeople.admin_attr isEqualToString:@"2"]) {
            GrabCustomersViewController *vc = [GrabCustomersViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请在个人资料中完成认证" delegate:nil cancelButtonTitle:@"好的，我知道了" otherButtonTitles: nil];
            [alert show];
        }
        
    }else if (btn.tag == 101)
    {
        if ([singlePeople.admin_attr isEqualToString:@"2"]) {
            ManagerViewController *MV = [[ManagerViewController alloc] init];
            [self.navigationController pushViewController:MV animated:YES];
        }else{
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请在个人资料中完成认证" delegate:nil cancelButtonTitle:@"好的，我知道了" otherButtonTitles: nil];
                [alert show];
            }
        
    }else if (btn.tag == 102)
    {
        PunchViewController *pVC = [[PunchViewController alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
        
    }else if (btn.tag == 103)
    {
        CalculatorViewController * calculator = [[CalculatorViewController alloc] init];
        [self.navigationController pushViewController:calculator animated:YES];
        
    }else if (btn.tag == 104)
    {
        MyWalletViewController *wallet = [[MyWalletViewController alloc] init];
        [self.navigationController pushViewController:wallet animated:YES];
        
    }else if (btn.tag == 105)
    {
        personViewController *PV = [[personViewController alloc] init];
        [self.navigationController pushViewController:PV animated:YES];
        
    }
    
}


-(void)mainWithAdminID:(NSString *)adminID andPageNumber:(NSString *)pageNumber{
    
    [HTTPRequest  mainWithAdminID:adminID pageNumber:pageNumber completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        if(ok){
            
            NSArray *imageList = [data objectForKey:@"imgList"];
            for (NSDictionary *subDic in imageList) {
                AdModel *admodel = [[AdModel alloc] init];
                NSString  *imgStr = [subDic objectForKey:@"img"];
                NSString *adStr = [subDic objectForKey:@"url"];
                admodel.imageUrl = imgStr;
                admodel.adUrl = adStr;
                [_dataImageArr addObject:admodel];
                
            }
            NSLog(@"(unsigned long)_dataImageArr.count ===== %lu",(unsigned long)_dataImageArr.count);
            VIBanner.banners = [_dataImageArr copy];
            VIBanner.pageControl.centerX = VIBanner.centerX;
        }else{
            [self makeToast:message duration:1];
        }
        
    }];
    
}

#pragma mark - VIBannerScrollViewDelegate

- (void)bannerScrollView:(VIBannerScrollView *)view willDisplayBanner:(id)banner onImageView:(UIImageView *)imageView {
    
    [imageView sd_setImageWithURL: [NSURL URLWithString:((AdModel *)banner).imageUrl] placeholderImage:[UIImage imageNamed:@"Mainloading"]];
}

- (void)bannerScrollView:(VIBannerScrollView *)view bannerClicked:(id)banner{
    [MobClick event:@"bannerClick"];
    SetWebViewController *vc = [[SetWebViewController alloc]initWithURLStr:((AdModel *)banner).adUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  add by wyy
-(void)buttonLeftClick
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    SZViewController *setting = [[SZViewController alloc]init];
    [self.navigationController pushViewController: setting animated:YES];
}


-(void)buttonWithAdminID:(NSString *)adminID{
    [HTTPRequest  buttonWithAdminID:adminID completeBlock:^(BOOL ok, NSString *message,  BOOL isAddReport , BOOL isSeeRecom,NSString *adminAttr) {
        if(ok){
            
            if (isAddReport) {
                redPunsh.hidden = YES;
                //                redPunsh.backgroundColor = [UIColor clearColor];
            }else{
                redPunsh.hidden = NO;
            }
            if (isSeeRecom) {
                redRecommand.hidden = YES;
            }else{
                redRecommand.hidden = NO;
            }
            NSLog(@"singlePeople.admin_attr === %@",singlePeople.admin_attr);
            singlePeople.admin_attr = adminAttr;
        }
        
    }];
    
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
