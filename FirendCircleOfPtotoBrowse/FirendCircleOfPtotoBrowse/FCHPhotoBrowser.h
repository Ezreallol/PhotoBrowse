//
//  FCHPtotoBrowser.h
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/26.
//  Copyright © 2016年 FCH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCHPhotoBrowser;

@protocol FCHPhotoBrowserDelegate  <NSObject>
@required
- (UIImage *)photoBrowser:(FCHPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;
@optional
- (NSURL *)photoBrowser:(FCHPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;
@end


@interface FCHPhotoBrowser : UIView<UIScrollViewDelegate>

@property (nonatomic, weak)UIView * sourceImagesContainerView;

@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;


@property (nonatomic,weak)id<FCHPhotoBrowserDelegate> delegate;



-(void)show;
@end
