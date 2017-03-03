//
//  UIView+GestureProperty.m
//  DraggingSortDemo
//
//  Created by Yioks-Mac on 17/3/3.
//  Copyright © 2017年 Yioks-Mac. All rights reserved.
//

#import "UIView+GestureProperty.h"
#import <objc/runtime.h>

NSString *PANGestureKey = @"panGesture";

@implementation UIView (GestureProperty)

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture {
    objc_setAssociatedObject(self, (__bridge const void *)(PANGestureKey), panGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIPanGestureRecognizer *)panGesture {
    return objc_getAssociatedObject(self, (__bridge const void *)(PANGestureKey));
}



@end
