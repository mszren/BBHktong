//
//  ShareTemplate.h
//  AH2House
//
//  Created by Ting on 14-8-13.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYActivityView.h"

@interface ShareModel : NSObject

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareImageURL;
@property (nonatomic, retain) UIImage *shareImage;
@property (nonatomic, copy) NSString *shareWebURL;
@end

@interface ShareTemplate : NSObject{

    UIViewController *showVc;
    
}

-(void)actionWithShare:(UIViewController *)vc WithSinaModel:(ShareModel*)shareMode andMessageTypeIsImage:(BOOL)isImage;

@property (nonatomic, retain) HYActivityView *activityView;

@end




