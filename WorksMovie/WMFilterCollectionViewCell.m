//
//  WMFilterCollectionViewCell.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 17..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMFilterCollectionViewCell.h"

@implementation WMFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViewComponents];
        [self setupConstraints];
    }
    
    return self;
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupFilterImageView];
    [self setupFilterNameLabel];
}

- (void)setupFilterImageView {
    self.filterImage = [[UIImageView alloc] init];
    self.filterImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.filterImage.clipsToBounds = YES;
    self.filterImage.layer.cornerRadius = 70 / 2.0f;
    [self.filterImage setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.filterImage];
}

- (void)setupFilterNameLabel {
    self.filterNameLabel = [[UILabel alloc] init];
    self.filterNameLabel.textColor = [UIColor grayColor];
    [self.filterNameLabel setFont:[UIFont systemFontOfSize:11]];
    self.filterNameLabel.textAlignment = NSTextAlignmentCenter;
    self.filterNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.filterNameLabel];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupFilterImageViewConstraints];
    [self setupFilterNameLabelConstraints];
}

- (void)setupFilterImageViewConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[filterImage(==70)]-3-[filterNameLabel(==20)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"filterImage" : self.filterImage, @"filterNameLabel" : self.filterNameLabel}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[filterImage(==70)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"filterImage" : self.filterImage}]];
    
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.filterImage
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
}

- (void)setupFilterNameLabelConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[filterNameLabel(==70)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"filterNameLabel" : self.filterNameLabel}]];
    
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.filterNameLabel
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];

}

@end
