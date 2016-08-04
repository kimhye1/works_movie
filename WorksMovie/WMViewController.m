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

NSString *const kShootingVideoButtonTitle = @"동영상 촬영";
NSString *const kShowVideoButtonTitle = @"내 동영상 보기";

@implementation WMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupShootingVideoButton];
    [self setupShowVideosButton];
}

- (void)setupShootingVideoButton {
    self.shootingVideoButton = [[UIButton alloc] init];
    [self.shootingVideoButton setTitle:kShootingVideoButtonTitle forState:UIControlStateNormal];
    self.shootingVideoButton.backgroundColor = [UIColor greenColor];
    self.shootingVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shootingVideoButton];
    [self.shootingVideoButton addTarget:self action:@selector(shootingVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupShowVideosButton {
    self.showVideosButton = [[UIButton alloc] init];
    [self.showVideosButton setTitle:kShowVideoButtonTitle forState:UIControlStateNormal];
    self.showVideosButton.backgroundColor = [UIColor redColor];
    self.showVideosButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.showVideosButton];
    [self.showVideosButton addTarget:self action:@selector(showVideosButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupShootingVideoButtonAlignConstraint];
    [self setupShootingVideoButtonHorizontalConstraints];
    [self setupShowVideoButtonAlignConstraint];
    [self setupShowVideosButtonHorizontalConstraints];
    
    [self setupButtonsVerticalConstraints];
}

- (void)setupShootingVideoButtonAlignConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.shootingVideoButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
}

- (void)setupShootingVideoButtonHorizontalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingVideoButton(==200)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shootingVideoButton" : self.shootingVideoButton}]];
}

- (void)setupShowVideoButtonAlignConstraint {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.showVideosButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
}

- (void)setupShowVideosButtonHorizontalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[showVideosButton(==200)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"showVideosButton" : self.showVideosButton}]];
}

- (void)setupButtonsVerticalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[shootingVideoButton(==50)]-30-[showVideosButton(==50)]"
                                             options:0
                                             metrics:nil
                                               views:@{
                                                       @"shootingVideoButton" : self.shootingVideoButton,
                                                       @"showVideosButton" : self.showVideosButton}]];
}


#pragma mark - Button Event Handler Methods

- (void)shootingVideoButtonClicked:(UIButton *)sender {
    [self presentWMShootingVideoViewController];
}

- (void)presentWMShootingVideoViewController {
    WMShootingVideoViewController *shootingVideoViewController = [[WMShootingVideoViewController alloc] init];
    [self presentViewController:shootingVideoViewController animated:YES completion:nil];
}

- (void)showVideosButtonClicked:(UIButton *)sender {
    [self presentWMShowVideosViewController];
}

- (void)presentWMShowVideosViewController {
    WMShowVideosViewController *showVideosViewController = [[WMShowVideosViewController alloc] init];
    [self presentViewController:showVideosViewController animated:YES completion:nil];
}


@end
