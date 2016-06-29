//
//  DialogView.m
//  HKT
//
//  Created by Ting on 15/9/22.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "DialogView.h"
#import "UIView+Size.h"
#import "STModal.h"

@implementation DialogView

-(instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail{
    
    self = [super init];
    if(self){
        
        self.frame = CGRectMake(0, 0, kDeviceWidth-20, 0);
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.width-20, 20)];
        titleLabel.numberOfLines = 0;
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.height = [titleLabel.text boundingRectWithSize:CGSizeMake(titleLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : titleLabel.font} context:nil].size.height;
        
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.bottom+10, self.width-20, 20)];
        detailLabel.numberOfLines = 0;
        detailLabel.text = detail;
        detailLabel.font = [UIFont systemFontOfSize:19.0f];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor = [UIColor redColor];
        detailLabel.height = [detailLabel.text boundingRectWithSize:CGSizeMake(detailLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : detailLabel.font} context:nil].size.height;
        
        UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, detailLabel.bottom+10, self.width-20, 20)];
        tipsLabel.numberOfLines = 0;
        tipsLabel.text = @"稍后会发放到您的钱包中";
        tipsLabel.font = [UIFont systemFontOfSize:14.0f];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.height = [tipsLabel.text boundingRectWithSize:CGSizeMake(tipsLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tipsLabel.font} context:nil].size.height;
        
        
        self.height = tipsLabel.bottom + 20;
        
        
    }
    return self;
}

+(void)showDialogViewWithTitle:(NSString *)title andDetail:(NSString *)detail{
    
    DialogView *dialog = [[DialogView alloc]initWithTitle:title andDetail:detail];
    
    
    STModal *modal = [STModal modalWithContentView:dialog];
    modal.hideWhenTouchOutside = YES;
    
    [modal showContentView:dialog animated:YES];
    
    
   
    
}

-(void)hide{

    

}

@end
