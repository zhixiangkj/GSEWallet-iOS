//
//  GSE_Menu.h
//  wallet
//
//  Created by user on 26/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSE_Menu;

@protocol GSE_MenuDelegate
- (void)menu:(GSE_Menu *)menu runCreateWallet:(BOOL)finish;
- (void)menu:(GSE_Menu *)menu runImportWallet:(BOOL)finish;
- (void)menu:(GSE_Menu *)menu runSettings:(BOOL)finish;
@end

@interface GSE_Menu : UIView

@property (nonatomic, assign) id delegate;

- (void)open;
- (void)close;
- (void)close:(void(^)(void))finish;

@end
