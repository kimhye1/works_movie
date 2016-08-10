//
//  WMCollectionViewCell.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMCollectionViewCell.h"

@implementation WMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupImageView];
    }
    
    return self;
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"imageView" : self.imageView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"imageView" : self.imageView}]];
}

@end
