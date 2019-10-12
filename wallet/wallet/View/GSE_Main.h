//
//  GSE_Main.h
//  wallet
//
//  Created by user on 26/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSE_Main;

@protocol GSE_MainDelegate
- (void)main:(GSE_Main *)mainView didSelectToken:(NSDictionary *)token;
- (void)main:(GSE_Main *)mainView didClickSend:(id)sender;
- (void)main:(GSE_Main *)mainView didClickReceive:(id)sender;
- (void)main:(GSE_Main *)mainView didClickMore:(id)sender;
- (void)main:(GSE_Main *)mainView didClickTitle:(id)sender;
@end

@interface GSE_Main : UIView
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, strong) NSString *totalUSD;
@property (nonatomic, strong) NSString *percentageChange;
@property (nonatomic, assign) BOOL canRebate;
- (void)reloadData;
- (void)refresh;
@end
