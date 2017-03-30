//
//  FCHPhotoGroup.m
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/29.
//  Copyright © 2016年 FCH. All rights reserved.
//

#import "FCHPhotoGroup.h"
#import "FCHPhotoItem.h"
#import <UIButton+WebCache.h>
#import "FCHPhotoBrowser.h"

#define FCHPhotoGroupImageMargin 15


@interface FCHPhotoGroup ()<FCHPhotoBrowserDelegate>

@end

@implementation FCHPhotoGroup




-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}

-(void)setPhototItemArray:(NSArray *)phototItemArray
{
    _phototItemArray = phototItemArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [phototItemArray enumerateObjectsUsingBlock:^(FCHPhotoItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
    
    long imageCount = phototItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    CGFloat h = 80;
    self.frame = CGRectMake(10, 10, 300, totalRowCount * (FCHPhotoGroupImageMargin + h));
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.phototItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat w = 80;
    CGFloat h = 80;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + FCHPhotoGroupImageMargin);
        CGFloat y = rowIndex * (h + FCHPhotoGroupImageMargin);
        btn.frame = CGRectMake(x, y, w, h);
    }];
}


-(void)buttonClick:(UIButton *)btn
{
    FCHPhotoBrowser *browser = [[FCHPhotoBrowser alloc]init];
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.phototItemArray.count;
    browser.currentImageIndex = btn.tag;
    browser.delegate = self;
    [browser show];

}

-(UIImage *)photoBrowser:(FCHPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


-(NSURL *)photoBrowser:(FCHPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.phototItemArray[index] thumbnail_pic]stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}






@end
