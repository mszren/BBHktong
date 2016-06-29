//
//  FollowUpHeadView.h
//  HKT
//
//  Created by Ting on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FollowUpHeadViewDelegate<NSObject>

-(void)actionWithFollowClick:(UIButton *)button;

-(void)actionWithTypeClick:(NSString *)type;

@end

@interface FollowUpHeadView : UIView

@property (nonatomic,weak)IBOutlet UILabel *labelStates;
@property (nonatomic,weak)IBOutlet UILabel *labelName;

@property (nonatomic,assign)id<FollowUpHeadViewDelegate>delegate;

//-(NSString *)getFollowType;
//
//-(NSString *)getFollowId;

@end
