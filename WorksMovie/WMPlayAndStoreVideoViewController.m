//
//  WMPlayAndStoreVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 7. 7..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMPlayAndStoreVideoViewController.h"
#import "WMShowVideosViewController.h"
#import "WMPlayVideo.h"
#import "WMStoreVideo.h"

@interface WMPlayAndStoreVideoViewController ()

@property (nonatomic, strong) WMModelManager *modelManager;
@property (nonatomic, strong) WMPlayVideo *playVideo;
@property (nonatomic, strong) WMStoreVideo *storeVideo;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIView *videoStoreMenuContainerView;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *returnToShootingVideoViewButton;

@end

@implementation WMPlayAndStoreVideoViewController

- (instancetype)initWithVideoModelManager:(WMModelManager *)modelManager {
    self = [super init];
    
    if(self) {
        self.modelManager = modelManager;
        self.playVideo = [[WMPlayVideo alloc] initWithModelManager:modelManager];
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
    [self setupVideoStoreMenuContainerView];
    [self setupStoreVideoButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [self.playVideo gettingThumbnailFromVideoInView:self.videoView];
    
    [self.videoView addSubview:imageView];
    [self.view addSubview:self.videoView];
}

- (void)setupPlayVideoButton {
    self.playVideoButton = [[UIButton alloc] init];
    [self.playVideoButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoButton];
    [self.playVideoButton addTarget:self action:@selector(playVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupVideoStoreMenuContainerView {
    self.videoStoreMenuContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videoStoreMenuContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.videoStoreMenuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoStoreMenuContainerView];
}

- (void)setupStoreVideoButton {
    self.storeVideoButton = [[UIButton alloc] init];
    [self.storeVideoButton
     setImage:[UIImage imageNamed:@"saveButton"] forState:UIControlStateNormal];
    self.storeVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.storeVideoButton];
    [self.storeVideoButton addTarget:self action:@selector(storeVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupPlayVideoButtonConstraints];
    [self setupVideoStoreMenuContainerViewConstraints];
    [self setupStoreVideoButtonConstraints];
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

- (void)setupVideoStoreMenuContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoStoreMenuContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoStoreMenuContainerView" : self.videoStoreMenuContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoStoreMenuContainerView(==200)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView, @"videoStoreMenuContainerView" : self.videoStoreMenuContainerView}]];
}

- (void)setupStoreVideoButtonConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoStoreMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.storeVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoStoreMenuContainerView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.storeVideoButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
}


#pragma mark - Play Video Button Event Handler Methods

// playVideoButton을 클릭하면 videoItems를 차례대로 이어서 재생시킨다.
- (void)playVideoButtonClicked:(UIButton *)sender {
    [self.playVideo playVideo:self.videoView];
}


#pragma mark - Store Video Button Event Handler Methods

- (void)storeVideoButtonClicked:(UIButton *)sender {
    self.storeVideo = [[WMStoreVideo alloc] initWithModelManager:self.modelManager];
    [self.storeVideo mergeVideo];
    [self.storeVideo storeVideo];
}

@end
