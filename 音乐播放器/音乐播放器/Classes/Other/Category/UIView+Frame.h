//
//  UIView+Frame.h
//  彩票01
//
//  Created by liii on 15/10/9.
//  Copyright (c) 2015年 liii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/** 设置origin */
@property (nonatomic, assign) CGPoint origin;
/** 设置origin.x坐标 */
@property (nonatomic, assign) CGFloat originX;
/** 设置origin.y坐标 */
@property (nonatomic, assign) CGFloat originY;

/** 设置size */
@property (nonatomic, assign) CGSize size;
/** 设置size.width */
@property (nonatomic, assign) CGFloat sizeWidth;
/** 设置size.height */
@property (nonatomic, assign) CGFloat sizeHeight;

/** 设置center */
@property (nonatomic, assign) CGPoint centers;
/** 设置center.x */
@property (nonatomic, assign) CGFloat centerX;
/** 设置center.y */
@property (nonatomic, assign) CGFloat centerY;

@end
