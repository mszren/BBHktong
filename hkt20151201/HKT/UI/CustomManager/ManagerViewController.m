//
//  ManagerViewController.m
//  HKT
//
//  Created by app on 15-6-3.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "ManagerViewController.h"
#import "DOPDropDownMenu.h"
#import "CustomDetailViewController.h"
#import "GJViewController.h"
#import "FollowUpViewController.h"
@interface ManagerViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,managerCellTableViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UITextField *textFieldSearch;
@property(nonatomic,strong)UIView *searchBgView;
@property(nonatomic,strong)NSMutableArray *statuesArr;
@property(nonatomic,strong)NSMutableArray *thinkArr;
@property(nonatomic,strong)NSMutableArray *tvDataArr;
@property(nonatomic,strong)UITableView *tVList;
@property(nonatomic,copy)NSString *keywords;
@property(nonatomic,copy)NSString *followid;
@property(nonatomic,copy)NSString *thinkid;
@property(nonatomic,copy)NSString *lastID;

@end


@implementation ManagerViewController
{
    DOPDropDownMenu *menu;
    UserManager *singleCustom;
    FollowUpViewControllerModel *modelSkip;
    UIImageView *imageViewNull;
    UILabel *labelNull;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户列表";
    //实例化
    modelSkip = [[FollowUpViewControllerModel alloc] init];
    singleCustom = [UserManager shareUserManager];
    _statuesArr = [[NSMutableArray alloc] init];
    _thinkArr = [[NSMutableArray alloc] init];
    _tvDataArr = [[NSMutableArray alloc] init];
    _followid = [[NSString alloc] init];
    _thinkid = [[NSString alloc] init];
    _lastID = [[NSString alloc] initWithFormat:@"0"];
    _keywords = [[NSString alloc] init];
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    //右按钮
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightButton setTitle:@"" forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"top_right_search"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"top_right_search_pre"] forState:UIControlStateHighlighted];
    [_rightButton addTarget:self action:@selector(buttonRightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(50, 5, ScreenSize.width - 100, 34)];
    _searchBgView.backgroundColor = [UIColor whiteColor];
    _searchBgView.layer.cornerRadius = 4;
    _searchBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchBgView.hidden = YES;
    
    _textFieldSearch = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenSize.width - 115, 34)];
    _textFieldSearch.delegate = self;
    _textFieldSearch.placeholder = @"搜索客户";
    [_searchBgView addSubview:_textFieldSearch];
    [self.navigationController.navigationBar addSubview:_searchBgView];
    
    
    //加头部标题按钮
    NSDictionary *dicStatues = @{@"followid":@"110",@"followtext":@"状态"};
    [_statuesArr insertObject:dicStatues atIndex:0];
    NSDictionary *dicThink = @{@"thinkid":@"100",@"thinktext":@"意向"};
    [_thinkArr insertObject:dicThink atIndex:0];
    
    //请求意向数据
    [self customConfig];
    menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
//    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(ScreenSize.width / 2 - 0.5, 0, 15, 44)];
//    labelLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
//    [menu addSubview:labelLine];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    [self creatTvList];
}

