//
//  AdViewController.m
//  HKT
//
//  Created by app on 15/11/12.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "AdViewController.h"
#import "HTTPRequest+AD.h"
#import "UIImageView+WebCache.h"
#import "UIView+Size.h"

@interface AdViewController ()

//@property(nonatomic,strong) UIView      *   splashView;
@property(nonatomic,strong) UIImageView *   imageAd;

@property(nonatomic,strong) UIView      *   bottomView;
@property(nonatomic,strong) UIImageView *   imageBottom;


@property(nonatomic,copy)   NSString    *   timeStr;
@property(nonatomic,strong) UILabel     *   labelTime;

@property(nonatomic,strong) UIButton    *   btnSkip;


@end

@implementation AdViewController
{
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //广告页
    
    _imageAd = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height - 80)];
    _imageAd.userInteractionEnabled = YES;
    [_imageAd setBackgroundColor:[UIColor colorWithHex:0xf8f8f8]];
    [self.view addSubview:_imageAd];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight - 80, kDeviceWidth, 80)];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    [self.view addSubview:_bottomView];
    
    
    _imageBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 320, 80)];
    _imageBottom.image = [UIImage imageNamed:@"hkt_logo"];
    
    _imageBottom.centerX = _bottomView.centerX;
    [_bottomView addSubview:_imageBottom];
    
    [self start];
}


-(void)start{
    
    [HTTPRequest getAdImageUrlCompleteBlock:^(BOOL ok, NSString *message, NSURL *url) {
        if(ok){
            if(url.absoluteString.length>0){
                [_imageAd addSubview:self.btnSkip];
                [self TimerAd];
                [_imageAd sd_setImageWithURL:url];
            }else {
                [self btnSkipClick];
            }
        }else {
            [self btnSkipClick];
        }
    }];
}

//隐藏广告
-(void)btnSkipClick{
    if(_timer){
        dispatch_source_cancel(_timer);
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //3block
    if (self.SkipStatus) {
        self.SkipStatus(@"skipLogin");
    }
}

-(void)TimerAd{
    __block int timeout=3;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self btnSkipClick];
            });
        }else{
            int seconds = timeout % 60;
            _timeStr = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _labelTime.text = _timeStr;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

-(UIButton *)btnSkip{
    if(!_btnSkip){
        _btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSkip.frame = CGRectMake(self.view.bounds.size.width - 70, 30, 54, 28);
        [_btnSkip setTitle:@"跳过" forState:UIControlStateNormal];
        _btnSkip.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSkip.titleEdgeInsets = UIEdgeInsetsMake(0, - 20, 0, 0);
        _btnSkip.layer.masksToBounds = YES;
        _btnSkip.layer.cornerRadius = 4;
        [_btnSkip setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
        [_btnSkip setBackgroundImage:[UIImage imageNamed:@"gray2"] forState:UIControlStateHighlighted];
        _btnSkip.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSkip addTarget:self action:@selector(btnSkipClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnSkip setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
        
        _labelTime = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 20, 30)];
        _labelTime.font = [UIFont systemFontOfSize:14];
        _labelTime.textColor = [UIColor redColor];
        [_btnSkip addSubview:_labelTime];
    }
    return _btnSkip;
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
