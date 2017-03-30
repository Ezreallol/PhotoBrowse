//
//  UIView+Frame.m
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 17/1/9.
//  Copyright © 2017年 FCH. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setFch_height:(CGFloat)fch_height
{
    CGRect rect = self.frame;
    rect.size.height = fch_height;
    self.frame = rect;
}




- (CGFloat)fch_height
{
    return self.frame.size.height;
}

- (CGFloat)fch_width
{
    return self.frame.size.width;
}
- (void)setFch_width:(CGFloat)fch_width
{
    CGRect rect = self.frame;
    rect.size.width = fch_width;
    self.frame = rect;
}

- (CGFloat)fch_x
{
    return self.frame.origin.x;
    
}

- (void)setFch_x:(CGFloat)fch_x
{
    CGRect rect = self.frame;
    rect.origin.x = fch_x;
    self.frame = rect;
}

- (void)setFch_y:(CGFloat)fch_y
{
    CGRect rect = self.frame;
    rect.origin.y = fch_y;
    self.frame = rect;
}

- (CGFloat)fch_y
{
    
    return self.frame.origin.y;
}

- (void)setFch_centerX:(CGFloat)fch_centerX
{
    CGPoint center = self.center;
    center.x = fch_centerX;
    self.center = center;
}

- (CGFloat)fch_centerX
{
    return self.center.x;
}

- (void)setFch_centerY:(CGFloat)fch_centerY
{
    CGPoint center = self.center;
    center.y = fch_centerY;
    self.center = center;
}

- (CGFloat)fch_centerY
{
    return self.center.y;
}
@end
