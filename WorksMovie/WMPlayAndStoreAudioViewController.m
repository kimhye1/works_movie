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
#import "WMNotificationStrings.h"

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
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *playerWithAudio;
@property (nonatomic, strong) AVPlayerLayer *playerLayerWithAudio;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, assign) BOOL audioAvailable;
@property (nonatomic, strong) AVVideoComposition *videoComposition;
@property (nonatomic, strong) UILabel *userGuideLabel;
@property (nonatomic, strong) UIButton *goHomeButton;
@property (nonatomic, strong) UILabel *saveAlertLabel;
@property (nonatomic, strong) UIView *savingView;
@property (nonatomic, strong) UILabel *savigLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation WMPlayAndStoreAudioViewController

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)videoModelManager
                        audioModelManager:(WMAudioModelManager *)audioModelManager
                              composition:(AVVideoComposition *)videoComposition
                                   filter:(WMFilter *)filter {
    self = [super init];
    if (self) {
        self.videoModelManager = videoModelManager;
        self.audioModelManager = audioModelManager;
        self.audioHelper = [[WMAudioHelper alloc] initWithVideoModelManager:self.videoModelManager audioModelManager:self.audioModelManager];
        self.videoComposition = videoComposition;
        self.filter = filter;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
    
    [self checkIsInitialEntry];
    
    [self preparePlayVideoAndAudio];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
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
    [self setupGoToHomeButton];
    [self setupSaveAlertView];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 170)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // thumbnail 추출
    UIImageView *imageView = [WMMediaUtils gettingThumbnailFromVideoInView:self.videoView URL:[self.videoModelManager.mediaDatas.firstObject mediaURL] filter:self.filter];
    
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

- (void)setupGoToHomeButton {
    self.goHomeButton = [[UIButton alloc] init];
    [self.goHomeButton setImage:[UIImage imageNamed:@"Home-100"] forState:UIControlStateNormal];
    self.goHomeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.goHomeButton];
    [self.goHomeButton addTarget:self action:@selector(goToHomeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupPlayVideoAndAudioButton {
    self.playVideoAndAudioButton = [[UIButton alloc] init];
    [self.playVideoAndAudioButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
    self.playVideoAndAudioButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.playVideoAndAudioButton];
        self.playVideoAndAudioButton.enabled = NO;
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

- (void)setupUserGuidLabel {
    self.userGuideLabel = [[UILabel alloc] init];
    self.userGuideLabel.text = @"버튼을 누르면\n동영상의 음향이 음소거되어 저장됩니다";
    [self.userGuideLabel setNumberOfLines:0];
    //    self.userGuideLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.userGuideLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    [self.userGuideLabel setFont:[UIFont systemFontOfSize:12]];
    self.userGuideLabel.layer.cornerRadius = 6;
    self.userGuideLabel.clipsToBounds = YES;
    self.userGuideLabel.textAlignment = NSTextAlignmentLeft;
    self.userGuideLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.userGuideLabel];
}

- (void)setupSaveAlertView {
    self.saveAlertLabel = [[UILabel alloc] init];
    self.saveAlertLabel.text = @"영상을 저장했습니다.";
    self.saveAlertLabel.textColor = [UIColor whiteColor];
    self.saveAlertLabel.textAlignment = NSTextAlignmentCenter;
    self.saveAlertLabel.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    [self.saveAlertLabel setFont:[UIFont systemFontOfSize:15]];
    self.saveAlertLabel.layer.cornerRadius = 8;
    self.saveAlertLabel.clipsToBounds = YES;
    self.saveAlertLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.saveAlertLabel];
    self.saveAlertLabel.hidden = YES;
}

- (void)setupSavingView {
    self.savingView = [[UIView alloc] init];
    self.savingView.layer.cornerRadius = 15;
    self.savingView.layer.masksToBounds = YES;
    self.savingView.backgroundColor = [[UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00] colorWithAlphaComponent:0.7f];
    self.savingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.savingView];
    
    [self setupSavigLabel];
    [self setupActivitiIndicatorView];
}

- (void)setupSavigLabel {
    self.savigLabel = [[UILabel alloc] init];
    self.savigLabel.text = @"저장 중 입니다";
    self.savigLabel.textColor = [UIColor whiteColor];
    self.savigLabel.textAlignment = NSTextAlignmentCenter;
    [self.savigLabel setFont:[UIFont systemFontOfSize:16]];
    self.savigLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.savingView addSubview:self.savigLabel];
}

- (void)setupActivitiIndicatorView {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.indicatorView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self.indicatorView startAnimating];
    [self.savingView addSubview:self.indicatorView];
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
    [self setupGoToHomeButtonConstraints];
    [self setupSaveAlertViewConstraints];
}

