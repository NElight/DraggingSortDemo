//
//   YLDragSortTool.h
//   
//
//  Created by HelloYeah on 2016/11/30.
//  Copyright © 2016年 YeLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGDragSortTool : NSObject
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) NSMutableArray * subscribeArray;
+ (instancetype)shareInstance;
@end
