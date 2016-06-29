//
//  CustomDetailViewController.m
//  HKT
//
//  Created by app on 15/11/20.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "CustomDetailViewController.h"
#import "UserManager.h"
#import "HTTPRequest+manager.h"
#import "detailModel.h"
#import "detailCell.h"
#import "findViewController.h"
#import "GJViewController.h"
#import "remindViewController.h"
#import "FollowUpViewController.h"

@interface CustomDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIScrollView *sc;

@property(nonatomic,strong)UIButton *btnName;
@property(nonatomic,strong)UILabel *labelName;
@property(nonatomic,strong)UIButton *btnThink;
@property(nonatomic,strong)UIImageView *imageViewArrowDown;
@property(nonatomic,strong)UIButton *btnMessage;
@property(nonatomic,strong)UIImageView *imageViewMessage;
@property(nonatomic,strong)UIButton *btnPhone;
@property(nonatomic,strong)UIImageView *imageViewPhone;
@property(nonatomic,strong)UIImageView *imageViewArrowRight;

@property(nonatomic,strong)UILabel *labelLine;
@property(nonatomic,strong)UIImageView *imageViewBtnChange;

@property(nonatomic,strong)UIScrollView *scChangeType;
@property(nonatomic,strong)UITableView *tableViewRecord;
@property(nonatomic,strong)UITableView *tableViewRemind;

@property(nonatomic,strong)NSMutableArray *recordDataSourceArr;
@property(nonatomic,strong)NSMutableArray *remindDataSourceArr;

@property(nonatomic,copy)NSString *CustomTel;
@property(nonatomic,copy)NSString *followText;
@property(nonatomic,copy)NSDictionary *followDic;

@end

@implementation CustomDetailViewController
{
    UserManager *singleCustom;
    FollowUpViewControllerModel *modelSkip;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelSkip = [[FollowUpViewControllerModel alloc] init];
    singleCustom = [UserManager shareUserManager];
    _recordDataSourceArr = [[NSMutableArray alloc] init];
    _remindDataSourceArr = [[NSMutableArray alloc] init];
    _CustomTel = [[NSString alloc] init];
    _followText = [[NSString alloc] init];
    _followDic = [[NSDictionary alloc] init];
    self.title = @"客户详情";
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    _sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _sc.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_sc];


    [self creatNameView];
    [self creatBtn];
    [self creatTvChange];
}

-(void)creatNameView{

    _btnName = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnName.frame = CGRectMake(0, 15, ScreenSize.width, 44);
    [_btnName addTarget:self action:@selector(btnNameClick) forControlEvents:UIControlEventTouchUpInside];
    _btnName.backgroundColor = [UIColor whiteColor];
    [_sc addSubview:_btnName];
    
    _labelName = [[UILabel alloc] init];
    _labelName.textColor = [UIColor colorWithHex:0x333333];
    _labelName.font = [UIFont systemFontOfSize:18];
    [_btnName addSubview:_labelName];
    
    _btnThink = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnThink addTarget:self action:@selector(btnThinkClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnName addSubview:_btnThink];
    
    _imageViewArrowDown = [[UIImageView alloc] init];
    _imageViewArrowDown.image = [UIImage imageNamed:@"customer_arrow_bottom"];
    [_btnThink addSubview:_imageViewArrowDown];
    
    _btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMessage.frame = CGRectMake(ScreenSize.width - 23 - 10 - 26 - 36, 0, 26, 44);
    [_btnMessage addTarget:self action:@selector(btnMessageClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnName addSubview:_btnMessage];
    
    _imageViewMessage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 26, 26)];
    _imageViewMessage.image = [UIImage imageNamed:@"customer_record_message"];
    [_btnMessage addSubview:_imageViewMessage];
    
    _btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPhone.frame = CGRectMake(ScreenSize.width - 23 - 10 - 26, 0, 26, 44);
    [_btnPhone addTarget:self action:@selector(btnPhoneClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnName addSubview:_btnPhone];
    
    _imageViewPhone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 26, 26)];
    _imageViewPhone.image = [UIImage imageNamed:@"customer_record_call"];
    [_btnPhone addSubview:_imageViewPhone];
    
    _imageViewArrowRight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width - 23, 14, 8, 16)];
    _imageViewArrowRight.image = [UIImage imageNamed:@"arrow"];
    [_btnName addSubview:_imageViewArrowRight];

}

