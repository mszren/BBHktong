//
//  PasswordManageViewController.m
//  HKT
//
//  Created by Ting on 15/11/16.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "PasswordManageViewController.h"
#import "UIView+Size.h"
#import "FindPasswordViewController.h"
#import "ModifyPasswordViewController.h"

@interface PasswordManageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *arrayForItem;
}

@property (nonatomic,weak)IBOutlet UITableView *myTableView;

@property (nonatomic, strong) UIView *viewForHead;
@property (nonatomic, strong) UIView *viewForFoot;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation PasswordManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviagionBar];
    
    self.myTableView.tableHeaderView = self.viewForHead;
    self.myTableView.tableFooterView = self.viewForFoot;
    
    arrayForItem = @[@"忘记提现密码",@"修改提现密码"];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayForItem.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForUITableViewCell = @"identifierForUITableViewCell";


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForUITableViewCell];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierForUITableViewCell];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    cell.textLabel.text = arrayForItem[indexPath.section];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        FindPasswordViewController *vc = [FindPasswordViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        ModifyPasswordViewController *vc = [ModifyPasswordViewController new];
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"提现密码管理";
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

- (UIView *)viewForHead{
    if(!_viewForHead){
        _viewForHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 44)];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = @"你正在为账户重置提现密码";
        [_viewForHead addSubview:lbl];
    }
    return _viewForHead;
}

- (UIView *)viewForFoot{
    if(!_viewForFoot){
        _viewForFoot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 200)];
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, kDeviceWidth-30, 15)];
        lblTitle.font = [UIFont systemFontOfSize:14.0f];
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.text = @"安全提示";
        [_viewForFoot addSubview:lblTitle];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 14, 14)];
        imgView.image = [UIImage imageNamed:@"wallet_notice"];
        [_viewForFoot addSubview:imgView];
        
        UILabel *lblDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, kDeviceWidth-30, 150)];
        lblDetail.numberOfLines = 0;
        lblDetail.font = [UIFont systemFontOfSize:12.0f];
        lblDetail.textColor = [UIColor lightGrayColor];
        lblDetail.text = @"1.请牢记您的提现密码 \n2.不要将密码泄露给其他人\n3.不要与银行取款密码相同";
  
        lblDetail.height = [lblDetail.text boundingRectWithSize:CGSizeMake(lblDetail.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lblDetail.font} context:nil].size.height;
     
        [_viewForFoot addSubview:lblDetail];
    
    }
    return _viewForFoot;
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
