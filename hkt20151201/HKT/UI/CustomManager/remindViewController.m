//
//  remindViewController.m
//  HKT
//
//  Created by app on 15-7-3.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "remindViewController.h"



@interface remindViewController ()<UITextViewDelegate>
{
    NSString *btnName;
    
    NSString *_strContent;
    NSString *_strTime;
    NSString *_strState;
    
    UserManager *singleRemind;
}

@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UILabel *labelRemindType;
@property(nonatomic,strong)UIImageView *selectImage;
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *labelUP;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *timeBtn;
@property(nonatomic,strong)UILabel *labelTip;
@property(nonatomic,strong)UILabel *labelTime;
@end

@implementation remindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    singleRemind = [UserManager shareUserManager];
    _strContent = [[NSString alloc] init];
    _strContent = @"";
    _strTime = [[NSString alloc] init];
    _strState = [[NSString alloc] init];
    _strState = @"回访";
    btnName = [[NSString alloc] init];
    
    _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(68, 2.5, 17, 17)];
    _selectImage.image = [UIImage imageNamed:@"customer_add_type"];
    
    self.title =  @"增加提醒";
    
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    //右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 120)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    
    _labelRemindType = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    _labelRemindType.text = @"提醒类型";
    _labelRemindType.font = [UIFont systemFontOfSize:16];
    [_topView addSubview:_labelRemindType];
    
    //    int y = 0;
    //    NSArray *arrContent = @[@"回访",@"资料催收",@"催款",@"签合同",@"约见客户",@"其他"];
    //    for (int i = 0; i < 2; i ++) {
    //        for (int j = 0 ; j < 3; j ++) {
    //            UIButton *btnTypeContent = [UIButton buttonWithType:UIButtonTypeCustom];
    //            btnTypeContent.frame = CGRectMake((ScreenSize.width - 270)/4 * (1 + j)+ 90 * j , 45 + 35 * i, 90, 22);
    //            [btnTypeContent setTitle:[arrContent objectAtIndex:y] forState:UIControlStateNormal];
    //            [btnTypeContent setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    //            btnTypeContent.titleLabel.font = [UIFont systemFontOfSize:14];
    //            btnTypeContent.tag = 110 + y;
    //            btnTypeContent.layer.masksToBounds = YES;
    //            btnTypeContent.layer.cornerRadius = 11;
    //            btnTypeContent.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
    //            btnTypeContent.layer.borderWidth = 0.5;
    //            [btnTypeContent addTarget:self action:@selector(btnTypeContent:) forControlEvents:UIControlEventTouchUpInside];
    //            [_topView addSubview:btnTypeContent];
    //            y ++;
    //            if (y == 1) {
    //                [btnTypeContent addSubview:_selectImage];
    //                btnTypeContent.titleEdgeInsets = UIEdgeInsetsMake(0, - 13, 0, 0);
    //            }
    //
    //        }
    //    }
    
    NSArray *arrContent = @[@"回访",@"资料催收",@"催款",@"签合同",@"约见客户",@"其他"];
    int allTopLength = 0;
    int allBottomLength = 0;
    int y = 0;
    for (int i = 0; i < 6; i ++) {
        UIButton *btnTypeContent = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *btnNameStr = [arrContent objectAtIndex:i];
        btnTypeContent.titleLabel.font = [UIFont systemFontOfSize:15];
        btnTypeContent.tag = 110 + y;
        btnTypeContent.layer.masksToBounds = YES;
        btnTypeContent.layer.cornerRadius = 4;
        btnTypeContent.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色,要为CGColor
        btnTypeContent.layer.borderWidth = 1;
        [btnTypeContent setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
        [btnTypeContent setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        btnTypeContent.frame = CGRectMake(15 + allTopLength, 40, btnNameStr.length * 16 + 20, 30);
        allTopLength += btnNameStr.length * 16 + 20 + 15;
        [btnTypeContent addTarget:self action:@selector(btnTypeContent:) forControlEvents:UIControlEventTouchUpInside];
        if (allTopLength + 15 > ScreenSize.width) {
            btnTypeContent.frame = CGRectMake(15 + allBottomLength, 85, btnNameStr.length * 16 + 20, 30);
            allBottomLength += btnNameStr.length * 16 + 20 + 15;
        }
        
        if (y== 0) {
            [btnTypeContent setBackgroundImage:[UIImage imageNamed:@"btn_disable"] forState:UIControlStateNormal];
        }
        y ++;
        [btnTypeContent setTitle:btnNameStr forState:UIControlStateNormal];
        [_topView addSubview:btnTypeContent];
    }
    
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 73)];
    _centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_centerView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 3, self.view.frame.size.width-30, 70)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    [_centerView addSubview:_textView];
    
    _labelUP = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _labelUP.enabled = NO;
    _labelUP.text = @" 请输入提醒内容";
    _labelUP.font = [UIFont systemFontOfSize:14];
    _labelUP.textColor =[UIColor darkGrayColor];
    [_textView addSubview:_labelUP];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 233, self.view.frame.size.width, 45)];
    _bottomView.userInteractionEnabled = YES;
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _timeBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 45);
    [_timeBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(ScreenSize.width - 190, 13, 160, 20)];
    _labelTime.textAlignment = NSTextAlignmentRight;
    _labelTime.font = [UIFont systemFontOfSize:14];
    _labelTime.textColor = [UIColor colorWithHex:0x35a8ee];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr =[format stringFromDate:today];
    
    _labelTime.text = timeStr;
    [_timeBtn addSubview:_labelTime];
    
    _labelTip = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 100, 20)];
    _labelTip.font = [UIFont systemFontOfSize:14];
    _labelTip.text = @"时间";
    [_timeBtn addSubview:_labelTip];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20, 12, 10, 20)];
    arrowImage.image = [UIImage imageNamed:@"arrow"];
    [_timeBtn addSubview:arrowImage];
    [_bottomView addSubview:_timeBtn];
    [self.view addSubview:_bottomView];
    
    
}


