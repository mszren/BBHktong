//
//  HistoryUserView.h
//  HKT
//
//  Created by Ting on 15/11/12.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HistoryUserViewDelegate <NSObject>


-(void)historyUseViewDeleteAtIndex:(NSUInteger)index;
-(void)historyUseViewChooseAtIndex:(NSUInteger)index;

@end

@interface HistoryUserView : UIView

@property (nonatomic,weak)IBOutlet UIImageView *imgViewForHead;
@property (nonatomic,weak)IBOutlet UILabel *lblName;
@property (nonatomic,weak)IBOutlet UIButton *closeBtn;
@property (nonatomic,assign)id<HistoryUserViewDelegate> delegate;

-(void)showCloseBtn;

@end
