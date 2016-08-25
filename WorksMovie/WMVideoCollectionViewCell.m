//
//  WMVideoCollectionViewCell.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMVideoCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface WMVideoCollectionViewCell ()

@end

@implementation WMVideoCollectionViewCell


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
    [self setupCollectionViewCellDesign];
    [self setupRemoveVideoButton];
    [self setupVideoNumberLabel];
    [self setupImageView];
    [self setupPlayButton];
}

- (void)setupCollectionViewCellDesign {
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
}

- (void)setupRemoveVideoButton {
    self.removeVideoButton = [[UIButton alloc] init];
    [self.removeVideoButton
     setImage:[UIImage imageNamed:@"Minus"] forState:UIControlStateNormal];
    self.removeVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.removeVideoButton];
}

- (void)setupVideoNumberLabel {
    self.videoNumberLabel = [[UILabel alloc] init];
    self.videoNumberLabel.textColor = [UIColor whiteColor];
    [self.videoNumberLabel setFont:[UIFont systemFontOfSize:16]];
    self.videoNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.videoNumberLabel];
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.imageView];
    
    self.videoView = [[UIView alloc] init];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView addSubview:self.videoView];
}

- (void)setupPlayButton {
    self.playButton = [[UIButton alloc] init];
    [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.playButton.enabled = NO;
    [self.imageView addSubview:self.playButton];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupViewsAlignConstraints];
    [self setupViewsHorizontalConstraints];
    [self setupViewsHeightConstraints];
    [self setupPlayButtonConstraints];
    [self setupVideoViewConstraints];
}

- (void)setupViewsAlignConstraints {
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.removeVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.videoNumberLabel
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.imageView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
}

- (void)setupViewsHorizontalConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[removeVideoButton(==40)]-30-[videoNumberLabel]-30-[imageView(==80)]-25-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"removeVideoButton" : self.removeVideoButton, @"videoNumberLabel" : self.videoNumberLabel, @"imageView" : self.imageView}]];
}

- (void)setupViewsHeightConstraints {
    [self setupRemoveVideoButtonHeightConstraints];
    [self setupVideoNumberLabelHeightConstraints];
    [self setupImageViewHeigthConstraints];
}

- (void)setupRemoveVideoButtonHeightConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[removeVideoButton(==40)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"removeVideoButton" : self.removeVideoButton}]];
}

- (void)setupVideoNumberLabelHeightConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoNumberLabel(==50)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"videoNumberLabel" : self.videoNumberLabel}]];
}

- (void)setupImageViewHeigthConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(==80)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"imageView" : self.imageView}]];
}

- (void)setupPlayButtonConstraints {
    [self.imageView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.imageView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    [self.imageView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.imageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.playButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playButton(==40)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"playButton" : self.playButton}]];
    
    [self.playButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[playButton(==40)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"playButton" : self.playButton}]];
}

- (void)setupVideoViewConstraints {
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"videoView" : self.videoView}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"videoView" : self.videoView}]];
}

@end