-(void)creatBtn{
    _labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, ScreenSize.width, 0.5)];
    _labelLine.backgroundColor = [UIColor colorWithHex:0xdddbdb];
    [_sc addSubview:_labelLine];
    
    _imageViewBtnChange = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 4 - 12, 35.5, 24, 10)];
    _imageViewBtnChange.image = [UIImage imageNamed:@"customer_arrow_top"];
    
    NSArray *arrTV = @[@"跟进记录",@"跟进提醒"];
    for (int j = 0; j <2; j ++) {
        UIButton *btnTV = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTV.frame = CGRectMake(ScreenSize.width / 2 * j, 74.5, ScreenSize.width / 2, 45.5);
        [btnTV setBackgroundColor:[UIColor colorWithHex:0xf5f3f3]];
        btnTV.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnTV setTitle:[arrTV objectAtIndex:j] forState:UIControlStateNormal];
        [btnTV setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [btnTV setTitleColor: [UIColor colorWithHex:0x58b6ee]forState:UIControlStateSelected];
        [btnTV setTintColor:[UIColor whiteColor]];
        btnTV.tag = 200 + j;
        [btnTV addTarget:self action:@selector(btnTV:) forControlEvents:UIControlEventTouchUpInside];
        
        if (j == 0) {
            btnTV.selected = YES;
            [btnTV addSubview:_imageViewBtnChange];
            [_scChangeType setContentOffset:CGPointMake(ScreenSize.width * 0, 0) animated:YES];
        }
        [_sc addSubview:btnTV];
    }
    
}

-(void)creatTvChange{

    _scChangeType = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, ScreenSize.width, ScreenSize.height - 120)];
    _scChangeType.delegate = self;
    _scChangeType.showsHorizontalScrollIndicator = NO;
    _scChangeType.contentSize = CGSizeMake(ScreenSize.width * 2, 0);
    _scChangeType.pagingEnabled = YES;
    //不裁边
    _scChangeType.clipsToBounds =NO;
    _scChangeType.bounces = NO;
    [_sc addSubview:_scChangeType];
    _tableViewRecord = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - 120) style:UITableViewStylePlain];
    _tableViewRecord.scrollEnabled = NO;
    _tableViewRecord.dataSource = self;
    _tableViewRecord.delegate = self;
    _tableViewRecord.separatorStyle = NO;
    _tableViewRecord.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
    [_scChangeType addSubview:_tableViewRecord];
    
    _tableViewRemind = [[UITableView alloc] initWithFrame:CGRectMake(ScreenSize.width, 0, ScreenSize.width, ScreenSize.height - 120) style:UITableViewStylePlain];
    _tableViewRemind.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
    _tableViewRemind.scrollEnabled = NO;
    _tableViewRemind.dataSource = self;
    _tableViewRemind.delegate = self;
    _tableViewRemind.separatorStyle = NO;
    [_scChangeType addSubview:_tableViewRemind];

}

