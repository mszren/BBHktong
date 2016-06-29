//
//  TingDropDownMenu.h
//  TingDropDownMenu
//
//  Created by Ting on 15/11/19.
//  Copyright (c) 2015年 Ting All rights reserved.
//

#import <UIKit/UIKit.h>

@class TingDropDownMenu;

@protocol TingDropDownMenuDataSource <NSObject>

@required

- (NSInteger)menu:(TingDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)menu:(TingDropDownMenu *)menu tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - delegate

@protocol TingDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(TingDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface TingDropDownMenu : NSObject


@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id <TingDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <TingDropDownMenuDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin targetView:(UIView *)targetView;

-(void)menuTapped;

@end
