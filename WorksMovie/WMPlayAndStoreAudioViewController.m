//
//  WMPlayAndStoreAudioViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 1..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "WMPlayAndStoreAudioViewController.h"

@interface WMPlayAndStoreAudioViewController ()

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *audioURL;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *playVideoAndAudioButton;
@property (nonatomic, strong) UIView *videoStoreMenuContainerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *playerWithAudio;
@property (nonatomic, strong) AVPlayerLayer *playerLayerWithAudio;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation WMPlayAndStoreAudioViewController

- (instancetype)initWithAudioURL:(NSURL *)audioURL videoURL:(NSURL *)videoURL {
    self = [super init];
    
    if(self) {
        self.audioURL = audioURL;
        self.videoURL = videoURL;
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
    [self setupBackButton];
    [self setupPlayVideoAndAudioButton];
    [self setupVideoStoreMenuContainerView];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // thumbnail 추출
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    [imageGenerator setAppliesPreferredTrackTransform:true];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(1, 10) actualTime:nil error:nil]]; // 특정 시점의 이미지를 추출
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.videoView.bounds;
    [self.videoView addSubview:imageView];
    
    [self.view addSubview:self.videoView];
}

- (void)setupBackButton {
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPlayVideoAndAudioButton {
    self.playVideoAndAudioButton = [[UIButton alloc] init];
    [self.playVideoAndAudioButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoAndAudioButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoAndAudioButton];
    [self.playVideoAndAudioButton addTarget:self action:@selector(playVideoAndAudioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupVideoStoreMenuContainerView {
    self.videoStoreMenuContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videoStoreMenuContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.videoStoreMenuContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoStoreMenuContainerView];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackButtonConstraints];
    [self setupPlayVideoAndAudioButtonConstraints];
    [self setupVideoStoreMenuContainerViewConstraints];
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

- (void)setupBackButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backButton" : self.backButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[backButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backButton" : self.backButton}]];
}

- (void)setupPlayVideoAndAudioButtonConstraints {
    [self.videoView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playVideoAndAudioButton
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.videoView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.playVideoAndAudioButton
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


#pragma mark - Play Video And Audio Button Event Handler Methods

- (void)playVideoAndAudioButtonClicked:(UIButton *)sender {
    [self playVideo];
    [self playAudio];
}

- (void)playVideo {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
    [self.videoView.layer addSublayer:self.playerLayer];
    
    [self.player play];
}

- (void)playAudio {
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
    [self.audioPlayer play];
}

// 비디오 재생이 끝나면 리플레이를 위해 preparePlayVideo를 호출한다.
-(void)itemDidFinishPlaying:(NSNotification *) notification {
    [self.videoView addSubview:self.playVideoAndAudioButton];
    [self.videoView addSubview:self.backButton];
}


#pragma mark - Back Button Event Handler Methods

- (void)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
