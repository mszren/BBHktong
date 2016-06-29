//
//  scoreViewController.m
//  HKT
//
//  Created by app on 15-7-14.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "scoreViewController.h"

@interface scoreViewController ()

@end

@implementation scoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *labelHKT = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 5, 60, 30)];
    labelHKT.text = @"给我打分";
    labelHKT.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = labelHKT;
    

    
    UIButton *leftButton = [self getBackButton];
    [leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    
    NSString *str = [[NSString alloc] init];
    
    str =  @"itms-apps://itunes.apple.com/app/id1044183743";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];    
    // Do any additional setup after loading the view.
}

-(void)buttonLeftClick{
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
