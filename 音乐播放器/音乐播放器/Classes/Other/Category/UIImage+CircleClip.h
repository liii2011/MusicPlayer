//
//  UIImage+CircleClip.h
//  36-圆形裁剪
//
//  Created by liii on 15/10/1.
//  Copyright (c) 2015年 liii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleClip)

/** 圆形裁剪 */
+ (instancetype)circleClipImageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor writeToFile:(NSString *)file;

@end
