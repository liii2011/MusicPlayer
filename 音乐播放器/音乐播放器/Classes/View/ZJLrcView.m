//
//  ZJLrcView.m
//  音乐播放器
//
//  Created by liii on 15/12/1.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJLrcView.h"
#import "UIView+Frame.h"

@interface ZJLrcView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

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
//    tableView.allowsSelection = NO; // 取消cell的选中状态
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
    
    self.tableView.frame = self.bounds;
    
}


#pragma mark - tableView的数据源方法
// row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    static NSString *reuseId = @"lrcCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    // 设置数据
    cell.textLabel.text = @"123";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // 去除背景, 取消选中状态
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - tableView的代理方法

@end
