//
//  UIView+Frame.m
//  彩票01
//
//  Created by liii on 15/10/9.
//  Copyright (c) 2015年 liii. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - origin
- (void)setOrigin:(CGPoint)origin
{
    CGRect tempFrame = self.frame;
    tempFrame.origin = origin;
    self.frame = tempFrame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

#pragma mark - origin(x, y)
- (void)setOriginX:(CGFloat)originX
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = originX;
    self.frame = tempFrame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}


- (void)setOriginY:(CGFloat)originY
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = originY;
    self.frame = tempFrame;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

#pragma mark - size
- (void)setSize:(CGSize)size
{
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

- (CGSize)size
{
    return self.frame.size;
}

#pragma mark - size(width, height)
- (void)setSizeWidth:(CGFloat)sizeWidth
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = sizeWidth;
    self.frame = tempFrame;
}

- (CGFloat)sizeWidth
{
    return self.frame.size.width;
}

- (void)setSizeHeight:(CGFloat)sizeHeight
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = sizeHeight;
    self.frame = tempFrame;
}

- (CGFloat)sizeHeight
{
    return self.frame.size.height;
}

#pragma mark - center
- (void)setCenters:(CGPoint)centers
{
    CGPoint tempCenter = self.center;
    tempCenter = centers;
    self.center = tempCenter;
}

- (CGPoint)centers
{
    return self.center;
}

#pragma mark - center(x, y)
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint tempCenter = self.center;
    tempCenter.x = centerX;
    self.center = tempCenter;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint tempCenter = self.center;
    tempCenter.y = centerY;
    self.center = tempCenter;
}

- (CGFloat)centerY
{
    return self.center.y;
}

@end