-(void)btnTV:(UIButton *)btnChangeTV{
    for (int i = 0; i < 2; i ++) {
        UIButton *buttn = (UIButton *)[self.view viewWithTag:200+i];
        buttn.selected = NO;
    }
    [btnChangeTV addSubview:_imageViewBtnChange];
    btnChangeTV.selected = YES;
    if (btnChangeTV.tag == 200) {
        _sc.contentSize = CGSizeMake(0, _tableViewRecord.contentSize.height + 200);
        if (_tableViewRecord.contentSize.height < ScreenSize.height - 120) {
            _scChangeType.frame =  CGRectMake(0, 120, ScreenSize.width, ScreenSize.height - 120);
        }else{
            _scChangeType.frame = CGRectMake(0, 120, ScreenSize.width, _tableViewRecord.contentSize.height);
        }
        [_scChangeType setContentOffset:CGPointMake(ScreenSize.width * 0, 0) animated:NO];

    }else{
        _sc.contentSize = CGSizeMake(0, _tableViewRemind.contentSize.height + 200);
        if (_tableViewRemind.contentSize.height < ScreenSize.height - 120) {
            _scChangeType.frame =  CGRectMake(0, 120, ScreenSize.width, ScreenSize.height - 120);
        }else{
            _scChangeType.frame = CGRectMake(0, 120, ScreenSize.width, _tableViewRemind.contentSize.height);
        }
        [_scChangeType setContentOffset:CGPointMake(ScreenSize.width , 0) animated:NO];
    }
}



#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scChangeType) {
        //计算出当前滚动的页数
        NSInteger count =  _scChangeType.contentOffset.x/ScreenSize.width;
        for (int i = 0; i < 2; i ++) {
            UIButton *buttn = (UIButton *)[self.view viewWithTag:200+i];
            buttn.selected = NO;
        }
        NSLog(@"count ==== %f",_scChangeType.contentOffset.x);
        if (count == 0) {
            if (_tableViewRecord.contentSize.height < ScreenSize.height - 120) {
                _scChangeType.frame =  CGRectMake(0, 120, ScreenSize.width, ScreenSize.height - 120);
            }else{
                _scChangeType.frame = CGRectMake(0, 120, ScreenSize.width, _tableViewRecord.contentSize.height);
            }

            _sc.contentSize = CGSizeMake(0, _tableViewRecord.contentSize.height + 200);

        }else{
            if (_tableViewRemind.contentSize.height <ScreenSize.height - 120) {
                _scChangeType.frame =  CGRectMake(0, 120, ScreenSize.width, ScreenSize.height - 120);
            }else{
                _scChangeType.frame = CGRectMake(0, 120, ScreenSize.width, _tableViewRemind.contentSize.height);
            }

            _sc.contentSize = CGSizeMake(0, _tableViewRemind.contentSize.height + 200);

        }
        UIButton *buttn = (UIButton *)[self.view viewWithTag:200+count];
        buttn.selected = YES;
        [buttn addSubview:_imageViewBtnChange];
    }
}


