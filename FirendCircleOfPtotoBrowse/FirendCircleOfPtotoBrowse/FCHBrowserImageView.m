//
//  FCHBrowserImageView.m
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/23.
//  Copyright © 2016年 FCH. All rights reserved.
//

#import "FCHBrowserImageView.h"
#import <UIImageView+WebCache.h>
#import "FCHPhotoBrowserConfig.h"
@implementation FCHBrowserImageView
{
    //下载提示视图
    __weak FCHWaitingView *_waitingView;
    
    UIScrollView *_scroll;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
    //缩放时的imageview
    UIImageView *_zoomingImageView;
    //缩放比例
    CGFloat _totalScale;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        
        //捏合手势缩放图片
        UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomImage:)];
        pin.delegate = self;
        [self addGestureRecognizer:pin];
        
        
    }
    return  self;
}


-(BOOL)isScaled
{
    return 1.0!= _totalScale;
}

/*
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    //加载视图时显示等待视图
    _waitingView.center = CGPointMake(self.frame.size.width*0.2, self.frame.size.height*0.5);
    CGSize imageSize = self.image.size;
    //如果是超出屏幕的长图,创建UIscrollerView
    if (self.bounds.size.width * (imageSize.height /imageSize.width) > self.bounds.size.height) {
        if (!_scroll) {
            UIScrollView *scroll = [[UIScrollView alloc]init];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = self.image;
            _scrollImageView = imageView;
            [scroll addSubview:imageView];
            scroll.backgroundColor  = FCHPhotoBrowserBackgrounColor;
            _scroll = scroll;
            [self addSubview:scroll];
            if (_waitingView) {
                [self bringSubviewToFront:_waitingView];
            }
        }
        
        _scroll.frame = self.bounds;
        CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        _scrollImageView.bounds = CGRectMake(0, 0, _scroll.frame.size.width, imageViewH);
        _scrollImageView.center = CGPointMake(_scroll.frame.size.width * 0.5, _scrollImageView.frame.size.height * 0.5);
        _scroll.contentSize = CGSizeMake(0, _scrollImageView.bounds.size.height);
        
        
    }else{
        if (_scroll) {
            [_scroll removeFromSuperview];
        }
    }
    
}


-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    FCHWaitingView *waiting  = [[FCHWaitingView alloc ]init];
    waiting.bounds = CGRectMake(0, 0, 100, 100);
    waiting.mode = FCHWaitingViewProgressMode;
    _waitingView = waiting;
    [self addSubview:waiting];
    
    
    
    __weak FCHBrowserImageView *imageViewWeak = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //等待视图加载的进度值
        imageViewWeak.progress = (CGFloat)receivedSize/expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [imageViewWeak removeWaitingView];
        
        
        if (error) {
            //可以用HUB等3方替换
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];

        }else{
            _scrollImageView.image = image;
            [_scrollImageView setNeedsDisplay];
        }
    }];
    
    
    
    
    
}




#pragma mark --------- 缩放-------------
-(void)zoomImage:(UIPinchGestureRecognizer *)pin
{
    [self prepareForImageViewScaling];
    CGFloat scale = pin.scale;
    CGFloat temp = _totalScale +(scale - 1);
    [self setTotalScale:temp];
    pin.scale = 1.0;

}
- (void)setTotalScale:(CGFloat)totalScale
{
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 2.0 && totalScale > _totalScale)) return; // 最大缩放 2倍,最小0.5倍
    
    [self zoomWithScale:totalScale];
}
- (void)zoomWithScale:(CGFloat)scale
{
    _totalScale = scale;
    
    _zoomingImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    if (scale > 1) {
        CGFloat contentW = _zoomingImageView.frame.size.width;
        CGFloat contentH = MAX(_zoomingImageView.frame.size.height, self.frame.size.height);
        
        _zoomingImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        _zoomingScroolView.contentSize = CGSizeMake(contentW, contentH);
        
        
        CGPoint offset = _zoomingScroolView.contentOffset;
        offset.x = (contentW - _zoomingScroolView.frame.size.width) * 0.5;
        //        offset.y = (contentH - _zoomingImageView.frame.size.height) * 0.5;
        _zoomingScroolView.contentOffset = offset;
        
    } else {
        _zoomingScroolView.contentSize = _zoomingScroolView.frame.size;
        _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _zoomingImageView.center = _zoomingScroolView.center;
    }
}
-(void)prepareForImageViewScaling
{
    if (!_zoomingScroolView) {
        _zoomingScroolView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _zoomingScroolView.backgroundColor = FCHPhotoBrowserBackgrounColor;
        _zoomingScroolView.contentSize = self.bounds.size;
        
        UIImageView *zoomingImageView = [[UIImageView alloc]initWithImage:self.image];
        CGSize imageSize = zoomingImageView.image.size;
        CGFloat imageViewH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageViewH = self.bounds.size.width *imageSize.height/imageSize.width;
        }
        zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
        zoomingImageView.center = _zoomingScroolView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        _zoomingImageView = zoomingImageView;
        [_zoomingScroolView addSubview:zoomingImageView];
        [self addSubview:_zoomingScroolView];
        
    }
}

- (void)doubleTapToZommWithScale:(CGFloat)scale
{
    [self prepareForImageViewScaling];
    [UIView animateWithDuration:0.5 animations:^{
        [self zoomWithScale:scale];
    } completion:^(BOOL finished) {
        if (scale == 1) {
            [self clear];
        }
    }];
}


- (void)scaleImage:(CGFloat)scale
{
    [self prepareForImageViewScaling];
    [self setTotalScale:scale];
}



//清除缩放
-(void)eliminateScale
{
    [_zoomingScroolView removeFromSuperview];
    [self clear];
    _totalScale = 1.0;
}
-(void)removeWaitingView
{
    [_waitingView removeFromSuperview];
}

-(void)clear
{
    [_zoomingScroolView removeFromSuperview];
    _zoomingScroolView = nil;
    _zoomingImageView = nil;
}
@end
