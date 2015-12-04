//
//  ZJLrcView.m
//  音乐播放器
//
//  Created by liii on 15/12/1.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJLrcView.h"
#import "UIView+Frame.h"
#import "ZJLrcCell.h"
#import "ZJLrcLine.h"

@interface ZJLrcView () <UITableViewDelegate, UITableViewDataSource>

/** 用于在歌词view中展示歌词 */
@property (nonatomic, weak) UITableView *tableView;
/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcLines;
/** 存储当前滚动到的行 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ZJLrcView

// 从xib加载控件的时候调用
- (void)awakeFromNib {
    [self setupUI];
}

// 设置UI界面
- (void)setupUI
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.bounds;

    // 去除背景色, 去除分割线
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // tableView.allowsSelection = NO; // 取消cell的选中状态
    tableView.contentInset = UIEdgeInsetsMake(tableView.sizeHeight * 0.5, 0, tableView.sizeHeight * 0.5, 0);
    
    // 设置代理和数据源
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self addSubview:tableView];
    self.tableView = tableView;
}

// 布局完子控件的时候调用
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置frame, 内边距
    self.tableView.frame = self.bounds;
}


#pragma mark - tableView的数据源方法
// row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    ZJLrcCell *cell = [ZJLrcCell lrcCellWithTableView:tableView];
    
    // 设置数据
    cell.lrcLine = self.lrcLines[indexPath.row];
    
    // 返回cell
    return cell;
}

#pragma mark - 获取歌词数据
// 重写setter
- (void)setLrcName:(NSString *)lrcName
{
    //1 保存歌名
    _lrcName = lrcName;
    
    //2 解析歌词文件, 获取整个字符串
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //3 分割出每一行歌词
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    
    /** 歌词格式
     [ti:]
     [ar:]
     [al:]
     
     [00:00.89]传奇
     [00:02.34]作词：刘兵
     [00:03.82]作曲：李健
     [00:05.48]演唱：王菲
     [00:07.39]
     [00:33.20]只是因为在人群中多看了你一眼
     [00:40.46]再也没能忘掉你容颜
     [00:47.68]梦想着偶然能有一天再相见
     [00:55.29]从此我开始孤单思念
     */
    
    //4 遍历歌词数组
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrc in lrcArray) {
        
        // 过滤掉ti, ar, al, 和空行
        if ([lrc hasPrefix:@"[ti"] || [lrc hasPrefix:@"[ar"] || [lrc hasPrefix:@"[al"] || ![lrc hasPrefix:@"["]) {
            continue;
        }
        
        // 把每一行从"]"分成2部分
        NSArray *lrcComponents = [lrc componentsSeparatedByString:@"]"];
        
        // 创建模型
        ZJLrcLine *lrcLine = [[ZJLrcLine alloc] init];
        // 从后半部分中, 取出歌词内容, 放到模型中
        lrcLine.text = [lrcComponents lastObject];
        
        // 从前半部分中, 分离出歌词时间, 放到模型中
        lrcLine.time = [[lrcComponents firstObject] substringFromIndex:1];
        
        // 把模型存放到数组中
        [tempArray addObject:lrcLine];
    }
    
    // 把歌词和对应时间的模型赋值给控制器数组
    self.lrcLines = tempArray;
    
    //3 添加到数组
    [self.tableView reloadData];
}

#pragma mark - 更新歌词
// 获取歌词, 实现歌词滚动
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    // 接收并保持时间(290.385714 分钟.秒)
    _currentTime  = currentTime;
    
    // 计算分钟, 秒数, 毫秒(290.324150 - 290) * 1000, 拼接为指定格式
    NSInteger minute = currentTime / 60;
    NSInteger second = (NSInteger)currentTime % 60;
    NSInteger millisecond = (currentTime - (NSInteger)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02ld:%02ld.%02ld", minute, second, millisecond];
    
    // 对比时间
    NSInteger count = self.lrcLines.count;
    for (int i=0; i<count; i++) {
        
        //1 取出当前歌词的模型
        ZJLrcLine *currentLrcLine = self.lrcLines[i];
        
        //2 取出下一个歌词模型
        NSInteger nextIndex = i + 1;
        if (nextIndex < count) { // 防止越界
            ZJLrcLine *nextLrcLine = self.lrcLines[nextIndex];
            
            // 如果时间大于等于当前歌词的时间, 或小于等于下一个歌词的时间, 同时有不和上一条歌词时间重复
            if ([currentTimeStr compare:currentLrcLine.time] != NSOrderedAscending && [currentTimeStr compare:nextLrcLine.time] != NSOrderedDescending &&
                self.currentIndex != i) {
                
                // 记录当前行, 用于比较
                self.currentIndex = i;
                
                // 就让tableView滚动指定位置
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        
        
    }
}

@end
