//
//  ZJPlayingViewController.m
//  音乐播放器
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJPlayingViewController.h"
#import "UIView+Frame.h"
#import "ZJMusicTool.h"
#import "ZJMusic.h"
#import "ZJAudioTool.h"

@interface ZJPlayingViewController ()

/** 记录正在播放的音乐 */
@property (nonatomic, strong) ZJMusic *playingMusic;

/** 歌曲名标签 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手名标签 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 歌手封面照 */
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;

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
    //4 ***停止正在播放的音乐, 清空数据
    if (self.playingMusic && self.playingMusic != [ZJMusicTool playingMusic]) {
        // 注意, 首次播放不需要停止, 如果本次选中音乐和上次播放相同, 也不需要停止
        [self stopPlayingMusic];
    }
    
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
        
        //5 ***开始播放选中的音乐, 更新数据
        [self startPlayingMusic];
    }];
}

// 设置界面数据, 播放音乐
- (void)startPlayingMusic
{
    // 拿到音乐模型
    ZJMusic *playingMusic = [ZJMusicTool playingMusic];
    
    // 判断如果本次播放的歌曲, 和上次播放的歌曲不一样, 再设置数据
    if (playingMusic != self.playingMusic) {
        // 记录本次播放的歌曲
        self.playingMusic = playingMusic;
        
        // 设置歌曲名, 歌手名, 封面图片
        self.songLabel.text = playingMusic.name;
        self.singerLabel.text = playingMusic.singer;
        self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
        
        // 播放音乐
        [ZJAudioTool playMusicWithName:playingMusic.filename];
    }
}

// 停止正在播放的音乐, 清空数据
- (void)stopPlayingMusic
{
    // 清空歌曲名, 歌手名, 封面图片
    self.songLabel.text = nil;
    self.singerLabel.text = nil;
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    
    // 停止正在播放的音乐
    [ZJAudioTool stopMusicWithName:self.playingMusic.filename];
}

// 退出播放控制器
- (IBAction)exit {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    // y值从0 --> height
    [UIView animateWithDuration:1 animations:^{
        //2 让view从下向上画到0的位置
        self.view.originY = self.view.sizeHeight;
    } completion:^(BOOL finished) {
        //3 当播放控制器显示完毕, 再恢复window的交互
        window.userInteractionEnabled = YES;
    }];
}

@end
