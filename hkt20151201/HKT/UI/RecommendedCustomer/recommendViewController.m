//
//  recommendViewController.m
//  HKT
//
//  Created by app on 15-6-23.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "recommendViewController.h"
#import "STAlertView.h"
#define  Size [[UIScreen mainScreen] bounds].size

@interface recommendViewController ()
{
    UIView *viewBG;
    UISegmentedControl *sg;
    
    UIView *tipView;
    UIImageView *tipImage;
    UITapGestureRecognizer *tap;
    UIScrollView *scrollView;
    
    UITableView *TVBerui;
    UITableView *TVAgent;
    
    UserManager *singleRcm;
    NSString *STRBerui;
    NSString *STRAgent;
    UIImageView *imageViewBerui;
    UILabel *labelBeruiNull;
    UIImageView *imageViewAgent;
    UILabel *labelAgentNull;
    NSString *push_ID;
    NSString *customer_ID;
    
    NSMutableArray *dataSourseBerui;
    NSMutableArray *dataSourseAgent;
    
    int _temp;
}

@end

@implementation recommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _temp = 100;
    STRBerui = [[NSString alloc] init];
    STRBerui = @"0";
    STRAgent = [[NSString alloc] init];
    STRAgent = @"0";
    singleRcm = [UserManager shareUserManager];
    push_ID = [[NSString alloc] init];

    customer_ID = [[NSString alloc] init];
    dataSourseBerui = [[NSMutableArray alloc] init];
    dataSourseAgent = [[NSMutableArray alloc] init];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Size.width, Size.height)];
    scrollView.delegate = self;
//    scrollView.bounds = NO;
    scrollView.contentSize = CGSizeMake(Size.width * 2,1);
//    scrollView.contentSize = CGSizeMake(0,1);

    scrollView.showsVerticalScrollIndicator = NO;

    
    //设置翻页滚动
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    TVBerui = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, Size.width - 20, Size.height - 69) style:UITableViewStylePlain];
    TVBerui.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    TVBerui.showsVerticalScrollIndicator = NO;
    TVBerui.delegate = self;
    TVBerui.dataSource = self;
    TVBerui.separatorStyle = UITableViewCellSeparatorStyleNone;
    [scrollView addSubview:TVBerui];
    __weak __typeof(self) weakSelf = self;
    TVBerui.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
 
        STRBerui = @"0";
        [weakSelf recommandWithAdminId:singleRcm.admin_id andType:@"1" andLastID:STRBerui andPageNums:@"8" andisRefresh:YES];
        
    }];
    
    TVBerui.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        HKTModel *model = [dataSourseBerui lastObject];
        STRBerui = model.customer_id;
        [weakSelf recommandWithAdminId:singleRcm.admin_id andType:@"1" andLastID:STRBerui andPageNums:@"8" andisRefresh:NO];
    }];
    
    
    TVAgent = [[UITableView alloc] initWithFrame:CGRectMake(Size.width + 10, 10, Size.width - 20, Size.height - 69) style:UITableViewStylePlain];
    TVAgent.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    TVAgent.showsVerticalScrollIndicator = NO;
    TVAgent.delegate = self;
    TVAgent.dataSource = self;
    TVAgent.separatorStyle = UITableViewCellSeparatorStyleNone;
    [scrollView addSubview:TVAgent];
