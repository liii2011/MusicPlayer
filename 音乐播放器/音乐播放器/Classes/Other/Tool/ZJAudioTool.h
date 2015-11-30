//
//  ZJAudioTool.h
//  播放音效的工具类
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJAudioTool : NSObject

/**
 *  播放音乐
 *
 *  @param soundName 文件名
 */
+ (void)playMusicWithName:(NSString *)musicName;

/**
 *  暂停音乐
 *
 *  @param soundName 文件名
 */
+ (void)pauseMusicWithName:(NSString *)musicName;

/**
 *  停止音乐
 *
 *  @param soundName 文件名
 */
+ (void)stopMusicWithName:(NSString *)musicName;

/**
 *  播放音效
 *
 *  @param soundName 文件名
 */
+ (void)playSoundWithName:(NSString *)soundName;

/**
 *  销毁音效
 *
 *  @param soundName 文件名
 */
+ (void)disposeWithSoundName:(NSString *)soundName;

@end
