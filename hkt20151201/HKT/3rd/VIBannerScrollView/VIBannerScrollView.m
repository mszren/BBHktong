//
//  VIBannerScrollView.m
//  Shalary
//
//  Created by xianli on 15/11/6.
//  Copyright © 2015年 xianli. All rights reserved.
//

#import "VIBannerScrollView.h"

@interface VIBannerScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIImageView *previousImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, assign) NSInteger currentBannerIndex;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation VIBannerScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark - private

- (void)reloadBanners {
    
    if (self.currentBannerIndex >= (NSInteger)self.banners.count) {
        self.currentBannerIndex = 0;
    }
    
    if (self.currentBannerIndex < 0) {
        self.currentBannerIndex = (NSInteger)self.banners.count - 1;
    }
    
    NSInteger previousBannerIndex = self.currentBannerIndex - 1;
    if (previousBannerIndex < 0) {
        previousBannerIndex = self.banners.count - 1;
    }
    
    NSInteger nextBannerIndex = self.currentBannerIndex + 1;
    if (nextBannerIndex == self.banners.count) {
        nextBannerIndex = 0;
    }
    
    self.pageControl.currentPage = self.currentBannerIndex;
    
    id previousBanner = self.banners[previousBannerIndex];
    id currentBanner = self.banners[self.currentBannerIndex];
    id nextBanner = self.banners[nextBannerIndex];
    
    [self.delegate bannerScrollView:self willDisplayBanner:previousBanner onImageView:self.previousImageView];
    [self.delegate bannerScrollView:self willDisplayBanner:currentBanner onImageView:self.currentImageView];
    [self.delegate bannerScrollView:self willDisplayBanner:nextBanner onImageView:self.nextImageView];
    
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    
    if (self.autoScrollTimeInterval > 0 && self.banners.count >1) {
        [self triggleTimer];
    }
}

- (void)triggleTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.delegate) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval
                                                      target:self
                                                    selector:@selector(autoScrollBanner)
                                                    userInfo:nil
                                                     repeats:NO];
    }
}

- (void)autoScrollBanner {
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * 2,
                                                    0,
                                                    self.scrollView.frame.size.width,
                                                    self.scrollView.frame.size.height)
                                animated:YES];
    self.currentBannerIndex++;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadBanners];
    });
}

#pragma mark - UIGestureRecognizer

- (void)tapped:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:bannerClicked:)]) {
        id banner = self.banners[self.currentBannerIndex];
        
        [self.delegate bannerScrollView:self bannerClicked:banner];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (scrollView.contentOffset.x >= self.frame.size.width * 2) {
        self.currentBannerIndex++;
    }
    else if (scrollView.contentOffset.x < self.frame.size.width) {
        self.currentBannerIndex--;
    }
    
    [self reloadBanners];
}

#pragma mark - setters and getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, self.frame.size.height);
        
        [_scrollView addGestureRecognizer:self.tap];
        
        [_scrollView addSubview:self.previousImageView];
        [_scrollView addSubview:self.currentImageView];
        [_scrollView addSubview:self.nextImageView];
    }
    return _scrollView;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    }
    return _tap;
}

- (UIImageView *)previousImageView {
    if (!_previousImageView) {
        _previousImageView.contentMode = UIViewContentModeScaleAspectFill;
        _previousImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.scrollView.frame.size.width,
                                                                          self.scrollView.frame.size.height)];
    }
    return _previousImageView;
}

- (UIImageView *)currentImageView {
    if (!_currentImageView) {
        _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width,
                                                                         0,
                                                                         self.scrollView.frame.size.width,
                                                                         self.scrollView.frame.size.height)];
    }
    return _currentImageView;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
        _nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width * 2,
                                                                      0,
                                                                      self.scrollView.frame.size.width,
                                                                      self.scrollView.frame.size.height)];
    }
    return _nextImageView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height -10, self.frame.size.width, 0)];
        //_pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        //_pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (void)setBanners:(NSArray *)banners {
    
    NSParameterAssert([banners isKindOfClass:[NSArray class]]);
    
    NSAssert(self.delegate != nil, @"Set delegate first!");
        
    _banners = banners;
    
    if (banners.count <= 1) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.contentSize.height);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.contentSize.height);
    }
    
    self.pageControl.numberOfPages = banners.count;
    self.pageControl.frame = CGRectMake(self.pageControl.frame.origin.x,
                                        self.pageControl.frame.origin.y,
                                        20 * banners.count,
                                        self.pageControl.frame.size.height);
    
    if (banners.count == 0) {
        self.previousImageView.image = nil;
        self.currentImageView.image = nil;
        self.nextImageView.image = nil;
    }
    else {
        [self reloadBanners];
    }
}

@end
