//
//  findViewController.m
//  HKT
//
//  Created by app on 15-7-2.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "findViewController.h"

@interface findViewController ()
{
    UIScrollView *sc;
    NSArray *arrDown;
    UIButton *leftButton;

}
@end

@implementation findViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"客户资料";
    //左按钮
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    
    sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - 64)];
    sc.tag = 880;
    sc.delegate = self;
    sc.backgroundColor =[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    sc.bounces = NO;
    sc.showsVerticalScrollIndicator = NO;
    [self creatLoad];
    int y = 0;
    NSArray *arrUnclick = @[@"姓名",@"号码",@"性别",@"意向楼盘",@"意向楼层",@"需求面积",@"意向价位"];
    for (int i = 0; i < 7; i ++) {
        if (i == 0 || i == 3) {
            y += 1;
        }
        UIView *ViewBgTop = [[UIView alloc] initWithFrame:CGRectMake(0, 44 * i+ 15 * y, ScreenSize.width, 44)];
        ViewBgTop.backgroundColor = [UIColor whiteColor];
        [sc addSubview:ViewBgTop];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 80, 20)];
        labelName.text = [arrUnclick objectAtIndex:i];
        labelName.font = [UIFont systemFontOfSize:14];
        [ViewBgTop addSubview:labelName];
        
        UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(ScreenSize.width - 15 - 120, 12, 120, 20)];
        labelContent.tag = 100+i;
        labelContent.textColor = [UIColor colorWithHex:0x999999];
        labelContent.textAlignment = NSTextAlignmentRight;
        labelContent.font = [UIFont systemFontOfSize:14];
        [ViewBgTop addSubview:labelContent];
        
        UILabel *labelLineTop = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, ScreenSize.width - 15, 1)];
        labelLineTop.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        [ViewBgTop addSubview:labelLineTop];
        
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame  = CGRectMake(0, 352, ScreenSize.width, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"gray2"] forState:UIControlStateHighlighted];
    [btn setTitle:@"点击查看更多" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:71/255.0f green:180/255.0f blue:245/255.0f alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sc addSubview:btn];
    
    [self.view addSubview:sc];
}

-(void)creatLoad
{
    [self findWithCustomerID:_customId];
    
}

-(void)findWithCustomerID:(NSString *)customerID{
    [HTTPRequest findWithCustomerID:customerID completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if(ok){

            NSArray *arr = @[data[@"customer_name"],data[@"customer_tel"],data[@"customer_sex"],data[@"customer_house"],data[@"customer_hight"],data[@"customer_size"],data[@"customer_price"]];
            arrDown = @[data[@"customer_marry"],data[@"customer_job"],data[@"customer_area"],data[@"customer_think"],data[@"customer_state"],data[@"customer_income"],data[@"customer_remark"]];
            
            for (NSInteger i = 0; i<7; i++) {
                UILabel *lable = (UILabel *)[self.view viewWithTag:100+i];
                lable.text = [NSString stringWithFormat:@"  %@",[arr objectAtIndex:i]];
                lable.textColor = [UIColor colorWithHex:0x999999];
            }

            
        }else{

            [self makeToast:message duration:1];

//            [MBProgressHUD showError:message];
        }
        
    }];

}


-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)btnClick:(UIButton *)btn
{
    
    btn.frame = CGRectMake(0, 0, 0, 0);
    UIScrollView * scroll = (UIScrollView *)[self.view viewWithTag:880];
    int z = 0;
    NSArray *arrDownName = @[@"家庭结构",@"客户职业",@"居住区域",@"案场判定",@"客户状态",@"家庭收入"];
    for (int j = 0 ; j < 6; j ++) {
        if (j == 3) {
            z += 1;
        }
        UIView *viewBgFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 352 + 44 * j+ 15 * z, ScreenSize.width, 44)];
        viewBgFoot.backgroundColor = [UIColor whiteColor];
        [sc addSubview:viewBgFoot];
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 80, 20)];
        labelName.text = [arrDownName objectAtIndex:j];
        labelName.font = [UIFont systemFontOfSize:14];
        [viewBgFoot addSubview:labelName];
        
        UILabel *labelContent = [[UILabel alloc] initWithFrame:CGRectMake(ScreenSize.width - 15 - 120, 12, 120, 20)];
        labelContent.tag = 100+j;
        labelContent.textAlignment = NSTextAlignmentRight;
        labelContent.font = [UIFont systemFontOfSize:14];
        [viewBgFoot addSubview:labelContent];
        
        UILabel *labelLineTop = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, ScreenSize.width - 15, 1)];
        labelLineTop.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        [viewBgFoot addSubview:labelLineTop];
        
    }
    sc.contentSize = CGSizeMake(0, 700);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
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
