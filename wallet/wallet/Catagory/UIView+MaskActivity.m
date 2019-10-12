//
//  UIView+MaskActivity.m
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/14.
//  Copyright © 2018 付金亮. All rights reserved.
//
#import <Toast/Toast.h>
#import "UIView+MaskActivity.h"

@implementation UIView (MaskActivity)
- (void) makeMaskActivity {
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.maskView makeToastActivity:CSToastPositionCenter];
    [self addSubview:self.maskView];
}
- (void) hideMaskActivity {
    [self.maskView hideToastActivity];
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}
@end
