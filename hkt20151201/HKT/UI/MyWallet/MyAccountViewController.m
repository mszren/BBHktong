//
//  MyAccountViewController.m
//  HKT
//
//  Created by Ting on 15/11/16.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyWalletEmptyHeadView.h"
#import "MyWalletAccountTableViewCell.h"
#import "BankAccount.h"
#import "HTTPRequest+MyWallet.h"
#import "UserManager.h"
#import "AddAccountViewController.h"
#import "PasswordView.h"
#import "FindPasswordViewController.h"

@interface MyAccountViewController ()<MyWalletEmptyHeadViewDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *arrayForAccountList;
    
}

@property (nonatomic,weak)IBOutlet UITableView *myTableView;
@property (nonatomic,retain)MyWalletEmptyHeadView * myWalletEmptyHeadViewl;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) PasswordView *passwordView;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviagionBar];
    [self getAccountList];
    
    //钱包变动
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAccountList)
                                                 name:@"accountValueChange"
                                               object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getAccountList{
    
    [self showHUDSimple];
    [HTTPRequest getAccountListWithAdminId:[UserManager shareUserManager].admin_id completeBlock:^(BOOL ok, NSString *message, NSArray *arrayForAccount) {
        [self hideHUD];
        if(ok){
            if(arrayForAccount.count==0){
                _myTableView.tableHeaderView = self.myWalletEmptyHeadViewl;
            }else {
                _myTableView.tableHeaderView = nil;
                arrayForAccountList =  arrayForAccount;
            }
            [_myTableView reloadData];
        }else{
            [self makeToast:message];
        }
    }];
}

#pragma mark -- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayForAccountList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForAccountCell = @"MyWalletAccountTableViewCell";
    
    MyWalletAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForAccountCell];
    if (!cell)
    {
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifierForAccountCell owner:self options:nil]lastObject];
    }
    
    BankAccount *bankAccount = [arrayForAccountList  objectAtIndex:indexPath.row];
    
    UIImage *headImg;
    
    switch (bankAccount.accountType) {
        case AlipayType:
            headImg = [UIImage imageNamed:@"wallet_account"];
            cell.titleLbl.text = @"支付宝";
            break;
        case WecharType:
            headImg = [UIImage imageNamed:@"wallet_account"];
            cell.titleLbl.text = @"微信";
            break;
            
        default:
            break;
    }
    
    cell.imgHead.image = headImg;
    cell.accountLbl.text = bankAccount.accountName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BankAccount *bankAccount = [arrayForAccountList  objectAtIndex:indexPath.row];
        [self.passwordView showPassWordView];
        __weak __typeof(self)weakSelf = self;
        
        [_passwordView setFinishEdit:^(NSString *password , PasswordView *passwordViewBlock) {
            //显示转圈等待
            [passwordViewBlock showWatting];
            
            [HTTPRequest deleteAccountWithAdminId:[UserManager shareUserManager].admin_id accountId:bankAccount.bankId password:password completeBlock:^(BOOL ok, NSString *message) {
                if(ok){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"accountValueChange" object:nil];
                    [passwordViewBlock showSuccess];
                    
                    
                }else {
                    [passwordViewBlock hiddenWattingAndTryAgain];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:message
                                                                       delegate:weakSelf
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"重试",@"忘记密码",nil];
                    [alertView show];
                }
            }];
        }];
    }
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark MyWalletEmptyHeadViewDelegate

-(void)actionWithGotoAddAccount{
    AddAccountViewController *vc = [AddAccountViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //重试
    if (buttonIndex ==0) {
        //忘记密码
    }else if (buttonIndex ==1){
        [self.passwordView removeFromSuperview];
        self.passwordView=nil;
        FindPasswordViewController *vc = [FindPasswordViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
}

#pragma mark - UIButton actions

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --getter/setter

-(MyWalletEmptyHeadView *)myWalletEmptyHeadViewl{
    if(!_myWalletEmptyHeadViewl){
        _myWalletEmptyHeadViewl = [[[NSBundle mainBundle]loadNibNamed:@"MyWalletEmptyHeadView" owner:self options:nil]lastObject];
        _myWalletEmptyHeadViewl.delegate = self;
        _myWalletEmptyHeadViewl.frame = self.view.bounds;
    }
    return _myWalletEmptyHeadViewl;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"我的提现账户";
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

-(PasswordView *)passwordView{
    if(!_passwordView){
        _passwordView = [[[NSBundle mainBundle]loadNibNamed:@"PasswordView" owner:self options:nil]lastObject];
        _passwordView.successTips = @"删除成功";
        __weak __typeof(self)weakSelf = self;
        
        [_passwordView setForgetPassword:^{
            FindPasswordViewController *vc = [FindPasswordViewController new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _passwordView;
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
