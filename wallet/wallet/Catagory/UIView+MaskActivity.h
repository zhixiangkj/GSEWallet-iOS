//
//  UIView+MaskActivity.h
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/14.
//  Copyright © 2018 付金亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MaskActivity)
@property(nullable, strong) UIView *maskView;
- (void) makeMaskActivity;
- (void) hideMaskActivity;
@end

NS_ASSUME_NONNULL_END
