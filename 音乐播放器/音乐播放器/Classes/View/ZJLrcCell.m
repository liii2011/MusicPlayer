//
//  ZJLrcCell.m
//  音乐播放器
//
//  Created by liii on 15/12/2.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJLrcCell.h"

@implementation ZJLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    // 创建cell
    static NSString *reuseId = @"lrcCell";
    ZJLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[ZJLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    // 去除背景, 取消选中状态
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置textLable的背景色和对齐方式
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
