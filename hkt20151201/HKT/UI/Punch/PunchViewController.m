//
//  PunchViewController.m
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "PunchViewController.h"
#import "iCarousel.h"
#import "UIColor+Hex.h"
#import "HTTPRequest+Punch.h"
#import "HTTPRequest+main.h"
#import "UserManager.h"
#import "UIImageView+WebCache.h"
#import "MoodModel.h"
#import "STAlertView.h"
#import "ShareTemplate.h"
#import "PureColorToImage.h"
#import "PunchItem.h"

@interface PunchViewController ()<iCarouselDataSource, iCarouselDelegate>{
    
    NSArray *dataSourceArray;
    
}

//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation PunchViewController
@synthesize icarousel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readyView];
    [self readyDataSource];
    
    // Do any additional setup after loading the view from its nib.
}

- (UIColor *)myViewBackgroundColor {
    return [UIColor colorWithHex:0xf5fafe];
}

-(void)readyView{
    
    UIImage *imgBtn     = [UIImage imageNamed:@"sign"];
    UIImage *imgBtnHigh = [UIImage imageNamed:@"sign_pre"];
    UIImage *imgBtndis  = [UIImage imageNamed:@"sign_disable"];
    
    [_btnSubmit setBackgroundImage:[imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20 , 20, 20)] forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:[imgBtnHigh resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20 , 20, 20)] forState:UIControlStateHighlighted];
    [_btnSubmit setBackgroundImage:[imgBtndis resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20 , 20, 20)] forState:UIControlStateDisabled];
    
 
    icarousel.backgroundColor = self.myViewBackgroundColor;
    // icarousel.contentOffset = CGSizeMake(0, -20);
    icarousel.type = iCarouselTypeCylinder;
    
    [self setupNaviagionBar];
}

-(void)readyDataSource{
    
    [self showHUDSimple];
    [HTTPRequest getMoodListWithAdminId:[UserManager shareUserManager].admin_id completeBlock:^(BOOL ok, NSString *message, NSArray *arrayForMoodList) {
        if(ok){
            dataSourceArray = arrayForMoodList;
            [icarousel reloadData];
            [self checkPunch];
        }else {
            [self makeToast:message duration:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//检测是否能够签到
-(void)checkPunch{
    
    [HTTPRequest  buttonWithAdminID:[UserManager shareUserManager].admin_id completeBlock:^(BOOL ok, NSString *message,  BOOL isAddReport , BOOL isSeeRecom,NSString *adminAttr) {
        [self hideHUD];
        if(ok){
            if (isAddReport) {
                [_btnSubmit setEnabled:NO];
            }else {
                
                [_btnSubmit setEnabled:YES];
            }
        }else {
            [self makeToast:message duration:1.0];
            
        }
    }];
}

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
    [self addRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.shareButton]];
    
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return dataSourceArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    MoodModel *moodModel = [dataSourceArray objectAtIndex:index];
    PunchItem *itemView = (PunchItem *)view;
    
    if(itemView ==nil){
        itemView = [[[NSBundle mainBundle]loadNibNamed:@"PunchItem" owner:self options:nil]lastObject];
        itemView.frame = CGRectMake(0, 0, 164, 300);
    }
    
    itemView.titleLabel.text = moodModel.feeling;
    itemView.detailLabel.text = moodModel.said;
    [itemView.detailImageView sd_setImageWithURL:[NSURL URLWithString:moodModel.iconUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    
    return itemView;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionArc:
        {
            return 2 * M_PI * 0.429143;
        }
            
        case iCarouselOptionRadius:
        {
            return  value *1.486071;
        }
        case iCarouselOptionSpacing:
        {
            return value * 0.848195;
        }
        default:
        {
            return value;
        }
    }
}


//#pragma mark - UIButton actions

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionWithShare{
    
    MoodModel *moodModel = [dataSourceArray objectAtIndex:icarousel.currentItemIndex];
    
    ShareModel *shareModel = [ShareModel new];
    shareModel.shareTitle = @"汇客通";
    shareModel.shareContent = moodModel.shareContent;
    shareModel.shareImageURL = nil;
    shareModel.shareWebURL = @"http://app.berui.com/hkt";
    
    ShareTemplate  *shareTemplate = [ShareTemplate new];
    [shareTemplate actionWithShare:self WithSinaModel:shareModel andMessageTypeIsImage:NO];
    
}

-(IBAction)actionWithSubmit{
    
    [self showHUDSimple];
    MoodModel *moodModel = [dataSourceArray objectAtIndex:icarousel.currentItemIndex];
    [HTTPRequest addMoodListWithAdminId:[UserManager shareUserManager].admin_id moodKey:moodModel.key completeBlock:^(BOOL ok, NSString *message) {
        [self hideHUD];
        if(ok){
            if(message.length>0){
                [STAlertView showTitle:@"签到成功" message:message hideDelay:2.0f];
            }else {
                [self makeToast:@"签到成功" duration:1.0];
            }
            
            [self checkPunch];
        }else {
            [self makeToast:message duration:1.0];
        }
    }];
}

#pragma mark getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"签到";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_shareButton setImage:[UIImage imageNamed:@"nav_btn_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(actionWithShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (void)dealloc
{
    icarousel.delegate = nil;
    icarousel.dataSource = nil;
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
