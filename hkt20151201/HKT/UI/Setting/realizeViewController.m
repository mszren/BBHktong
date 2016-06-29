//
//  realizeViewController.m
//  HKT
//
//  Created by app on 15/8/19.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "realizeViewController.h"
#import "CoreLabel.h"
#define Size [[UIScreen mainScreen] bounds].size

@interface realizeViewController ()
@property(nonatomic,strong)UIButton *leftButton;

@end

@implementation realizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"了解汇客通";
    
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:
                          CGRectMake(Size.width / 2 - 79, 15, 158, 120)];
    image.image = [UIImage imageNamed:@"set_abouthkt"];
    [self.view addSubview:image];
    
    UILabel * labelJJN = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 20, 25)];
    labelJJN.alpha = 0.8;
    
    //    labelJJN.text = @"汇客通是百瑞地产家居网，官方推出的转为置业顾问用户量身打造的手机APP，目前已覆盖合肥大部分在售楼盘，在线沟通功能帮助置业顾问及时，便捷的与购房者进行交流，轻松网罗目标用户，云端客户管理系统，对目标客户进行分类管理，经纪人推荐客户，让置业顾问业绩飙升，汇客通将为广大置业顾问提供更专业的服务。";
    //    [labelJJN setNumberOfLines:0];
    //    labelJJN.lineBreakMode = NSLineBreakByCharWrapping;
    //    CGSize size = [labelJJN sizeThatFits:CGSizeMake(labelJJN.frame.size.width, MAXFLOAT)];
    //    labelJJN.frame = CGRectMake(10, [[UIScreen mainScreen] bounds].size.width / 2.4 -17, self.view.frame.size.width - 20, size.height);
    //    labelJJN.font = [UIFont systemFontOfSize:14];
    //    [self.view addSubview:labelJJN];
    
    CoreLabel *labelEquleDirect = [[CoreLabel alloc] init];
    labelEquleDirect.font = [UIFont systemFontOfSize:15];
    labelEquleDirect.cl_verticalAlignment=CoreLabelVerticalAlignmentMiddle;
    labelEquleDirect.cl_lineSpacing = 5;
    labelEquleDirect.text = @"汇客通是百瑞地产家居网，官方推出的转为置业顾问用户量身打造的手机APP，目前已覆盖合肥大部分在售楼盘，在线沟通功能帮助置业顾问及时，便捷的与购房者进行交流，轻松网罗目标用户，云端客户管理系统，对目标客户进行分类管理，经纪人推荐客户，让置业顾问业绩飙升，汇客通将为广大置业顾问提供更专业的服务。";
    CGSize trueSizeEquleDirect = [labelEquleDirect.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(Size.width - 40, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    labelEquleDirect.frame = CGRectMake(15, 150 , Size.width - 30, trueSizeEquleDirect.height);
    labelEquleDirect.textColor = [UIColor darkGrayColor];
    [labelEquleDirect addAttr:CoreLabelAttrFont value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0,3)];
    [labelEquleDirect updateLabelStyle];
    [self.view addSubview:labelEquleDirect];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 115, [[UIScreen mainScreen] bounds].size.width , 20)];
    label.text = @"百瑞地产家居网版权所有";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x999999];
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
    UILabel *labelC = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, [[UIScreen mainScreen] bounds].size.width , 20)];
    labelC.text = @"Copyright © 2015 berui.com Limited,All Right Reserved";
    labelC.textAlignment = NSTextAlignmentCenter;
    labelC.textColor = [UIColor grayColor];
    labelC.font = [UIFont systemFontOfSize:9];
    [self.view addSubview:labelC];

}

-(void)buttonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