-(void)creatTvList{
    
    _tVList = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenSize.width, ScreenSize.height - 108) style:UITableViewStylePlain];
    _tVList.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
    _tVList.delegate = self;
    _tVList.dataSource = self;
    _tVList.separatorStyle = NO;
    _tVList.showsVerticalScrollIndicator = NO;
    __weak __typeof(self) weakSelf = self;
    _tVList.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _lastID = @"0";
        [weakSelf ManagerWithKeywords:_keywords followID:_followid thinkID:_thinkid adminID:singleCustom.admin_id lastID:_lastID pageNums:@"8" isRefresh:YES];
    }];
    
    _tVList.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        managerModel *model = [_tvDataArr lastObject];
        _lastID = model.developer_id;
        [weakSelf ManagerWithKeywords:_keywords followID:_followid thinkID:_thinkid adminID:singleCustom.admin_id lastID:_lastID pageNums:@"8" isRefresh:NO];
    }];
    [_tVList.header beginRefreshing];

    
        //设置背景图片
    imageViewNull = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 2 - 37.5, (ScreenSize.height) / 2 - 61, 75, 61)];
    imageViewNull.image = [UIImage imageNamed:@"no_infor"];
    imageViewNull.hidden = YES;
    [_tVList addSubview:imageViewNull];
    
    labelNull = [[UILabel alloc] initWithFrame:CGRectMake(0, (ScreenSize.height) / 2 + 5, ScreenSize.width, 30)];
    labelNull.text = @"暂时还没有客户哦!";
    labelNull.textAlignment = NSTextAlignmentCenter;
    labelNull.alpha = 0.6;
    labelNull.hidden = YES;
    [_tVList addSubview:labelNull];
    
    [self.view addSubview:_tVList];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _tvDataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CellID";
    managerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[managerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    managerModel *model = [_tvDataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    managerModel *modelHeight =  [_tvDataArr objectAtIndex:indexPath.row];
    CGSize noteTextTrueSize = [modelHeight.noteText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenSize.width - 30 - [modelHeight.noteTypeText length] * 11, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"noteTextTrueSize.height ===== %f",noteTextTrueSize.height);
    if ([[NSString stringWithFormat:@"%@",modelHeight.noteNums] isEqualToString:@"0"]) {
        //跟进次数为空
        if (modelHeight.noteText.length == 0) {
            //跟进记录为空
            return 103 + 44 ;
            
        }else{
            //跟进记录不为空
            return 103 + (noteTextTrueSize.height + 20);
        }
        
    }else{
        
        //跟进次数不为空
        
        if (modelHeight.noteText.length == 0) {
            //跟进记录为空
            return 103 + 34;
        }else{
            return 103 + 34 + 10 + noteTextTrueSize.height;
            
        }
    }
}

-(void)managerBtnClick:(UIButton *)btnChangeView{
    CGPoint currentTouchPosition = [btnChangeView convertPoint:btnChangeView.bounds.origin toView:_tVList];
    NSIndexPath *indexPath = [_tVList indexPathForRowAtPoint: currentTouchPosition];
    managerModel *managerModel = [_tvDataArr objectAtIndex:indexPath.row];
    if (btnChangeView.tag == 1) {
        CustomDetailViewController *custom = [[CustomDetailViewController alloc] init];
        custom.custom_id = managerModel.customer_id;
        [self.navigationController pushViewController:custom animated:YES];
    }else{
        if ([managerModel.followText isEqualToString:@"认购"]) {
             [self makeToast:@"该客户跟进状态已结束" duration:1];
        }else{
            modelSkip.followText = managerModel.followText;
            modelSkip.customer_id = managerModel.customer_id;
            modelSkip.customer_name = managerModel.customer_name;
            FollowUpViewController* follow = [[FollowUpViewController alloc]initWithModel:modelSkip];
            [self.navigationController pushViewController:follow animated:YES];
        }
    }
}


#pragma mark DOPDropDownMenuDelegate

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 2;
}

//每个按钮点击进入的tableViewCell个数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return _statuesArr.count;
    }else {
        return _thinkArr.count;
    }
}

//选中cell后的内容
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    if (indexPath.column == 0) {
        NSDictionary *dicStatues = [_statuesArr objectAtIndex:indexPath.row];
        NSLog(@"dicStatues ===== %@",dicStatues[@"followtext"]);
        return dicStatues[@"followtext"];
    } else {
        
        NSString *strChange = [NSString stringWithFormat:@" %@ ",[_thinkArr objectAtIndex:indexPath.row][@"thinktext"]];
        return strChange;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSDictionary *dictList;
    if (indexPath.column == 0 ) {
        _followid = [_statuesArr objectAtIndex:indexPath.row][@"followid"];
        if ([_followid isEqualToString:@"7"]) {
            dictList = @{@"type" : @"search_with_buy"};
        }else if ([_followid isEqualToString:@"8"]) {
            
        }else if ([_followid isEqualToString:@"9"]) {
            dictList = @{@"type" : @"search_with_pledged_to_raise"};
        }else if ([_followid isEqualToString:@"10"]) {
            
        }else if ([_followid isEqualToString:@"3"]) {
            dictList = @{@"type" : @"search_with_no_visit"};
        }else if ([_followid isEqualToString:@"4"]) {
            dictList = @{@"type" : @"search_with_visit"};
        }
        
    }else {
        
        _thinkid = [_thinkArr objectAtIndex:indexPath.row][@"thinkid"];
        if ([_thinkid isEqualToString:@"1"]) {
            dictList = @{@"type" : @"search_with_A"};
        }else if ([_thinkid isEqualToString:@"2"]) {
            dictList = @{@"type" : @"search_with_B"};
        }else if ([_thinkid isEqualToString:@"3"]) {
            dictList = @{@"type" : @"search_with_C"};
        }

    }
    [MobClick event:@"customer_search" attributes:dictList];
    [_tVList.header beginRefreshing];
    
}

