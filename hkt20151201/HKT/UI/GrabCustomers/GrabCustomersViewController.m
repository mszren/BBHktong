//
//  GrabCustomersViewController.m
//  HKT
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "GrabCustomersViewController.h"
#import "MJRefresh.h"
#import "HTTPRequest+GrabCustomers.h"
#import "GrabCustomerModel.h"
#import "UserManager.h"
#import "GrabCunstomerTableViewCell.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "GrabCunstomerHeadView.h"
#import "GrabCunstomerHelpView.h"
#import "STAlertView.h"
#import "NSTimer+Blocks.h"
#import "ManagerViewController.h"
#import "peopleViewController.h"

@interface GrabCustomersViewController ()<UITableViewDelegate,UITableViewDataSource,GrabCunstomerTableViewCellDelegate>{
    NSString *lastId;
}

@property (nonatomic,weak)IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSTimer *timer;

//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) GrabCunstomerHeadView *grabCunstomerHeadView;

@property (nonatomic, strong) GrabCunstomerHelpView *grabCunstomerHelpView;



@end

@implementation GrabCustomersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readyView];
    [self readyDataSource];
    // Do any additional setup after loading the view from its nib.
}

-(void)readyView{
    [self setupNaviagionBar];
}

-(void)readyDataSource{
    
    __weak __typeof(self) weakSelf = self;
    _myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf getListDataWithRefresh:YES];
        
    }];
    
    _myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf getListDataWithRefresh:NO];
        
    }];
    _myTableView.footer.automaticallyChangeAlpha = YES;
    
    [_myTableView.header beginRefreshing];
    
}

-(void)beggingABC{
    
    [_timer invalidate];
    _timer = nil;
    
    if(self.dataSource.count>0){
        
        __weak __typeof(self)weakSelf = self;
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self repeats:YES block:^{
            [weakSelf show];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)show{
    
    for (GrabCustomerModel *demoModel in self.dataSource) {
        if(demoModel.sec >0){
            demoModel.sec = demoModel.sec -1;
        }else {
            [_timer invalidate];
            _timer = nil;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"countDown" object:nil];
    
}

-(void)getListDataWithRefresh:(BOOL)isRefresh{
    
    if(isRefresh){
        lastId = @"0";
    }else {
        GrabCustomerModel *model = [self.dataSource lastObject];
        if(model){
            lastId = model.customer_id;
        }
    }
    
    [HTTPRequest customerListWithAdminId:[UserManager shareUserManager].admin_id lastID:lastId completeBlock:^(BOOL ok, NSString *message, NSArray *array) {
        
        [_myTableView.header endRefreshing];
        [_myTableView.footer endRefreshing];
        
        if(ok){
            if(isRefresh){
                [self.dataSource removeAllObjects];
            }
            
            [self.dataSource addObjectsFromArray:array];
            
            if(array.count < HTTPPageSize){
                
                [_myTableView.footer noticeNoMoreData];
            }
            
            if(self.dataSource.count > 0){
                _myTableView.tableHeaderView = nil;
            }else {
                _myTableView.tableHeaderView = self.grabCunstomerHeadView;
            }
            
            [self beggingABC];
            
            
        }else {
            
            [self makeToast:message duration:1.0];
            
        }
        
        [_myTableView reloadData];
        
    }];
    
}

#pragma mark -- UITableViewDataSource


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [UIView new];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForAccountCell = @"GrabCunstomerTableViewCell";
    
    GrabCunstomerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForAccountCell];
    if (!cell){
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifierForAccountCell owner:self options:nil]lastObject];
        cell.delegate = self;
    }
    
    GrabCustomerModel *model = [self.dataSource objectAtIndex:indexPath.section];
    
    [cell setModel:model];
    
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

- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)helpButtonClicked{
    [self.grabCunstomerHelpView show];
    
}

#pragma mark GrabCunstomerTableViewCellDelegate

-(void)actionWithPhoneCall:(UIButton *)btn{
    CGPoint currentTouchPosition = [btn convertPoint:btn.bounds.origin toView:_myTableView];
    NSIndexPath *indexPath = [_myTableView indexPathForRowAtPoint: currentTouchPosition];
    
    GrabCustomerModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    [UIActionSheet showInView:self.view
                    withTitle:@"拨打电话"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[model.customer_tel]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         
                         if (buttonIndex == actionSheet.cancelButtonIndex) {
                             return;
                         }
                         
                         NSString *phoneNumberString = [NSString stringWithFormat:@"tel://%@", model.customer_tel];
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberString]];
                     }];
    
}

-(void)actionWithGrabCunstomer:(UIButton *)btn{
    CGPoint currentTouchPosition = [btn convertPoint:btn.bounds.origin toView:_myTableView];
    NSIndexPath *indexPath = [_myTableView indexPathForRowAtPoint: currentTouchPosition];
    GrabCustomerModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    [UIAlertView showWithTitle:nil
                       message:nil
             cancelButtonTitle:@"取消"
             otherButtonTitles:@[@"有效,我要跟进",@"与案场冲突",@"无效客户",]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          
                          if (buttonIndex == alertView.cancelButtonIndex) {
                              return;
                          }
                          //1=无效 2=有效 3=无意向 4=与案场冲突
                          
                          NSString *status;
                          
                          //有效跟进
                          if(buttonIndex==1){
                              status = @"2";
                          }
                          
                          //与案场冲突
                          if(buttonIndex==2){
                              status = @"4";
                          }
                          
                          //无效客户
                          if(buttonIndex==3){
                              status = @"1";
                          }
                          
                          [self show];
                          [HTTPRequest grabCustomerWithAdminId:[UserManager shareUserManager].admin_id Status:status Custom:model completeBlock:^(BOOL ok, NSString *message, NSDictionary *dic) {
                              [self hideHUD];
                              if(ok){
                                  
                                  NSString *alertStr = dic[@"rewardMoney"];
                                  if (alertStr.length>0) {
                                      [STAlertView showTitle:message message:alertStr hideDelay:2.0];
                                  }

                                  if (buttonIndex == 1) {

                                      
                                      NSMutableArray *navView = [NSMutableArray new];
                                      for (UIViewController *temp in self.navigationController.viewControllers) {
                                          if ([temp isKindOfClass:[peopleViewController class]]) {
                                              [navView addObject:temp];
                                              ManagerViewController *vc = [[ManagerViewController alloc]init];
                                              [navView addObject:vc];
                                              [self.navigationController setViewControllers:navView animated:YES];
                                              break;
                                          }
                                          [navView addObject:temp];
                                      }

                                  }
                                  
                                  [self.myTableView.header beginRefreshing];
                                  
                              }else{
                                  [self makeToast:message];
                              }
                              
                          }];

                      }];
    
}

#pragma mark getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"抢客户";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_helpButton setImage:[UIImage imageNamed:@"nav_btn_help"] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}

- (GrabCunstomerHeadView *)grabCunstomerHeadView{
    if(!_grabCunstomerHeadView){
        _grabCunstomerHeadView = [[[NSBundle mainBundle]loadNibNamed:@"GrabCunstomerHeadView" owner:self options:nil]lastObject];
        _grabCunstomerHeadView.frame = self.view.bounds;
    }
    return _grabCunstomerHeadView;
}

- (GrabCunstomerHelpView *)grabCunstomerHelpView{
    if(!_grabCunstomerHelpView){
        _grabCunstomerHelpView = [[[NSBundle mainBundle]loadNibNamed:@"GrabCunstomerHelpView" owner:self options:nil]lastObject];
    }
    return _grabCunstomerHelpView;
}

-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
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