-(void)admin:(NSString *)admin_id  customid:(NSString *)custom_id{
    [HTTPRequest GJWithAdminID:admin_id CustomerID:custom_id completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(ok){
            [_recordDataSourceArr removeAllObjects];
            singleCustom.customer_name = data[@"customerInfo"][@"customer_name"];
            _labelName.text = data[@"customerInfo"][@"customer_name"];
            _labelName.frame = CGRectMake(15, 13, _labelName.text.length * 18, 20);
            _btnThink.titleLabel.font = [UIFont systemFontOfSize:15];
            _btnThink.frame = CGRectMake(30 + _labelName.text.length * 18, 1.5, 60, 44);
            _btnThink.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
            _followDic = data;
            _followText = data[@"customerInfo"][@"followText"];
            _CustomTel = data[@"customerInfo"][@"customer_tel"];
            modelSkip.followText = data[@"customerInfo"][@"followText"];
            modelSkip.customer_id = data[@"customerInfo"][@"customer_id"];
            modelSkip.customer_name = data[@"customerInfo"][@"customer_name"];
            
            if ([data[@"customerInfo"][@"thinkText"] isEqualToString:@"A"]) {
                [_btnThink setTitleColor:[UIColor colorWithHex:0xff3737] forState:UIControlStateNormal];
                [_btnThink setTitle:data[@"customerInfo"][@"thinkText"] forState:UIControlStateNormal];
            }else if ([data[@"customerInfo"][@"thinkText"] isEqualToString:@"B"]) {
                [_btnThink setTitleColor:[UIColor colorWithHex:0xf19149] forState:UIControlStateNormal];
                [_btnThink setTitle:data[@"customerInfo"][@"thinkText"] forState:UIControlStateNormal];

            }else if ([data[@"customerInfo"][@"thinkText"] isEqualToString:@"C"]) {
                [_btnThink setTitleColor:[UIColor colorWithHex:0xf2bc11] forState:UIControlStateNormal];
                [_btnThink setTitle:data[@"customerInfo"][@"thinkText"] forState:UIControlStateNormal];

            }else if ([data[@"customerInfo"][@"thinkText"] isEqualToString:@"D"]) {
                [_btnThink setTitleColor:[UIColor colorWithHex:0x4bdd8b] forState:UIControlStateNormal];
                [_btnThink setTitle:data[@"customerInfo"][@"thinkText"] forState:UIControlStateNormal];

            }else{
                [_btnThink setTitle:@"等级" forState:UIControlStateNormal];
                [_btnThink setTitleColor:[UIColor colorWithHex:0xff3737] forState:UIControlStateNormal];
                
            }
            _imageViewArrowDown.frame = CGRectMake(_btnThink.titleLabel.text.length * 15 + 6, 15, 14, 14);
            
            for (NSDictionary *subDict in data[@"customerInfo"][@"noteList"]) {
                detailModel *model = [[detailModel alloc] init];
                NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[subDict[@"note_atime"] intValue]];
                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"YYYY.MM.dd  HH:mm:ss"];
                NSMutableString *timeStr = [NSMutableString stringWithString:[df stringFromDate:dt]];
                
//                if (timeStr.length > 14) {
//                    //上下午类型
//                    NSString *timeChange = [timeStr substringWithRange:NSMakeRange(12, 2)];
//                    [timeStr deleteCharactersInRange:NSMakeRange(12, 2)];
//                    NSString *addTimeType;
//                    if ([timeChange intValue] > 12) {
//                        addTimeType = [NSString stringWithFormat:@"PM%d",[timeChange intValue] - 12];
//                    }else{
//                        addTimeType = [NSString stringWithFormat:@"AM%d",[timeChange intValue]];
//                    }
//                    [timeStr insertString:addTimeType atIndex:12];
//                }
                
                model.note_atime = timeStr;
                model.noteTypeText = [subDict objectForKey:@"noteText"];
                model.note_content = [subDict objectForKey:@"note_content"];
                model.note_pics = [subDict objectForKey:@"note_pics"];
                [_recordDataSourceArr addObject:model];
                [_tableViewRecord reloadData];
            }

        }else{
            [self makeToast:message duration:1];
        }
    }];

}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableViewRecord) {
        return _recordDataSourceArr.count;
    }else{
        return _remindDataSourceArr.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CellID";
    detailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[detailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    detailModel *model;
    if (tableView == _tableViewRecord) {
        //高度
        _tableViewRecord.frame = CGRectMake(0, 0, ScreenSize.width, _tableViewRecord.contentSize.height);
        _sc.contentSize = CGSizeMake(0, _tableViewRecord.contentSize.height + 200);
        if (_tableViewRecord.contentSize.height < ScreenSize.height - 120) {
            _scChangeType.frame =  CGRectMake(0, 120, ScreenSize.width, ScreenSize.height - 120);
        }else{
            _scChangeType.frame = CGRectMake(0, 120, ScreenSize.width, _tableViewRecord.contentSize.height);
        }
        NSLog(@"_tableViewRecord.contentSize.height ===== %f",_tableViewRecord.contentSize.height);
        NSLog(@"_scChangeType.frame.height ===== %f",_scChangeType.frame.size.height);
        
        cell.imageViewTime.image = [UIImage imageNamed:@"customer_record_time"];
        model = [_recordDataSourceArr objectAtIndex:indexPath.row];
    }else{
        _tableViewRemind.frame = CGRectMake(ScreenSize.width, 0, ScreenSize.width, _tableViewRemind.contentSize.height);
        cell.imageViewTime.image = [UIImage imageNamed:@"customer_record_olock"];
        model = [_remindDataSourceArr objectAtIndex:indexPath.row];
    }
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithHex:0xf6f6f6];
    }else if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.model = model;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailModel *modelHeight;
    if (tableView ==  _tableViewRecord) {
        
        modelHeight =  [_recordDataSourceArr objectAtIndex:indexPath.row];
        CGSize noteContentTrueSize = [modelHeight.note_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenSize.width - 55, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (modelHeight.noteTypeText.length == 0) {
            
            if (modelHeight.note_content.length == 0) {
                //内容为空
                if (modelHeight.note_pics.count == 0) {
                    

                    return 50;
                }else{

                    return 15 + 20 + 5 + 21 + 15;
                }
                
            }else{
                //内容不为空
                if (modelHeight.note_pics.count == 0) {

                    return 15 + 20 + 5 + noteContentTrueSize.height + 15;
                }else{

                    return 15 + 20 + 5 + noteContentTrueSize.height + 15 + 26;
                }
            }
            
        }else{
            
            if (modelHeight.note_content.length == 0) {
                //内容为空
                if (modelHeight.note_pics.count == 0) {

                    return 75;
                }else{

                    return 65 + 21 + 15;
                }
            }else{
                //内容不为空
                if (modelHeight.note_pics.count == 0) {

                    return 60 + 5  + noteContentTrueSize.height + 15;
                }else{

                    return 60 + 5 + noteContentTrueSize.height + 5 + 21 + 15;
                }
            }
            
        }

    }else{

        modelHeight =  [_remindDataSourceArr objectAtIndex:indexPath.row];
        
        CGSize noteContentTrueSize = [modelHeight.note_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenSize.width - 55, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (modelHeight.noteTypeText.length == 0) {
            
            if (modelHeight.note_content.length == 0) {
                //内容为空
                if (modelHeight.note_pics.count == 0) {
                    return 50;
                }else{
                    return 15 + 20 + 5 + 21 + 15;
                }
                
            }else{
                //内容不为空
                if (modelHeight.note_pics.count == 0) {
                    return 15 + 20 + 5 + noteContentTrueSize.height + 15;
                }else{
                    return 15 + 20 + 5 + noteContentTrueSize.height + 15 + 26;
                }
            }
            
        }else{
            
            if (modelHeight.note_content.length == 0) {
                //内容为空
                if (modelHeight.note_pics.count == 0) {
                    return 75;
                }else{
                    return 65 + 21 + 15;
                }
            }else{
                //内容不为空
                if (modelHeight.note_pics.count == 0) {
                    return 60 + 5  + noteContentTrueSize.height + 15;
                }else{
                    return 60 + 5 + noteContentTrueSize.height + 5 + 21 + 15;
                }
            }
            
        }

    }
    
}

//设置分区头部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *btnTVHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTVHeader.frame = CGRectMake(0, 0, ScreenSize.width, 26);
    btnTVHeader.backgroundColor = [UIColor colorWithHex:0xdddbdb];
    btnTVHeader.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnTVHeader addTarget:self action:@selector(btnTVHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnTVHeader setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    btnTVHeader.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    if (tableView == _tableViewRecord) {
        [btnTVHeader setTitle:@"添加跟进" forState:UIControlStateNormal];
        btnTVHeader.tag = 300;
    }else{
        [btnTVHeader setTitle:@"添加提醒" forState:UIControlStateNormal];
        btnTVHeader.tag = 400;
    }
    
    UIImageView *imageViewAdd = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 2 - 38, 3, 20, 20)];
    imageViewAdd.image = [UIImage imageNamed:@"customer_record_add"];
    [btnTVHeader addSubview:imageViewAdd];
   
    return btnTVHeader;
}


