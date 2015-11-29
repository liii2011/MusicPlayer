//
//  ZJMusic.h
//  音乐播放器
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJMusic : NSObject

/*
 <key>name</key>
 <string>月半小夜曲</string>
 <key>filename</key>
 <string>1201111234.mp3</string>
 <key>lrcname</key>
 <string>月半小夜曲.lrc</string>
 <key>singer</key>
 <string>李克勤</string>
 <key>singerIcon</key>
 <string>lkq_icon.jpg</string>
 <key>icon</key>
 <string>lkq.jpg</string>
 */

/** 歌曲名 */
@property (nonatomic, copy) NSString *name;
/** 歌曲文件名 */
@property (nonatomic, copy) NSString *filename;
/** 歌词 */
@property (nonatomic, copy) NSString *lrcname;
/** 歌手名 */
@property (nonatomic, copy) NSString *singer;
/** 歌手头像 */
@property (nonatomic, copy) NSString *singerIcon;
/** 歌手封面照 */
@property (nonatomic, copy) NSString *icon;

@end
