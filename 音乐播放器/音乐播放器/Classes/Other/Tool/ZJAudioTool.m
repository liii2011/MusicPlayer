//
//  ZJAudioTool.m
//  播放音效的工具类
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJAudioTool.h"

// 音效字典
static NSMutableDictionary *soundIDs;
// 音乐字典
static NSMutableDictionary *musics;

@implementation ZJAudioTool

//static NSMutableDictionary *_soundIDs;
//static NSMutableDictionary *_musics;

// 第一次使用该类的时候调用
+ (void)initialize
{
    // 初始化一个字典
    soundIDs = [NSMutableDictionary dictionary];
    musics = [NSMutableDictionary dictionary];
}

// 播放音乐
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName
{
    // 断言
    assert(musicName);
    
    // 初始化一个字典
    AVAudioPlayer *player = musics[musicName];
    
    if (player == nil) {
        // 获取音乐的url
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        // 创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
        
        // 添加到数组
        musics[musicName] = player;
    }
    
    // 播放音乐
    [player play];
    return player;
}

// 暂停音乐
+ (void)pauseMusicWithName:(NSString *)musicName
{
    // 断言
    assert(musicName);
    
    // 取出播放器
    AVAudioPlayer *player = musics[musicName];
    
    if (player) {        
        // 暂停音乐
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)musicName
{
    // 断言
    assert(musicName);
    
    // 取出播放器
    AVAudioPlayer *player = musics[musicName];
    
    // 清空指针
    if (player) {
        // 停止音乐
        [player stop];
        player = nil;
        // 移除数组中的播放器
        [musics removeObjectForKey:musicName];
    }
}

// 播放音效
+ (void)playSoundWithName:(NSString *)soundName
{
    // 到字典中取音效(把对象转换为基本数据类型)
    SystemSoundID soundID = [soundIDs[soundName] unsignedIntValue];
    
    if (soundID == 0) {
        // 获取音效的URL
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        // 创建soundID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundURL), &soundID);
        // 把上面创建的soundID, 添加到字典中
        soundIDs[soundName] = @(soundID);
    }
    
    // 播放音效
    AudioServicesPlaySystemSound(soundID);
}

// 关闭音效
+ (void)disposeWithSoundName:(NSString *)soundName
{
    //1 从字典中取出音效ID
    SystemSoundID sounID = [soundIDs[soundName] unsignedIntValue];
    
    //2 销毁音效
    if (sounID) {
        AudioServicesDisposeSystemSoundID(sounID);
    }
}

@end
