//
//  WMPlayAndStoreAudioViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 1..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "WMPlayAndStoreAudioViewController.h"
#import "WMMediaUtils.h"
#import "WMAudioHelper.h"

@interface WMPlayAndStoreAudioViewController ()

@property (nonatomic, strong) WMAudioHelper *audioHelper;
@property (nonatomic, strong) WMVideoModelManager *videoModelManager;
@property (nonatomic, strong) WMAudioModelManager *audioModelManager;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *playVideoAndAudioButton;
@property (nonatomic, strong) UIView *videoStoreMenuContainerView;
@property (nonatomic, strong) UIButton *storeVideoButton;
@property (nonatomic, strong) UILabel *storeLabel;
@property (nonatomic, strong) UIButton *shareVideoButton;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *playerWithAudio;
@property (nonatomic, strong) AVPlayerLayer *playerLayerWithAudio;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, assign) BOOL audioAvailable;

@end

@implementation WMPlayAndStoreAudioViewController

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager audioModelManager:(WMAudioModelManager *)audioModelManager {
    self = [super init];
    
    if (self) {
        self.videoModelManager = videoModelManager;
        self.audioModelManager = audioModelManager;
        self.audioHelper = [[WMAudioHelper alloc] initWithVideoModelManager:self.videoModelManager audioModelManager:self.audioModelManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
    
    [self preparePlayVideoAndAudio];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupVideoView];
    [self setupBackButton];
    [self setupPlayVideoAndAudioButton];
    [self setupVideoStoreMenuContainerView];
    [self setupStoreVideoButton];
    [self setupShareVideoButton];
    [self setupAudioButton];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // thumbnail 추출
    UIImageView *imageView = [WMMediaUtils gettingThumbnailFromVideoInView:self.videoView withURL:[(WMMediaModel *)self.videoModelManager.mediaDatas[0] mediaURL]];
    
    
    [self.videoView addSubview:imageView];
    [self.view addSubview:self.videoView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewTapped:)];
    [self.videoView addGestureRecognizer:tapRecognizer];
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
    
    [self setupStoreVideoButtonLabel];
}

- (void)setupStoreVideoButtonLabel {
    self.storeLabel = [[UILabel alloc] init];
    self.storeLabel.text = @"저장";
    self.storeLabel.textColor = [UIColor whiteColor];
    [self.storeLabel setFont:[UIFont systemFontOfSize:14]];
    self.storeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.storeLabel];
}

- (void)setupShareVideoButton {
    self.shareVideoButton = [[UIButton alloc] init];
    [self.shareVideoButton
     setImage:[UIImage imageNamed:@"shareButton"] forState:UIControlStateNormal];
    self.shareVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.shareVideoButton];
    [self.shareVideoButton addTarget:self action:@selector(shareVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupShareVideoButtonLabel];
}

- (void)setupShareVideoButtonLabel {
    self.shareLabel = [[UILabel alloc] init];
    self.shareLabel.text = @"공유";
    self.shareLabel.textColor = [UIColor whiteColor];
    [self.shareLabel setFont:[UIFont systemFontOfSize:14]];
    self.shareLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoStoreMenuContainerView addSubview:self.shareLabel];
}

- (void)setupAudioButton {
    self.audioButton = [[UIButton alloc] init];
    [self.audioButton setImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal];
    [self.audioButton setImage:[UIImage imageNamed:@"noaudio"] forState:UIControlStateSelected];
    self.audioAvailable = YES;
    self.audioButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.audioButton];
    [self.audioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackButtonConstraints];
    [self setupPlayVideoAndAudioButtonConstraints];
    [self setupVideoStoreMenuContainerViewConstraints];
    [self setupStoreVideoButtonConstraints];
    [self setupShareVideoButtonConstraints];
    [self setupAudioButtonConstraints];
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
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-84-[storeLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeLabel" : self.storeLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[storeVideoButton]-10-[storeLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeVideoButton" : self.storeVideoButton, @"storeLabel" : self.storeLabel}]];
    
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
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareLabel]-84-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareLabel" : self.shareLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[shareVideoButton]-10-[shareLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareVideoButton" : self.shareVideoButton, @"shareLabel" : self.shareLabel}]];
}

- (void)setupAudioButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[audioButton(==45)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"audioButton" : self.audioButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[audioButton(==45)]-10-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"audioButton" : self.audioButton}]];

}


#pragma mark - Prepare Play Video And Audio Method

- (void)preparePlayVideoAndAudio {
    [self preparePlayVideo];
    [self preparePlayAudio];
}

- (void)preparePlayVideo {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[(WMMediaModel *)self.videoModelManager.mediaDatas[0] mediaURL] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    self.player = [AVQueuePlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
}

- (void)preparePlayAudio {
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[(WMMediaModel *)self.audioModelManager.mediaDatas[0] mediaURL] error:nil];
}


#pragma mark - Video View Tapped Event Handler Methods

// viewView를 tap하면 비디오의 재생 상태에 따라 play또는 pause시킨다.
- (void)videoViewTapped:(UITapGestureRecognizer *)sender {
    if (self.player.rate == 1.0) { // 재생 중일 때 실행
        self.playVideoAndAudioButton.hidden = NO;
        self.backButton.hidden = NO;
        [self.player pause];
        [self.audioPlayer pause];
    } else if (self.player.rate == 0.0) { // 정지 상태일 때 실행
        self.playVideoAndAudioButton.hidden = YES;
        self.backButton.hidden = YES;
        [self.videoView.layer insertSublayer:self.playerLayer below:self.playVideoAndAudioButton.layer];
        [self.player play];
        [self.audioPlayer play];
    }
}

// 비디오 재생이 끝나면 리플레이를 위해 preparePlayVideo를 호출한다.
- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [self preparePlayVideo];
    
    self.playVideoAndAudioButton.hidden = NO;
    self.backButton.hidden = NO;
}


#pragma mark - Back Button Event Handler Methods

- (void)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Audio Button Event Handler Methods

- (void)audioButtonClicked:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if(!self.audioAvailable) {
        self.audioAvailable = YES;
    }
    else {
        self.audioAvailable = NO;
    }
}


#pragma mark - Store Video Button Event Handler Methods

- (void)storeVideoButtonClicked:(UIButton *)sender {
    [self.player pause];
    
    NSURL *audioURL = [self.audioModelManager.mediaDatas.firstObject mediaURL];
    NSURL *videoURL = [self.videoModelManager.mediaDatas.firstObject mediaURL];
    
    AVMutableComposition *composition = [self.audioHelper mergeAudio:audioURL withVideo:videoURL audioAvailable:self.audioAvailable];
    [self.audioHelper storeVideo:composition];
}

@end
