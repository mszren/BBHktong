//
//  MyWalletEmptyHeadView.h
//  HKT
//
//  Created by Ting on 15/11/16.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyWalletEmptyHeadViewDelegate <NSObject>

-(void)actionWithGotoAddAccount;

@end

@interface MyWalletEmptyHeadView : UIView

@property (nonatomic,assign)id<MyWalletEmptyHeadViewDelegate>delegate;

@end
