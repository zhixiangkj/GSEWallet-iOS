//
//  UIViewController+Extensions.m
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UIViewController+Extensions.h"

#import <objc/runtime.h>

@implementation UIViewController (Extensions)

#pragma mark - back


-(void)setBackItem{
    UIImage *image = [UIImage imageFromColor:[UIColor clearColor]];
    UIImage *image_back = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.navigationController.navigationBar setBackIndicatorImage:image_back];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)setBlankLeftItem{
    UIImage *image = [UIImage imageFromColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackIndicatorImage:image];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(blank)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setLeftItem:(UIImage *)aimage{
    UIImage *image = [aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftItem setImage:image];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)blank{
    
}

#pragma mark - loading

- (MBProgressHUD *)loading{
    return [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (MBProgressHUD *)unlocking{
    MBProgressHUD *hud = [self loading];
    
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Unlocking...",nil);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 120.f);
    
    return hud;
}

- (MBProgressHUD *)finishing:(NSString *)complete {
    
    MBProgressHUD *hud = [self loading];
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = complete;
    hud.minSize = CGSizeMake(150.f, 120.f);
    return hud;
}

- (MBProgressHUD *)finishing:(NSString *)complete withHud:(MBProgressHUD *)hud{
    
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = complete;
    return hud;
}

- (void)loadingFinish{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
}

#pragma mark - alert

- (void)alertTitle:(NSString *)title withMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle finish:(void (^)(void))finish{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (finish) {
            finish();
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertTitle:(NSString *)title withMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle cancel:(void (^)(void))cancel finish:(void (^)(void))finish{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (finish) {
            finish();
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - objc/runtime

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self tap_swizzleSelector:@selector(viewWillAppear:) withSelector:@selector(gt_viewWillAppear:)];
        [self tap_swizzleSelector:@selector(viewWillDisappear:) withSelector:@selector(gt_viewWillDisappear:)];
    });
}

+ (void)tap_swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)gt_viewWillAppear:(BOOL)animated
{
    [self gt_viewWillAppear:animated];
    
    //NSLog(@"%@",NSStringFromClass(self.class));
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value: NSStringFromClass(self.class)];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)gt_viewWillDisappear:(BOOL)animated
{
    [self gt_viewWillDisappear:animated];
}

@end
