//
//  ZJLrcView.h
//  音乐播放器
//
//  Created by liii on 15/12/1.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface ZJLrcView : DRNRealTimeBlurView

/** 歌曲名称 */
@property (nonatomic, copy) NSString *lrcName;
/** 歌词当前播放时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

@end
