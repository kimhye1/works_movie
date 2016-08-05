//
//  ViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "WMViewController.h"
#import "WMShowVideosViewController.h"
#import "WMShootingVideoViewController.h"

NSString *const shootingVideoButtonTitle = @"동영상 촬영";
NSString *const showVideoButtonTitle = @"동영상 가져오기";

@implementation WMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupBackgroundView];
    [self setupShootingVideoButton];
    [self setupShowVideosButton];
}

- (void)setupBackgroundView {
    AVPlayer *avPlayer = [self setupBackgroundVideo];
    [self playVideo:avPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[avPlayer currentItem]];
}

- (void)setupShootingVideoButton {
    self.shootingVideoButton = [[UIButton alloc] init];
    [self.shootingVideoButton setTitle:shootingVideoButtonTitle forState:UIControlStateNormal];
    self.shootingVideoButton.backgroundColor = [UIColor whiteColor];
    [self.shootingVideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.shootingVideoButton.layer.cornerRadius = 4;
    self.shootingVideoButton.clipsToBounds = YES;
    self.shootingVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shootingVideoButton];
    [self.shootingVideoButton addTarget:self action:@selector(shootingVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupShowVideosButton {
    self.showVideosButton = [[UIButton alloc] init];
    [self.showVideosButton setTitle:showVideoButtonTitle forState:UIControlStateNormal];
    self.showVideosButton.backgroundColor = [UIColor whiteColor];
    [self.showVideosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.showVideosButton.layer.cornerRadius = 4;
    self.showVideosButton.clipsToBounds = YES;
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shootingVideoButton(==270)]"
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[showVideosButton(==270)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"showVideosButton" : self.showVideosButton}]];
}

- (void)setupButtonsVerticalConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[shootingVideoButton(==50)]-17-[showVideosButton(==50)]-30-|"
                                             options:0
                                             metrics:nil
                                               views:@{
                                                       @"shootingVideoButton" : self.shootingVideoButton,
                                                       @"showVideosButton" : self.showVideosButton}]];
}


#pragma mark - Play Background Video

- (AVPlayer *)setupBackgroundVideo {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"works.mov" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    AVPlayer *avPlayer = [AVPlayer playerWithURL:fileURL];
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    AVPlayerLayer *videoLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    videoLayer.frame = self.view.bounds;
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:videoLayer];
    
    return avPlayer;
}

- (void)playVideo:(AVPlayer *)avPlayer {
    [avPlayer play];
}


#pragma mark - Background Video End Event Handler

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    AVPlayerItem *player = [notification object];
    [player seekToTime:kCMTimeZero];
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