- (void)setupVideoViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoView]-170-|"
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[videoStoreMenuContainerView(==170)]|"
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
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-84-[storeLabel]"
                                             options:0
                                             metrics:nil
                                               views:@{@"storeLabel" : self.storeLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-47-[storeVideoButton]-10-[storeLabel]"
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
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[shareLabel]-84-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"shareLabel" : self.shareLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-47-[shareVideoButton]-10-[shareLabel]"
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

- (void)setupUserGuideLabelConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[userGuideLabel(==195)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"userGuideLabel" : self.userGuideLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userGuideLabel(==40)]-12-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"userGuideLabel" : self.userGuideLabel}]];
}

- (void)setupGoToHomeButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[goHomeButton(==33)]-20-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"goHomeButton" : self.goHomeButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[goHomeButton(==30)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"goHomeButton" : self.goHomeButton}]];
}

- (void)setupSaveAlertViewConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.videoView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.saveAlertLabel
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[saveAlertLabel(==150)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"saveAlertLabel" : self.saveAlertLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveAlertLabel(==40)]-50-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"saveAlertLabel" : self.saveAlertLabel}]];
}

- (void)setupSavingViewConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.view
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.savingView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[savingView(==170)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"savingView" : self.savingView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-190-[savingView(==105)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"savingView" : self.savingView}]];
    
    [self setupSavigLabelConstraints];
    [self setupActivitiIndicatorViewConstraints];
}

- (void)setupSavigLabelConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.savingView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.savigLabel
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[savigLabel(==120)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"savigLabel" : self.savigLabel}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[savigLabel(==20)]-15-[indicatorView(==30)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"savigLabel" : self.savigLabel, @"indicatorView" : self.indicatorView}]];
    
}

- (void)setupActivitiIndicatorViewConstraints {
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.savingView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.indicatorView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[indicatorView(==30)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"indicatorView" : self.indicatorView}]];
    
}


#pragma mark - Check Is Initial Entry

- (void)checkIsInitialEntry {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault valueForKey:@"isInitialInWMPlayAndStoreAudioViewController"] == nil) {   // 앱을 처음 실행한 상태
        [userDefault setBool:false forKey:@"isInitialInWMPlayAndStoreAudioViewController"];
        
        [self setupUserGuidLabel];
        [self setupUserGuideLabelConstraints];
    }
}


#pragma mark - Prepare Play Video And Audio Method

- (void)preparePlayVideoAndAudio {
    [self preparePlayVideo];
    [self preparePlayAudio];
}

- (void)preparePlayVideo {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[(WMMediaModel *)self.videoModelManager.mediaDatas.firstObject mediaURL] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    self.playerItem.videoComposition = self.videoComposition;
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    self.player = [AVQueuePlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
}

- (void)preparePlayAudio {
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[(WMMediaModel *)self.audioModelManager.mediaDatas.firstObject mediaURL] error:nil];
}


#pragma mark - Video View Tapped Event Handler Methods

// viewView를 tap하면 비디오의 재생 상태에 따라 play또는 pause시킨다.
- (void)videoViewTapped:(UITapGestureRecognizer *)sender {
    if ([self isPlaying]) { // 재생 중일 때 실행
        [self.videoView addSubview:self.backButton];
        [self.videoView addSubview:self.goHomeButton];
        self.playVideoAndAudioButton.hidden = NO;
        self.backButton.hidden = NO;
        self.goHomeButton.hidden = NO;
        [self.player pause];
        [self.audioPlayer pause];
    } else { // 정지 상태일 때 실행
        self.playVideoAndAudioButton.hidden = YES;
        self.backButton.hidden = YES;
        self.goHomeButton.hidden = YES;
        [self.videoView.layer insertSublayer:self.playerLayer below:self.playVideoAndAudioButton.layer];
        [self.player play];
        [self.audioPlayer play];
    }
}

- (BOOL)isPlaying {
    if (self.player.rate == 0.0) { // player가 정지 상태일 때 실행
        return NO;
    }
    return YES;
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
//    AVPlayerItem *p = [notification object];
//    [p seekToTime:kCMTimeZero];
//    
//    self.playVideoAndAudioButton.hidden = NO;
//    self.backButton.hidden = NO;
    
    [self.videoView addSubview:self.backButton];
    [self.videoView addSubview:self.goHomeButton];
    self.playVideoAndAudioButton.hidden = NO;
    self.backButton.hidden = NO;
    self.goHomeButton.hidden = NO;
    
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;
    
    [self preparePlayVideo];
    [self preparePlayVideo];
}


#pragma mark - Back Button Event Handler Methods

- (void)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMPlayAndStoreAudioViewControllerDidDismissedNotification object:nil];
}


