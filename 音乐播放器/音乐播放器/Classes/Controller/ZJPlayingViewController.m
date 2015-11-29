//
//  ZJPlayingViewController.m
//  音乐播放器
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJPlayingViewController.h"
#import "UIView+Frame.h"

@interface ZJPlayingViewController ()

/** 退出 */
- (IBAction)exit;

@end

@implementation ZJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 显示播放控制器
- (void)show
{
    // 拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 当显示播放控制器的过程中, 关闭window的交互, 禁止用户再操作
    window.userInteractionEnabled = NO;
    
    // 设置frame, 添加到window
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    
    // 添加播放控制器的弹出界面
        //1 让播放控制器的先再屏幕的最下方
    self.view.originY = self.view.sizeHeight;
    [UIView animateWithDuration:1 animations:^{
        //2 让view从下向上画到0的位置
        self.view.originY = 0;
    } completion:^(BOOL finished) {
        //3 当播放控制器显示完毕, 再恢复window的交互
        window.userInteractionEnabled = YES;
    }];
}

// 退出播放控制器
- (IBAction)exit {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
//    self.view.originY = self.view.sizeHeight;
    [UIView animateWithDuration:1 animations:^{
        //2 让view从下向上画到0的位置
        self.view.originY = self.view.sizeHeight;
    } completion:^(BOOL finished) {
        //3 当播放控制器显示完毕, 再恢复window的交互
        window.userInteractionEnabled = YES;
    }];
}
@end
