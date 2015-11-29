//
//  UIImage+CircleClip.m
//  36-圆形裁剪
//
//  Created by liii on 15/10/1.
//  Copyright (c) 2015年 liii. All rights reserved.
//

#import "UIImage+CircleClip.h"

@implementation UIImage (CircleClip)

// 圆形裁剪
+ (instancetype)circleClipImageName:(NSString *)imageName borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor writeToFile:(NSString *)file
{
    // 加载图片
    UIImage *img = [UIImage imageNamed:imageName];

    // 开启上下文(尺寸和图片相同, 且透明不缩放)
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);

//----------------------画外圆-----------------------//

    // 半径
    CGFloat bigRadius = img.size.width * 0.5;
    // 圆心
    CGPoint bigCenter = CGPointMake(bigRadius, bigRadius);
    // 从0度到360度, 画一个整圆
    CGFloat angle_0 = 0;
    CGFloat angle_360 = M_PI * 2;
    
    // 画大圆
    UIBezierPath *bigCirclePath = [UIBezierPath bezierPathWithArcCenter:bigCenter radius:bigRadius startAngle:angle_0 endAngle:angle_360 clockwise:YES];

    // 设置圆颜色, 并填充
    [borderColor set];
    [bigCirclePath fill];

//----------------------画内圆-----------------------//

    // 半径
    CGFloat smlRadius = bigRadius - borderWidth;
    // 圆心
    CGPoint smlCenter = bigCenter;
    // 画小圆
    UIBezierPath *smlCirclePath = [UIBezierPath bezierPathWithArcCenter:smlCenter radius:smlRadius startAngle:angle_0 endAngle:angle_360 clockwise:YES];
    
    // 按小圆裁剪
    [smlCirclePath addClip];

    // 添加要裁剪图片
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];

    // 从上下文获取图片
    img = UIGraphicsGetImageFromCurrentImageContext();

    // 关闭上下文
    UIGraphicsEndImageContext();

//----------------------图片存储-----------------------//
    // 转二进制文件
    NSData *imgData = UIImagePNGRepresentation(img);

    // 写入到指定路径
    [imgData writeToFile:file atomically:YES];
    
    // 返回图片
    return img;
}


#pragma mark - UIBezierPath 的方式实现圆形裁剪
#if 0
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //----------------------画圆前-----------------------//
    // 加载图片
    UIImage *img = [UIImage imageNamed:@"me"];
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
    
    //----------------------画大圆-----------------------//
    // 大圆范围
    CGRect bigCircleRect = CGRectMake(0, 0, img.size.width, img.size.height);
    // 画出一个圆
    UIBezierPath *bigCirclePath = [UIBezierPath bezierPathWithOvalInRect:bigCircleRect];
    // 设置颜色
    [[UIColor blackColor] set];
    // 填充颜色
    [bigCirclePath fill];
    
    //----------------------画小圆-----------------------//
    // 与第一个圆的间距
    CGFloat margin = 2;
    // 小圆范围
    CGRect smallCircleRect = CGRectMake(margin, margin, bigCircleRect.size.width - 2*margin, bigCircleRect.size.height - 2*margin);
    // 根据范围画圆
    UIBezierPath *smallCirclePath = [UIBezierPath bezierPathWithOvalInRect:smallCircleRect];
    // 设置颜色
    [[UIColor whiteColor] set];
    // 填充颜色
    [smallCirclePath fill];
    
    //----------------------裁剪开始-----------------------//
    // 设置裁剪范围(后边的受影响, 前边的不受影响)
    [smallCirclePath addClip];
    
    // 添加图片
    [img drawInRect:bigCircleRect];
    
    //----------------------裁剪后-----------------------//
    // 获取裁剪后的上下文
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 输出到控件
    self.clipView.image = img;
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    //----------------------文件写入-----------------------//
    // 图片转二进制文件
    NSData *imgData = UIImagePNGRepresentation(img);
    // 存储路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [path stringByAppendingPathComponent:@"circle.png"];
    // 写入到沙盒
    [imgData writeToFile:filePath atomically:YES];
}
#endif

#pragma mark - Quartz2D 的方式实现圆形裁剪
#if 0
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载图片
    UIImage *img = [UIImage imageNamed:@"me"];
    
    // 创建上下文
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    //----------------------第一个圆-----------------------//
    
    //大圆半径, 圆心
    CGFloat bigCircleRadius = img.size.width * 0.5;
    CGFloat centerX = bigCircleRadius;
    CGFloat centerY = bigCircleRadius;
    
    // 画大圆
    CGContextAddArc(ref, centerX , centerY, bigCircleRadius, 0, M_PI * 2, 1);
    
    // 设置颜色
    [[UIColor whiteColor] set];
    
    // 填充路径
    CGContextFillPath(ref);
    
    //----------------------第二个圆-----------------------//
    
    // 小圆半径, 圆心
    CGFloat border = 2;
    CGFloat smallCircleRadius = bigCircleRadius - border;
    // 画小圆
    CGContextAddArc(ref, centerX , centerY, smallCircleRadius, 0, M_PI * 2, 1);
    
    // 按这个圆裁剪上下文
    CGContextClip(ref);
    
    // 添加要裁剪的图片
    CGRect circleRect = CGRectMake(0, 0, img.size.width, img.size.height);
    [img drawInRect:circleRect];
    
    //----------------------裁剪完毕-----------------------//
    
    // 生成图片
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 显示到屏幕控件
    self.clipView.image = img;
    
    // 关闭位图上下文
    UIGraphicsEndImageContext();
    
    
    //----------------------数据存储-----------------------//
    // UIImage -> NSData
    NSData *imgData = UIImagePNGRepresentation(img);
    // 获取沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接文件路径
    NSString *filePath = [path stringByAppendingPathComponent:@"circle.png"];
    
    // 写入
    [imgData writeToFile:filePath atomically:YES];
}
#endif


@end