#pragma mark - Audio Button Event Handler Methods

- (void)audioButtonClicked:(UIButton *)sender {
    [self userGuideLabelFadeOut];

    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if(!self.audioAvailable) {
        self.audioAvailable = YES;
    }
    else {
        self.audioAvailable = NO;
    }
}

- (void)userGuideLabelFadeOut {
    [UIView animateWithDuration:1.0f animations:^{
        [self.userGuideLabel setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        //fade out
        [UIView animateWithDuration:1.0f animations:^{
            [self.userGuideLabel setAlpha:0.0f];
            self.userGuideLabel = nil;
        } completion:nil];
        
        
    }];
}


#pragma mark - Store Video Button Event Handler Methods

- (void)storeVideoButtonClicked:(UIButton *)sender {
    [self setupSavingView];
    [self setupSavingViewConstraints];

    [self.player pause];
    [self.audioPlayer stop];
    
    [self.videoView addSubview:self.backButton];
    self.playVideoAndAudioButton.hidden = NO;
    self.backButton.hidden = NO;
    
    NSURL *audioURL = [self.audioModelManager.mediaDatas.firstObject mediaURL];
    NSURL *videoURL = [self.videoModelManager.mediaDatas.firstObject mediaURL];
    
    AVMutableComposition *composition = [self.audioHelper mergeAudio:audioURL withVideo:videoURL audioAvailable:self.audioAvailable];
    [self.audioHelper storeVideo:composition videoComposition:self.videoComposition alertLabel:self.saveAlertLabel savigView:self.savingView];

}


#pragma mark - Share Video Button Event Handler Methods

- (void)shareVideoButtonClicked:(UIButton *)sender {
    self.saveAlertLabel = nil;

    [self.player pause];
    [self.audioPlayer stop];
    
    [self.videoView addSubview:self.backButton];
    self.playVideoAndAudioButton.hidden = NO;
    self.backButton.hidden = NO;
    
    NSURL *audioURL = [self.audioModelManager.mediaDatas.firstObject mediaURL];
    NSURL *videoURL = [self.videoModelManager.mediaDatas.firstObject mediaURL];

    AVMutableComposition *composition = [self.audioHelper mergeAudio:audioURL withVideo:videoURL audioAvailable:self.audioAvailable];
    NSURL *url = [self.audioHelper storeVideo:composition videoComposition:self.videoComposition alertLabel:(UILabel *)self.saveAlertLabel savigView:(UIView *)self.savingView];
    
    UIActivityViewController *activityView = [self.audioHelper shareVideo:url];
    [self presentViewController:activityView animated:YES completion:nil];
}


#pragma mark - Go To Home Button Event Handler Methods

//goToHomeButto을 누르면 홈화면으로 되돌아간다.
- (void)goToHomeButtonClicked:(UIButton *)sender {
    [self alertResetVideo];
}

- (void)alertResetVideo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"홈 화면으로 이동하겠습니까?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"취소"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *reset = [UIAlertAction
                            actionWithTitle:@"이동"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction *action) {
                                __strong typeof(weakSelf) strongSelf = weakSelf;
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                
                                [strongSelf.videoModelManager.mediaDatas removeAllObjects];
                                [strongSelf.audioModelManager.mediaDatas removeAllObjects];
                                
                                NSFileManager *manager = [[NSFileManager alloc] init];
                                if ([manager fileExistsAtPath:[self.audioModelManager.mediaDatas.firstObject mediaURL].path]) {
                                    [manager removeItemAtPath:[self.audioModelManager.mediaDatas.firstObject mediaURL].path error:nil];
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIViewController *vc = strongSelf.presentingViewController;
                                    while (vc.presentingViewController) {
                                        vc = vc.presentingViewController;
                                    }
                                    
                                    [vc dismissViewControllerAnimated:YES completion:NULL];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:WMShootingVideoViewControllerDidDismissedNotification object:nil];
                                });
                            }];
    [alert addAction:cancel];
    [alert addAction:reset];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notificatioin Handler Methods

- (void)applicationWillResignActive:(NSNotification *)notification {
    if ([self isPlaying]) {
        [self.player pause];
        self.playerLayer.player = nil;
        
        [self.videoView addSubview:self.backButton];
        [self.videoView addSubview:self.goHomeButton];
        self.playVideoAndAudioButton.hidden = NO;
        self.backButton.hidden = NO;
        self.goHomeButton.hidden = NO;
        
        [self.playerLayer removeFromSuperlayer];
        self.player = nil;
        self.playerItem = nil;
        self.playerLayer = nil;
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    self.playerLayer.player = self.player;
    
    [self preparePlayVideo];
}

@end
