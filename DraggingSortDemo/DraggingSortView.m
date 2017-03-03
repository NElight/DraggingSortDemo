//
//  DraggingSortView.m
//  DraggingSortDemo
//
//  Created by Yioks-Mac on 17/3/2.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

#import "DraggingSortView.h"
#import "UIView+GestureProperty.h"

/***  当前屏幕宽度 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
/***  当前屏幕高度 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/***  屏宽比例 */
#define SCREEN_WIDTH_RATIO (SCREEN_WIDTH / 375)
#define kLineHeight (1 / [UIScreen mainScreen].scale)
#pragma mark - 字体
/***  普通字体 */
#define kFont(size) [UIFont systemFontOfSize:((size) * SCREEN_WIDTH_RATIO + SCREEN_WIDTH_RATIO * (SCREEN_WIDTH_RATIO < 1 ? 1 : - 1 ))]

//根据RGB值创建UIColor
#define RGBColorMake(R,G,B,_alpha_) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:_alpha_]

#define Cell_identifier @"DraggingSortCell"

@interface DraggingSortView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *snapshotView;

@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, strong) NSIndexPath * selectIndexPath;

@property (nonatomic, strong) NSIndexPath * nextIndexPath;

@property (nonatomic, strong) UICollectionViewCell *selectedCell;

@property (nonatomic, strong) NSMutableArray *colorArr;

@end

@implementation DraggingSortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    _colorArr = [NSMutableArray arrayWithCapacity:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 4 * 10) / 5, 40);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    
    [self addSubview:self.collectionView];
}

- (void)setRegisterClass:(Class)registerClass {
    _registerClass = registerClass;
    [self.collectionView registerClass:registerClass forCellWithReuseIdentifier:Cell_identifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)setRegisterNib:(UINib *)registerNib {
    _registerNib = registerNib;
    [self.collectionView registerNib:registerNib forCellWithReuseIdentifier:Cell_identifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
}

- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell_identifier forIndexPath:indexPath];
    
    UIPanGestureRecognizer *pan = cell.panGesture;
    if (!pan) {
        
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        [cell addGestureRecognizer:pan];
        cell.panGesture = pan;
    }
    
    
#define Random arc4random() % 256
    cell.backgroundColor = RGBColorMake(Random, Random, Random, 1);
    if (self.colorArr.count < self.dataList.count) {
        
        [self.colorArr addObject:cell.backgroundColor];
    }
    return cell;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    static CGPoint startPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        UICollectionViewCell *cell = pan.view;
        self.snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
        self.snapshotView.center = cell.center;
        [self.collectionView addSubview:self.snapshotView];
        startPoint = [pan locationInView:self.collectionView];
        self.selectIndexPath = [self.collectionView indexPathForCell:cell];
        self.selectedCell = cell;
        self.selectedCell.hidden = YES;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat tranX = [pan locationOfTouch:0 inView:self.collectionView].x - startPoint.x;
        CGFloat tranY = [pan locationOfTouch:0 inView:self.collectionView].y - startPoint.y;
        self.snapshotView.center = CGPointApplyAffineTransform(self.snapshotView.center, CGAffineTransformMakeTranslation(tranX, tranY));
        startPoint = [pan locationOfTouch:0 inView:self.collectionView];
        for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
            if ([self.collectionView indexPathForCell:cell] == self.selectIndexPath) {
                continue;
            }
            
            CGFloat space = sqrtf(pow(self.snapshotView.center.x - cell.center.x, 2) + powf(self.snapshotView.center.y - cell.center.y, 2));
            
            if (space <= self.snapshotView.bounds.size.width * 0.5 && fabs(self.snapshotView.center.y - cell.center.y) <= self.snapshotView.bounds.size.height * 0.5) {
                self.nextIndexPath = [self.collectionView indexPathForCell:cell];
                if (self.nextIndexPath.item > self.selectIndexPath.item) {
                    for (NSUInteger i = self.selectIndexPath.item; i < self.nextIndexPath.item; i ++) {
                        [self.dataList exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                    }
                }else {
                    for (NSUInteger i = self.selectIndexPath.item; i > self.nextIndexPath.item; i --) {
                        [self.dataList exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                    }
                }
                
                [self.collectionView moveItemAtIndexPath:self.selectIndexPath toIndexPath:self.nextIndexPath];
                self.selectIndexPath = self.nextIndexPath;
                break;
                
            }
            
            
        }
        
    }else if (pan.state == UIGestureRecognizerStateEnded ) {
        [self.snapshotView removeFromSuperview];
        self.selectedCell.hidden = NO;
    }
}



@end
