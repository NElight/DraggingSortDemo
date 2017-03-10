//
//   ZGDargSortCell.h
//   
//
//  Created by HelloYeah on 2016/11/30.
//  Copyright © 2016年 YeLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKDragSortDelegate <NSObject>

- (void)ZGDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer;

- (void)ZGDargSortCellCancelSubscribe:(NSString *)subscribe;

@end

@interface ZGDargSortCell : UICollectionViewCell
@property (nonatomic,strong) NSString * subscribe;
@property (nonatomic,weak) id<SKDragSortDelegate> delegate;

- (void)showDeleteBtn;
@end
