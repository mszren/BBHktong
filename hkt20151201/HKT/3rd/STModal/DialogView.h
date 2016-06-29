//
//  DialogView.h
//  HKT
//
//  Created by Ting on 15/9/22.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogView : UIView

+(void)showDialogViewWithTitle:(NSString *)title andDetail:(NSString *)detail;

-(instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail;

@end
