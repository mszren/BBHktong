//
//  PasswordView.h
//  HKT
//
//  Created by Ting on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasswordView : UIView

@property (nonatomic, copy) void (^finishEdit)(NSString * password ,PasswordView *passwordView);

@property (nonatomic, copy) void (^forgetPassword)();

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

@property (nonatomic, copy) NSString *successTips;

//显示此view.不要用addSubview
-(void)showPassWordView;
//等待
-(void)showWatting;
//错误,隐藏等待层,激活输入框重新输入
-(void)hiddenWattingAndTryAgain;
//显示成功
-(void)showSuccess;

@end
