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
#import "ZJLrcView.h"

@interface ZJPlayingViewController () <AVAudioPlayerDelegate>

/** 记录正在播放的音乐 */
@property (nonatomic, strong) ZJMusic *playingMusic;
/** 进度定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;
/** 记录当前播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

/** 歌曲名标签 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手名标签 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 歌手封面ImageView */
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
/** 歌曲播放总时长Label */
@property (weak, nonatomic) IBOutlet UILabel *playingTime;
/** 滑块按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sliderButton;
/** 拖动的时候, 显示时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;
/** 播放或暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
/** 歌词View */
@property (weak, nonatomic) IBOutlet ZJLrcView *lrcView;


/** 滑块左边的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLeftConstraint;

/**
 *  点击了退出, 返回主界面
 */
- (IBAction)exit;

/**
 *  监听tip点击手势
 */
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender;
/**
 *  监听pan点击手势
 */
- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender;

/**
 *  播放暂停按钮的点击
 */
- (IBAction)playOrPauseButtonClick;
/**
 *  上一首按钮的点击
 */
- (IBAction)previousButtonClick;
/**
 *  下一首按钮的点击
 */
- (IBAction)nextButtonClick;

/**
 *  歌词和图片按钮的点击
 */
- (IBAction)lrcOrPicButton:(UIButton *)sender;

@end

@implementation ZJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置时间标签的圆角
    self.showTimeLabel.layer.cornerRadius = 5;
    self.showTimeLabel.layer.masksToBounds = YES;
    // self.showTimeLabel.clipsToBounds = YES;
}

#pragma mark - 播放控制器相关方法

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
    
    // 如果是同一首歌, 再次开启定时器
    if (playingMusic == self.playingMusic) {
        // 开启定时器
        [self addProgressTimer];
        return;
    }
    
    // 记录本次播放的歌曲
    self.playingMusic = playingMusic;
    
    // 设置歌曲名, 歌手名, 封面图片
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
    
    // 把歌曲名传递给歌词view
    self.lrcView.lrcName = self.playingMusic.lrcname;
    
    // 播放音乐
    AVAudioPlayer *player = [ZJAudioTool playMusicWithName:playingMusic.filename];
    // 保存播放器
    self.currentPlayer = player;
    
    // 设置代理
    player.delegate = self;
    
    // 显示播放时间
    self.playingTime.text = [self stringWithTime:player.duration];
    
    // 更新滑块的位置
    [self updateInfo];
    
    // 开启定时器
    [self addProgressTimer];
    
    // 更改按钮的选中状态
    self.playOrPauseButton.selected = NO;
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
    
    // 移除定时器
    [self removeProgressTimer];
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
        //4 移除定时器
        [self removeProgressTimer];
    }];
}

// 把歌曲播放时间, 格式化成 "分钟:秒" 的格式
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    // 计算分钟, 秒数, 返回拼接后的字符串
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}

#pragma mark - 定时器相关方法

