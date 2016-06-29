//
//  VIBannerScrollView.h
//  Shalary
//
//  Created by xianli on 15/11/6.
//  Copyright © 2015年 xianli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VIBannerScrollView;

@protocol VIBannerScrollViewDelegate <NSObject>

@required
- (void)bannerScrollView:(VIBannerScrollView *)view willDisplayBanner:(id)banner onImageView:(UIImageView *)imageView;

@optional
- (void)bannerScrollView:(VIBannerScrollView *)view bannerClicked:(id)banner;

@end


@interface VIBannerScrollView : UIView

@property (nonatomic, weak) id<VIBannerScrollViewDelegate>delegate; // 未指定delegate的情况下，banners里的model都当UIImage处理

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, assign) NSInteger autoScrollTimeInterval; //广告图片轮播时停留的时间，默认0秒不会轮播
@property (nonatomic, strong) UIPageControl *pageControl;

@end