//    UILabel *labelY = [[UILabel alloc] initWithFrame:CGRectMake(Size.width + 50, 50, 50, 50)];
//    labelY.backgroundColor = [UIColor yellowColor];
//    [TVAgent addSubview:labelY];
    TVAgent.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRAgent = @"0";
        [weakSelf recommandWithAdminId:singleRcm.admin_id andType:@"2" andLastID:STRBerui andPageNums:@"8" andisRefresh:YES];
    }];
    
    TVAgent.footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        HKTModel *model = [dataSourseAgent lastObject];
        STRAgent = model.customer_id;
        [weakSelf recommandWithAdminId:singleRcm.admin_id andType:@"2" andLastID:STRBerui andPageNums:@"8" andisRefresh:NO];
        
    }];
    
    if (sg.selectedSegmentIndex == 0) {
        [scrollView setContentOffset:CGPointMake(Size.width * 0, 0) animated:YES];
    }
    
    //设置背景图片
    imageViewBerui = [[UIImageView alloc] initWithFrame:CGRectMake(Size.width / 2 - 37.5, (Size.height) / 2 - 61, 75, 61)];
    imageViewBerui.image = [UIImage imageNamed:@"no_infor"];
    imageViewBerui.hidden = YES;
    [scrollView addSubview:imageViewBerui];
    
    labelBeruiNull = [[UILabel alloc] initWithFrame:CGRectMake(0, (Size.height) / 2 + 5, Size.width, 30)];
    labelBeruiNull.text = @"暂时还没有客户哦!";
    labelBeruiNull.textAlignment = NSTextAlignmentCenter;
    labelBeruiNull.alpha = 0.6;
    labelBeruiNull.hidden = YES;
    [scrollView addSubview:labelBeruiNull];
    
    imageViewAgent = [[UIImageView alloc] initWithFrame:CGRectMake(Size.width / 2 - 37.5 + Size.width , (Size.height) / 2 - 61, 75, 61)];
    imageViewAgent.image = [UIImage imageNamed:@"no_infor"];
    imageViewAgent.hidden = YES;
    [scrollView addSubview:imageViewAgent];
    
    labelAgentNull = [[UILabel alloc] initWithFrame:CGRectMake( Size.width, (Size.height) / 2 + 5, Size.width, 30)];
    labelAgentNull.text = @"暂时还没有客户哦!";
    labelAgentNull.textAlignment = NSTextAlignmentCenter;
    labelAgentNull.alpha = 0.6;
    labelAgentNull.hidden = YES;
    [scrollView addSubview:labelAgentNull];
    
    
    //提示框
    tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    tipView.backgroundColor = [UIColor blackColor];
    tipView.alpha = 0.6;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnKnowClick)];
    tap.numberOfTapsRequired = 1;
    [tipView addGestureRecognizer:tap];
    
    tipImage = [[UIImageView alloc] initWithFrame:CGRectMake( 35 , [[UIScreen mainScreen] bounds].size.height/2 - 170 , [[UIScreen mainScreen] bounds].size.width - 70, 270)];
    [tipImage resignFirstResponder];
    tipImage.alpha = 1;
    tipImage.backgroundColor = [UIColor whiteColor];
    tipImage.userInteractionEnabled = YES;
    tipImage.layer.masksToBounds = YES;
    tipImage.layer.cornerRadius = 6;
    tipImage.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    tipImage.layer.borderWidth = 0.9;
    
    UIImageView *imagePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 70, ([[UIScreen mainScreen] bounds].size.width - 70) * 95 / 260)];
    imagePicture.image = [UIImage imageNamed:@"tipImage.jpg"];
    [tipImage addSubview:imagePicture];
    
    UILabel *labelTip1 = [[UILabel alloc] initWithFrame:CGRectMake(10, ([[UIScreen mainScreen] bounds].size.width - 70) * 95 / 260 + 10, ([[UIScreen mainScreen] bounds].size.width - 100) - 20, 25)];
    labelTip1.font = [UIFont systemFontOfSize:15];
    labelTip1.text = @"1.推荐客户通过有效性审核，即可跟进";
    [labelTip1 setNumberOfLines:0];
    labelTip1.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [labelTip1 sizeThatFits:CGSizeMake(labelTip1.frame.size.width, MAXFLOAT)];
    labelTip1.frame = CGRectMake(10, ([[UIScreen mainScreen] bounds].size.width - 100) * 95 / 260 + 25, ([[UIScreen mainScreen] bounds].size.width - 70) - 20, size.height);
    [tipImage addSubview:labelTip1];
    
    
    UILabel *labelTip2 = [[UILabel alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.width - 100) * 95 / 260 + 10 + size.height + 10, 240, 25)];
    labelTip2.font = [UIFont systemFontOfSize:15];
    labelTip2.text = @"2.经纪人推荐的客户完整信息，初审后可见";
    [labelTip2 setNumberOfLines:0];
    labelTip2.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size2 = [labelTip2 sizeThatFits:CGSizeMake(labelTip2.frame.size.width, MAXFLOAT)];
    labelTip2.frame = CGRectMake(10, ([[UIScreen mainScreen] bounds].size.width - 100) * 95 / 260 + 10 + size.height + 25, ([[UIScreen mainScreen] bounds].size.width - 70) - 20, size2.height);
    [tipImage addSubview:labelTip2];
    
    UIButton *btnKnow = [UIButton buttonWithType:UIButtonTypeSystem];
    btnKnow.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 70) / 2 - 75, ([[UIScreen mainScreen] bounds].size.width - 100) * 95 / 260 + 10 + size.height + 25 + size2.height + 20, 140, 35);
    [btnKnow addTarget:self action:@selector(btnKnowClick) forControlEvents:UIControlEventTouchUpInside];
    [btnKnow setTitle:@"我知道了" forState:UIControlStateNormal];
    btnKnow.layer.masksToBounds = YES;
    btnKnow.layer.cornerRadius = 17.5;
    btnKnow.layer.borderColor = [UIColor colorWithRed:14/255.0f green:141/255.0f blue:249/255.0f alpha:1].CGColor;//边框颜色,要为CGColor
    btnKnow.layer.borderWidth = 1;
    [tipImage addSubview:btnKnow];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    //左按钮
    UIButton *leftButton = [self getBackButton];
    [leftButton addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setImage:[UIImage imageNamed:@"tip"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    self.navigationItem.titleView.userInteractionEnabled = YES;
    sg = [[UISegmentedControl alloc] initWithItems:@[@"百瑞推荐",@"经纪人推荐"]];
    [sg addTarget:self action:@selector(sgementValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView =sg;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica-Bold"size:15],UITextAttributeFont ,nil];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica-Bold"size:15],UITextAttributeFont ,nil];
    sg.tintColor = [UIColor colorWithRed:58/255.0f green:152/255.0f blue:213/255.0f alpha:1];
    sg.backgroundColor = [UIColor colorWithRed:107/255.0f green:193/255.0f blue:250/255.0f alpha:1];
    sg.layer.masksToBounds = YES;
    sg.layer.cornerRadius = 4;
    [sg setTitleTextAttributes:dic forState:UIControlStateNormal];
    [sg setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    sg.frame = CGRectMake(self.view.frame.size.width / 2 -100, 5, 200, 30);
    sg.selectedSegmentIndex = 0;
    
    tipView.hidden = YES;
    tipImage.hidden = YES;
    [self.view addSubview:tipView];
    [self.view  addSubview:tipImage];
}


-(void)sgementValueChanged:(UISegmentedControl *)seg
{
    
    if (seg.selectedSegmentIndex == 0) {
        [scrollView setContentOffset:CGPointMake(Size.width * 0, 0) animated:NO];
    }else if (seg.selectedSegmentIndex == 1){
        [scrollView setContentOffset:CGPointMake(Size.width * 1, 0) animated:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scroll
{
    if (scroll == scrollView) {
            //计算出当前滚动的页数
        NSInteger count =  scroll.contentOffset.x/(Size.width - 20);
            sg.selectedSegmentIndex = count;
            
        }

}

-(void)recommandWithAdminId:(NSString *)adminID andType:(NSString *)type andLastID:(NSString *)lastID andPageNums:(NSString *)pageNums andisRefresh:(BOOL)isRefresh{
    
    [HTTPRequest recommandWithAdminId:adminID andType:type andLastID:lastID andPageNums:pageNums completeBlock:^(BOOL ok, NSString *message, NSArray *arrayForHKTModel) {
        
        if ([type isEqualToString:@"1"]) {
           
            [TVBerui.footer endRefreshing];
            [TVBerui.header endRefreshing];
            if(ok){
                
                if(isRefresh){
                    [dataSourseBerui removeAllObjects];
                }
                
                [dataSourseBerui addObjectsFromArray:arrayForHKTModel];
                if (dataSourseBerui.count == 0) {
                    imageViewBerui.hidden = NO;
                    labelBeruiNull.hidden = NO;
                }else{
                    imageViewBerui.hidden = YES;
                    labelBeruiNull.hidden = YES;
                }
                if(arrayForHKTModel.count < 8  ){
                    [TVBerui.footer noticeNoMoreData];
                }
                [TVBerui reloadData];
                
            }else {
                imageViewBerui.hidden = NO;
                labelBeruiNull.hidden = NO;
                [self makeToast:message duration:2.0];
            }
            
        }
        
        else {
            
            [TVAgent.footer endRefreshing];
            [TVAgent.header endRefreshing];
            if(ok){
                
                if(isRefresh){
                    [dataSourseAgent removeAllObjects];
                }
                
                [dataSourseAgent addObjectsFromArray:arrayForHKTModel];
                if (dataSourseAgent.count == 0) {
                    imageViewAgent.hidden = NO;
                    labelAgentNull.hidden = NO;
                }else{
                    imageViewAgent.hidden = YES;
                    labelAgentNull.hidden = YES;
                }
                if(arrayForHKTModel.count < 8){
                    [TVAgent.footer noticeNoMoreData];
                }
                [TVAgent reloadData];
                
            }else {
                imageViewAgent.hidden = NO;
                labelAgentNull.hidden = NO;
                [self makeToast:message duration:2.0];
            }
        }
     }
  ];
}

#pragma mark tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == TVBerui) {
        return [dataSourseBerui count];
    }else{
        return [dataSourseAgent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName = @"CellID";
    HKTCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[HKTCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        //5.指定代理
        cell.delegate = self;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    HKTModel *model = [[HKTModel alloc] init];
    if (tableView == TVBerui) {
        if (dataSourseBerui.count >= indexPath.row) {
            model = [dataSourseBerui objectAtIndex:indexPath.row];
            cell.model = model;
            cell.HKTCellBtn.tag = 0;
        }
    }else{
        if (dataSourseAgent.count >= indexPath.row) {
            model = [dataSourseAgent objectAtIndex:indexPath.row];
            cell.model = model;
            cell.HKTCellBtn.tag = 1;
        }
        
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215;
}

#pragma mark - HKTCellTableViewCellDelegate
//6 实现代理方法
-(void)HKTCellBtnClick:(UIButton *)btn{
    [MobClick event:@"customerClick"];
    HKTModel *model;
    if(btn.tag==0){
        CGPoint currentTouchPosition = [btn convertPoint:btn.bounds.origin toView:TVBerui];
        NSIndexPath *indexPath = [TVBerui indexPathForRowAtPoint: currentTouchPosition];
        model = [dataSourseBerui objectAtIndex:indexPath.row];
        push_ID = model.push_id;
        customer_ID = model.customer_id;
    }else{
        CGPoint currentTouchPosition = [btn convertPoint:btn.bounds.origin toView:TVBerui];
        NSIndexPath *indexPath = [TVBerui indexPathForRowAtPoint: currentTouchPosition];
        model = [dataSourseAgent objectAtIndex:indexPath.row];
        push_ID = model.push_id;
        customer_ID = model.customer_id;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"客户审核结果" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: @"有效我要跟进",@"无意向",@"与案场冲突",@"无效客户", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *strStatus;
    NSDictionary *dict;
    if (buttonIndex != 0) {
        if (buttonIndex == 1) {
            dict = @{@"type" : @"customer_valid"};
            strStatus = @"2";
        }else if(buttonIndex == 2)
        {
            dict = @{@"type" : @"customer_no_intent"};
            strStatus = @"3";
        }else if(buttonIndex == 3)
        {
            dict = @{@"type" : @"customer_conflict"};
            strStatus = @"4";
        }else if(buttonIndex == 4)
        {
            dict = @{@"type" : @"customer_invalid"};
            strStatus = @"1";
        }
        [MobClick event:@"customer_follow_up" attributes:dict];
        [self recommandMoveWithAdminId:singleRcm.admin_id andStatus:strStatus andCustomID:customer_ID andPushID:push_ID];
    }
}

-(void)recommandMoveWithAdminId:(NSString *)adminID andStatus:(NSString *)status andCustomID:(NSString *)customID andPushID:(NSString *)pushID{
    [HTTPRequest recommandMoveWithAdminId:adminID andStatus:status andCustomID:customID andPushID:pushID completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        if(ok){
            [STAlertView showTitle:message message:data[@"rewardMoney"] hideDelay:2.0];
            ManagerViewController *manager = [[ManagerViewController alloc] init];
            if ([status isEqualToString:@"2"]) {
                [self.navigationController pushViewController:manager animated:YES];
            }
            [TVBerui.header beginRefreshing];
            [TVAgent.header beginRefreshing];
        }else{
            [self makeToast:message duration:1.0];
        }
        
    }];
}

-(void)btnLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonRightClick
{
    tipView.hidden = !tipView.hidden;
    tipImage.hidden = !tipImage.hidden;
}

-(void)btnKnowClick
{
    tipView.hidden = YES;
    tipImage.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [TVBerui.header beginRefreshing];
    [TVAgent.header beginRefreshing];
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