-(void)ManagerWithKeywords:(NSString *)keywords followID:(NSString *)followID thinkID:(NSString *)thinkID  adminID:(NSString *)adminID lastID:(NSString *)lastID pageNums:(NSString *)pageNums isRefresh:(BOOL)isRefresh{
    [HTTPRequest ManagerWithKeywords:keywords followID:followID thinkID:thinkID adminID:adminID lastID:lastID pageNums:pageNums completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [_tVList.footer endRefreshing];
        [_tVList.header endRefreshing];
        
        if(ok){
            if (isRefresh) {
                [_tvDataArr removeAllObjects];
            }
            
            NSArray *arr = [data objectForKey:@"pageList"];
            for (NSDictionary *subDict in arr) {
                managerModel *model = [[managerModel alloc] init];
                model.customer_id = [subDict objectForKey:@"customer_id"];
                model.customer_name = [subDict objectForKey:@"customer_name"];
                model.followText = [subDict objectForKey:@"followText"];
                model.thinkText = [subDict objectForKey:@"thinkText"];
                model.noteNums = [subDict objectForKey:@"noteNums"];
                model.noteTypeText = [subDict objectForKey:@"noteTypeText"];
                model.developer_id = [subDict objectForKey:@"developer_id"];
                model.PhoneStr = [subDict objectForKey:@"customer_tel"];
                //时间格式
                NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[subDict[@"push_last_uptime"] intValue]];
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"YYYY.MM.dd"];
                model.push_last_uptime = [df stringFromDate:dt];
                model.noteText = [subDict objectForKey:@"noteText"];
                [_tvDataArr addObject:model];
            }
            if (_tvDataArr.count == 0) {
                labelNull.hidden = NO;
                imageViewNull.hidden = NO;
            }else{
                labelNull.hidden = YES;
                imageViewNull.hidden = YES;
            }

            [_tVList reloadData];

        }else{
            labelNull.hidden = NO;
            imageViewNull.hidden = NO;
            [self makeToast:message duration:1];
            
        }
    }];
    
}

-(void)customConfig{
    
    [HTTPRequest CustomConfig:^(BOOL ok, NSString *message, NSDictionary *data) {
        
        if(ok){
            _statuesArr = [NSMutableArray arrayWithArray:data[@"followConfig"]];
            _thinkArr =     [NSMutableArray arrayWithArray:data[@"thinkConfig"]];
            
        }else {
            [self makeToast:message duration:1];
            
        }
    }];
    
}


-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//keyWorks
-(void)buttonRightClick:(UIButton *)rightButton{
    _textFieldSearch.text = @"";
    rightButton.selected = !rightButton.selected;
    _searchBgView.hidden = !_searchBgView.hidden;

    if (rightButton.selected) {
        _keywords = @"";
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
        _tVList.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - 108);
        [menu backgroundTapped:nil];
        menu.hidden = YES;
//        menu.leftTableView.hidden = YES;
//        menu.rightTableView.hidden = YES;
    }else{
        _keywords = @"";
        _tVList.frame = CGRectMake(0, 44, ScreenSize.width, ScreenSize.height - 108);
        [_rightButton setTitle:@"" forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"top_right_search"] forState:UIControlStateNormal];
        [_textFieldSearch resignFirstResponder];
        menu.leftTableView.hidden = NO;
        menu.rightTableView.hidden = NO;
        menu.hidden = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _keywords = textField.text;
    [_textFieldSearch resignFirstResponder];
    [_tVList.header beginRefreshing];
    NSDictionary *dict = @{@"type" : @"search_with_string"};
    [MobClick event:@"customer_search" attributes:dict];

    return YES;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    menu.hidden = NO;
//    menu.leftTableView.hidden = NO;
//    menu.rightTableView.hidden = NO;
//    [menu backgroundTapped:nil];
    _tVList.frame = CGRectMake(0, 44, ScreenSize.width, ScreenSize.height - 108);
    [_rightButton setTitle:@"" forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"top_right_search"] forState:UIControlStateNormal];
    _rightButton.selected = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    _searchBgView.hidden = YES;
    [_textFieldSearch resignFirstResponder];
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
