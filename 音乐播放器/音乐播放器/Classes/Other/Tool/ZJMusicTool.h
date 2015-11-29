//
//  ZJMusicTool.h
//  音乐播放器
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZJMusic;
@interface ZJMusicTool : NSObject

/**
 *  获取所有音乐模型数据
 *
 *  @return 返回音乐模型数组
 */
+ (NSArray *)musics;

/**
 *  设置要播放的音乐
 *
 *  @param playingMusic 音乐模型
 */
+ (void)setPlayingMusic:(ZJMusic *)playingMusic;

/**
 *  返回正在播放的音乐
 *
 *  @return 音乐模型
 */
+ (ZJMusic *)playingMusic;

/**
 *  播放下一首音乐
 *
 *  @return 返回下一首的模型
 */
+ (ZJMusic *)nextMusic;

/**
 *  播放上一首
 *
 *  @return 返回上一首的模型
 */
+ (ZJMusic *)previousMusic;

@end
