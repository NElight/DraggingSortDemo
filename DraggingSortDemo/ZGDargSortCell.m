//
//   ZGDargSortCell.m
//   
//
//  Created by HelloYeah on 2016/11/30.
//  Copyright © 2016年 YeLiang. All rights reserved.
//

#import "ZGDargSortCell.h"
#import "ZGDefine.h"
#import "UIView+Frame.h"
#import "ZGDragSortTool.h"

#define kDeleteBtnWH 10 * SCREEN_WIDTH_RATIO
@interface ZGDargSortCell ()
@property (nonatomic,strong)  UILabel *label;
@property (nonatomic,assign) BOOL  isEditing;
@property (nonatomic,strong) UIButton * deleteBtn;
@end
@implementation ZGDargSortCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    _label = [[UILabel alloc] init];
    [self.contentView addSubview:_label];
    _label.font = kFont(15);
    _label.textColor = RGBColorMake(110, 110, 110, 1);
    _label.layer.cornerRadius = 4 * SCREEN_WIDTH_RATIO;
    _label.layer.masksToBounds = NO;
    _label.layer.borderColor = RGBColorMake(110, 110, 110, 1).CGColor;
    _label.layer.borderWidth = kLineHeight;
    _label.textAlignment = NSTextAlignmentCenter;
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"drag_delete"] forState:UIControlStateNormal];
    _deleteBtn.width = kDeleteBtnWH;
    _deleteBtn.height = kDeleteBtnWH;
    
    [_deleteBtn addTarget:self action:@selector(cancelSubscribe) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
}

- (void)cancelSubscribe {

    if (self.delegate && [self.delegate respondsToSelector:@selector(ZGDargSortCellCancelSubscribe:)]) {
        [self.delegate ZGDargSortCellCancelSubscribe:self.subscribe];
    }
}

- (void)showDeleteBtn {

    _deleteBtn.hidden = NO;
}

- (void)editStateChange:(NSNotification *)noti {

    self.isEditing = YES;
}

- (void)setSubscribe:(NSString *)subscribe {
    
    _subscribe = subscribe;
    _deleteBtn.hidden = ![ZGDragSortTool shareInstance].isEditing;
    _label.text = subscribe;
    _label.width = self.width - kDeleteBtnWH;
    _label.height = self.height - kDeleteBtnWH;
    _label.center = CGPointMake(self.width * 0.5, self.height * 0.5);
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![ZGDragSortTool shareInstance].isEditing) {
        return NO;
    }
    return YES;
}


- (void)gestureAction:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZGDargSortCellGestureAction:)]) {
        [self.delegate ZGDargSortCellGestureAction:gestureRecognizer];
    }
}

@end
