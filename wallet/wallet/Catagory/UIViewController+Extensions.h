//
//  UIViewController+Extensions.h
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIViewController (Extensions)

- (void)setLeftItem:(UIImage *)image;
- (void)setBackItem;
- (void)setBlankLeftItem;

- (id)loading;
- (id)unlocking;
- (MBProgressHUD *)finishing:(NSString *)complete;
- (MBProgressHUD *)finishing:(NSString *)complete withHud:(MBProgressHUD *)hud;

- (void)loadingFinish;

- (void)alertTitle:(NSString *)title withMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle finish:(void (^)(void))finish;

- (void)alertTitle:(NSString *)title withMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle cancel:(void (^)(void))cancel finish:(void (^)(void))finish;

@end
