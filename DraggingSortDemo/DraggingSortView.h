//
//  DraggingSortView.h
//  DraggingSortDemo
//
//  Created by Yioks-Mac on 17/3/2.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggingSortView : UIView

@property (nonatomic, strong) NSMutableArray *dataList;

//registerClass和registerNib不能同时设置，否则后一个设置的覆盖前一个
@property (nonatomic, assign) Class registerClass;

@property (nonatomic, strong) UINib *registerNib;

@end
