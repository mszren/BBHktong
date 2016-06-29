//
//  TingDropDownMenu.m
//  TingDropDownMenu
//
//  Created by Ting on 15/11/19.
//  Copyright (c) 2015年 Ting All rights reserved.
//

#import "TingDropDownMenu.h"

@interface TingDropDownMenu()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, assign) BOOL show;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, assign) CGFloat tableViewHeight;

@property (nonatomic, strong) UITableView *middleTableView;

@property (nonatomic, weak) UIView *targetView;

@end

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define TingDropDownMenuRowHeight 38.0f


@implementation TingDropDownMenu

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin targetView:(UIView *)targetView{
    if (self) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        _origin = origin;
        _show = NO;
        _targetView = targetView;
        
        _middleTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y , ScreenWidth, 0) style:UITableViewStylePlain];
        _middleTableView.rowHeight = TingDropDownMenuRowHeight;
        _middleTableView.dataSource = self;
        _middleTableView.delegate = self;
        _middleTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _middleTableView.backgroundColor = [UIColor clearColor];
        _middleTableView.scrollEnabled = NO;
        
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
    }
    return self;
}



#pragma mark - gesture handle

- (void)menuTapped{
    
    if (!_show) {
        
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.middleTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    [self animateBackGroundView:self.backGroundView show:!_show complete:^{
        
        [self animateTableViewShow:!_show complete:^{

            _show = !_show;
            
        }];
    }];
    
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self animateBackGroundView:_backGroundView show:NO complete:^{
        
        [self animateTableViewShow:NO complete:^{
            _show = NO;
            
        }];
    }];
}

#pragma mark - animation method


- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.targetView addSubview:view];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete {
    
    if (show) {
        
        _middleTableView.frame = CGRectMake(self.origin.x, self.origin.y, ScreenWidth , 0);
        
        [self.targetView addSubview:_middleTableView];
        _middleTableView.alpha = 1.f;
        [UIView animateWithDuration:0.2 animations:^{
            
            _middleTableView.frame = CGRectMake(self.origin.x , self.origin.y, ScreenWidth, _tableViewHeight);
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(M_PI);
            }
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _middleTableView.alpha = 0.f;
            if (self.transformView) {
                self.transformView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            
            [_middleTableView removeFromSuperview];
        }];
    }
    complete();
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)]) {
        
        NSInteger rowNum = [self.dataSource menu:self tableView:tableView numberOfRowsInSection:section];
        
        _tableViewHeight = TingDropDownMenuRowHeight * rowNum;
        
        return rowNum;
        
    } else {
        
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(self.dataSource != nil, @"menu's datasource shouldn't be nil");
    
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:cellForRowAtIndexPath:)]) {
        
        return [self.dataSource menu:self tableView:tableView cellForRowAtIndexPath:indexPath];
        
     }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        //TODO: delegate is nil
    }
}

@end