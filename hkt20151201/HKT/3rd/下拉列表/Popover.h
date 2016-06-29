//
//  Popover.h
//  HKT
//
//  Created by app on 15-6-15.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPopoverListView;

@protocol UIPopoverListViewDataSource <NSObject>

@required

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section;

@end

@protocol UIPopoverListViewDelegate <NSObject>
@optional

- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListViewCancel:(UIPopoverListView *)popoverListView;

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface Popover : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_listView;
//    UILabel     *_titleView;
    UIControl   *_overlayView;
    
//    id<UIPopoverListViewDataSource> _datasource;
//    id<UIPopoverListViewDelegate>   _delegate;
 
    

}

@property (nonatomic, assign) id<UIPopoverListViewDataSource> datasource;
@property (nonatomic, assign) id<UIPopoverListViewDelegate>   delegate;

@property (nonatomic, retain) UITableView *listView;

//- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;


@end
