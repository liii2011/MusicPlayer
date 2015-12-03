//
//  ZJLrcLine.h
//  音乐播放器
//
//  Created by liii on 15/12/3.
//  Copyright © 2015年 liii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJLrcLine : NSObject

/** 每行歌词对应的播放时间 */
@property (nonatomic, copy) NSString *time;
/** 每行歌词对应歌词内容 */
@property (nonatomic, copy) NSString *text;

@end
