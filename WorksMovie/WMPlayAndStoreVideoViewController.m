//
//  WMPlayAndStoreVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 7..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMPlayAndStoreVideoViewController.h"
#import "WMShowVideosViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WMPlayAndStoreVideoViewController ()

@property (nonatomic, strong) NSMutableArray *videoListArray;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *returnToShootingVideoViewButton;

@end

@implementation WMPlayAndStoreVideoViewController

- (instancetype)initWithVideoFileURLList:list {
    self = [super init];
    
    if(self) {
        self.videoListArray = list;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupComponents {
    [self setupVideoView];
    [self setupPlayVideoButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoView];
}

- (void)setupPlayVideoButton {
    self.playVideoButton = [[UIButton alloc] init];
    [self.playVideoButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoButton];
    [self.playVideoButton addTarget:self action:@selector(playVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupPlayVideoButtonConstraints];
}

- (void)setupVideoViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoView]-200-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];

}

- (void)setupPlayVideoButtonConstraints {
    [self.videoView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playVideoButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.videoView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}


#pragma mark - Play Video Button Event Handler Methods

// playVideoButton을 클릭하면 videoItems를 차례대로 이어서 재생시킨다.
- (void)playVideoButtonClicked:(UIButton *)sender {
    NSMutableArray *videoItems = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.videoListArray.count; i++) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoListArray[i]];
        [videoItems addObject:playerItem];
    }
    AVQueuePlayer *player = [[AVQueuePlayer alloc] initWithItems:videoItems];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    playerLayer.frame = self.videoView.frame;
    
    [self.view.layer addSublayer:playerLayer];
    
    [player play];
}

@end
