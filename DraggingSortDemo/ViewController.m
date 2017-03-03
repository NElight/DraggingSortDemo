//
//  ViewController.m
//  DraggingSortDemo
//
//  Created by Yioks-Mac on 17/3/2.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

#import "ViewController.h"
#import "DraggingSortView.h"
@interface ViewController ()

@property (nonatomic, strong) DraggingSortView *sortView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sortView = [[DraggingSortView alloc]initWithFrame:self.view.bounds];
    self.sortView.registerClass = [UICollectionViewCell class];
    self.sortView.dataList = [@[@"推荐",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码",@"文化",@"美文",@"星座",@"旅游",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码",@"文化",@"美文",@"星座",@"旅游"] mutableCopy];
    [self.view addSubview:self.sortView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
