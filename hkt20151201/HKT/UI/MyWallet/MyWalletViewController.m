//
//  MyWalletViewController.m
//  HKT
//
//  Created by Ting on 15/9/16.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletRewardDetailTableViewCell.h"
#import "UIView+Size.h"
#import "UIColor+Hex.h"
#import "MyWalletHeaderView.h"
#import "AddAccountViewController.h"
#import "WithdrawViewController.h"
#import "WithdrawHistoryViewController.h"
#import "UserManager.h"
#import "MJRefresh.h"
#import "HTTPRequest+MyWallet.h"
#import "UserManager.h"
#import "MyWalletModel.h"
#import "IQKeyboardManager.h"
#import "MyAccountViewController.h"
#import "PasswordManageViewController.h"
#import "AccountDetails.h"

#define sectionHeight 44.0f

#define accountKey @"accountKey"
#define rewardListKey @"rewardListKey"

@interface MyWalletViewController ()<UITableViewDataSource,UITableViewDelegate,MyWalletHeaderViewDelegate>{
    
    UserManager *myUser;
    MyWalletModel *myWallet;
    
    NSString *lastId;
    
    //NSArray *arrayForMyAccountList;        //银行list
    
    NSMutableArray *arrayForDetailList;     //历史记录
    
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTop;

@property (weak, nonatomic) IBOutlet UIView *menuView;

//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *helpButton;
//
@property (nonatomic,retain) IBOutlet UITableView *walletTableView;
@property (nonatomic,retain) UIView *headView;

@property (nonatomic, strong) UIView *addAccountView;
@property (nonatomic, strong) UIView *dewardDetailTitleView;

@property (nonatomic,retain) MyWalletHeaderView *myWalletHeaderView;

@end

@implementation MyWalletViewController

@synthesize headView,walletTableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self readyView];
    
    [self readyDataSource];
    
    [self setupNaviagionBar];
    
    //钱包变动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshWalletData)
                                                 name:@"accountValueChange"
                                               object:nil];
}

-(void)readyView{
    
    _menuView.layer.shadowColor = [UIColor blackColor].CGColor;
    _menuView.layer.shadowOffset = CGSizeMake(-2.0f, 2.0f);
    _menuView.layer.shadowOpacity = 0.5f;
    _menuView.layer.cornerRadius = 2.0f;
    [_menuView.layer setShadowPath:[[UIBezierPath
                                     bezierPathWithRect:_menuView.bounds] CGPath]];
    
    _menuTop.constant = -90.0f;
    
    
    walletTableView.tableHeaderView = self.myWalletHeaderView;
    walletTableView.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
}

-(void)readyDataSource{
    
    arrayForDetailList = [NSMutableArray new];
    myUser = [UserManager shareUserManager];
    
    __weak __typeof(self) weakSelf = self;
    walletTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [walletTableView.header endRefreshing];
        [weakSelf refreshWalletData];
    }];
    
    walletTableView.header.automaticallyChangeAlpha = YES;
    
    walletTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getListDataWithRefresh:NO];
        
    }];
    
    walletTableView.footer.automaticallyChangeAlpha = YES;
    
    [self refreshWalletData];
    
}

-(void)refreshWalletData{
    
    [self showHUDSimple];
    [HTTPRequest getMyWalletWithAdminId:myUser.admin_id completeBlock:^(BOOL ok, NSString *message, MyWalletModel *myWalletModel) {
        [self hideHUD];
        
        [self getListDataWithRefresh:YES];
        
        if(ok){
            myWallet = myWalletModel;
            
        }else{
            [self makeToast:message duration:1.0];
        }
        
        [self showWalletData];
    }];
}

-(void)getListDataWithRefresh:(BOOL)isRefresh{
    
    if(isRefresh){
        lastId = @"0";
    }else {
        AccountDetails *accountDetails = [arrayForDetailList lastObject];
        if(accountDetails){
            lastId = accountDetails.reward_list_id;
        }
    }
    
    [HTTPRequest getMyWalletDetailWithAdminId:myUser.admin_id andLastId:lastId completeBlock:^(BOOL ok, NSString *message, NSArray *arrayForWalletDetailList) {
        
        [walletTableView.footer endRefreshing];
        if(ok){
            if(isRefresh){
                [arrayForDetailList removeAllObjects];
            }
            
            [arrayForDetailList addObjectsFromArray:arrayForWalletDetailList];
            
            if(arrayForWalletDetailList.count < HTTPPageSize){
                
                [walletTableView.footer noticeNoMoreData];
            }
            
            [walletTableView reloadData];
            
        }else {
            
            [self makeToast:message duration:1.0];
            
        }
    }];
}