-(void)timeBtnClick
{
    CustomPickerView *datePicker = [[CustomPickerView alloc] initWithTitle:@"选择日期" pickerType:KDateAndTimePicker contextData:nil  cancelBlock:^(BOOL animated) {
        ;
    } selectDataBlock:^(NSDictionary *dic) {
        
        _labelTime.text = dic[@"date"];
        
    }];
    
    [datePicker show:YES];
    
}

//切换标签

-(void)btnTypeContent:(UIButton *)btn
{
    for (int m = 0; m < 7; m ++) {
        UIButton *btnAll = (UIButton *)[self.view viewWithTag:110 + m];
        [btnAll setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
    }
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_disable"] forState:UIControlStateNormal];
    
    btnName =  btn.titleLabel.text ;
    _strState = btn.titleLabel.text;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text length] == 0) {
        [_labelUP setHidden:NO];
    }else{
        [_labelUP setHidden:YES];
    }
    _strContent = textView.text;
}

#pragma mark - buttonLeftClick


-(void)buttonLeftClick{
    
    if ([_textView.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您确定要放弃编辑吗？" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
        alert.tag = 111;
        alert.delegate = self;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)buttonRightClick
{
    [self creatConserve];
}
//保存
-(void)creatConserve
{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *fromdate=[format dateFromString:_labelTime.text];
    
    //设置事件之前多长时候开始提醒
    float alarmFloat=-10;
    NSString*eventTitle=@"汇客通提醒";
    NSString*locationStr=[NSString stringWithFormat:@"%@_%@",singleRemind.customer_name,_strState];
    
    NSLog(@"singleRemind.customer_name ===== %@",singleRemind.customer_name);
    if (_labelTime.text.length == 0) {
        
        [self makeToast:@"请输入提醒时间" duration:1];
    }else{
        
        [ZCActionOnCalendar saveEventStartDate:fromdate endDate:fromdate alarm:alarmFloat eventTitle:eventTitle location:locationStr isReminder:YES];
        
        _strTime = _labelTime.text;
        singleRemind = [UserManager shareUserManager];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_customId,@"customer_id",_labelTime.text,@"note_atime",_strState,@"noteText",_strContent,@"note_content", nil];
        
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[de objectForKey:@"defaultArr1"]];
        //越界，赋值限制了范围
        //  NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        // dataArr = [de objectForKey:@"dataArr"];
        [dataArr insertObject:dict atIndex:0];
        //[dataArr addObject:dict];
        [de setObject:dataArr forKey:@"defaultArr1"];
        [de synchronize];
        [self makeToast:@"保存成功" duration:1];
        CustomDetailViewController *detail = [[CustomDetailViewController alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
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
