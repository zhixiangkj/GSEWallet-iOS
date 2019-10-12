//
//  GSE_MenuVertical.h
//  wallet
//
//  Created by user on 19/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSE_MenuVertical;

@protocol GSE_MenuDelegate
- (void)menu:(GSE_MenuVertical *)menu runCreateWallet:(BOOL)finish;
- (void)menu:(GSE_MenuVertical *)menu runImportWallet:(BOOL)finish;
- (void)menu:(GSE_MenuVertical *)menu runSettings:(BOOL)finish;
- (void)menu:(GSE_MenuVertical *)menu runSelectWallet:(NSString *)wallet;
@end

@interface GSE_MenuVertical : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL viewIsAnimating;
@property (nonatomic, assign) BOOL hidePercentage;
@property (nonatomic, assign) BOOL hideTotalAssets;
@property (nonatomic, assign) BOOL hideCreateAndImport;
@property (nonatomic, copy) NSString *menuTitle;

- (void)open;
- (void)close;
- (void)reloadData;

- (void)open:(void(^)(void))finish;
- (void)close:(void(^)(void))finish;
- (void)toggle:(void(^)(void))finish;

@end