// 添加定时器
- (void)addProgressTimer
{
    // 给当前控制器添加定时器
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    // 把定时器添加到主运行循环
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

// 移除定时器
- (void)removeProgressTimer
{
    // 关闭定时器
    [self.progressTimer invalidate];
    // 回收指针
    self.progressTimer = nil;
}

#pragma mark - 进度条相关方法

// 更新数据
- (void)updateInfo
{
    // 根据播放时间计算播放比例
    AVAudioPlayer *player = self.currentPlayer;
    CGFloat progressRatio = player.currentTime / player.duration;
    
    // 根据播放比例更新滑块左边的约束, 使滑块移动
    self.sliderLeftConstraint.constant = progressRatio * (self.view.sizeWidth - self.sliderButton.sizeWidth);
    
    // 更新滑块上的时间
    NSString *currentTime = [self stringWithTime:self.currentPlayer.currentTime];
    [self.sliderButton setTitle:currentTime forState:UIControlStateNormal];
}

// 点击手势
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender {
    // 获取点击位置
    CGPoint tapPoint = [sender locationInView:sender.view];
    
    // 进度条左边的有效点击位置 = 滑块宽度的一半; 右边的有效点击位置 = 屏幕宽度 - 按钮宽度的一半
    CGFloat viewWidth = self.view.sizeWidth;
    CGFloat sliderButtonWidth = self.sliderButton.sizeWidth;
    CGFloat constant = self.sliderLeftConstraint.constant;
    
    // 如果点在左边的无效位置
    if (tapPoint.x <= sliderButtonWidth * 0.5) {
        constant = 0;
    // 如果点在右边的无效位置
    } else if (tapPoint.x >= viewWidth - sliderButtonWidth * 0.5) {
        // (-1的作用, 让系统自动播放下一首, 调用代理方法)
        constant = viewWidth - sliderButtonWidth - 1;
    // 如果点在有效位置
    } else {
        constant = tapPoint.x - sliderButtonWidth * 0.5;
    }
    
    // 计算点击位置占总长度的比例
    CGFloat progressRatio = constant / (viewWidth - sliderButtonWidth);
    
    // 根据比例计算播放前当前播放时间
    self.currentPlayer.currentTime = progressRatio * self.currentPlayer.duration;
    
    // 手动更新一下进度条, 使文字立刻改变
    [self updateInfo];
}

/** 拖动手势 */
- (IBAction)panSliderButton:(UIPanGestureRecognizer *)sender {
    // 获取拖拽的位移的"增量", 并把上次拖拽的位置, 作为起点
    CGPoint panPoint = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 边界判断
    if (self.sliderLeftConstraint.constant + panPoint.x <= 0) {
        // 如果点在左边的无效位置
        self.sliderLeftConstraint.constant = 0;
    } else if (self.sliderLeftConstraint.constant + panPoint.x >= self.view.sizeWidth - self.sliderButton.sizeWidth) {
        // 如果点在右边的无效位置(-1的作用, 让系统自动播放下一首, 调用代理方法)
        self.sliderLeftConstraint.constant = self.view.sizeWidth - self.sliderButton.sizeWidth -1 ;
    } else {
        // 改变滑块左边的约束, 让滑块移动
        self.sliderLeftConstraint.constant += panPoint.x;
    }
    
    // 计算播放比例
    CGFloat progressRatio = self.sliderLeftConstraint.constant / (self.view.sizeWidth - self.sliderButton.sizeWidth);
    // 计算播放时间
    CGFloat currentTime = progressRatio * self.currentPlayer.duration;
    // 转换为字符串
    NSString *currentTimeStr = [self stringWithTime:currentTime];
    // 设置播放时间
    [self.sliderButton setTitle:currentTimeStr forState:UIControlStateNormal];
    // 设置时间标签
    self.showTimeLabel.text = currentTimeStr;
    
    // 拖拽开始的时候移除定时器
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 移除定时器
        [self removeProgressTimer];
        // 显示时间标签
        self.showTimeLabel.hidden = NO;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        // 设置播放位置
        self.currentPlayer.currentTime = currentTime;
        // 添加定时器
        [self addProgressTimer];
        // 隐藏时间标签
        self.showTimeLabel.hidden = YES;
    }
}

#pragma mark - 控制播放按钮
// 播放或暂停按钮
- (IBAction)playOrPauseButtonClick {
    // 按钮状态取反
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    
    if (self.currentPlayer.playing) {
        // 如果音乐正在播放, 就执行停止
        [self.currentPlayer pause];
        // 移除定时器
        [self removeProgressTimer];
    } else {
        // 如果音乐处于停止, 就执行播放
        [self.currentPlayer play];
        // 添加定时器
        [self addProgressTimer];
    }
}

// 上一首按钮
- (IBAction)previousButtonClick {
    // 停止正在播放的音乐
    [self stopPlayingMusic];
    // 设置上一首为要播放的音乐
    [ZJMusicTool previousMusic];
    // 开始播放音乐
    [self startPlayingMusic];
}

// 下一首按钮
- (IBAction)nextButtonClick {
    // 停止正在播放的音乐
    [self stopPlayingMusic];
    // 设置下一首为要播放的音乐
    [ZJMusicTool nextMusic];
    // 开始播放音乐
    [self startPlayingMusic];
}

// 歌词和图片按钮的点击事件
- (IBAction)lrcOrPicButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.lrcView.hidden = !self.lrcView.hidden;
    
    // 把歌曲名传递给歌词view
//    self.lrcView.lrcName = self.playingMusic.lrcname;
}

#pragma mark - AVAudioPlayerDelegate代理方法
// 播放完成时执行
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        // 播放下一首
        [self nextButtonClick];
    }
}

// 打断开始的时候执行
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    // 点击开始或暂停按钮
    [self playOrPauseButton];
}

// 打断接收的时候执行
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    // 点击开始或暂停按钮
    [self playOrPauseButton];
}

@end
