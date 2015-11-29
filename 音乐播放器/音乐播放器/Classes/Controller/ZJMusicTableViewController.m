//
//  ZJMusicTableViewController.m
//  音乐播放器
//
//  Created by liii on 15/11/29.
//  Copyright © 2015年 liii. All rights reserved.
//

#import "ZJMusicTableViewController.h"
//#import "MJExtension.h"
#import "ZJMusic.h"
#import "UIImage+CircleClip.h"
#import "ZJPlayingViewController.h"
#import "ZJMusicTool.h"

@interface ZJMusicTableViewController ()

///** 所有的音乐 */
//@property (nonatomic, strong) NSArray *musics;
/** 播放控制器 */
@property (nonatomic, strong) ZJPlayingViewController *playingVc;

@end

@implementation ZJMusicTableViewController

//// 懒加载
//- (NSArray *)musics
//{
//    if (_musics == nil) {
//        _musics = [ZJMusic objectArrayWithFilename:@"Musics.plist"];
//    }
//    return _musics;
//}

// 懒加载一个播放控制器
- (ZJPlayingViewController *)playingVc
{
    if (_playingVc == nil) {
        _playingVc = [[ZJPlayingViewController alloc] init];
    }
    return _playingVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置cell 行高
    self.tableView.rowHeight = 70;
    
    // 返回模型数组
    NSArray *musics = [ZJMusicTool musics];
    NSLog(@"%@", musics);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZJMusicTool musics].count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建cell
    static NSString *reuseId = @"music";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
    // 拿到模型数据
    ZJMusic *music = [ZJMusicTool musics][indexPath.row];
    
    // 给子控件赋值
    cell.imageView.image = [UIImage circleClipImageName:music.singerIcon borderWidth:2 borderColor:[UIColor greenColor] writeToFile:nil];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    
    // 返回cell
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 隐藏选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 显示播放控制器
    [self.playingVc show];
}




@end
