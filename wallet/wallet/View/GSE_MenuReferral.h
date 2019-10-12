//
//  GSE_MenuReferral.h
//  GSEWallet
//
//  Created by user on 05/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_MenuReferral : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL viewIsAnimating;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *referalTipLabel;

- (void)open;
- (void)close;

- (void)open:(void(^)(void))finish;
- (void)close:(void(^)(void))finish;
- (void)toggle:(void(^)(void))finish;

@end
