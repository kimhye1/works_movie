//
//  ViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMViewController.h"
#import "WMShowVideosViewController.h"
#import "WMShootingVideoViewController.h"

@interface WMViewController ()

@end

@implementation WMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
}

- (void)setupViewComponents {
    [self setupShootingVideoButton];
    [self setupShowVideosButton];
}

- (void)setupShootingVideoButton {
    self.shootingVideoButton = [[UIButton alloc] init];
    [self.shootingVideoButton setTitle:@"동영상 촬영" forState:UIControlStateNormal];
    self.shootingVideoButton.backgroundColor = [UIColor greenColor];
    self.shootingVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shootingVideoButton];
    [self.shootingVideoButton addTarget:self action:@selector(shootingVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupShowVideosButton {
    self.showVideosButton = [[UIButton alloc] init];
    [self.showVideosButton setTitle:@"내 동영상 보기" forState:UIControlStateNormal];
    self.showVideosButton.backgroundColor = [UIColor redColor];
    self.showVideosButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.showVideosButton];
    [self.showVideosButton addTarget:self action:@selector(showVideosButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setupConstraints {
    [self setupShootingVideoButtonHorizontalConstraint];
    [self setupShowVideosButtonHorizontalConstraint];
    [self setupButtonVerticalConstraints];
    [self setupShowVideosButtonVerticalConstraints];
    [self setupShootingVideoButtonVerticalConstraints];
}

- (void)setupShootingVideoButtonHorizontalConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.shootingVideoButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)setupShowVideosButtonHorizontalConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.showVideosButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)setupButtonVerticalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[shootingVideoButton(==50)]-30-[showVideosButton(==50)]" options:0 metrics:nil views:@{@"shootingVideoButton" : self.shootingVideoButton, @"showVideosButton" : self.showVideosButton}]];
}

- (void)setupShootingVideoButtonVerticalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingVideoButton(==200)]" options:0 metrics:nil views:@{@"shootingVideoButton" : self.shootingVideoButton}]];
}

- (void)setupShowVideosButtonVerticalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[showVideosButton(==200)]" options:0 metrics:nil views:@{ @"showVideosButton" : self.showVideosButton}]];

}

- (void)shootingVideoButtonClicked:(UIButton *)sender {
    WMShootingVideoViewController *shootingVideoViewController = [[WMShootingVideoViewController alloc] init];
    [self presentViewController:shootingVideoViewController animated:YES completion:nil];
}

- (void)showVideosButtonClicked:(UIButton *)sender {
    WMShowVideosViewController *showVideosViewController = [[WMShowVideosViewController alloc] init];
    [self presentViewController:showVideosViewController animated:YES completion:nil];
}


@end
