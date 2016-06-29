//
//  ourCompanyViewController.m
//  HKT
//
//  Created by app on 15-6-4.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "ourCompanyViewController.h"
#import "SetWebViewController.h"
#import "UserManager.h"
#import "realizeViewController.h"

#define Size [[UIScreen mainScreen] bounds].size
@interface ourCompanyViewController ()
{
    UserManager *singleOc;
}
@property(nonatomic,strong)UIButton *leftButton;

@end

@implementation ourCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sc.backgroundColor = [UIColor whiteColor];
    sc.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sc];
    self.title = @"关于我们";
    
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];

    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:
                          CGRectMake(0, -15, Size.width, Size.width / 2.5)];
    image.image = [UIImage imageNamed:@"berui"];
    [sc addSubview:image];
    
    UILabel *labelJJ = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + 30, Size.width - 20, 30)];
    labelJJ.text = @"简介";
    labelJJ.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    [sc addSubview:labelJJ];
    
    UILabel * labelJJN = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + 65, Size.width - 20, 25)];
    labelJJN.alpha = 0.8;
    labelJJN.font = [UIFont systemFontOfSize:15];
    labelJJN.text = @"百瑞地产家居网成立于2005年，历时10年秉承网络改变生活的理念，致力于为购房者提供便捷可靠的购房体验。至今，百瑞地产家居网覆盖全省楼盘信息、网站日均PV超过350W，拥有注册会员数30W人，依靠丰富的楼盘信息、专业的楼市解读、以及丰富的线下活动深受合肥本地购房者喜爱和支持。";
    [labelJJN setNumberOfLines:0];
    CGSize trueSize = [labelJJN.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(Size.width - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    labelJJN.frame = CGRectMake(10, Size.height/8 + 65, Size.width - 20, trueSize.height);
    [sc addSubview:labelJJN];
    
    UILabel *labelSM = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 80, Size.width - 20, 30)];
    labelSM.text = @"百瑞使命";
    labelSM.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    [sc addSubview:labelSM];

    UILabel *labelSMT = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + 105 + trueSize.height , Size.width - 20, 30)];
    labelSMT.alpha = 0.8;
    labelSMT.font = [UIFont systemFontOfSize:15];
    labelSMT.text = @"为购房者提供便捷可靠的购房服务";
    [sc addSubview:labelSMT];

    UILabel *labelQY = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + 145 + trueSize.height, Size.width - 20, 30)];
    labelQY.text = @"企业价值观";
    labelQY.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    [sc addSubview:labelQY];

    UILabel *labelQYT = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 175, Size.width - 20, 30)];
    labelQYT.alpha = 0.8;
    labelQYT.font = [UIFont systemFontOfSize:15];
    labelQYT.text = @"客户至上、追求卓越、诚信为本、高效创新、合作共赢";
    [labelQYT setNumberOfLines:0];
    CGSize trueSizeQYT = [labelQYT.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(Size.width - 20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    labelQYT.frame = CGRectMake(10, Size.height/8 + trueSize.height + 175, Size.width - 20, trueSizeQYT.height);
    [sc addSubview:labelQYT];

    UILabel *labelKH = [[UILabel alloc] initWithFrame:CGRectMake(10,Size.height/8 + trueSize.height + 195 + trueSizeQYT.height, self.view.frame.size.width - 20, 30)];
    labelKH.text = @"企业口号";
    labelKH.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    [sc addSubview:labelKH];
    
//    UILabel *labelKHT = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/8 + size.height + size1.height + 53, self.view.frame.size.width - 20, 30)];
        UILabel *labelKHT = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 220 + trueSizeQYT.height, Size.width - 20, 30)];
    labelKHT.text = @"上百瑞，买房更优惠";
    labelKHT.alpha = 0.8;
    labelKHT.font = [UIFont systemFontOfSize:15];
    [sc addSubview:labelKHT];
    
    UILabel *labelTell = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 260 + trueSizeQYT.height , 150, 30)];
    labelTell.text = @"客服电话";
    labelTell.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    [sc addSubview:labelTell];

    
    UIButton *TellContent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    TellContent.frame = CGRectMake(10, Size.height/8 + trueSize.height + 285 + trueSizeQYT.height , 300, 30);
    TellContent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [TellContent setTitle:@"400-9955-877" forState:UIControlStateNormal];
    [TellContent addTarget:self action:@selector(btnClick)
  forControlEvents:UIControlEventTouchUpInside];
    [TellContent setTitleColor:[UIColor colorWithHex:0x32acea] forState:UIControlStateNormal];
    TellContent.titleLabel.font = [UIFont systemFontOfSize:15];
    [sc addSubview:TellContent];
    
    UILabel *labelEdition = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 325 + trueSizeQYT.height, 300, 30)];
    labelEdition.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    labelEdition.text = @"当前版本";
    [sc addSubview:labelEdition];
    
    UILabel *labelEditionContent = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 350 + trueSizeQYT.height, 300, 30)];
    labelEditionContent.alpha = 0.7;
    labelEditionContent.font = [UIFont systemFontOfSize:15];
    labelEditionContent.text = @"v1.1.0 for iPhone";
    [sc addSubview:labelEditionContent];
    
    UILabel *labelWeb = [[UILabel alloc] initWithFrame:CGRectMake(10, Size.height/8 + trueSize.height + 390 + trueSizeQYT.height, 300, 30)];
    labelWeb.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    labelWeb.text = @"网站";
    [sc addSubview:labelWeb];
    
    sc.contentSize = CGSizeMake(0, Size.height/8 + trueSize.height + 540 + trueSizeQYT.height);
    
    UIButton *WebContent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    WebContent.frame = CGRectMake(10, Size.height/8 + trueSize.height + 415 + trueSizeQYT.height, 300, 30);
    WebContent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [WebContent setTitle:@"http://www.berui.com" forState:UIControlStateNormal];
    [WebContent addTarget:self action:@selector(btnWebClick)
          forControlEvents:UIControlEventTouchUpInside];
    [WebContent setTitleColor:[UIColor colorWithHex:0x32acea] forState:UIControlStateNormal];
    WebContent.titleLabel.font = [UIFont systemFontOfSize:15];
    [sc addSubview:WebContent];
    
    
}

-(void)btnClick{
    NSString *number = @"4009955877";
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",number]];
    if( [[UIApplication sharedApplication] canOpenURL:telUrl]){
        [[UIApplication sharedApplication]openURL:telUrl];
    }

}

-(void)btnWebClick{
    SetWebViewController *web = [[SetWebViewController alloc] initWithURLStr:@"http://www.berui.com"];
    [self.navigationController pushViewController:web animated:YES];
    
}

-(void)buttonLeftClick
{
    singleOc._urlPage = 0;
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
