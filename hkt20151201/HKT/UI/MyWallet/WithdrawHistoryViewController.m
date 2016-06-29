//
//  WithdrawHistoryViewController.m
//  HKT
//
//  Created by Ting on 15/9/17.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "WithdrawHistoryViewController.h"
#import "WithdrawHistoryTableViewCell.h"

#import "UIColor+Hex.h"
#import "MJRefresh.h"
#import "HTTPRequest+MyWallet.h"
#import "UserManager.h"
#import "HTTPRequest+main.h"
#import "WithdrawHistoryModel.h"
#import "TingDropDownMenu.h"
#import "TingDropDownTableViewCell.h"

@interface WithdrawHistoryViewController ()<TingDropDownMenuDataSource,TingDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataSource;
    NSString *lastId;
    
    NSArray *arrayForSelect;
    
    NSInteger historyStatus;
}

//基础
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) TingDropDownMenu *tingDropDownMenu;
@property (nonatomic, strong) IBOutlet UITableView *detailTableView;

@property(nonatomic,strong)NSIndexPath *selectIndex;

@end

@implementation WithdrawHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"withdrew_cash"];
    
    [self readyDataSource];
    
    [self readyView];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)readyView{
    
    _detailTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _detailTableView.backgroundColor = [UIColor colorWithHex:0xecedef];
    
    [self setupNaviagionBar];
}

-(void)readyDataSource{
    
    historyStatus = 0;
    
    arrayForSelect = @[@"全部",@"申请中",@"成功",@"失败"];
    
    dataSource = [NSMutableArray new];
    
    __weak __typeof(self) weakSelf = self;
    _detailTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getListDataWithRefresh:YES];
        
    }];
    
    _detailTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getListDataWithRefresh:NO];
        
    }];
    _detailTableView.footer.automaticallyChangeAlpha = YES;
    
    [_detailTableView.header beginRefreshing];
    
}

-(void)getListDataWithRefresh:(BOOL)isRefresh{
    
    if(isRefresh){
        lastId = @"0";
    }else {
        WithdrawHistoryModel *model = [dataSource lastObject];
        lastId = model.cashout_id;
    }
    
    [HTTPRequest withdrawHistoryWithAdminId:[UserManager shareUserManager].admin_id andLastId:lastId andStatus:historyStatus completeBlock:^(BOOL ok, NSString *message, NSArray *arrayForWalletDetailList) {
        
        [_detailTableView.header endRefreshing];
        [_detailTableView.footer endRefreshing];
        
        if(ok){
            if(isRefresh){
                [dataSource removeAllObjects];
            }
            
            [dataSource addObjectsFromArray:arrayForWalletDetailList];
            
            if(arrayForWalletDetailList.count < HTTPPageSize){
                
                [_detailTableView.footer noticeNoMoreData];
            }
            
        }else {
            
            [self makeToast:message duration:1.0];
            
        }
        
        [_detailTableView reloadData];
    }];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForAccountCell = @"WithdrawHistoryTableViewCell";
    
    WithdrawHistoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForAccountCell];
    if (!cell)
    {
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifierForAccountCell owner:self options:nil]lastObject];
    }
    
    WithdrawHistoryModel *model = [dataSource objectAtIndex:indexPath.row];
    cell.lblTime.text  = model.timeStr;
    cell.lblMoney.text = model.money;
    cell.lblText.text  = model.ststusTxt;
    
    switch (model.status) {
        case WithdrawFaild:
            [cell needHelp:YES];
            break;
        case WithdrawFinish:
        case Withdrawing:
            [cell needHelp:NO];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WithdrawHistoryModel *model = [dataSource objectAtIndex:indexPath.row];
    if(model.status == WithdrawFaild){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提现失败" message:model.remark delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
}

#pragma mark - TingDropDownMenuDataSource &TingDropDownMenuDelegate

- (NSInteger)menu:(TingDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayForSelect.count;
}

- (UITableViewCell *)menu:(TingDropDownMenu *)menu tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"TingDropDownTableViewCell";
    TingDropDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
    }
    
    if(indexPath.row == self.selectIndex.row && self.selectIndex!= nil){
        [cell setSelectedSytle:YES];
    }else
    {
        [cell setSelectedSytle:NO];
    }
    
    cell.titleLbl.text = arrayForSelect[indexPath.row];
    
    return cell;
}

- (void)menu:(TingDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.selectIndex) {
        self.selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        BOOL selectTheSameRow = indexPath.row == self.selectIndex.row? YES:NO;
        NSIndexPath *tempIndexPath = [self.selectIndex copy];
        //两次点击不同的cell
        if (!selectTheSameRow) {
            self.selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:@[tempIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    [self btnPressed];
    historyStatus = indexPath.row;
    [_detailTableView.header beginRefreshing];
    
}


-(void)btnPressed{
    
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        [self.tingDropDownMenu menuTapped];
    }];
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    
    self.navigationItem.titleView = self.titleBtn;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
}


#pragma mark - UIButton actions

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark getter/setter

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame = CGRectMake(0, 0, 220, 44);
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_titleBtn setTitle:@"我的提现历史" forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"wallet_show"] forState:UIControlStateNormal];
        [_titleBtn setImage:[UIImage imageNamed:@"wallet_show"] forState:UIControlStateHighlighted];
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0  , 0, 30 );
        _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 150 , 0, 0);
        [_titleBtn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _titleBtn;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(NSIndexPath *)selectIndex{
    if(!_selectIndex){
        _selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectIndex;
}

-(TingDropDownMenu *)tingDropDownMenu{
    if(!_tingDropDownMenu){
        _tingDropDownMenu = [[TingDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) targetView:self.view];
        _tingDropDownMenu.transformView = self.titleBtn.imageView;
        _tingDropDownMenu.dataSource = self;
        _tingDropDownMenu.delegate = self;
    }
    return _tingDropDownMenu;
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
