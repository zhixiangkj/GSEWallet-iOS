//
//  GSE_TransferCell.h
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_TransferCell : UITableViewCell
@property (nonatomic, assign) BOOL showSeparator;
@end

@interface GSE_TransferTextFieldCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@end

@interface GSE_TransferTextFieldQRCell : UITableViewCell
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, assign) id delegate;
@end

@interface GSE_TransferSliderCell : UITableViewCell
@property (nonatomic, strong) UISlider *gasSlider;
@property (nonatomic, assign) id delegate;

- (void)setEtherchainData:(NSDictionary *)dic;
@end

@interface GSE_TransferGasCell : UITableViewCell
@property (nonatomic, assign) id delegate;
@end