-(void)photoViewClick:(BOOL)photoViewClick{

    self.navigationController.navigationBarHidden = photoViewClick;
}

#pragma mark nameBtnClick

-(void)btnNameClick{

    findViewController *find = [[findViewController alloc] init];
    find.customId = _custom_id;
    [self.navigationController pushViewController:find animated:YES];

}

-(void)btnThinkClick{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"客户意向等级" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: @"A",@"B",@"C",@"D",nil];
    alert.delegate = self;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *dictThink;
    NSString *strABC;
   
    if (buttonIndex != 0) {
        if (buttonIndex == 1) {
            strABC = @"1";
            [_btnThink setTitle:@"A" forState:UIControlStateNormal];
            [_btnThink setTitleColor:[UIColor colorWithHex:0xff3737] forState:UIControlStateNormal];
            dictThink = @{@"type" : @"set_intent_A"};
        }else if (buttonIndex == 2){
            [_btnThink setTitle:@"B" forState:UIControlStateNormal];
            dictThink = @{@"type" : @"set_intent_B"};
            [_btnThink setTitleColor:[UIColor colorWithHex:0xf19149] forState:UIControlStateNormal];
            strABC = @"2";
        }else if (buttonIndex == 3){
            [_btnThink setTitle:@"C" forState:UIControlStateNormal];
            [_btnThink setTitleColor:[UIColor colorWithHex:0xf2bc11] forState:UIControlStateNormal];
            dictThink = @{@"type" : @"set_intent_C"};
            strABC = @"3";
        }else{
            [_btnThink setTitle:@"D" forState:UIControlStateNormal];
            [_btnThink setTitleColor:[UIColor colorWithHex:0x4bdd8b] forState:UIControlStateNormal];
            dictThink = @{@"type" : @"set_intent_D"};
            strABC = @"6";
        
        }
        [MobClick event:@"set_intent" attributes:dictThink];
        [self thinkWithAdminID:singleCustom.admin_id CustomerID:_custom_id thinkID:strABC ];
    }
    
}