-(void)showWalletData{
    
    [self.myWalletHeaderView setFreeze:myWallet.isFreeze];
    self.myWalletHeaderView.lblAllMoney.text = [NSString stringWithFormat:@"%.2f",[myWallet.nowFund floatValue]];
    self.myWalletHeaderView.lblWithdrawMoney.text = [NSString stringWithFormat:@"%.2f",[myWallet.cashOuted floatValue]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.menuTop.constant = -90.0f;
    self.menuView.alpha = 0.0f;
    [self.view layoutIfNeeded];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayForDetailList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.dewardDetailTitleView.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return self.dewardDetailTitleView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifierForRewardDetailCell = @"MyWalletRewardDetailTableViewCell";
    
    MyWalletRewardDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForRewardDetailCell];
    if (!cell)
    {
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifierForRewardDetailCell owner:self options:nil]lastObject];
    }
    
    AccountDetails *accountDetails = [arrayForDetailList objectAtIndex:indexPath.row];
    
    cell.lblTitle.text =  accountDetails.reward_text;
    cell.lblTime.text  = accountDetails.reward_list_atime;
    cell.lblMoney.text =  [NSString stringWithFormat:@"+%@元",accountDetails.reward_value];
    cell.lblMoney.textColor = [UIColor colorWithHex:accountDetails.reward_status_color];
    cell.lblText.text  = accountDetails.reward_status_text;
    
    if(indexPath.row == 0){
        [cell isTopCell:YES];
    }else {
        [cell isTopCell:NO];
    }
    
    return cell;
}


#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
    [self addRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.helpButton]];
}

#pragma mark - UIButton actions

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)helpButtonClicked{
    
    [UIView transitionWithView:self.menuView duration:0.5 options:0 animations:^{
        if(self.menuTop.constant==0){
            self.menuTop.constant = -90.0f;
            self.menuView.alpha = 0.0f;
        }else{
            self.menuTop.constant = 0.0f;
            self.menuView.alpha = 1.0f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

-(IBAction)actionWithGotoMyAccount{
    MyAccountViewController *vc = [MyAccountViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)actionWithGotoMyPwd{
    if(!myWallet.isBindBank){
        [self makeToast:@"请先绑定提现账户"];
        return;
    }
    
    PasswordManageViewController *vc = [PasswordManageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark MyWalletHeaderViewDelegate

#pragma mark 我要提现

-(void)actionWithWithdraw{
    
    if(!myWallet.isBindBank){
        [self makeToast:@"请先绑定提现账号" duration:1.0];
    }else if(myWallet.isFreeze){
        [self makeToast:@"您的账户已被冻结" duration:1.0];
    }else {
        WithdrawViewController *vc = [[WithdrawViewController alloc]initWithAllMoney:myWallet.nowFund];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)actionWithGotoWithdrawHistory{
    
    WithdrawHistoryViewController *vc = [WithdrawHistoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark getter/setter

-(UIView *)addAccountView{
    if(!_addAccountView){
        _addAccountView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 5)];
        _addAccountView.backgroundColor = [UIColor clearColor];
    }
    return _addAccountView;
}

-(UIView *)dewardDetailTitleView{
    
    if(!_dewardDetailTitleView){
        
        _dewardDetailTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, sectionHeight)];
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, sectionHeight)];
        titleLbl.text = @"奖励明细";
        titleLbl.font = [UIFont systemFontOfSize:16.0f];
        titleLbl.textColor = [UIColor colorWithHex:0x333333];
        [_dewardDetailTitleView addSubview:titleLbl];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10,titleLbl.bottom-5, kDeviceWidth-20, 1)];
        lineView.backgroundColor = [UIColor colorWithHex:0x727272];
        [_dewardDetailTitleView addSubview:lineView];
        _dewardDetailTitleView.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        
    }
    return _dewardDetailTitleView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"我的钱包";
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

- (UIButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_helpButton setImage:[UIImage imageNamed:@"top_wallet_right"] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}

- (UIView *)headView{
    if(!headView){
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,200)];
    }
    return headView;
}

-(MyWalletHeaderView *)myWalletHeaderView{
    
    if(!_myWalletHeaderView){
        _myWalletHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"MyWalletHeaderView" owner:self options:nil]lastObject];
        _myWalletHeaderView.delegate =self;
        _myWalletHeaderView.frame = CGRectMake(0, 0, 0, 100);
    }
    return _myWalletHeaderView;
}

-(void)didReceiveMemoryWarning {
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
