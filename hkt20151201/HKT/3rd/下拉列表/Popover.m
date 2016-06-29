//
//  Popover.m
//  HKT
//
//  Created by app on 15-6-15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "Popover.h"
#import <QuartzCore/QuartzCore.h>

//@interface UIPopoverListView ()
//@interface UIPopoverListView ()
//
//
//- (void)defalutInit;
//- (void)fadeIn;
//- (void)fadeOut;
//
//@end


@implementation Popover

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

@synthesize listView = _listView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
       CGFloat xWidth = self.bounds.size.width;
    
    CGRect tableFrame = CGRectMake(0, 32.0f, xWidth, self.bounds.size.height-32.0f);
    _listView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _listView.bounces = NO;
   //线
    _listView.separatorStyle = NO;
    _listView.dataSource = self;
    _listView.delegate = self;
    [self addSubview:_listView];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
    {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:cellForIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:heightForRowAtIndexPath:)])
    {
        return [self.delegate popoverListView:self heightForRowAtIndexPath:indexPath];
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:didSelectIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectIndexPath:indexPath];
    }
    
    [self dismiss];
}


//#pragma mark - animations
//
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    //_titleView.text = title;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListViewCancel:)]) {
        [self.delegate popoverListViewCancel:self];
    }
    
    // dismiss self
    [self dismiss];
}







@end