- (void)thinkWithAdminID:(NSString *)adminID
              CustomerID:(NSString *)customerID
                 thinkID:(NSString *)thinkID{
     [self showHUDSimple];
    [HTTPRequest thinkWithAdminID:adminID CustomerID:customerID thinkID:thinkID completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [self hideHUD];
        if(ok){
//            [MBProgressHUD showSuccess:nil];
        }else{
            [MBProgressHUD showError:message];            
        }
        
    }];
}

-(void)btnMessageClick{
    
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_CustomTel]]];

}

-(void)btnPhoneClick{
    [MobClick event:@"call_phone"];
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",_CustomTel]];
    if( [[UIApplication sharedApplication] canOpenURL:telUrl]){
        [[UIApplication sharedApplication]openURL:telUrl];
    }
}

-(void)btnTVHeaderClick:(UIButton *)btnTVheader{
    if (btnTVheader.tag == 300) {
        if ([_followText isEqualToString:@"认购"]) {
            [self makeToast:@"该客户跟进状态已结束" duration:1];
        }else{
            FollowUpViewController *followUp = [[FollowUpViewController alloc] initWithModel:modelSkip];
            
                [self.navigationController pushViewController:followUp animated:YES];
        }
        
    }else{
        remindViewController *rvc = [[remindViewController alloc] init];
        rvc.customId = _custom_id;
        [self.navigationController pushViewController:rvc animated:YES];
    }


}


-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
    [self admin:singleCustom.admin_id customid:_custom_id];
    [_remindDataSourceArr removeAllObjects];
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    for (NSDictionary *dictRemind in [defa objectForKey:@"defaultArr1"]) {
        if ([dictRemind[@"customer_id"] isEqualToString:_custom_id]) {
            detailModel *model = [[detailModel alloc] init];
            model.noteTypeText = dictRemind[@"noteText"];
            model.note_atime = dictRemind[@"note_atime"];
            model.note_content = dictRemind[@"note_content"];
            model.note_pics = dictRemind[@"note_pics"];
            [_remindDataSourceArr addObject:model];
        }
        [_tableViewRemind reloadData];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
