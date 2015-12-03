//
//  ZJLrcCell.h
//  音乐播放器
//
//  Created by liii on 15/12/2.
//  Copyright © 2015年 liii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJLrcLine;
@interface ZJLrcCell : UITableViewCell

/** 歌词模型 */
@property (nonatomic, strong) ZJLrcLine *lrcLine;

/** 创建歌词cell */
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
