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
#import "WMShareVideo.h"
#import "WMShareVideo.h"


@interface WMPlayAndStoreVideoViewController ()

@property (nonatomic, strong) WMModelManager *modelManager;
@property (nonatomic, strong) WMPlayVideo *playVideo;
@property (nonatomic, strong) WMStoreVideo *storeVideo;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backToCameraViewButton;
@property (nonatomic, strong) UIButton *resetAndbackToCameraButton;
@property (nonatomic, strong) UIButton *playVideoButton;
@property (nonatomic, strong) UIView *videoStoreMenuContainerView;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UIButton *shareVideoButton;
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
    [self setupBackToCameraViewButton];
    [self setupResetAndbackToCameraButton];
    [self setupPlayVideoButton];
    [self setupVideoStoreMenuContainerView];
    [self setupStoreVideoButton];
    [self setupShareVideoButton];

}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [self.playVideo gettingThumbnailFromVideoInView:self.videoView];
    
    [self.videoView addSubview:imageView];
    [self.view addSubview:self.videoView];
}


- (void)setupBackToCameraViewButton {
    self.backToCameraViewButton = [[UIButton alloc] init];
    [self.backToCameraViewButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backToCameraViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.backToCameraViewButton];
    [self.backToCameraViewButton addTarget:self action:@selector(backToCameraViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupResetAndbackToCameraButton {
    self.resetAndbackToCameraButton = [[UIButton alloc] init];
    [self.resetAndbackToCameraButton setImage:[UIImage imageNamed:@"videoButton"] forState:UIControlStateNormal];
    self.resetAndbackToCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.resetAndbackToCameraButton];
    [self.resetAndbackToCameraButton addTarget:self action:@selector(resetAndbackToCameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)setupShareVideoButton {
    self.shareVideoButton = [[UIButton alloc] init];
    [self.shareVideoButton
     setImage:[UIImage imageNamed:@"shareButton"] forState:UIControlStateNormal];
    self.shareVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.shareVideoButton];
    [self.shareVideoButton addTarget:self action:@selector(shareVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackToCameraViewButtonConstraints];
    [self setupResetAndbackToCameraButtonConstraints];
    [self setupPlayVideoButtonConstraints];
    [self setupVideoStoreMenuContainerViewConstraints];
    [self setupStoreVideoButtonConstraints];
    [self setupShareVideoButtonConstraints];

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

- (void)setupBackToCameraViewButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backToCameraViewButton(==40)]"
                                            options:0
                                            metrics:nil
                                               views:@{@"backToCameraViewButton" : self.backToCameraViewButton}]];
    
     [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[backToCameraViewButton(==40)]"
                                            options:0
                                            metrics:nil
                                                views:@{@"backToCameraViewButton" : self.backToCameraViewButton}]];
}

- (void)setupResetAndbackToCameraButtonConstraints {
    [self.view addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[resetAndbackToCameraButton(==40)]-20-|"
                                                options:0
                                                metrics:nil
                                                    views:@{@"resetAndbackToCameraButton" : self.resetAndbackToCameraButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[resetAndbackToCameraButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"resetAndbackToCameraButton" : self.resetAndbackToCameraButton}]];
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
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[storeVideoButton]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeVideoButton" : self.storeVideoButton}]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoStoreMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.storeVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}

- (void)setupShareVideoButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareVideoButton]-70-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareVideoButton" : self.shareVideoButton}]];
    
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoStoreMenuContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.shareVideoButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}


#pragma mark - Play Video Button Event Handler Methods

// playVideoButton을 클릭하면 videoItems를 차례대로 이어서 재생시킨다.
- (void)playVideoButtonClicked:(UIButton *)sender {
    [self.playVideo playVideo:self.videoView];
}


#pragma mark - back To Camera View Button Event Handler Methods

// backToCamerViewButton을 누르면 카메라 촬영화면으로 되돌아 간다.
- (void)backToCameraViewButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - reset And back To Camera Button Event Handler Methods

//resetAndbackToCameraButton을 누르면 촬영한 데이터가 모두 삭제되고 카메라 촬영화면으로 되돌아간다.
- (void)resetAndbackToCameraButtonClicked:(UIButton *)sender {
    [self.modelManager.videoDatas removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Store Video Button Event Handler Methods

- (void)storeVideoButtonClicked:(UIButton *)sender {
    self.storeVideo = [[WMStoreVideo alloc] initWithModelManager:self.modelManager];
    [self.storeVideo mergeVideo];
    [self.storeVideo storeVideo];
}


#pragma mark - Share Video Button Event Handler Methods
- (void)shareVideoButtonClicked:(UIButton *)sender {
    NSLog(@"share video clicked");
}



@end
