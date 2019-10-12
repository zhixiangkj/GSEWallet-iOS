//
//  GSE_SpinnerCell
//  insta
//
//  Created by user on 17/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_SpinnerCell.h"

@interface GSE_SpinnerCell ()

@end

@implementation GSE_SpinnerCell

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:self.indicatorView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    self.indicatorView.center = CGPointMake(CGRectGetWidth(bounds) / 2.0, CGRectGetHeight(bounds) / 2.0);
}

@end
