//
//  FCHBrowserImageView.h
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/23.
//  Copyright © 2016年 FCH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCHWaitingView.h"
@interface FCHBrowserImageView : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void)eliminateScale; // 清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

@end
