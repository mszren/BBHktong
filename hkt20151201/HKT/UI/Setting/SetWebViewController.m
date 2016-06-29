//
//  SetWebViewController.m
//  HKT
//
//  Created by app on 15/10/22.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "SetWebViewController.h"
#import "UIView+Size.h"

@interface SetWebViewController ()<UIWebViewDelegate>
{
    UIView *view;
    UIActivityIndicatorView *activity;
    NSString *firestUrl;
    UILabel *labelHKT;
    NSTimer * timer;
    
}
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIWebView *webViewSelf;

@end

@implementation SetWebViewController

-(instancetype)initWithURLStr:(NSString *)urlStr{
    self = [super init];
    if (self) {
        firestUrl = urlStr;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //设置中心点为view的中心点
    activity.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2 - 35);
    activity.color = [UIColor whiteColor];
    view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.5;
 
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    _webViewSelf = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webViewSelf.height = _webViewSelf.height-64;
    NSURL *url = [NSURL URLWithString:firestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webViewSelf.delegate = self;
    [_webViewSelf loadRequest:request];
    [self.view addSubview:_webViewSelf];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getState) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
}

-(void)getState{
    
    NSString *jsonStr = [self.webViewSelf stringByEvaluatingJavaScriptFromString:@"getStatus()"];
    if(jsonStr.length>0){
        [self stateFunction:jsonStr];
    }
}

-(void)stateFunction:(NSString *)jsonStr{
    if(jsonStr.length>0){
        if([jsonStr isEqualToString:@"1"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activity removeFromSuperview]; // 结束旋转
    self.title = [webView  stringByEvaluatingJavaScriptFromString:@"document.title"];

    view.hidden = YES;
    //[activity stopAnimating];
}

-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activity removeFromSuperview]; // 结束旋转
    view.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.view addSubview:view];
    [view addSubview:activity];
    //让控件开始转动
    [activity startAnimating];
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
