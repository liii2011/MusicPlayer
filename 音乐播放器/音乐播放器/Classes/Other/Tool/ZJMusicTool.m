//
//  ZJMusicTool.m
//  音乐播放器
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJMusicTool.h"
#import "ZJMusic.h"
#import "MJExtension.h"

@implementation ZJMusicTool

// 用于存放所有的音乐模型
static NSArray *_musics;
// 用于记录正在播放的音乐
static ZJMusic *_playingMusic;

// 第一次使用到该类的时候调用
+ (void)initialize
{
    // 使用MJExtension实现字典装模型
    _musics = [ZJMusic objectArrayWithFilename:@"Musics.plist"];
}

// 返回模型数组
+ (NSArray *)musics
{
    return _musics;
}

// 设置要播放的音乐, setter
+ (void)setPlayingMusic:(ZJMusic *)playingMusic
{
    // 保证不为空
    assert(playingMusic);
    _playingMusic = playingMusic;
}

// 返回正在播放的音乐, getter
+ (ZJMusic *)playingMusic
{
    return _playingMusic;
}

// 播放下一首, 返回下一首对应模型
+ (ZJMusic *)nextMusic
{
    // 在模型数组中找到正在播放的音乐的索引值, 计算下一首音乐的索引值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    currentIndex++;
    
    // 越界判断
    if (currentIndex > _musics.count - 1) {
        // 如果播放到最后一首, 在点击下一首, 就从第一首开始循环
        currentIndex = 0;
    }
    
    // 取出模型, 设置为正在播放的音乐, 并返回
    ZJMusic *nextMusic = _musics[currentIndex];
    [self setPlayingMusic:nextMusic];
    return nextMusic;
}

// 播放上一首, 返回上一首对应模型
+ (ZJMusic *)previousMusic
{
    // 在模型数组中找到正在播放的音乐的索引值, 计算下一首音乐的索引值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    currentIndex--;
    
    // 越界判断
    if (currentIndex < 0) {
        // 如果播放到第一首, 在点击上一首, 就从最后一首循环
        currentIndex = _musics.count - 1;
    }
    
    // 取出模型, 设置为正在播放的音乐, 并返回
    ZJMusic *previousMusic = _musics[currentIndex];
    [self setPlayingMusic:previousMusic];
    return previousMusic;
}

@end
